FROM mysql:5.7 as builder

RUN apt-get update && apt-get install -y wget lsb-release
RUN lsb_release -sc > /lsb_release
RUN wget https://repo.percona.com/apt/percona-release_0.1-4.$(cat /lsb_release)_all.deb

FROM mysql:5.7
ARG PACKAGE=percona-xtrabackup-24
COPY --from=builder /lsb_release /lsb_release
COPY --from=builder /*.deb /
RUN dpkg -i /percona-release_0.1-4.$(cat /lsb_release)_all.deb && \
    apt-get update && \
    apt-get install -y $PACKAGE cron && \
    apt-get clean && \
    rm -f /percona-release_0.1-4.$(cat /lsb_release)_all.deb /lsb_release && \
    touch /var/log/cron.log && \
    mkdir -p /backup/backups && \
    (crontab -l ; echo "0 0 */3 * * sh -c 'exec innobackupex --host="localhost" --port="3306" --user=root --password="wordpress" /backup/backups' >> /var/log/cron.log") | crontab && \
    (crontab -l ; echo "0 1 */3 * * sh -c 'find /backup/backups -mtime +14 -exec rm {}\;' >> /var/log/cron.log") | crontab

 VOLUME ["/backup/xtrabackup"]
