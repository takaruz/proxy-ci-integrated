#!/bin/bash

docker exec -it $1 sh -c "echo \"machine bitbucket.org login $2 password $3\" \
 >> /root/.netrc"

