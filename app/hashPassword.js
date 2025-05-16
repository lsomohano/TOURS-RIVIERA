const bcrypt = require('bcrypt');

async function crearUsuarioPrueba() {
  const passwordPlano = 'password123';
  const hash = await bcrypt.hash(passwordPlano, 10);
  console.log(hash); // Esto te muestra el hash en consola
}
crearUsuarioPrueba();
