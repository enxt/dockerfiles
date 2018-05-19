FROM gliderlabs/alpine

COPY scripts/run.sh /scripts/run.sh
COPY scripts/my.cnf /etc/mysql/my.cnf

RUN apk --update add mariadb mariadb-client pwgen && rm -f /var/cache/apk/* && \
	chmod -R 755 /scripts

EXPOSE 3306

VOLUME ["/var/lib/mysql"]

ENTRYPOINT ["/scripts/run.sh"]

