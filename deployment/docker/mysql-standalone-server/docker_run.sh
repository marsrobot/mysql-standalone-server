#!/bin/bash

. ./project.sh

export PASSWORD="password"

sudo docker stop $CONTAINER_NAME
sudo docker rm -f $CONTAINER_NAME

sudo iptables -I INPUT -p tcp --dport 3306 -j ACCEPT
sudo iptables -I INPUT -p udp --dport 3306 -j ACCEPT

export MY_HOST_NAME=`hostname`

echo "Hostname: " "${MY_HOST_NAME}"
export DATA_DIR="/local"

echo "Data directory: " ${DATA_DIR}/var/lib/mysql

sudo mkdir -p ${DATA_DIR}/var/lib/mysql

sudo systemctl stop mysqld
sudo systemctl disable mysqld

sudo docker run -it -d \
    --restart unless-stopped \
    --privileged \
    --name $CONTAINER_NAME \
    --env MYSQL_PASSWORD=${PASSWORD} \
    --env MYSQL_ROOT_PASSWORD=${PASSWORD} \
    --env MYSQL_USER=mysql_user \
    -v ${DATA_DIR}/var/lib/mysql:/var/lib/mysql:rw \
    -p 3306:3306 \
    --entrypoint sh \
    mysql:8.0.27 \
    -c "exec docker-entrypoint.sh mysqld --default-authentication-plugin=mysql_native_password" \
    --binlog_expire_logs_seconds=3600 \
    --innodb_buffer_pool_instances=1 \
    --innodb_buffer_pool_size=4096M \
    --innodb_file_per_table=ON \
    --innodb_flush_log_at_trx_commit=2 \
    --innodb_flush_method=O_DIRECT \
    --innodb_log_file_size=512MB \
    --innodb_read_io_threads=8 \
    --innodb_write_io_threads=4