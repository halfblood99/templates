# Аргументы для Compose, определяемые по умолчанию
COMPOSE_ARGS=" -f jenkins.yml -p jenkins "
# Необходимо остановить и удалить все старые контейнеры
docker compose $COMPOSE_ARGS stop 
docker compose $COMPOSE_ARGS rm --force -v
# Создание (сборка) системы
docker compose $COMPOSE_ARGS build --no-cache
docker compose $COMPOSE_ARGS up -d
# Выполнение модульного тестирования
docker compose $COMPOSE_ARGS run --no-deps --rm -e ENV=UNIT identidock ERR=$?
# Выполнение тестирования системы в целом, если модульное тестирование завершилось
успешно
if [ $ERR -eq 0 ]; then
IP=$(docker inspect -f {{.NetworkSettings.IPAddress}}
jenkins_identidock_1) 
CODE=$(curl -sL -w "%{http_code}" $IP:9090/monster/bla -o /dev/null) || true 
if [ $CODE -ne 200 ]; then
echo "Site returned " $CODE
ERR=1
fi
fi
# Останов и удаление системы
docker compose $COMPOSE_ARGS stop
docker compose $COMPOSE_ARGS rm --force -v
return $ERR