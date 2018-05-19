FROM node:alpine
  
RUN apk add --no-cache git \
  && apk add --no-cache --virtual .build-deps-angular python \
  && yarn global add @angular/cli@latest
  
USER node
WORKDIR /home/node
RUN ng set --global packageManager=yarn && ng new my-app && rm -fR my-app

USER root
RUN apk del .build-deps-angular

USER node

EXPOSE 4200

CMD [ "sh" ]
