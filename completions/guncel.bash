# Bash completion for guncel/updater/bigfive
# BigFive Updater v6.5.0+
# Install: sudo cp guncel.bash /usr/share/bash-completion/completions/guncel

_guncel_completions() {
    local cur prev opts skip_only_opts lang_opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    # Ana seçenekler
    opts="--help --auto --verbose --quiet --dry-run --json --json-full --skip --only --uninstall --doctor --history --lang --security-only --jitter"

    # --skip ve --only için değerler
    skip_only_opts="snapshot flatpak snap fwupd system apt dnf pacman zypper apk"

    # --lang için değerler
    lang_opts="tr en"

    # --uninstall sonrası --purge
    if [[ "${COMP_WORDS[*]}" == *"--uninstall"* ]]; then
        COMPREPLY=( $(compgen -W "--purge" -- "${cur}") )
        return 0
    fi

    # --skip veya --only sonrası backend seçenekleri
    case "${prev}" in
        --skip|--only)
            COMPREPLY=( $(compgen -W "${skip_only_opts}" -- "${cur}") )
            return 0
            ;;
        --lang)
            COMPREPLY=( $(compgen -W "${lang_opts}" -- "${cur}") )
            return 0
            ;;
        --history|--jitter)
            # Sayısal değer için tamamlama yok, kullanıcı sayı yazabilir
            return 0
            ;;
    esac

    # Virgülle ayrılmış değerler için (örn: --skip flatpak,snap)
    if [[ "${cur}" == *,* ]]; then
        local prefix="${cur%,*},"
        local last="${cur##*,}"
        COMPREPLY=( $(compgen -W "${skip_only_opts}" -- "${last}") )
        COMPREPLY=( "${COMPREPLY[@]/#/${prefix}}" )
        return 0
    fi

    # Varsayılan: ana seçenekleri göster
    COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
}

# guncel, updater ve bigfive için completion kaydet
complete -F _guncel_completions guncel
complete -F _guncel_completions updater
complete -F _guncel_completions bigfive
