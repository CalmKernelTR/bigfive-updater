# Skill: i18n Senkronizasyon

> TR/EN dil dosyaları arasında mesaj senkronizasyonu ve tutarlılık kontrolü

---

## Ön Koşullar

- `lang/tr.sh` ve `lang/en.sh` dosyaları mevcut
- Her iki dosya da `MSG_` prefix'li değişkenler içerir
- Dosyalar `safe_source()` ile yüklendiği için bash syntax uyumlu olmalı

---

## Dosya Yapısı

```
lang/
├── tr.sh    # Türkçe dil dosyası (256 satır, ~120 MSG_ değişkeni)
└── en.sh    # İngilizce dil dosyası (256 satır, ~120 MSG_ değişkeni)
```

Her dil dosyasının yapısı:
```bash
#!/usr/bin/env bash
# BigFive Updater - Türkçe Dil Dosyası
# Language: Turkish (tr)
# Version: 6.5.1 Fluent Edition India
# Encoding: UTF-8

# ============================================
# HEADERS - Bölüm Başlıkları
# ============================================
MSG_HEADER_SELF_UPDATE="Self-Update Başlatılıyor..."
MSG_HEADER_SNAPSHOT_TIMESHIFT="Sistem Yedekleniyor (Timeshift)"
# ...
```

---

## Adım 1: Eksik Mesaj Tespiti

İki dil dosyasındaki `MSG_` değişkenlerini karşılaştır:

```bash
# TR'de olup EN'de olmayan mesajlar
diff <(grep -oP '^MSG_\w+' lang/tr.sh | sort) \
     <(grep -oP '^MSG_\w+' lang/en.sh | sort) \
     | grep '^<' | sed 's/^< //'

# EN'de olup TR'de olmayan mesajlar
diff <(grep -oP '^MSG_\w+' lang/tr.sh | sort) \
     <(grep -oP '^MSG_\w+' lang/en.sh | sort) \
     | grep '^>' | sed 's/^> //'
```

**Beklenen sonuç:** Hiçbir fark olmamalı. İki dosyada da aynı MSG_ değişkenleri olmalı.

---

## Adım 2: Mesaj Sayısı Kontrolü

```bash
echo "TR mesaj sayısı: $(grep -c '^MSG_' lang/tr.sh)"
echo "EN mesaj sayısı: $(grep -c '^MSG_' lang/en.sh)"
```

İki sayı eşit olmalı.

---

## Adım 3: Kategori Kontrolü

MSG_ değişkenleri şu kategorilerde organize edilmelidir:

| Prefix | Kategori | Kullanım |
|--------|----------|----------|
| `MSG_HEADER_*` | Bölüm başlıkları | `print_header()` çağrılarında |
| `MSG_INFO_*` | Bilgi mesajları | `print_info()` çağrılarında |
| `MSG_SUCCESS_*` | Başarı mesajları | `print_success()` çağrılarında |
| `MSG_WARN_*` | Uyarılar | `print_warning()` çağrılarında |
| `MSG_ERR_*` | Hatalar | `print_error()` çağrılarında |
| `MSG_HINT_*` | Çözüm önerileri | Hata mesajlarından sonra |
| `MSG_HELP_*` | Yardım metinleri | `show_help()` fonksiyonunda |
| `MSG_DOCTOR_*` | Doctor kontrolleri | `do_doctor()` fonksiyonunda |
| `MSG_HISTORY_*` | History mesajları | `do_history()` fonksiyonunda |
| `MSG_SUMMARY_*` | Özet mesajları | `print_final_summary()` fonksiyonunda |
| `MSG_HOOK_*` | Hook mesajları | `run_hooks()` fonksiyonunda |
| `MSG_CONFIRM_*` | Onay mesajları | Kullanıcı etkileşimi |

### Kategori bazlı sayım:

```bash
for prefix in HEADER INFO SUCCESS WARN ERR HINT HELP DOCTOR HISTORY SUMMARY HOOK CONFIRM; do
  TR=$(grep -c "^MSG_${prefix}_" lang/tr.sh 2>/dev/null || echo 0)
  EN=$(grep -c "^MSG_${prefix}_" lang/en.sh 2>/dev/null || echo 0)
  STATUS="OK"
  [[ "$TR" != "$EN" ]] && STATUS="FARKLI!"
  printf "%-12s TR: %3d  EN: %3d  %s\n" "$prefix" "$TR" "$EN" "$STATUS"
done
```

---

## Adım 4: printf Format Tutarlılığı

Bazı mesajlar `%s`, `%d` gibi printf formatları içerir. İki dil dosyasında formatlar eşleşmeli:

```bash
# printf format string'lerini karşılaştır
for msg in $(grep -oP '^MSG_\w+' lang/tr.sh); do
  TR_FMT=$(grep "^${msg}=" lang/tr.sh | grep -oP '%[sd]' | tr '\n' ' ')
  EN_FMT=$(grep "^${msg}=" lang/en.sh | grep -oP '%[sd]' | tr '\n' ' ')
  if [[ "$TR_FMT" != "$EN_FMT" ]]; then
    echo "FORMAT UYUMSUZ: $msg"
    echo "  TR: $TR_FMT"
    echo "  EN: $EN_FMT"
  fi
done
```

---

## Adım 5: Yeni Mesaj Ekleme

Yeni bir mesaj eklemek için 3 dosya güncellenmeli:

### 1. `guncel` script'ine ekle (varsayılan ile):
```bash
print_info "${MSG_INFO_YENI_OZELLIK:-Yeni özellik etkinleştirildi}"
```

### 2. `lang/tr.sh`'e ekle:
```bash
MSG_INFO_YENI_OZELLIK="Yeni özellik etkinleştirildi"
```

### 3. `lang/en.sh`'e ekle:
```bash
MSG_INFO_YENI_OZELLIK="New feature enabled"
```

### Ekleme Kuralları:
- Doğru kategoriye, bölüm yorum satırının altına ekle
- Alfabetik sıra zorunlu değil, mantıksal gruplama tercih edilir
- `%s` ve `%d` formatları her iki dosyada eşleşmeli
- Encoding her zaman UTF-8

---

## Adım 6: guncel'deki Kullanılmayan Mesajları Bul

```bash
# lang/tr.sh'deki MSG_ değişkenlerinin guncel'de kullanılıp kullanılmadığını kontrol et
for msg in $(grep -oP '^MSG_\w+' lang/tr.sh); do
  if ! grep -q "\$${msg}\|\"$msg\"\|\${${msg}" guncel; then
    echo "KULLANILMIYOR: $msg"
  fi
done
```

> **Not:** Bazı mesajlar `${MSG_XXX:-varsayılan}` sözdizimi ile kullanılır, yukarıdaki kontrol bunu da yakalar.

---

## Adım 7: Syntax Doğrulama

Dil dosyaları `safe_source()` ile yüklendiğinden bash syntax uyumlu olmalı:

```bash
bash -n lang/tr.sh
bash -n lang/en.sh
```

---

## Tam Senkronizasyon Checklist

```bash
# 1. Syntax kontrolü
bash -n lang/tr.sh && bash -n lang/en.sh && echo "Syntax OK"

# 2. Mesaj sayısı eşitliği
TR=$(grep -c '^MSG_' lang/tr.sh)
EN=$(grep -c '^MSG_' lang/en.sh)
[[ "$TR" == "$EN" ]] && echo "Sayı eşit: $TR" || echo "FARKLI: TR=$TR EN=$EN"

# 3. Eksik mesajları bul
echo "--- TR'de var, EN'de yok ---"
diff <(grep -oP '^MSG_\w+' lang/tr.sh | sort) <(grep -oP '^MSG_\w+' lang/en.sh | sort) | grep '^<'

echo "--- EN'de var, TR'de yok ---"
diff <(grep -oP '^MSG_\w+' lang/tr.sh | sort) <(grep -oP '^MSG_\w+' lang/en.sh | sort) | grep '^>'
```
