/bin/sh
service docker start
docker build -t nginx-lua:v1 .
docker run -d nginx-lua:v1
