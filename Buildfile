echo stoping services
docker stop restheart
docker stop mongodb
docker rm restheart
docker rm mongodb
docker rmi softinstigate/restheart
docker rmi mongo:3.6
docker stop tomcat-server
docker rm tomcat-server
docker rmi tomcat-server
docker rmi tomcat

mkdir data
docker run -d -e MONGO_INITDB_ROOT_USERNAME='restheart' -e MONGO_INITDB_ROOT_PASSWORD='R3ste4rt!'  --name mongodb -v "$PWD/data:/data/db" -v "$PWD/import:/home" mongo:3.6 --bind_ip_all --auth
sleep 20
docker  exec  mongodb mongoimport  -u restheart -p R3ste4rt! --authenticationDatabase admin --db myflix --collection videos --drop --file /home/videos.json
docker  exec  mongodb mongoimport  -u restheart -p R3ste4rt! --authenticationDatabase admin --db myflix --collection categories --drop --file /home/categories.json
docker run -d -p 81:80 --name restheart --link mongodb:mongodb softinstigate/restheart
docker build -t tomcat-server ../TomcatServer
docker run -d -p 80:8080 --name tomcat-server --link mongodb:mongodb tomcat-server
