docker-compose run web rake db:create &&
docker-compose run web rake db:migrate &&
docker-compose run web rake db:seed &&
docker-compose up