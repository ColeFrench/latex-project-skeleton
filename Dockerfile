FROM alpine:latest AS downloader

WORKDIR /root

# Download the latest release of tectonic
RUN archive='tectonic.tar.gz' && \
    wget -qO - 'https://api.github.com/repos/tectonic-typesetting/tectonic/releases/latest' | \
    grep 'browser_download_url.*86_64-unknown-linux-musl.tar.gz' | \
    tr -s ' ' | \
    cut -d ' ' -f 3 | \
    xargs wget -qO "$archive" && \
    tar xf "$archive" && \
    rm "$archive"

FROM alpine:latest AS runner

# Add an unprivileged user
RUN adduser --disabled-password --gecos 'Unprivileged user' user

# Copy over the standalone tectonic executable
COPY --from=downloader --chmod=0755 /root/tectonic /usr/local/bin/

# Switch to the unprivileged user
USER user
WORKDIR /home/user

ENTRYPOINT [ "tectonic" ]
