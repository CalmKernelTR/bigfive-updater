# TUI Audit Report - guncel script

**Tarih:** 2026-02-24
**Script Sürümü:** 6.5.1 (Fluent Edition - India)
**Toplam Satır:** ~2635

---

## 1. Renk Tanımları

Script satır 79-85 arasında ANSI escape kodları ile renk tanımlıyor:

| Değişken | ANSI Kodu       | Renk/Stil      | setaf Eşdeğeri |
|----------|-----------------|----------------|----------------|
| `RED`    | `\033[0;31m`    | Kırmızı        | setaf 1        |
| `GREEN`  | `\033[0;32m`    | Yeşil          | setaf 2        |
| `YELLOW` | `\033[0;33m`    | Sarı           | setaf 3        |
| `BLUE`   | `\033[0;34m`    | Mavi           | setaf 4        |
| `BOLD`   | `\033[1m`       | Kalın          | bold           |
| `NC`     | `\033[0m`       | Reset          | sgr0           |

### Notlar
- **tput kullanılmıyor.** Renkler doğrudan ANSI-C quoting (`$'\033[...]'`) ile tanımlanmış.
- `setaf`, `setab`, `sgr0`, `smul`, `rmul`, `colors` gibi tput çağrıları **hiç yok**.
- Config ile renk override destekleniyor (satır 148-151): `CONFIG_COLOR_RED`, `CONFIG_COLOR_GREEN`, `CONFIG_COLOR_YELLOW`, `CONFIG_COLOR_BLUE`.
- Terminal renk desteği kontrolü (`tput colors`) **yapılmıyor** - renkler koşulsuz olarak uygulanıyor.
- `NO_COLOR` ortam değişkeni desteği **yok**.

---

## 2. Renk Kullanım Haritası (Fonksiyon Bazında)

### Renkli Çıktı Üreten Fonksiyonlar

| Fonksiyon                | Satır   | Kullanılan Renkler        | Prefix/Sembol  |
|--------------------------|---------|---------------------------|----------------|
| `safe_source`            | 50, 58  | YELLOW, NC                | `[!]`          |
| `safe_mktemp`            | 73      | RED, NC                   | `[!]`          |
| `print_header`           | 215-216 | BLUE+BOLD, BLUE, NC       | `>>>`          |
| `print_error`            | 227     | RED+BOLD, NC              | `[X] HATA:`    |
| `print_error_with_hint`  | 248-252 | RED+BOLD, YELLOW, NC      | `[X] HATA:` + `💡 Çözüm:` |
| `print_warning_with_hint`| 274-275 | YELLOW, BLUE, NC          | `[!] UYARI:` + `💡 Öneri:` |
| `print_warning`          | 285     | YELLOW, NC                | `[!] UYARI:`   |
| `print_success`          | 294     | GREEN+BOLD, NC            | `[+]`          |
| `print_info`             | 304     | BLUE, NC                  | `[i]`          |
| `print_dry_run`          | 315     | YELLOW, NC                | `[DRY-RUN]`    |
| `print_system_header`    | 386-392 | GREEN, NC                 | `========`     |
| `print_final_summary`    | 470-570 | GREEN, YELLOW, BLUE, NC   | `========`     |
| `do_history`             | 1074-1149| BLUE+BOLD, RED, GREEN, YELLOW, NC | Tablo formatı |
| `do_doctor`              | 1157-1343| BLUE, RED, GREEN, YELLOW, NC | `[N/9]` + `✓✗-!?` |
| `check_connectivity`     | 1038-1058| YELLOW, GREEN, NC         | `[~]`          |
| `check_self_update`      | 1395    | YELLOW, NC                | `[!]`          |
| `check_root`             | 1348    | YELLOW, NC                | `[*]`          |
| `wait_for_lock`          | 1509    | YELLOW, NC                | `[~]`          |
| `do_uninstall`           | 2301-2385| BLUE+BOLD, GREEN, RED, NC | `✅❌`         |
| `show_help`              | 2390    | BOLD, NC                  | (yalnızca başlık) |
| `perform_dry_run_check`  | 2142-2274| BLUE, GREEN, NC           | Separator çizgileri |
| `update_firmware`        | 2114    | GREEN, NC                 | (düz metin)    |

### Renksiz/Log-Only Çıktılar

| Bölüm                     | Satır   | Açıklama                             |
|----------------------------|---------|--------------------------------------|
| `finish_logging`           | 208     | Sadece `$LOG_FILE`'a echo            |
| `setup_logging`            | 742-755 | Sadece `$LOG_FILE`'a echo            |
| `output_json`              | 593-728 | stdout'a saf JSON (renksiz)          |
| `json_escape`              | 329     | Dahili string işleme                 |
| `add_package_info`         | 335     | Diziye ekleme, çıktı yok             |
| `add_json_warning`         | 340     | Diziye ekleme, çıktı yok             |
| `add_json_error`           | 346     | Diziye ekleme, çıktı yok             |
| `add_pkg_manager_status`   | 352     | Diziye ekleme, çıktı yok             |
| `get_distro_info`          | 362     | Dahili, stdout'a düz metin           |
| `check_reboot_required`    | 411     | Dahili, "yes"/"no" döner             |
| `download_file`            | 758     | Çıktı yok (curl/wget sessiz)         |
| `verify_gpg_signature`     | 783     | Mevcut print_* fonksiyonlarını kullanır |
| `check_disk_space`         | 845     | Mevcut print_* fonksiyonlarını kullanır |
| `load_config`              | 134     | Çıktı yok                           |
| `load_language`            | 159     | Çıktı yok                           |
| `should_run_backend`       | 1612    | Çıktı yok                           |
| `show_help`                | 2392-2434| echo ile düz metin (renksiz gövde)  |
| `send_notification`        | 967     | Sadece log'a echo                    |
| `run_hooks`                | 924     | Mevcut print_* fonksiyonlarını kullanır |
| Argüman parse hataları     | 2451-2550| Doğrudan printf ile RED/YELLOW       |

---

## 3. Renk Semantiği Özeti

| Renk         | Anlam                                  | Kullanım Yoğunluğu |
|--------------|----------------------------------------|---------------------|
| **RED+BOLD** | Hata (HATA/ERROR)                      | Yüksek (~15 yer)    |
| **YELLOW**   | Uyarı, bekleme durumu, dry-run, çözüm  | Çok yüksek (~25 yer)|
| **GREEN**    | Başarı, özet kutusu, güncel durum       | Yüksek (~30 yer)    |
| **GREEN+BOLD** | Başarı mesajları                      | Orta (~5 yer)       |
| **BLUE**     | Bilgi, header separator, ipucu          | Yüksek (~20 yer)    |
| **BLUE+BOLD**| Bölüm başlıkları (header, history, doctor) | Orta (~5 yer)   |
| **BOLD**     | Tek başına sadece help başlığında       | Düşük (1 yer)       |

---

## 4. Progress Göstergesi Analizi

### Spinner: **YOK**
Script'te spinner (dönen karakter animasyonu: `⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏` veya `|/-\`) implementasyonu **bulunmuyor**.

### Progress Bar: **YOK**
İndirme veya güncelleme sürecinde progress bar (`[████░░░░░░] 40%`) **bulunmuyor**.

### Mevcut "Progress" Göstergeleri:
- **Lock bekleme sayacı** (satır 1509): `[~] APT kilitli (fuser), bekleniyor... (3/15)` - Sayaçlı metin, animasyon yok.
- **DNF lock bekleme** (satır 1529): `DNF kilidi bekleniyor... (1/30)` - Sayaçlı metin.
- **Bağlantı kontrolü** (satır 1038): `[~] Bağlantı kontrol ediliyor...` - Tek satır, sonuç aynı satıra yazılır (`printf` ile newline yok, sonra `Bağlı.` veya `Kısmi...` eklenir).
- **Doctor kontrolleri** (satır 1162-1328): `[1/9] ... [9/9]` - Sıralı kontrol listesi, her adım sonucu aynı satıra yazılır.

---

## 5. Box Drawing / Çerçeve Karakterleri

### Kullanılan Karakterler:

| Karakter | Unicode | Kullanıldığı Yer          | Satır      |
|----------|---------|---------------------------|------------|
| `═`      | U+2550  | `do_history`, `do_doctor`  | 1075, 1158, 1333 |
| `─`      | U+2500  | `do_history`               | 1078, 1147 |

### Kullanılmayan Box Drawing Karakterleri:
- `╭` `╮` `╰` `╯` (rounded corners) - **YOK**
- `│` (vertical line) - **YOK**
- `┌` `┐` `└` `┘` (sharp corners) - **YOK**
- `║` (double vertical) - **YOK**
- `┃` (heavy vertical) - **YOK**

### Mevcut Çerçeve Yöntemi:
- **ASCII `=` ve `-`**: Çoğu yerde `========` ve `--------------------------------------------------` kullanılıyor (düz ASCII).
- **Unicode çizgiler**: Sadece `do_history` ve `do_doctor` fonksiyonlarında `══════` ve `────────` var.
- **Tutarsızlık**: `print_system_header` ve `print_final_summary` ASCII `=` kullanırken, `do_history` ve `do_doctor` Unicode `═` ve `─` kullanıyor.

---

## 6. Çıktı Yapısı Analizi

### Genel Yapı: **Bölümlü Düz Metin**

Script çıktısı şu sırayı takip eder:

```
1. [system_header]    ======== kutusu (GREEN)
2. [bilgi satırları]  Log, Mod, Verbose, Dry-Run bilgisi
3. [snapshot]         Header + sonuç
4. [pre-hooks]        Hook çalıştırma bilgisi
5. [updates]          Her paket yöneticisi için:
                        >>> HEADER >>> (BLUE+BOLD)
                        --------------------------------------------------
                        Bilgi/uyarı/hata mesajları
6. [post-hooks]       Hook çalıştırma bilgisi
7. [final_summary]    ======== kutusu (GREEN)
```

### Çıktı Tipleri:

| Tip              | Format                    | Kullanıldığı Yer              |
|------------------|---------------------------|-------------------------------|
| **Başlık Kutusu**| `========` ile çevrelenmiş | system_header, final_summary  |
| **Bölüm Header** | `>>> Başlık >>>` + `-----`| Her güncelleme adımı          |
| **Prefixed Satır**| `[X]`, `[+]`, `[!]`, `[i]`| Hata, başarı, uyarı, bilgi   |
| **Hint Satırı**  | `    💡 Çözüm/Öneri: ...` | Hata ve uyarı detayları       |
| **Tablo**        | `printf %-12s %-8s ...`   | Sadece `do_history`           |
| **Checklist**    | `[N/9] label ... ✓/✗/-`  | Sadece `do_doctor`            |
| **Saf JSON**     | `{ "key": "value" }`      | `--json` / `--json-full` modu|
| **Düz Metin**    | `echo "..."` (renksiz)    | Help, log dosyası             |

### Tablo Kullanımı:
- `do_history` (satır 1077): `printf '%-12s %-8s %-10s %s\n'` ile hizalanmış 4 sütun.
- `do_doctor` (satır 1162-1328): Pseudo-checklist formatı (`[N/9] Label ... ✓/✗`).
- **Gerçek tablo çerçevesi (grid)**: Yok. Tablolar sütun hizalama ile yapılmış, çerçeve çizgisi yok.

---

## 7. Emoji Kullanımı

| Emoji | Kullanıldığı Yer                     | Satır      |
|-------|---------------------------------------|------------|
| 💡    | `print_error_with_hint` (Çözüm)      | 252        |
| 💡    | `print_warning_with_hint` (Öneri)     | 275        |
| 🤖    | Mod bilgisi (Otomatik)                | 2603       |
| 👤    | Mod bilgisi (İnteraktif)              | 2603       |
| ✅    | `do_uninstall` (başarılı silme)       | 2370, 2385 |
| ❌    | `do_uninstall` (başarısız silme)      | 2377       |
| ✓     | `do_doctor` (check passed)            | 1165, vb.  |
| ✗     | `do_doctor` (check failed)            | 1167, vb.  |
| ⚠️    | `send_notification` (hata başlığı)    | 988        |

---

## 8. Eksiklikler ve Tutarsızlıklar Özeti

| # | Sorun                                      | Detay                                               |
|---|--------------------------------------------|------------------------------------------------------|
| 1 | Terminal renk desteği kontrol edilmiyor     | `tput colors` veya `TERM` kontrolü yok               |
| 2 | `NO_COLOR` desteği yok                     | https://no-color.org/ standardına uyum sağlanmamış    |
| 3 | Spinner/progress bar yok                   | Uzun süren işlemlerde (apt update, dnf upgrade) görsel feedback yok |
| 4 | Box drawing tutarsızlığı                   | history/doctor: Unicode `═─`, diğerleri: ASCII `=-`  |
| 5 | Rounded corner karakterleri kullanılmıyor  | `╭╮╰╯│` hiç yok - modern TUI görünümü eksik         |
| 6 | help çıktısı renksiz                       | `show_help` gövdesinde sadece echo, renk yok         |
| 7 | Pipe/redirect algılama yok                 | `[ -t 1 ]` kontrolü yapılmıyor, pipe'a renk kodu gider |
| 8 | Doctor checklist'te renk prefix'te         | Satır sonunda değil, `%b` ile inline, hizalama bozulabilir |
| 9 | Quiet modda JSON error/warning hala sessiz | JSON modunda `print_error` stdout'a yazmıyor ama `add_json_error` çağrılıyor - tutarlı |
