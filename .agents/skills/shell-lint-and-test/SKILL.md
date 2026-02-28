# Skill: Shell Lint ve Test

> ShellCheck + shfmt + BATS test çalıştırma ve hata düzeltme

---

## Ön Koşullar

- `shellcheck` kurulu olmalı (`apt install shellcheck` veya `brew install shellcheck`)
- `shfmt` kurulu olmalı (`go install mvdan.cc/sh/v3/cmd/shfmt@latest` veya `snap install shfmt`)
- `bats` kurulu olmalı (`apt install bats` veya `npm install -g bats`)
- `kcov` (opsiyonel, coverage için)

---

## Adım 1: Bash Syntax Kontrolü

Tüm script'lerin sözdizimi geçerliliğini kontrol et:

```bash
bash -n guncel
bash -n install.sh
bash -n release.sh
bash -n lang/tr.sh
bash -n lang/en.sh
```

Hata durumunda: Belirtilen satır numarasına git, genellikle eşleşmeyen parantez/tırnak/fi/done sorunudur.

---

## Adım 2: ShellCheck Lint

```bash
shellcheck -S warning guncel install.sh release.sh
```

### Önemli Notlar

- `guncel` dosyasının başında `# shellcheck disable=SC2059` var — bu **bilerek** yapılmıştır (i18n printf format değişkenleri)
- ShellCheck uyarıları `warning` seviyesinde kontrol edilir (CI ile aynı)
- Yeni disable eklemeden önce gerçekten gerekli olduğundan emin ol

### Yaygın ShellCheck Hataları ve Çözümleri

| Kod | Açıklama | Çözüm |
|-----|----------|-------|
| SC2059 | printf format değişkeni | i18n için disable gerekli (dosya başında mevcut) |
| SC2086 | Tırnak içine alınmamış değişken | `"$var"` şeklinde tırnak ekle |
| SC2155 | declare ve atama tek satırda | `local var; var=$(...)` olarak ayır |
| SC2034 | Kullanılmayan değişken | Gerçekten kullanılmıyorsa kaldır |
| SC2153 | Yazım hatası şüphesi | Değişken adını kontrol et |

---

## Adım 3: shfmt Stil Kontrolü

```bash
# Fark göster (düzeltme yapmaz)
shfmt -d -i 2 -ci -sr guncel install.sh release.sh

# Otomatik düzeltme
shfmt -w -i 2 -ci -sr guncel install.sh release.sh
```

### shfmt Parametreleri

| Parametre | Açıklama |
|-----------|----------|
| `-i 2` | 2 boşluk indent |
| `-ci` | Switch-case indent |
| `-sr` | Redirect operatörleri boşlukla ayrılır |
| `-d` | Fark göster (dry-run) |
| `-w` | Dosyaya yaz (düzelt) |

---

## Adım 4: BATS Testleri

```bash
# Tüm testleri çalıştır
bats tests/guncel.bats tests/install.bats

# Tek test dosyası
bats tests/guncel.bats

# Belirli test (filtre)
bats tests/guncel.bats --filter "safe_source"

# TAP formatında çıktı
bats --tap tests/guncel.bats
```

### Test Yapısı

- `tests/test_helper.bash` — ortak değişkenler ve helper fonksiyonlar
  - `$GUNCEL_SCRIPT` → ana script yolu
  - `$PROJECT_ROOT` → proje kök dizini
  - `$MOCK_DIR` → mock dizini (setup/teardown'da oluşturulur/silinir)
- `tests/guncel.bats` — ~160 test (~816 satır)
- `tests/install.bats` — kurulum testleri

### Yeni Test Ekleme

```bash
@test "yeni fonksiyon açıklaması" {
    # Fonksiyon varlık kontrolü
    grep -qE '^yeni_fonksiyon\(\)' "$GUNCEL_SCRIPT"
}

@test "--yeni-flag help'te görünür" {
    run bash "$GUNCEL_SCRIPT" --help
    [ "$status" -eq 0 ]
    [[ "$output" == *"--yeni-flag"* ]]
}
```

---

## Adım 5: Coverage (Opsiyonel)

```bash
# kcov ile coverage
kcov --include-path=. coverage/ bats tests/guncel.bats

# Rapor görüntüle
open coverage/bats/index.html
```

---

## Tam Lint Pipeline (CI İle Aynı)

```bash
# 1. Syntax
bash -n guncel && bash -n install.sh && bash -n release.sh

# 2. ShellCheck
shellcheck -S warning guncel install.sh release.sh

# 3. shfmt
shfmt -d -i 2 -ci -sr guncel install.sh release.sh

# 4. BATS
bats tests/guncel.bats tests/install.bats
```

Tüm adımlar başarılıysa commit atmaya hazırsın.

---

## Hata Ayıklama İpuçları

1. **ShellCheck false positive** → `# shellcheck disable=SCXXXX` ekle (tek satır veya dosya başı)
2. **shfmt ile ShellCheck çakışması** → Önce shfmt, sonra ShellCheck çalıştır
3. **BATS test başarısız** → `bats --tap tests/guncel.bats` ile detaylı çıktı al
4. **Alpine uyumsuzluk** → `grep -P` yerine `grep -E` kullan (Alpine'da PCRE yok)
5. **Timeout sorunları** → CI'da multi-distro testleri network erişimi gerektirir
