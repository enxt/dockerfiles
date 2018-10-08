#!/bin/sh


if [ ! -d "/run/mysqld" ]; then
	mkdir -p /run/mysqld
fi

chown -R mysql:mysql /var/lib/mysql /run/mysqld

if [ -d /var/lib/mysql/mysql ]; then
	echo "[i] MySQL directory already present, skipping creation"
else
	echo "[i] MySQL data directory not found, creating initial DBs"

	mysql_install_db --user=mysql > /dev/null

	if [ "$MYSQL_ROOT_PASSWORD" = "" ]; then
		MYSQL_ROOT_PASSWORD=`pwgen 16 1`
		echo "[i] MySQL root Password: $MYSQL_ROOT_PASSWORD"
	fi

	
	REMOTE_USER=${REMOTE_USER:-""}
	REMOTE_PASS=${REMOTE_PASS:-""}
	REMOTE_HOST=${REMOTE_HOST:-""}
	REMOTE_DBS=${REMOTE_DBS:-""}
	
	MYSQL_DATABASE=${MYSQL_DATABASE:-""}
	MYSQL_USER=${REMOTE_USER:-${MYSQL_USER:-""}}
	MYSQL_PASSWORD=${REMOTE_PASS:-${MYSQL_PASSWORD:-""}}
	
	tfile=`mktemp`
	if [ ! -f "$tfile" ]; then
	    return 1
	fi

	cat << EOF > $tfile
USE mysql;
FLUSH PRIVILEGES;
DELETE FROM mysql.user ;
DROP USER IF EXISTS 'root'@'%','root'@'localhost','${MYSQL_USER}'@'localhost','${MYSQL_USER}'@'%';
CREATE USER 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' ;
CREATE USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' ;
CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}' ;
CREATE USER '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}' ;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION ;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION ;
GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_USER}'@'%' WITH GRANT OPTION ;
GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_USER}'@'localhost' WITH GRANT OPTION ;
DROP DATABASE IF EXISTS test ;
FLUSH PRIVILEGES ;
EOF

	if [ "$MYSQL_DATABASE" != "" ]; then
	    echo "[i] Creating database: $MYSQL_DATABASE"
	    echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` CHARACTER SET utf8 COLLATE utf8_general_ci;" >> $tfile

	    if [ "$MYSQL_USER" != "" ]; then
		echo "[i] Creating user: $MYSQL_USER with password $MYSQL_PASSWORD"
		echo "GRANT ALL ON \`$MYSQL_DATABASE\`.* to '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';" >> $tfile
	    fi
	fi
	
	if [ "$REMOTE_HOST" != "" ] && [ "$REMOTE_DBS" != "" ]; then
		echo "[i] Importing databases from $REMOTE_HOST"
		if [ "$REMOTE_DBS" != "" ]; then
			for db in $REMOTE_DBS
			do
				echo "[i] Transfering $db database..."
				mysqldump -h$REMOTE_HOST -u$REMOTE_USER -p$REMOTE_PASS --databases $db | sed -e s/TokuDB/InnoDB/g >> $tfile #| mysql -u$MYSQL_USER -p$MYSQL_PASSWORD
				echo "GRANT ALL ON \`$db\`.* to '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';" >> $tfile
			done
		else
			echo "[i] Only databases in REMOTE_DBS variable will been imported"
		fi
	fi

	/usr/bin/mysqld --user=mysql --bootstrap --verbose=0 < $tfile
	rm -f $tfile
fi

if [ -d /var/lib/mysql/toimport ]; then
	echo "[i] Folder toimport found"
	/usr/bin/mysqld --user=mysql --console &
	sleep 10
	ls /var/lib/mysql/toimport/*sql | while read FILE; do
		db=`basename $FILE | sed "s/\.sql$//g"`
		if [ ! -d "/var/lib/mysql/$db" ]; then
			echo "[i] Creating $db database"
			mysql -u$MYSQL_USER -p$MYSQL_PASSWORD --execute="CREATE DATABASE IF NOT EXISTS \`$db\` CHARACTER SET utf8 COLLATE utf8_general_ci;"
			echo "[i] Importing data"
			cat $FILE | sed -e s/TokuDB/InnoDB/g | mysql -u$MYSQL_USER -p$MYSQL_PASSWORD --force $db
			echo "[i] $db database will be imported"
		else
			echo "[i] Database $db exists, passing"
		fi
	done
	killall mysqld
fi


exec /usr/bin/mysqld --user=mysql --console