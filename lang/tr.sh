#!/usr/bin/env bash
# BigFive Updater - Türkçe Dil Dosyası
# Language: Turkish (tr)
# Version: 6.2.0 Foxtrot Edition
# Encoding: UTF-8

# ============================================
# HEADERS - Bölüm Başlıkları
# ============================================
MSG_HEADER_SELF_UPDATE="Self-Update Başlatılıyor..."
MSG_HEADER_SNAPSHOT_TIMESHIFT="Sistem Yedekleniyor (Timeshift)"
MSG_HEADER_SNAPSHOT_SNAPPER="Sistem Yedekleniyor (Snapper)"
MSG_HEADER_APT_UPDATE="APT: Güncelleme Başlıyor"
MSG_HEADER_APT_UPGRADE="APT: Dist-Upgrade"
MSG_HEADER_APT_CLEANUP="APT: Temizlik"
MSG_HEADER_DNF_UPDATE="DNF: Güncelleme"
MSG_HEADER_PACMAN_UPDATE="Pacman: Güncelleme"
MSG_HEADER_PACMAN_ORPHAN="Pacman: Orphan Temizliği"
MSG_HEADER_ZYPPER_UPDATE="Zypper: Güncelleme"
MSG_HEADER_ZYPPER_CLEANUP="Zypper: Temizlik"
MSG_HEADER_APK_UPDATE="APK: Güncelleme"
MSG_HEADER_FLATPAK="Flatpak: Güncelleme"
MSG_HEADER_SNAP="Snap: Güncelleme"
MSG_HEADER_FIRMWARE="Firmware: Kontrol"
MSG_HEADER_DRYRUN="[DRY-RUN] Mevcut Güncellemeler Kontrol Ediliyor"

# ============================================
# INFO - Bilgi Mesajları
# ============================================
MSG_INFO_SHA256_OK="SHA256 doğrulama başarılı."
MSG_INFO_BACKUP_CREATED="Eski sürüm yedeklendi: %s"
MSG_INFO_PGREP_MISSING="pgrep bulunamadı, DNF kilit kontrolü atlanıyor."
MSG_INFO_SNAPSHOT_SKIPPED="Snapshot atlandı (--skip snapshot)"
MSG_INFO_APT_COUNT="APT: %d paket güncellendi."
MSG_INFO_DNF_COUNT="DNF: %d paket güncellendi."
MSG_INFO_PACMAN_COUNT="Pacman: %d paket güncellendi."
MSG_INFO_ZYPPER_COUNT="Zypper: %d paket güncellendi."
MSG_INFO_APK_COUNT="APK: %d paket güncellendi."
MSG_INFO_FLATPAK_COUNT="Flatpak: %d uygulama güncellendi."
MSG_INFO_SNAP_COUNT="Snap: %d paket güncellendi."
MSG_INFO_FIRMWARE_NONE="Firmware: Güncellenebilir cihaz bulunamadı."
MSG_INFO_FIRMWARE_COUNT="Firmware: %d güncelleme."
MSG_INFO_GPG_OK="GPG imza doğrulaması başarılı."

# ============================================
# SUCCESS - Başarı Mesajları
# ============================================
MSG_SUCCESS_SCRIPT_UPDATED="Script güncellendi. Yeniden başlatılıyor..."
MSG_SUCCESS_RESTORE="Geri yükleme başarılı."
MSG_SUCCESS_TIMESHIFT="Timeshift snapshot oluşturuldu."
MSG_SUCCESS_SNAPPER="Snapper snapshot oluşturuldu."
MSG_SUCCESS_UPDATE_DONE="[+] GÜNCELLEME TAMAMLANDI"

# ============================================
# WARNING - Uyarı Mesajları
# ============================================
MSG_WARN_REPO_ACCESS="Repo dosyalarına erişilemiyor. Self-update devre dışı."
MSG_WARN_SHA256_MISSING="SHA256SUMS dosyası bulunamadı, doğrulama atlanıyor."
MSG_WARN_BACKUP_FAILED="Yedek oluşturulamadı, devam ediliyor."
MSG_WARN_DNF_LOCK_WAIT="DNF kilidi bekleniyor... (%d/%d)"
MSG_WARN_TIMESHIFT_TIMEOUT="Timeshift snapshot zaman aşımına uğradı (%ds)"
MSG_WARN_TIMESHIFT_FAILED="Timeshift snapshot başarısız oldu (exit: %d)"
MSG_WARN_SNAPPER_TIMEOUT="Snapper snapshot zaman aşımına uğradı (%ds)"
MSG_WARN_SNAPPER_FAILED="Snapper snapshot oluşturulamadı."
MSG_WARN_FLATPAK_ERROR="Flatpak hata verdi."
MSG_WARN_SNAP_ERROR="Snap hata verdi."
MSG_WARN_FIRMWARE_FAILED="Firmware kontrolü başarısız (exit code: %d)"
MSG_WARN_GPG_MISSING="GPG bulunamadı, imza doğrulama atlanıyor."
MSG_WARN_GPG_KEY_FAIL="Public key indirilemedi, GPG doğrulama atlanıyor."
MSG_WARN_GPG_IMPORT_FAIL="Public key import edilemedi, GPG doğrulama atlanıyor."
MSG_WARN_GPG_SIG_MISSING="SHA256SUMS.asc bulunamadı, GPG doğrulama atlanıyor."

# ============================================
# ERROR - Hata Mesajları
# ============================================
MSG_ERR_NO_CURL="Sistemde 'curl' veya 'wget' bulunamadı!"
MSG_ERR_NO_SUDO="Sudo yok ve root değilsin."
MSG_ERR_SHA256_FAIL="SHA256 doğrulama başarısız! Güncelleme iptal edildi."
MSG_ERR_COPY_FAIL="Güncelleme kopyalanamadı!"
MSG_ERR_APT_LOCK="APT kilitleri kaldırılamadı."
MSG_ERR_DNF_LOCK="DNF kilidi zaman aşımı!"
MSG_ERR_ALREADY_RUNNING="Başka bir güncelleme işlemi zaten çalışıyor."
MSG_ERR_NO_INTERNET="İnternet bağlantısı kurulamadı."
MSG_ERR_GPG_FAIL="GPG imza doğrulaması başarısız! Güncelleme iptal edildi."

# ============================================
# HINTS - Çözüm Önerileri
# ============================================
MSG_HINT_INSTALL_CURL="apt install curl veya dnf install curl ile kurabilirsiniz."
MSG_HINT_NO_SUDO="sudo kurulu değilse: su -c 'dnf install sudo' veya root olarak çalıştırın."
MSG_HINT_SHA256_FAIL="Dosya bozulmuş olabilir. Daha sonra tekrar deneyin veya manuel kurulum yapın."
MSG_HINT_COPY_FAIL="Disk dolu olabilir veya yazma izni yok. 'df -h' ve 'ls -la /usr/local/bin/' ile kontrol edin."
MSG_HINT_APT_LOCK="Başka bir güncelleme çalışıyor olabilir. 'sudo lsof /var/lib/dpkg/lock-frontend' ile kontrol edin."
MSG_HINT_DNF_LOCK="'pgrep -a dnf' ile çalışan işlemi bulun veya bekleyin. GNOME Software açıksa kapatın."
MSG_HINT_ALREADY_RUNNING="'pgrep -a guncel' ile kontrol edin. Gerekirse 'sudo rm %s' ile kilidi kaldırın."
MSG_HINT_NO_INTERNET="'ping -c 1 google.com' ile bağlantıyı test edin. DNS veya ağ ayarlarını kontrol edin."
MSG_HINT_GPG_FAIL="Dosya değiştirilmiş olabilir. Manuel kurulum: curl -fsSL https://raw.githubusercontent.com/CalmKernelTR/bigfive-updater/main/install.sh | sudo bash"

# ============================================
# HELP - Yardım Metinleri
# ============================================
MSG_HELP_USAGE="Kullanım: guncel | updater | bigfive [SEÇENEK]"
MSG_HELP_OPTIONS="Seçenekler:"
MSG_HELP_OPT_AUTO="  --auto              Otomatik mod (Onay sormadan günceller)"
MSG_HELP_OPT_VERBOSE="  --verbose           Detaylı çıktı modu (Tüm komut çıktılarını gösterir)"
MSG_HELP_OPT_QUIET="  --quiet             Sessiz mod (Sadece hata ve özet gösterir)"
MSG_HELP_OPT_DRYRUN="  --dry-run           Kuru çalıştırma (Ne yapılacağını göster, yapma)"
MSG_HELP_OPT_JSON="  --json              JSON çıktı (monitoring sistemleri için)"
MSG_HELP_OPT_JSON_FULL="  --json-full         Detaylı JSON çıktı (SIEM/audit için)"
MSG_HELP_OPT_SKIP="  --skip <backend>    Belirtilen backend'leri atla (virgülle ayır)"
MSG_HELP_OPT_SKIP_VALUES="                      Değerler: snapshot, flatpak, snap, fwupd, system"
MSG_HELP_OPT_SKIP_SYSTEM="                      (system = apt, dnf, pacman, zypper, apk)"
MSG_HELP_OPT_ONLY="  --only <backend>    Sadece belirtilen backend'leri çalıştır (virgülle ayır)"
MSG_HELP_OPT_ONLY_VALUES="                      Değerler: system, flatpak, snap, fwupd, apt, dnf, pacman, zypper, apk"
MSG_HELP_OPT_UNINSTALL="  --uninstall         BigFive Updater kaldır"
MSG_HELP_OPT_PURGE="  --uninstall --purge Config ve logları da sil"
MSG_HELP_OPT_LANG="  --lang <code>       Dil seçimi (tr, en)"
MSG_HELP_OPT_HELP="  --help              Bu yardım mesajını gösterir"
MSG_HELP_EXAMPLES="Örnekler:"
MSG_HELP_EX_INTERACTIVE="  guncel                        -> İnteraktif (Önerilen)"
MSG_HELP_EX_AUTO="  guncel --auto                 -> Cron / Zamanlanmış görevler"
MSG_HELP_EX_VERBOSE="  guncel --verbose              -> Detaylı çıktı ile güncelleme"
MSG_HELP_EX_QUIET="  guncel --quiet                -> Sessiz güncelleme (sadece özet)"
MSG_HELP_EX_DRYRUN="  guncel --dry-run              -> Güncellemeleri listele (uygulamadan)"
MSG_HELP_EX_JSON="  guncel --json                 -> Monitoring için JSON çıktı (Zabbix/Nagios)"
MSG_HELP_EX_JSON_FULL="  guncel --json-full            -> SIEM için detaylı JSON (Wazuh/Splunk)"
MSG_HELP_EX_SKIP="  guncel --skip flatpak,snap    -> Flatpak ve Snap atla"
MSG_HELP_EX_ONLY_SYSTEM="  guncel --only system          -> Sadece sistem paketleri (APT/DNF/Pacman/Zypper/APK)"
MSG_HELP_EX_ONLY_FLATPAK="  guncel --only flatpak,fwupd   -> Sadece Flatpak ve Firmware"
MSG_HELP_EX_ONLY_PACMAN="  guncel --only pacman          -> Sadece Pacman (Arch Linux)"
MSG_HELP_EX_ONLY_APK="  guncel --only apk             -> Sadece APK (Alpine Linux)"
MSG_HELP_EX_UNINSTALL="  guncel --uninstall            -> Aracı kaldır (config/log korunur)"
MSG_HELP_EX_PURGE="  guncel --uninstall --purge    -> Aracı tamamen kaldır"
MSG_HELP_CONFIG="Config Dosyası: %s"
MSG_HELP_CONFIG_DESC="  Varsayılan ayarları config dosyasında tanımlayabilirsiniz."
MSG_HELP_CONFIG_EXAMPLE="  Örnek: /etc/bigfive-updater.conf.example"

# ============================================
# SUMMARY - Özet Mesajları
# ============================================
MSG_SUMMARY_PRE="PRE-UPDATE SYSTEM INFO"
MSG_SUMMARY_POST="POST-UPDATE SUMMARY"
MSG_SUMMARY_REBOOT_YES="Reboot: [!] Gerekli"
MSG_SUMMARY_REBOOT_NO="Reboot: Gerekli değil"
MSG_SUMMARY_REBOOT_REQUIRED="Gerekli"
MSG_SUMMARY_REBOOT_NOT_REQUIRED="Gerekli değil"

# ============================================
# MISC - Diğer
# ============================================
MSG_CONFIRM_CONTINUE="Devam etmek istiyor musunuz? [E/h]"
MSG_RESTORE_ATTEMPT="Yedekten geri yükleme deneniyor..."
MSG_DNF_LOCK_FAILED="DNF kilidi alınamadı, DNF güncellemesi atlanıyor."

# ============================================
# v6.1.0 - DOCTOR Mesajları
# ============================================
MSG_DOCTOR_TITLE="BigFive Doctor - Sistem Sağlık Kontrolü"
MSG_DOCTOR_CHECK_CONFIG="Config dosyası..."
MSG_DOCTOR_CHECK_REQUIRED="Gerekli komutlar..."
MSG_DOCTOR_CHECK_OPTIONAL="Opsiyonel komutlar..."
MSG_DOCTOR_CHECK_DISK="Disk alanı..."
MSG_DOCTOR_CHECK_INTERNET="İnternet bağlantısı..."
MSG_DOCTOR_CHECK_LANG="Dil dosyaları..."
MSG_DOCTOR_CONFIG_OK="%s"
MSG_DOCTOR_CONFIG_SYNTAX_ERR="Syntax hatası: %s"
MSG_DOCTOR_CONFIG_NONE="Yok (varsayılan ayarlar kullanılacak)"
MSG_DOCTOR_CMDS_OK="Tümü mevcut"
MSG_DOCTOR_CMDS_MISSING="Eksik: %s"
MSG_DOCTOR_DISK_OK="%sMB mevcut (min: 500MB)"
MSG_DOCTOR_DISK_LOW="%sMB mevcut (min: 500MB gerekli)"
MSG_DOCTOR_DISK_UNKNOWN="Kontrol edilemedi"
MSG_DOCTOR_NET_OK="GitHub erişilebilir"
MSG_DOCTOR_NET_FAIL="GitHub erişilemiyor"
MSG_DOCTOR_LANG_OK="%d dil dosyası mevcut"
MSG_DOCTOR_LANG_PARTIAL="%d mevcut, %d eksik"
MSG_DOCTOR_SUMMARY_OK="Sistem sağlıklı - BigFive kullanıma hazır"
MSG_DOCTOR_SUMMARY_WARN="%d uyarı - BigFive çalışabilir"
MSG_DOCTOR_SUMMARY_ERR="%d hata, %d uyarı - Sorunları düzeltin"
# v6.5.0 - Yeni Doctor kontrolleri
MSG_DOCTOR_CHECK_PERMS="Dosya izinleri..."
MSG_DOCTOR_PERMS_OK="Tüm izinler doğru"
MSG_DOCTOR_PERMS_WARN="Kontrol: %s"
MSG_DOCTOR_CHECK_GPG="GPG keyring..."
MSG_DOCTOR_GPG_OK="GPG mevcut, %d anahtar"
MSG_DOCTOR_GPG_NOKEYS="GPG mevcut, anahtar yok"
MSG_DOCTOR_GPG_NOTFOUND="GPG kurulu değil (opsiyonel)"
MSG_DOCTOR_CHECK_LOCK="Kilit dosyası..."
MSG_DOCTOR_LOCK_OK="Kilit dosyası yok (çalışmaya hazır)"
MSG_DOCTOR_LOCK_ACTIVE="Başka bir örnek çalışıyor (PID: %s)"
MSG_DOCTOR_LOCK_STALE="Eski kilit dosyası (silinebilir)"

# ============================================
# v6.1.0 - HISTORY Mesajları
# ============================================
MSG_HISTORY_TITLE="BigFive Update History - Son %d Gün"
MSG_HISTORY_COL_DATE="Tarih"
MSG_HISTORY_COL_TIME="Saat"
MSG_HISTORY_COL_STATUS="Durum"
MSG_HISTORY_COL_DETAIL="Detay"
MSG_HISTORY_NO_DIR="Log dizini bulunamadı: %s"
MSG_HISTORY_NO_DIR_HINT="Henüz güncelleme yapılmamış olabilir."
MSG_HISTORY_NO_LOGS="Son %d günde güncelleme kaydı bulunamadı."
MSG_HISTORY_TOTAL="Toplam: %d kayıt"
MSG_HISTORY_STATUS_OK="OK"
MSG_HISTORY_STATUS_ERROR="HATA"
MSG_HISTORY_STATUS_DRY="DRY"
MSG_HISTORY_STATUS_UNKNOWN="?"
MSG_HISTORY_DETAIL_SUCCESS="Başarılı"
MSG_HISTORY_DETAIL_ERRORS="%d hata"
MSG_HISTORY_DETAIL_SIMULATION="Simülasyon"
MSG_HISTORY_DETAIL_UNKNOWN="Belirsiz"

# ============================================
# v6.1.0 - HELP Mesajları (Ek)
# ============================================
MSG_HELP_OPT_DOCTOR="  --doctor            Sistem sağlık kontrolü (config, bağımlılıklar, disk, ağ)"
MSG_HELP_OPT_HISTORY="  --history [N]       Son N günün güncelleme geçmişi (varsayılan: 7)"

# ============================================
# v6.3.0+ - Güvenlik, Hook, Container, Jitter
# ============================================
MSG_HELP_OPT_JITTER="  --jitter <sn>       Cron jitter (0-N saniye arası rastgele bekleme)"
MSG_HELP_OPT_SECURITY="  --security-only     Sadece güvenlik güncellemeleri (DNF/Zypper)"
MSG_HELP_EX_SECURITY="  guncel --security-only        -> Sadece güvenlik güncellemeleri (DNF/Zypper)"

# Disk kontrolü
MSG_ERR_LOW_DISK="Yetersiz disk alanı: %sMB mevcut, %sMB gerekli."
MSG_HINT_LOW_DISK="Disk alanı açın: sudo apt clean / sudo dnf clean all / sudo pacman -Sc"
MSG_INFO_DISK_OK="Disk alanı yeterli: %sMB mevcut."
MSG_WARN_DISK_CHECK_FAIL="Disk alanı kontrol edilemedi."

# Container
MSG_WARN_CONTAINER="Container ortamı tespit edildi: %s"
MSG_HINT_CONTAINER="Container güncellemeleri kalıcı değildir. Host sistemini güncellemek için container dışında çalıştırın."

# Jitter
MSG_INFO_JITTER="Cron jitter: %d saniye bekleniyor (max: %d)..."

# Sudo
MSG_ERR_SUDO_NOPASSWD="Auto mode için sudo NOPASSWD gerekli."
MSG_HINT_SUDO_NOPASSWD="/etc/sudoers dosyasına NOPASSWD ekleyin veya root olarak çalıştırın."

# Hook
MSG_HOOK_RUNNING="Hook çalıştırılıyor: %s"
MSG_HOOK_FAILED="Hook başarısız: %s"
MSG_HOOK_COMPLETE="%d hook çalıştırıldı (%d başarısız)"

# Security-only
MSG_INFO_SECURITY_ONLY="Sadece güvenlik güncellemeleri uygulanıyor..."
MSG_WARN_SECURITY_APT="APT için --security-only desteklenmiyor. Tüm güncellemeler uygulanacak."
MSG_WARN_SECURITY_PACMAN="Pacman için --security-only desteklenmiyor. Tüm güncellemeler uygulanacak."
MSG_WARN_SECURITY_APK="APK için --security-only desteklenmiyor. Tüm güncellemeler uygulanacak."
MSG_HINT_SECURITY_APT="Öneri: unattended-upgrades paketi ile otomatik güvenlik güncellemeleri yapılandırın."
MSG_HINT_SECURITY_PACMAN="Öneri: arch-audit paketi ile güvenlik açıklarını kontrol edebilirsiniz."
