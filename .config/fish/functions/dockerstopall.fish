function dockerstopall
  docker stop $(docker ps -a -q)
end
