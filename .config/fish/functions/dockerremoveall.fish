function dockerremoveall
  docker rm $(docker ps -a -q)
end
