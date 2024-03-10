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

WORKDIR /sync/
CMD ["bash"]
