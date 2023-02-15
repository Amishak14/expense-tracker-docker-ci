FROM node:12.18.1-slim
#RUN adduser --disabled-password amisha
#USER amisha1
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 5000
CMD ["npm","run","server"]
