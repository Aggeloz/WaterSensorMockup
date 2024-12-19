FROM node:latest

# COPY node_modules /fake_sensor/node_modules

# COPY package.json /fake_sensor/
# COPY index.js /fake_sensor/
COPY . /sensor_mockup/

WORKDIR /sensor_mockup

RUN npm install

# EXPOSE 1883

CMD [ "node", "." ]