# Base Image
FROM kalilinux/kali-rolling

LABEL maintainer="RedTeam User"
ENV DEBIAN_FRONTEND=noninteractive

# 1. Instalação de Pacotes
RUN apt-get update && apt-get -y upgrade && \
    apt-get -y install \
    kali-linux-headless \
    net-tools iputils-ping iproute2 \
    curl wget nano vim git man-db \
    bash-completion python3-pip \
    seclists wordlists \
    nmap hydra wpscan smbmap smbclient \
    metasploit-framework \
    terminator \
    x11-xkb-utils xkb-data dbus-x11 \
    bloodhound-ce-python \
    libgtk-3-0 libcanberra-gtk3-module && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# 2. Descompacta a rockyou
RUN if [ -f /usr/share/wordlists/rockyou.txt.gz ]; then \
    gzip -d /usr/share/wordlists/rockyou.txt.gz; \
    fi

# 3. Configuração do Usuário Kali
RUN useradd -m -s /bin/bash -u 1000 kali && \
    echo "kali:kali" | chpasswd && \
    usermod -aG sudo kali && \
    echo "kali ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/kali


# 4. Variáveis Globais
ENV DISPLAY=:0
ENV XKB_DEFAULT_LAYOUT=br
ENV XKB_DEFAULT_MODEL=abnt2
ENV GDK_BACKEND=x11
ENV SHELL=/bin/bash
ENV NO_AT_BRIDGE=1

# --- CORREÇÃO DO ERRO (NOVO) ---
# Prepara diretórios de sistema que o Terminator/GTK exigem
RUN mkdir -p /run/user/1000 && \
    chown -R kali:kali /run/user/1000 && \
    chmod 700 /run/user/1000 && \
    dbus-uuidgen > /var/lib/dbus/machine-id && \
    mkdir -p /etc/xdg/terminator && \
    touch /etc/xdg/terminator/config && \
    # Fix DCONF
    mkdir -p /etc/dconf/profile && \
    echo "user-db:user" > /etc/dconf/profile/user && \
    mkdir -p /etc/dconf/db/local.d && \
    touch /etc/dconf/db/local  

# 5. Configuração de Arquivos
RUN mkdir -p /home/kali/.config/terminator

# Copia os arquivos locais
COPY --chown=kali:kali .bashrc /home/kali/.bashrc
COPY --chown=kali:kali terminator_config /home/kali/.config/terminator/config

# 6. Define diretório e usuário final
USER kali
WORKDIR /home/kali/trabalho

CMD ["terminator"]
