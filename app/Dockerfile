FROM node:20

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install

COPY . .
# Copia el script wait-for-it al contenedor
#COPY wait-for-it.sh /usr/src/app/wait-for-it.sh
RUN chmod +x /usr/src/app/wait-for-it.sh

EXPOSE 3000

#CMD ["node", "app.js"]