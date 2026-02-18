# Builder stage
FROM registry.access.redhat.com/ubi9/ubi-minimal as builder
LABEL maintainer="Tao Hansen <59834693+worldofgeese@users.noreply.github.com>"

# Update and install dependencies
RUN rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm && \
    microdnf install -y \
    tar \
    make \
    tidy \
    gzip \
    perl \
    python3 \
    wget \
    bash \
    fontconfig \
    which \
    fontawesome-fonts \
    adobe-source-sans-pro-fonts && \
    microdnf clean all

ARG RACKET_VERSION=8.15
ARG RACKET_INSTALLER_URL=https://mirror.racket-lang.org/installers/$RACKET_VERSION/racket-minimal-$RACKET_VERSION-x86_64-linux-natipkg-cs.sh

RUN --mount=type=cache,target=/root/.local/share/racket/$RACKET_VERSION/pkgs \
    curl --retry 5 -Ls "${RACKET_INSTALLER_URL}" > racket-install.sh && \
    echo "yes\n1\n" | sh racket-install.sh --create-dir --unix-style --dest /usr/ && \
    rm racket-install.sh

# Install TinyTeX for XeLateX and dependencies
ENV PATH="${PATH}:/root/bin"

# Install TinyTeX for XeLateX and dependencies with cache mount
RUN --mount=type=cache,target=/root/bin \
    wget -qO- "https://yihui.org/tinytex/install-bin-unix.sh" | sh && \
    tlmgr install ragged2e eurosym frankenstein mathspec xltxtra realscripts fontawesome microtype mdframed zref needspace pst-node pstricks pgf upquote listingsutf8 listings caption greek-fontenc titling titlesec footmisc soul

# Install Fira Code
RUN wget -qO- "https://gist.githubusercontent.com/worldofgeese/af966eb29b147c1b13c345684a2edb81/raw/6b26bd17d85e05df3e071f44fd812a42111e539a/download_and_install.sh" | sh

# Install Pollen via raco with cache mount
RUN --mount=type=cache,target=/root/.local/share/racket/$RACKET_VERSION/pkgs \
    raco pkg install --auto --skip-installed pollen

# Add application sources
ADD . /opt/app-root/src

# Build the blog
WORKDIR /opt/app-root/src
RUN --mount=type=cache,target=/root/.local/share/racket/$RACKET_VERSION/pkgs \
    --mount=type=cache,target=/root/bin \
    make all && make pdfs

# Production stage
FROM registry.access.redhat.com/ubi9/nginx-122 as production
LABEL maintainer="Tao Hansen <59834693+worldofgeese@users.noreply.github.com>"

# Copy Nginx configuration files, static HTML, and RSS feed
COPY --from=builder --chown=1001:0 --chmod=775 /opt/app-root/src/nginx.conf "${NGINX_CONF_PATH}"
COPY --from=builder --chown=1001:0 --chmod=775 /opt/app-root/src/nginx-default-cfg/*.conf "${NGINX_DEFAULT_CONF_PATH}"
COPY --from=builder --chown=1001:0 --chmod=775 /opt/app-root/src/nginx-cfg/*.conf "${NGINX_CONFIGURATION_PATH}"
COPY --from=builder --chown=1001:0 --chmod=775 /opt/app-root/src/posts/*.html posts/
COPY --from=builder --chown=1001:0 --chmod=775 /opt/app-root/src/posts/*.pdf posts/
COPY --from=builder --chown=1001:0 --chmod=775 /opt/app-root/src/feed.xml .
COPY --from=builder --chown=1001:0 --chmod=775 /opt/app-root/src/*.html .
COPY --from=builder --chown=1001:0 --chmod=775 /opt/app-root/src/styles.css .
COPY --from=builder --chown=1001:0 --chmod=775 /opt/app-root/src/img img/
COPY --from=builder --chown=1001:0 --chmod=775 /opt/app-root/src/css css/

# Set permissions and group ownership for OpenShift compatibility
USER 0
RUN chgrp -R 0 /opt/app-root/src && chmod -R g=u /opt/app-root/src
USER 1001

# Set nginx to serve the static content
CMD ["nginx", "-g", "daemon off;"]

# Expose a non-privileged port
EXPOSE 8080

