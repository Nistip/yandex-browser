FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    DISPLAY=:1 \
    VNC_SCREEN_SIZE=1366x768 \
    LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN groupadd -r app && useradd -r -g app -m -d /home/app -s /bin/bash app

COPY apt-packages.txt /tmp/apt-packages.txt

RUN apt-get update && \
    xargs -a /tmp/apt-packages.txt apt-get install -y --no-install-recommends && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

RUN curl -fsSL https://repo.yandex.ru/yandex-browser/YANDEX-BROWSER-KEY.GPG | \
        gpg --dearmor -o /etc/apt/trusted.gpg.d/yandex-browser.gpg && \
    echo "deb https://repo.yandex.ru/yandex-browser/deb stable main" \
        > /etc/apt/sources.list.d/yandex-browser.list

RUN apt-get update && \
    apt-get install -y --no-install-recommends yandex-browser-stable && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY --chown=app:app --chmod=755 entrypoint.sh /usr/local/bin/entrypoint.sh
COPY --chown=app:app --chmod=755 healthcheck.sh /usr/local/bin/healthcheck.sh

EXPOSE 6080

USER app
WORKDIR /home/app

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/usr/bin/supervisord"]

HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
  CMD ["/usr/local/bin/healthcheck.sh"]