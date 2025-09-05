# Etapa de construcción: construye la aplicación de React
FROM node:16-alpine as build

# Establece el directorio de trabajo
WORKDIR /app

# Copia el archivo package.json
COPY package.json .

# Instala las dependencias
RUN npm install --production

# Copia el resto de los archivos
COPY . .

# Construye la aplicación de React
RUN npm run build

# Etapa de producción: utiliza un servidor web ligero para servir los archivos estáticos
FROM nginx:alpine

# Copia los archivos de la etapa de construcción
COPY --from=build /app/build /usr/share/nginx/html

# Copia el archivo de configuración de nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Expone el puerto 80 (el puerto predeterminado para HTTP)
EXPOSE 8080

# Comando de arranque del servidor nginx
CMD ["nginx", "-g", "daemon off;"]