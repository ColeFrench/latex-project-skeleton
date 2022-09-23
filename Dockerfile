FROM alpine:latest AS downloader

WORKDIR /root

# Set the timezone
RUN apk --no-cache add tzdata && \
    cp /usr/share/zoneinfo/America/New_York /etc/localtime && \
    apk del tzdata

# Download the latest release of tectonic
RUN archive='tectonic.tar.gz' && \
    wget -qO - 'https://api.github.com/repos/tectonic-typesetting/tectonic/releases/latest' | \
    grep 'browser_download_url.*86_64-unknown-linux-musl.tar.gz' | \
    tr -s ' ' | \
    cut -d ' ' -f 3 | \
    xargs wget -qO "$archive" && \
    tar xf "$archive" && \
    rm "$archive"

# Download the latest release of biber
RUN archive='biber.tar.gz' && \
    wget -qO "$archive" 'https://sourceforge.net/projects/biblatex-biber/files/biblatex-biber/current/binaries/Linux-musl/biber-linux_x86_64-musl.tar.gz/download' && \
    tar xf "$archive" && \
    rm "$archive"

FROM alpine:latest AS runner

# Add an unprivileged user
RUN adduser --disabled-password --gecos 'Unprivileged user' user

# Copy over the timezone data
COPY --from=downloader /etc/localtime /etc/localtime

# Copy over the standalone tectonic executable
COPY --from=downloader --chmod=0755 /root/tectonic /usr/local/bin/

# Copy over the standalone biber executable
COPY --from=downloader --chmod=0755 /root/biber /usr/local/bin/

# Install extra packages
RUN echo '@testing https://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories
RUN apk --no-cache add \
    font-merriweather@testing \
    ttf-opensans \
    font-fira-code@testing

# Switch to the unprivileged user
USER user
WORKDIR /home/user

ENTRYPOINT [ "tectonic" ]
