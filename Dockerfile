# Use ubuntu 20.04
FROM maxkratz/texlive:base
LABEL maintainer="Max Kratz <account@maxkratz.com>"

# Install texlive
COPY texlive.profile .
RUN wget http://ftp.math.utah.edu/pub/tex/historic/systems/texlive/2020/install-tl-unx.tar.gz \
  && tar xvzf install-tl-unx.tar.gz \
  && ./install-tl-*/install-tl -profile texlive.profile -repository http://ftp.math.utah.edu/pub/tex/historic/systems/texlive/2020/tlnet-final/ --no-verify-downloads \
  && echo "echo \"texbuilder\"" >/bin/whodis && chmod 777 /bin/whodis

# Add texlive to path
ENV PATH="/usr/local/texlive/2020/bin/x86_64-linux:$PATH"
ENV PATH="/usr/local/texlive/2020/bin/aarch64-linux:$PATH"
ENV PATH="/usr/local/texlive/2020/bin/armhf-linux:$PATH"

# Update tlmgr + tex-packages
RUN tlmgr update --self --all --reinstall-forcibly-removed \
  && luaotfload-tool -v -vvv -u

#Extra Stuffs
RUN apt-get update \ 
  && apt-get install -y neovim tmux curl wget \
  && curl -fsSL https://code-server.dev/install.sh | bash \
  && echo "alias attach='tmux a -t'" >> /root/.bashrc \
  && echo "alias list='tmux list-sessions'" >> /root/.bashrc \
  && echo "alias new='tmux new -s'" >> /root/.bashrc \
  && echo "code-server --auth none --disable-telemetry --disable-update-check --bind-addr 0.0.0.0:8912 --user-data-dir `pwd`" >> /bin/vs

WORKDIR /sync/
CMD ["bash"]
