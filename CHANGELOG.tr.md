# Değişiklik Günlüğü

Bu projedeki tüm önemli değişiklikler bu dosyada belgelenecektir.

Format [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) standardına,
versiyon numaraları ise [Semantic Versioning](https://semver.org/spec/v2.0.0.html) standardına uygundur.

## [6.2.1] - 2026-02-03 "Fluent Edition - Foxtrot"
### Düzeltilenler
- **GPG keyring izolasyonu:** `GNUPGHOME` ile izole temp keyring kullanımı
  - Sistem/root GPG keyring'i artık kirletilmiyor
  - Her doğrulamada temiz, geçici keyring oluşturulur
  - Doğrulama sonrası otomatik cleanup

---

## [6.2.0] - 2026-02-03 "Fluent Edition - Foxtrot"
### Eklenenler
- **GPG imza doğrulaması:** Self-update için GPG imza doğrulaması eklendi
  - Yeni fonksiyon: `verify_gpg_signature()` - SHA256SUMS.asc dosyasını doğrular
  - Public key otomatik olarak GitHub'dan indirilir ve import edilir
  - GPG yoksa uyarı ile devam eder (graceful degradation)
  - Geçersiz imza E032 hata kodu ile reddedilir
- **Yeni URL sabitleri:**
  - `GITHUB_SHA256_SIG_URL`: İmza dosyası için
  - `GITHUB_PUBKEY_URL`: Public key için

### Değişenler
- **Codename:** Echo → Foxtrot (v6.2.x minor serisi)

---

## [6.1.1] - 2026-02-03 "Fluent Edition - Echo"
### Düzeltilenler
- **Timeout parametreleri:** `download_file()` ve bağlantı kontrollerinde timeout eklendi
  - curl: `--connect-timeout 10 --max-time 300`
  - wget: `--timeout=30 --tries=2`
  - Yavaş bağlantı veya firewall durumunda asılı kalma önlendi
- **Arch Linux reboot kontrolü:** Kernel modül dizini kontrolü eklendi
  - `/usr/lib/modules/$(uname -r)` yoksa reboot gerekli
- **DNF5 uyumluluğu:** `wait_for_dnf_lock()` fonksiyonuna `dnf5` eklendi (Fedora 41+)
- **Kod temizliği:** Kullanılmayan `deleted_count` değişkeni kaldırıldı (logrotate yönetiyor)

---

## [6.1.0] - 2026-02-02 "Fluent Edition - Echo"
### Eklenenler
- **--doctor komutu:** 6 diagnostik test ile sistem sağlık kontrolü
  - Config dosyası syntax doğrulama
  - Gerekli komut kontrolü (curl/wget)
  - Opsiyonel komut kontrolü (flatpak, snap, fwupd, timeshift, snapper)
  - Disk alanı doğrulama (minimum 500MB)
  - İnternet bağlantı testi (GitHub erişilebilirliği)
  - Dil dosyaları kontrolü
- **--history [N] komutu:** Güncelleme geçmişi görüntüleyici
  - Son N günün güncelleme loglarını gösterir (varsayılan: 7)
  - Tarih, saat, durum (OK/HATA/DRY) ve detayları görüntüler
  - `/var/log/bigfive-updater/` dizininden log dosyalarını parse eder
- **Yeni komutlar için i18n:** Her iki dil dosyasına ~50 MSG_ değişkeni eklendi
  - Sağlık kontrolü çıktısı için `MSG_DOCTOR_*` mesajları
  - Geçmiş görüntüleme için `MSG_HISTORY_*` mesajları
  - --help için `MSG_HELP_OPT_DOCTOR` ve `MSG_HELP_OPT_HISTORY`
- **Shell completion güncellemeleri:** Tüm shell'lere --doctor, --history, --lang eklendi
  - Bash: `completions/guncel.bash`
  - Zsh: `completions/_guncel`
  - Fish: `completions/guncel.fish`

### Düzeltilenler
- **Güvenlik iyileştirmeleri:**
  - `safe_source()`: Kaynak almadan önce config dosyası sahiplik ve izin doğrulama
  - `safe_mktemp()`: Doğru izinlerle güvenli geçici dosya oluşturma
  - --auto modu için NOPASSWD kontrolü (E041 hata kodu)
  - Root olmayan kullanıcılar için sahiplik kontrolü gevşetildi
- **ShellCheck düzeltmeleri:** Kullanılmayan değişkenler kaldırıldı (SC2034)
  - History fonksiyonunda `pkg_count`
  - release.sh'de `bad_commits`

### Değişenler
- **release.sh:** Dev-V1.3.1'e güncellendi
  - `get_current_version()` hata yönetimi eklendi
  - Commit ve tag'ler için GPG imzalama
  - Injection önleme için `escape_for_sed()`
  - X.Y.Z format kontrolü için `validate_version()`
  - Rollback için `cleanup_on_error()` trap
- **install.sh:** Night-V1.4.2'ye güncellendi
  - TLS 1.3 desteği olmayan eski sistemler için wget fallback
- **Man sayfaları:** 6.1.0 sürümüne güncellendi
  - --doctor ve --history dokümantasyonu eklendi
  - Yeni komutlar için örnekler eklendi

---

## [6.0.2] - 2026-01-30 "Fluent Edition - Echo"
### Eklenenler
- **Disk Alanı Kontrolü:** Güncelleme öncesi disk alanı kontrolü
  - `check_disk_space()` fonksiyonu eklendi
  - Varsayılan 500MB minimum gereksinim
  - E040 hata kodu ile kullanıcı dostu mesaj
- **Türkçe Man Page Kurulumu (install.sh):**
  - `docs/guncel.8.tr` artık `/usr/share/man/tr/man8/guncel.8` olarak kuruluyor
  - `LANG=tr_TR.UTF-8 man guncel` ile Türkçe dokümantasyon
- **i18n BATS Testleri:** 13 yeni test eklendi (toplam 151 test)
  - `--lang tr/en` flag testleri
  - `BIGFIVE_LANG` env var testleri
  - Fallback ve dil dosyası eşitlik kontrolleri
- **AUR Paketi:** Arch Linux kullanıcıları için resmi AUR paketi
  - `yay -S bigfive-updater` ile kurulum
  - https://aur.archlinux.org/packages/bigfive-updater
- **Alpine APKBUILD:** Alpine Linux paket desteği
  - `packaging/alpine/APKBUILD` eklendi
  - Subpackages: doc, bash-completion, zsh-completion, fish-completion
- **GitHub Actions Paket Workflow:** Otomatik paket build
  - `.github/workflows/packages.yml`
  - Her release'de Arch ve Alpine paketleri otomatik build

### Değişenler
- **Atomic Self-Update:** Self-update mekanizması atomic replace pattern kullanıyor
  - Eski: `install -m 0755 "$REMOTE_FILE" "$0"` (kesintide bozulabilir)
  - Yeni: `install -m 0755 "$REMOTE_FILE" "${0}.tmp" && mv "${0}.tmp" "$0"` (atomic)
  - `mv` aynı filesystem'de atomic işlem - kesinti olursa orijinal korunur
- VERSION: 6.0.1 → 6.0.2
- install.sh VERSION: Night-V1.4.0 → Night-V1.4.1

---

## [6.0.1] - 2026-01-30 "Fluent Edition - Echo"
### Düzeltilenler
- **printf invalid number hatası:** `grep -c` komutu eşleşme olmadığında exit code 1
  döndürüyordu ve `|| echo "0"` da çalışarak çift çıktı (`0\n0`) üretiyordu.
  Bu durum `printf %d` için geçersiz sayı hatası oluşturuyordu.
  - Etkilenen: APT, DNF, Pacman, Zypper, APK, fwupd sayaçları
  - Çözüm: `COUNT=$(... | grep -c ... 2>/dev/null) || COUNT=0`

### Değişenler
- VERSION: 6.0.0 → 6.0.1

---

## [6.0.0] - 2026-01-30 "Fluent Edition - Echo"
### Eklenenler
- **i18n (Çoklu Dil Desteği):** Türkçe ve İngilizce tam destek
  - `lang/tr.sh`: Türkçe dil dosyası (~110 string)
  - `lang/en.sh`: İngilizce dil dosyası (~110 string)
  - `--lang <code>` parametresi ile dil seçimi (tr, en)
  - `BIGFIVE_LANG` environment variable desteği
  - Sistem LANG ayarına göre otomatik dil tespiti
- **Dil Dosyası Konumları:**
  - Kurulu: `/usr/share/bigfive-updater/lang/`
  - Geliştirme: Script'in yanındaki `lang/` dizini

### Değişenler
- VERSION: 5.5.2 → 6.0.0
- CODENAME: Dream → Echo
- Tüm kullanıcı mesajları MSG_* değişkenlerine taşındı

---

## [5.5.2] - 2026-01-30 "BigFive Edition - Dream"
### Düzeltilenler
- **pgrep bağımlılığı:** `wait_for_dnf_lock()` fonksiyonunda pgrep bulunamadığında
  DNF kilit kontrolünü atlıyor (Alpine ve minimal container'larda sorun çözüldü)
- **Zypper sayaç parsing:** `update_zypper()` çıktısından gerçek güncelleme sayısı
  doğru alınıyor (Installing/Upgrading satırları sayılıyor)

### Değişenler
- VERSION: 5.5.1 → 5.5.2

---

## [5.5.1] - 2026-01-30 "BigFive Edition - Dream"
### Eklenenler
- **Gelişmiş Hata Mesajları (Error UX):** Kullanıcı dostu hata mesajları
  - `print_error_with_hint()`: Hata + çözüm önerisi
  - `print_warning_with_hint()`: Uyarı + öneri
  - Hata kodları sistemi (E001, E002, E010, E011, E020, E021, E030, E031)
- **Düzeltilen Hata Mesajları:**
  - E001: curl/wget bulunamadı → kurulum önerisi
  - E002: sudo yok → alternatif çözüm
  - E010: APT kilidi → kontrol komutu
  - E011: DNF kilidi → process kontrolü
  - E020: Başka güncelleme çalışıyor → kilit dosyası bilgisi
  - E021: İnternet bağlantısı yok → test komutu
  - E030: SHA256 doğrulama başarısız → çözüm önerisi
  - E031: Güncelleme kopyalanamadı → disk/izin kontrolü

### Değişenler
- VERSION: 5.5.0 → 5.5.1

---

## [5.5.0] - 2026-01-30 "BigFive Edition - Dream"
### Eklenenler
- **Tam Rebranding:** Proje adı `arcb-wider-updater` → `bigfive-updater` olarak değiştirildi
  - GitHub repository rename edildi
  - Tüm referanslar güncellendi (README, CHANGELOG, scripts, Docker)
  - Log dizini: `/var/log/arcb-updater/` → `/var/log/bigfive-updater/`
  - Config dosyası: `/etc/arcb-updater.conf` → `/etc/bigfive-updater.conf`
  - Lock dosyası: `/var/lock/arcb-updater.lock` → `/var/lock/bigfive-updater.lock`
- **CODENAME:** "Dream" - tam marka geçişi tamamlandı

### Değişenler
- VERSION: 5.4.8 → 5.5.0
- CODENAME: "Beacon" → "Dream"
- Banner: `ARCB-WIDER-UPDATER` → `BIGFIVE-UPDATER`
- GitHub URL'leri güncellendi

---

## [5.4.8] - 2026-01-29 "BigFive Edition - Beacon"
### Eklenenler
- **Zsh completion:** Tab tamamlama Zsh kabukları için (`completions/_guncel`)
  - Tüm seçenekler ve backend'ler için tamamlama
  - `/usr/share/zsh/site-functions/` dizinine kurulum
- **Fish completion:** Tab tamamlama Fish kabukları için (`completions/guncel.fish`)
  - Tüm seçenekler ve backend'ler için tamamlama
  - `/usr/share/fish/vendor_completions.d/` dizinine kurulum
- **JSON paket detayları:** `--json-full` modunda güncellenen paketlerin listesi
  - APT, DNF, Pacman, Zypper, APK, Flatpak, Snap için paket bilgileri
  - Paket adı, eski versiyon, yeni versiyon bilgileri
- **Snapshot timeout:** Timeshift/Snapper için zaman aşımı desteği
  - `CONFIG_SNAPSHOT_TIMEOUT=300` (varsayılan 5 dakika)
  - Timeout durumunda JSON warning ekleniyor
- **10 yeni BATS testi:** Zsh ve Fish completion doğrulama testleri

### Değişenler
- install.sh versiyonu: Night-V1.3.1 → Night-V1.3.2
- Toplam BATS testleri: 128 → 138

---

## [5.4.7] - 2026-01-29 "BigFive Edition - Beacon"
### Düzeltilenler
- **DNF5 sayaç parsing:** Transaction Summary'den "Upgrading: X packages" satırını parse ediyor
  - DNF5 çıktı formatı DNF4'ten farklı, eski pattern'ler çalışmıyordu
  - Fedora 43+ sistemlerde "DNF: 0" gösterme sorunu düzeltildi
- **Zypper sayaç parsing:** `zypper lu` çıktısından doğru paket sayısı alınıyor
  - Eski `grep -c "^v"` pattern'i yanlıştı
- **install.sh temp file cleanup:** TEMP_COMPLETION ve TEMP_MAN trap'e eklendi
  - Script kesildiğinde temp dosyaları temizleniyor

### Değişenler
- install.sh versiyonu: Night-V1.3.0 → Night-V1.3.1

---

## [5.4.6] - 2026-01-29 "BigFive Edition - Beacon"
### Düzeltilenler
- **Self-update indirme URL'i:** `GITHUB_RAW_URL` raw.githubusercontent.com'dan releases URL'e değiştirildi
  - raw.githubusercontent.com CDN cache'i nedeniyle eski dosya döndürebiliyordu
  - SHA256SUMS releases'den geldiği için hash uyuşmazlığı oluşuyordu
  - Artık hem dosya hem SHA256 aynı kaynaktan (releases) geliyor

---

## [5.4.5] - 2026-01-29 "BigFive Edition - Beacon"
### Düzeltilenler
- **Self-update SHA256 doğrulama:** `check_self_update()` fonksiyonundaki grep pattern düzeltildi
  - Eski: `grep "guncel"` → `guncel`, `guncel.bash`, `guncel.8` (3 hash döndürüyordu)
  - Yeni: `grep -E "  guncel$"` → sadece `guncel` (tek hash)
  - Bu hata self-update'i tamamen engelliyordu ("SHA256 doğrulama başarısız" hatası)

---

## [5.4.3] - 2026-01-29 "BigFive Edition - Beacon"
### Düzeltilenler
- **Kurulum URL'i:** raw.githubusercontent.com yerine releases URL kullanılıyor (CDN cache sorunu önlendi)
- **SHA256 checksum doğrulama:** Tam dosya adı `guncel` eşleşmesi için grep pattern düzeltildi (`guncel.bash` veya `guncel.8` değil)

### Değişenler
- **bigfive-updater.conf.example:** v5.4.x'e güncellendi, `CONFIG_JSON_MODE` opsiyonu eklendi
- **guncel:** `load_config()` fonksiyonuna `CONFIG_JSON_MODE` desteği eklendi

---

## [5.4.1] - 2026-01-29 "BigFive Edition - Beacon"
### Eklenenler
- **Man sayfası:** Troff formatında tam kılavuz sayfası (`docs/guncel.8`)
  - Tüm seçenekler, backend'ler, yapılandırma ve örnekleri kapsar
  - `man updater` ve `man bigfive` için symlink'ler
  - `install.sh` ile otomatik kurulum
- **7 yeni BATS testi:** Man sayfası doğrulama testleri

### Dokümantasyon
- Man sayfası `man guncel` ile erişilebilir

---

## [5.4.0] - 2026-01-29 "BigFive Edition - Beacon"
### Eklenenler
- **Bash tamamlama:** Tüm seçenekler ve backend'ler için Tab tamamlama
  - Dosya: `completions/guncel.bash`
  - `guncel`, `updater` ve `bigfive` komutlarını destekler
  - `--skip` ve `--only` backend isimleriyle tamamlanır
  - `/usr/share/bash-completion/completions/` dizinine otomatik kurulum
- **8 yeni BATS testi:** Bash tamamlama doğrulama testleri
- **install.sh:** Artık bash completion ve man sayfasını otomatik kuruyor

### Değişenler
- install.sh versiyonu: Night-V1.2.1 → Night-V1.3.0
- release.yml: `guncel.bash` ve `guncel.8` release asset'lerine eklendi
- Toplam BATS testleri: 70 → 85

---

## [5.3.0] - 2026-01-29 "BigFive Edition - Beacon"
### Eklenenler
- **JSON Çıktı Modu:** Makine tarafından okunabilir çıktı için `--json` ve `--json-full` bayrakları
  - `--json`: Monitoring sistemleri için hafif JSON (Zabbix, Nagios, Prometheus)
  - `--json-full`: SIEM/audit sistemleri için detaylı JSON (Wazuh, Splunk, ELK)
- **JSON yardımcı fonksiyonları:** `json_escape()`, `add_pkg_manager_status()`, `get_distro_info()`
- **Paket yöneticisi durum takibi:** Her backend durumunu JSON çıktısına raporlar
- **Yeni BATS testleri:** 10 yeni JSON ile ilgili test

### JSON Çıktı Alanları
- Hafif (`--json`): version, status, exit_code, timestamp, hostname, duration_seconds, dry_run, updated_count, reboot_required
- Detaylı (`--json-full`): Tüm hafif alanlar artı sistem bilgisi, package_managers dizisi, packages dizisi, snapshot bilgisi, warnings, errors

### Değişenler
- VERSION: 5.2.1 → 5.3.0
- JSON modu otomatik olarak sessiz modu etkinleştirir (terminal çıktısı yok)

### Dokümantasyon
- Tüm README dosyaları JSON çıktı dokümantasyonu ile güncellendi
- Monitoring entegrasyonları için JSON örnekleri eklendi

---

## [5.2.1] - 2026-01-29 "BigFive Edition - Alpine"
### Eklenenler
- **EDITION değişkeni:** Edition adını Codename'den ayır
  - Edition = Major seri adı (örn: "BigFive" v5.x için)
  - Codename = Minor sürüm adı (örn: "Alpine" v5.2.x için)
- **`bigfive` komut alias'ı:** Uluslararası/marka ismi komutu
  - Artık 3 komut mevcut: `guncel` (Türkçe), `updater` (İngilizce), `bigfive` (Marka)
- **Kaldırma sırasında symlink temizliği:** `do_uninstall()` artık `updater` ve `bigfive` symlink'lerini de kaldırır

### Değişenler
- VERSION: 5.2.0 → 5.2.1
- Versiyon gösterim formatı: `v5.2.1 (BigFive Edition - Alpine)`
- `show_help()` artık üç komut alias'ını da gösteriyor
- install.sh versiyonu: Night-V1.1.0 → Night-V1.2.0
- install.sh artık `updater` yanında `bigfive` symlink de oluşturuyor

### Dokümantasyon
- Tüm dokümanlar `*.en.md` / `*.tr.md` isimlendirme kuralına standardize edildi
- README dosyaları Edition/Codename açıklamasıyla güncellendi
- Tüm versiyon referansları güncellendi

---

## [5.2.0] - 2026-01-28 "BigFive"
### Eklenenler
- **Alpine Linux Desteği:** Alpine Linux paket yönetimi için yeni `update_apk()` fonksiyonu
  - Sistem güncellemeleri için `apk update && apk upgrade`
  - Önbellek temizliği için `apk cache clean`
- **APK_COUNT değişkeni:** Özette Alpine paket güncellemelerini takip eder
- **Alpine CI Testi:** Multi-distro test matrisine Alpine 3.20 eklendi
- **Yeni BATS testleri:** 4 yeni APK-specific test (guncel.bats için toplam 60)

### Değişenler
- VERSION: 5.0.0 → 5.2.0
- CODENAME: "BigFour" → "BigFive"
- `should_run_backend()` artık `apk`'yı geçerli backend olarak tanıyor
- Execution chain: `update_apt || update_dnf || update_pacman || update_zypper || update_apk`
- Yardım metni `--skip apk` ve `--only apk` seçenekleriyle güncellendi
- `print_summary()` artık APK güncelleme sayısını gösteriyor

### Dokümantasyon
- BigFive için README.tr.md ve README.en.md güncellendi
- CI workflow yorumları güncellendi

## [5.0.0] - 2026-01-28 "BigFour"
### Eklenenler
- **Arch Linux Desteği:** Yeni `update_pacman()` fonksiyonu
  - Sistem güncellemeleri için `pacman -Sy && pacman -Su --noconfirm`
  - `pacman -Rns` ile yetim paket temizliği
  - `paccache` ile önbellek temizliği (varsa)
- **openSUSE Desteği:** Yeni `update_zypper()` fonksiyonu
  - `zypper refresh && zypper --non-interactive update`
  - Yetim paket tespiti
- **PACMAN_COUNT ve ZYPPER_COUNT değişkenleri:** Backend başına güncelleme takibi
- **Multi-distro CI matrisi:** Ubuntu, Fedora, Arch Linux, openSUSE Tumbleweed
- **Yeni BATS testleri:** 9 yeni BigFour testi (toplam 56)

### Değişenler
- VERSION: 4.1.4 → 5.0.0
- CODENAME: "Signed" → "BigFour"
- `should_run_backend()` artık `pacman` ve `zypper`'ı tanıyor
- 4 paket yöneticisi için execution chain güncellendi
- Yardım metni BigFour seçenekleriyle güncellendi

### Dokümantasyon
- Arch ve openSUSE kullanıcıları için kapsamlı README güncellemeleri
- Docker test ortamı dokümantasyonu

## [4.1.5] - 2026-01-28
### Eklenenler
- **`updater` symlink:** `guncel` komutu için İngilizce alias
- **TLS 1.2+ güçlendirmesi:** Tüm curl/wget çağrıları modern TLS kullanıyor
  - curl: `--proto '=https' --tlsv1.2`
  - wget: `--secure-protocol=TLSv1_2`
- **PATH export:** Standart sistem dizinleri için Cron uyumluluğu sağlar
- **`--uninstall` seçeneği:** ARCB Wider Updater'ı sistemden kaldır
- **`--uninstall --purge`:** Config ve loglar dahil tamamen kaldır

### Değişenler
- VERSION: 4.1.4 → 4.1.5
- install.sh `guncel` yanında `updater` symlink oluşturuyor

### Güvenlik
- TLS güçlendirmesi indirmeler sırasında downgrade saldırılarını önler

## [4.1.4] - 2026-01-28
### Değişenler
- VERSION: 4.1.3 → 4.1.4
- `release.sh` scripti ile release automation testi

## [4.1.3] - 2026-01-28
### Değişenler
- VERSION: 4.1.2 → 4.1.3
- Kod ve GitHub release arasında versiyon numarası senkronizasyonu

## [4.1.2] - 2026-01-28
### Düzeltilenler
- **GitHub Actions GPG İmzalama:** CI ortamı için `--batch --yes` flag'leri eklendi
  - Non-interactive ortamda "cannot open '/dev/tty'" hatasını düzeltir

### Değişenler
- VERSION: 4.1.0 → 4.1.2
- CODENAME: "Signed"

## [4.1.0] - 2026-01-28
### Eklenenler
- **Modüler Update Fonksiyonları:** Her backend (APT, DNF, Flatpak, Snap, Firmware) artık kendi dedicated fonksiyonuna sahip
  - `update_apt()`, `update_dnf()`, `update_flatpak()`, `update_snap()`, `update_firmware()`
  - Daha temiz kod yapısı, bakımı ve genişletmesi kolay

### Değişenler
- VERSION: 4.0.0 → 4.1.0
- CODENAME: "Polished" → "Signed"
- `perform_updates()` modüler fonksiyonları kullanacak şekilde refactor edildi

## [Night-V1.1.0] - 2026-01-28 (install.sh)
### Eklenenler
- **GPG İmza Doğrulama:** Kurulum sırasında tam kriptografik doğrulama
  - `pubkey.asc`'den public key indirir ve import eder
  - `SHA256SUMS.asc` imzasını public key'e karşı doğrular
  - İndirilen dosya hash'ini imzalı checksum'lara karşı validate eder
  - Doğrulama başarısız olursa kurulum iptal edilir
- **`updater` symlink:** Kurulum sırasında İngilizce alias oluşturulur
- **TLS 1.2+ güçlendirmesi:** Modern TLS ile güvenli indirmeler
- Yeni değişkenler: `GPG_PUBKEY_URL`, `GPG_SHA256SUMS_URL`, `GPG_SHA256SUMS_SIG_URL`
- GPG kurulu değilse graceful fallback ile `verify_gpg_signature()` fonksiyonu

### Güvenlik
- **Supply Chain Güvenliği:** Değiştirilmiş scriptlerin kurulumunu önler
- Yerel dosya kurulumlarında GPG doğrulaması atlanır (geliştirici workflow'u)

### Değişenler
- install.sh versiyonu: Night-V1.0.0 → Night-V1.1.0
- Banner güncellendi: ">>> ARCB Wider Updater Kurulum (Night-V1.1.0)"

## [4.0.0] - 2026-01-26
### Değişenler
- **Header Sadeleştirildi:** Script header yorumundan versiyon bilgisi kaldırıldı, sadece proje adı ve GitHub URL kaldı
- **VERSION:** 3.9.1 → 4.0.0
- **CODENAME:** "Tested" → "Polished"
- **Yardım Metni Güncellendi:** `--skip` seçeneği artık `system`'i `dnf` ve `apt` yanında gösteriyor
  - Yeni format: `Değerler: snapshot, flatpak, snap, fwupd, system (veya dnf, apt)`

### İyileştirmeler
- **install.sh:** Başarılı kurulumdan sonra VERSION yanında CODENAME gösteriyor
  - Yeni format: `✅ Kurulum Başarılı! (v4.0.0 - Polished)`

### Dokümantasyon
- Tüm README dosyaları (README.md, README.tr.md, README.en.md) v4.0.0 versiyon bilgisiyle güncellendi
- BATS testleri v4.0.0 ve "Polished" codename bekleyecek şekilde güncellendi

## [3.9.1] - 2026-01-26
### Düzeltilenler
- **DNF Lock Kontrolü:** Alternatifler yerine literal string arayan bozuk `pgrep -x "dnf|yum|rpm"` pattern'i düzeltildi
  - Şimdi doğru kullanıyor: `! pgrep -x dnf && ! pgrep -x yum && ! pgrep -x rpm`

### Değişenler
- **SKIP_DNF → SKIP_PKG_MANAGER:** Semantik netlik için flag yeniden adlandırıldı
  - Eski `SKIP_DNF` yanıltıcıydı çünkü hem APT hem DNF'i etkiliyordu
  - Yeni `SKIP_PKG_MANAGER` tüm paket yöneticilerini atladığını açıkça belirtiyor
  - `--skip dnf|apt|system` seçenek dokümantasyonu güncellendi
- VERSION: 3.9.0 → 3.9.1

## [3.9.0] - 2026-01-26
### Eklenenler
- **BATS Test Altyapısı:** Bash Automated Testing System kullanan kapsamlı unit test suite'i
  - `tests/test_helper.bash`: Testler için ortak helper fonksiyonları
  - `tests/guncel.bats`: 30+ test case içeren ana test dosyası
  - Testler kapsıyor: --help, --version, --dry-run, --skip/--only flag'leri, color değişkenleri, kritik fonksiyonlar
- **Geliştirilmiş CI Workflow:** Güncellenmiş `.github/workflows/test.yml`
  - BATS kurulumu ve test execution eklendi
  - shellcheck, syntax-check, bats-tests, help-output, version-output için ayrı job'lar
- **README Test Bölümü:** Testleri yerel olarak çalıştırma dokümantasyonu eklendi
  - BATS kurulum talimatları (apt, brew)
  - Test execution komutları

### Değişenler
- VERSION: 3.8.2 → 3.9.0
- CODENAME: "Documented" → "Tested"

## [3.8.2] - 2026-01-26
### Düzeltilenler
- **Color Değişken Düzeltmesi:** Terminal renkleri için ANSI escape sequence'leri düzeltildi

## [3.8.1] - 2026-01-26
### Eklenenler
- **Test Otomasyonu:** Yeni GitHub Actions workflow `.github/workflows/test.yml`
  - `guncel` ve `install.sh` için ShellCheck lint
  - Bash syntax doğrulama (`bash -n`)
  - `--help` output doğrulama
  - push ve pull_request'te tetiklenir
- **README Bölünmesi:** Dokümantasyon dile özel dosyalara ayrıldı
  - `README.md` → Her iki dile link veren kısa özet
  - `README.tr.md` → Tam Türkçe dokümantasyon
  - `README.en.md` → Tam İngilizce dokümantasyon
- **Versiyon Sistemi Dokümantasyonu:** Çift versiyonlama açıklaması eklendi
  - `guncel`: SemVer (3.x.x) - Her özellik/fix'te güncellenir
  - `install.sh`: Night-Vx.x.x - Sadece kurulum mantığı değiştiğinde güncellenir

### Düzeltilenler
- **fwupd Exit Code Handling:** `fwupdmgr get-updates` "No updatable devices" için exit code 2 döndürüyor
  - Bu artık başarı olarak kabul ediliyor (hata değil)
  - Güncellenebilir firmware'i olmayan sistemlerde yanlış hata mesajlarını önler
  - Hem dry-run hem de gerçek güncelleme modları bunu doğru işliyor

### Değişenler
- VERSION: 3.8.0 → 3.8.1
- CODENAME: "Automated" → "Documented"
- **CONTRIBUTING.md:** Kapsamlı kılavuzlarla genişletildi
  - Kod stili: ShellCheck kuralları, 4-space indent, POSIX uyumluluğu
  - Commit mesaj formatı: `type(scope): description`
  - Versiyon yönetimi: SemVer açıklaması, çift versiyon sistemi
  - Test senaryoları: shellcheck, bash -n, --dry-run, --help
  - PR süreci: branch isimlendirme, review checklist

## [Night-V1.0.0] - 2026-01-26 (install.sh)
### Değişenler
- **install.sh artık ayrı versiyon sistemi kullanıyor**
  - Format: Night-Vx.x.x
  - Ana script (guncel) versiyonundan bağımsız
  - Kurulum banner: ">>> ARCB Wider Updater Kurulum (Night-V1.0.0)"


## [3.8.0] - 2026-01-26
### Eklenenler
- **GitHub Actions Release Automation:** Tag push'ta otomatik release oluşturma
  - Yeni workflow: `.github/workflows/release.yml`
  - Tetikleyici: `push tags v*`
  - `guncel` ve `install.sh` için otomatik `SHA256SUMS` oluşturur
  - Checksum'lar ekli GitHub Release oluşturur
- **--dry-run modu:** Uygulamadan güncellemeleri önizle
  - APT, DNF, Flatpak, Snap ve Firmware için mevcut güncellemeleri gösterir
  - Native list komutlarını kullanır: `apt list --upgradable`, `flatpak remote-ls --updates`, vb.
  - Sistemde değişiklik yapılmaz - test için güvenli

### Değişenler
- VERSION: 3.7.2 → 3.8.0
- CODENAME: "Rotated" → "Automated"
- --help --dry-run seçeneği ve örneklerle güncellendi
- dry-run modunda self-update atlanır

### Notlar
- Release automation ek kurulum gerektirmez - yerleşik GITHUB_TOKEN kullanır
- Release oluşturmak için: `git tag v3.8.0 && git push origin v3.8.0`

## [3.7.2] - 2026-01-26
### Düzeltilenler
- **Hotfix:** Zorin OS 18'de syntax error'a neden olan Flatpak counter newline bug'ı düzeltildi
  - `wc -l` çıktısı bazen arithmetic expression'ları bozan newline karakterleri içerir
  - Tüm counter değişkenlerine (flatpak, snap, fwupd) `tr -cd '0-9'` sanitization eklendi
  - Düzeltir: `[[: 0\n0: syntax error in expression` satır 666'da

## [3.7.1] - 2026-01-25
### Düzeltilenler
- install.sh renk kodları ve ilk karakter görüntüleme sorunu düzeltildi
- Güvenilir çıktı için echo -e yerine ANSI-C quoting ile printf'e geçildi

## [v3.7.0] - 2026-01-25

### Eklenenler
- **Logrotate desteği:** Otomatik log rotation ve temizlik
  - Yeni config dosyası: `/etc/logrotate.d/bigfive-updater`
  - Haftalık rotation, 4 haftalık log tutar
  - Eski logları otomatik sıkıştırır
  - install.sh aracılığıyla otomatik kurulur
- **Log yönetimi dokümantasyonu:** README'ye (TR/EN) eklendi

### Değişenler
- VERSION: 3.6.1 → 3.7.0
- CODENAME: "Configurable" → "Rotated"
- guncel'deki manuel log temizliği devre dışı (artık logrotate hallediyor)
- install.sh logrotate config'i kuracak şekilde güncellendi

### Kaldırılanlar
- Manuel 30 günlük log silme (logrotate ile değiştirildi)

## [v3.6.0] - 2026-01-25

### Eklenenler
- **--skip/--only flag'leri:** Seçici backend execution
  - Belirli backend'leri atlamak için `--skip snapshot,flatpak,snap,fwupd,dnf`
  - Sadece belirtilen backend'leri çalıştırmak için `--only system,flatpak,fwupd`
  - Örnek: `guncel --skip flatpak,snap` veya `guncel --only dnf`
- **Config dosyası desteği:** `/etc/bigfive-updater.conf`
  - Varsayılan modları, skip ayarlarını ve renkleri tanımla
  - Komut satırı argümanları config ayarlarını override eder
- **Self-update sırasında SHA256 doğrulama:**
  - GitHub Releases'den `SHA256SUMS` indirir
  - Hash eşleşmezse güncellemeyi iptal eder
  - Değiştirilmiş indirmelere karşı güvenlik sağlar
- **.bak yedekleme mekanizması:**
  - Self-update öncesi `/usr/local/bin/guncel.bak` oluşturur
  - Kolay rollback sağlar: `sudo cp /usr/local/bin/guncel.bak /usr/local/bin/guncel`
  - install.sh de .bak yedeği oluşturur

### Değişenler
- VERSION: 3.5.0 → 3.6.0
- CODENAME: "Locked & Loaded" → "Configurable"
- Argüman parsing artık düzgün --skip/--only handling için shift ile while loop kullanıyor
- --help output yeni seçenekler ve örneklerle güncellendi

### Güvenlik
- SHA256 hash doğrulama değiştirilmiş scriptlerin kurulumunu önler
- Başarısız güncellemelerde otomatik rollback

## [v3.5.0] - 2026-01-25

### Eklenenler
- `flock` kullanarak concurrent execution lock (cron + manuel çakışmalarını önler)
- `wait_for_dnf_lock()` fonksiyonu ile DNF lock retry mekanizması
  - Çalışan dnf/yum/rpm process'lerini kontrol etmek için `pgrep` kullanır
  - 10 saniyelik aralıklarla maksimum 30 deneme
  - Lock alınamazsa DNF update'i gracefully atlar

### Değişenler
- CODENAME: "Colorful" → "Locked & Loaded"

### Notlar
- `flock` genellikle `util-linux` paketiyle gelir (çoğu sistemde önceden kurulu)

## [v3.4.6] - 2026-01-25

### Düzeltilenler
- Header display'de eksik ilk karakter düzeltildi (echo -e sorunu)
- Bozuk ANSI color code'ları düzeltildi (escape sequence'ler restore edildi)
- Satır 157'de arithmetic syntax error düzeltildi (counter'lar artık tr -cd ile sanitize ediliyor)
- Kullanıcı geri bildirimiyle header ve summary kutularından dikey çubuklar (|) kaldırıldı

### Değişenler
- Header ve summary artık sadece yatay çizgiler kullanıyor (=== ve ---)
- Renkli çıktı restore edildi (yeşil, mavi, sarı ANSI renkleri)
- Codename "Stable Output"tan "Colorful"a değiştirildi

## [v3.4.5] - 2026-01-25

### Düzeltilenler
- Satır 150'de arithmetic syntax error düzeltildi (strict mode uyumluluğu)
- Terminal uyumluluğu için Unicode box drawing karakterleri düzeltildi
- SSH/minimal sistemler için emoji karakterleri ASCII sembolleriyle değiştirildi

## [3.4.4] - 2026-01-25

### Eklenenler
- Versiyon, host, kullanıcı, kernel, RAM ve disk kullanımını gösteren güncelleme öncesi sistem header'ı.
- Backend başına güncellenen paketleri, snapshot bilgisini, reboot durumunu ve log path'ini gösteren güncelleme sonrası özet.
- `--verbose` modu: Tüm komut çıktılarını gösterir (önceki davranış gibi).
- `--quiet` modu: Sadece hataları ve son özeti gösterir.
- Debian (`/var/run/reboot-required`) ve Fedora (`needs-restarting -r`) için reboot gerekli tespiti.
- APT, DNF, Flatpak, Snap ve Firmware için güncelleme sayaçları.

### Değişenler
- Varsayılan mod artık verbose komut çıktısı olmadan bilgilendirici özetler gösteriyor.
- Codename "Security Hardened"dan "Informative"e değiştirildi.

## [3.4.3] - 2026-01-25

### Güvenlik
- Geçici dosya oluşturma sürecindeki sembolik link açığı düzeltildi.

## [3.4.2] - 2026-01-24

### Eklenenler
- Daha kolay geliştirme için installer'da akıllı yerel dosya tespiti.
- Installer ve ana script arasında versiyon senkronizasyonu.

### Düzeltilenler
- Fedora (RHEL-tabanlı) sistemler için tam uyumluluk.

## [3.4.0] - 2026-01-20

### Eklenenler
- Sağlam hata işleme için "Ironclad" modu: `set -Eeuo pipefail`.
- Güvenli environment variable handling (`sudo -E`).
- Güvenli geçici dosya kullanımı.

## [3.3.0] - 2026-01-15

### Eklenenler
- Fedora/RHEL sistemleri için başlangıç desteği.
- DNF paket yöneticisi ve Snapper snapshot entegrasyonu.
