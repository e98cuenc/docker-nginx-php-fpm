#!/bin/sh
docker run -d -p 80:80 -p 3306:3306 --name tutpad --cap-add=SYS_PTRACE --security-opt=apparmor:unconfined -v ${1:-/Users/cuenca/projects/core_v2}:/var/www e98cuenc/nginx-php-fpm && \
echo "Attach with: docker exec -ti tutpad /bin/sh" && \
echo "Follow logs: docker logs --follow tutpad"
