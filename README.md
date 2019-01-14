## Just with docker

1. Fire up a database:
   ```
   docker run --name bookstack_db -e MYSQL_ROOT_PASSWORD=`tr -dc A-Za-z0-9 < /dev/urandom | head -c 30 | tee /dev/stderr` mariadb
   ```
2. Create a "env" file for BookStack, read more at https://github.com/BookStackApp/BookStack.
3. Run bookstack:
   ```
   docker run -v $PWD/env:/data/.env -v $PWD/storage:/data/storage/uploads -v $PWD/uploads:/data/public/uploads -p 8080:80 bookstack
   ```

## With docker-compose
```yaml
version: '3'
services:
  web:
    image: bookstack
    restart: unless-stopped
    ports:
    - 8080:80
    volumes:
    - env:/data/.env
    - storage:/data/storage/uploads
    - uploads:/data/public/uploads
  db:
    image: mariadb
    restart: unless-stopped
    env: MYSQL_ROOT_PASSWORD: changeme
    volumes: [./database:/var/lib/mysql]
```
