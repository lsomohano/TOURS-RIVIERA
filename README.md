# 🌴 Sistema de Reservas de Tours - Riviera Maya

Este proyecto es una aplicación web para ofrecer, gestionar y reservar tours turísticos en la Riviera Maya. Incluye integración con Stripe para pagos en línea, soporte multilenguaje (`es`, `en`), y está preparado para correr en entornos locales o con Docker.

## 🚀 Tecnologías Utilizadas

- Node.js + Express
- MySQL
- EJS (template engine)
- Stripe (pagos en línea)
- Docker + Docker Compose
- i18n (internacionalización)

## ⚙️ Configuración del entorno

1. **Clona el repositorio**

```bash
git clone https://github.com/lsomohano/TOURS-RIVIERA.git
cd TOURS-RIVIERA
```

2. **Instala las dependencias**

```bash
npm install
```

3. **Copia el archivo de entorno**

```bash
cp .env.example .env
```

4. **Edita `.env` con tus credenciales**

Incluye variables como:

```env
DB_HOST=db
DB_USER=usuario_loc
DB_PASSWORD=admin123
DB_NAME=tours
MYSQL_ROOT_PASSWORD=admin123

STRIPE_SECRET_KEY=sk_test_xxx
STRIPE_PUBLIC_KEY=pk_test_xxx
STRIPE_WEBHOOK_SECRET=whsec_xxx

DOMAIN=localhost
PORT=3000
```

## 🐳 Usando Docker

Inicia los servicios con:

```bash
docker-compose up --build
```

Accede en tu navegador a: `http://localhost:3000`

## 📦 Scripts útiles

- `npm run dev`: Inicia el servidor en modo desarrollo (con nodemon)
- `npm start`: Inicia el servidor en producción

## 🌐 Idiomas soportados

- Español (`es`)
- Inglés (`en`)

Puedes cambiar el idioma desde la interfaz o ajustando el encabezado `Accept-Language` del navegador.

## 💳 Pagos con Stripe

Este sistema permite realizar pagos seguros con tarjeta mediante Stripe. Asegúrate de configurar correctamente las claves en `.env`.

---

## 📂 Estructura del proyecto

```
├── controllers/
├── models/
├── views/
├── public/
├── routes/
├── locales/
├── .env
├── docker-compose.yml
└── app.js
```
## Ususio de sistema 
Email: admin@demo.com

Contraseña: password123

Rol: admin
## 🛠 Mantenimiento

Para reportar errores o sugerencias, abre un issue o un pull request.

## 📄 Licencia

MIT © Leonel Somohano