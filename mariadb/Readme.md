# Docker Alpine - MariaDB 10.2.14

Build: ```docker build -t mariadb . ```
Run example: ```docker run -ti -p 3306:3306 -v ${PWD}/data:/var/lib/mysql -e MYSQL_DATABASE=db -e MYSQL_USER=user -e MYSQL_PASSWORD=blah -e MYSQL_ROOT_PASSWORD=pepe mariadb```
