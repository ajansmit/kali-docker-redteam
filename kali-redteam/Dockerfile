FROM kalilinux/kali-rolling

LABEL maintainer="smitoff@smitoff.com.br"
LABEL description="Kali Red Team - Docker CLI"

ENV DEBIAN_FRONTEND=noninteractive

# 1. Instalação de Pacotes
RUN apt-get update && apt-get -y upgrade && \
    apt-get -y install \
    kali-linux-headless \
    net-tools iputils-ping iproute2 \
    curl wget nano vim git man-db \
    tmux feroxbuster bash-completion \
    python3-pip seclists wordlists && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 2. Descompacta a rockyou
RUN if [ -f /usr/share/wordlists/rockyou.txt.gz ]; then \
    gzip -d /usr/share/wordlists/rockyou.txt.gz; \
    fi

# 3. Cria Usuário Kali
ARG USER_ID=1000
ARG GROUP_ID=1000
RUN groupadd -g ${GROUP_ID} kali && \
    useradd -l -u ${USER_ID} -g kali -m kali && \
    usermod -aG sudo kali && \
    echo "kali ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER kali
WORKDIR /home/kali

# 4. Injeta a função 'settarget' no .bashrc
# Isso cria o comando mágico que salva o IP no arquivo .target
RUN echo 'function settarget() {' >> ~/.bashrc && \
    echo '  if [ -z "$1" ]; then echo "Uso: settarget <IP>"; return; fi' >> ~/.bashrc && \
    echo '  echo "$1" > ~/.target' >> ~/.bashrc && \
    echo '  echo "🎯 Alvo definido para: $1"' >> ~/.bashrc && \
    echo '}' >> ~/.bashrc

# 5. Copia os arquivos de configuração
COPY --chown=kali:kali meu-tmux.conf /home/kali/.tmux.conf
COPY --chown=kali:kali thm_ip.sh /home/kali/thm_ip.sh

# 6. Torna o script executável
RUN chmod +x /home/kali/thm_ip.sh

CMD ["/bin/bash"]
