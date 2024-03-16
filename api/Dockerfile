FROM node:18.18.2 as develop-stage

RUN mkdir /code
COPY . /code
WORKDIR /code

RUN npm i -g @nestjs/cli ; npm i ; chown -R 501:20 node_modules

EXPOSE 3000

ENTRYPOINT ["sh", "/code/entrypoint.sh"]
