# ~/.bashrc: executed by bash(1) for non-login shells.

# Se não estiver rodando interativamente, não faz nada
case $- in
    *i*) ;;
      *) return;;
esac

# --- CONFIGURAÇÕES PADRÃO DO KALI (HISTÓRICO E CORES) ---
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000

# Checa o tamanho da janela após cada comando
shopt -s checkwinsize

# Cores para o comando ls
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Aliases comuns
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Autocomplete programável
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# --- RED TEAM CONFIGURATION (CUSTOM) ---

# 1. Correção de Teclado (ABNT2) para X11/Terminator
# O redirecionamento de erro evita mensagens chatas se rodar fora do X11
setxkbmap -layout br -model abnt2 2>/dev/null

# 2. Correção para Firefox no WSLg
export GDK_BACKEND=x11

# 3. Funções de Gerenciamento de Alvo
function settarget() {
    if [ -z "$1" ]; then
        echo "Uso: settarget <IP>"
        return
    fi
    echo "$1" > /tmp/target_ip
    echo -e "\n[+] Alvo definido para: $1"
}

function cleartarget() {
    rm -f /tmp/target_ip
    echo -e "\n[-] Alvo removido"
}

# 4. Funções Auxiliares para o Prompt
function get_target() {
    if [ -f /tmp/target_ip ]; then
        echo " 🎯 $(cat /tmp/target_ip)"
    else
        echo ""
    fi
}

function get_vpn() {
    # Tenta pegar o IP da interface tun0
    ip_tun=$(ip addr show tun0 2>/dev/null | grep "inet " | awk '{print $2}' | cut -d/ -f1)
    if [ -n "$ip_tun" ]; then
        echo " 🛡️ $ip_tun"
    else
        echo " ❌ No VPN"
    fi
}

# 5. O PROMPT (PS1)
# Formato: [VPN] ┌──(user@host)-[dir] [TARGET]
#          └─$
# Usamos aspas simples ' ' para garantir que as funções $(get_vpn) rodem
# a cada Enter, e não apenas na hora que o bash abre.
export PS1='\[\033[01;32m\]$(get_vpn)\[\033[00m\] \[\033[01;34m\]┌──(\[\033[01;31m\]\u@\h\[\033[01;34m\])-[\[\033[00m\]\w\[\033[01;34m\]]\[\033[01;33m\]$(get_target)\[\033[00m\]\n\[\033[01;34m\]└─\$\[\033[00m\] '
