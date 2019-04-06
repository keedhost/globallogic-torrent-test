#     docker build --tag=globallogic-torrent-test .



FROM debian:latest
MAINTAINER Andrii Kondratiev <andrii.kondratiev@globallogic.com>
ENV DEBIAN_FRONTEND noninteractive
ENV GIT_BRANCH master

ADD ./torrents /torrents
ADD ./download /download
ADD ./log /log

# Update packages in base image, avoid caching issues by combining statements, install build software and deps
RUN	apt-get update && apt-get install -y aria2 cron && \
	apt-get autoremove --purge -y && apt-get clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
	service cron start && \
	chmod 777 /download && chmod 777 /log && \
	(crontab -l ; echo "*/30 * * * * rm -Rf /download/\* >/dev/null 2>&1") | crontab && \
	ls -la /download /log

EXPOSE 6800

CMD ["/usr/bin/aria2c", "--max-concurrent-downloads=50", \
						"--max-upload-limit=1M", \
						"--log=/log/1.log", \
						"--dir=/download", \
						"-T /torrents/debian-9.8.0-source-DVD-1.iso.torrent", \
						"-T /torrents/debian-9.8.0-source-DVD-2.iso.torrent", \
						"-T /torrents/debian-9.8.0-source-DVD-3.iso.torrent", \
						"-T /torrents/debian-9.8.0-source-DVD-4.iso.torrent", \
						"-T /torrents/debian-9.8.0-source-DVD-5.iso.torrent", \
						"-T /torrents/debian-9.8.0-source-DVD-6.iso.torrent", \
						"-T /torrents/debian-9.8.0-source-DVD-7.iso.torrent", \
						"-T /torrents/debian-9.8.0-source-DVD-8.iso.torrent", \
						"-T /torrents/debian-9.8.0-source-DVD-9.iso.torrent", \
						"-T /torrents/debian-9.8.0-source-DVD-10.iso.torrent",\
						"-T /torrents/debian-9.8.0-source-DVD-11.iso.torrent",\
						"-T /torrents/debian-9.8.0-source-DVD-12.iso.torrent"]

