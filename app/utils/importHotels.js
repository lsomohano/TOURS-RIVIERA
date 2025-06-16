require('dotenv').config();
const axios = require('axios');
const mysql = require('mysql2/promise');

const ZONAS = [
   { zona: 'Cancun', ciudad: 'Cancún' },
   { zona: 'Zona Hotelera', ciudad: 'Zona Hotelera' },
   { zona: 'Playa del Carmen', ciudad: 'Playa del Carmen' },
   { zona: 'Playacar', ciudad: 'Playacar' },
   { zona: 'Tulum', ciudad: 'Tulum' },
   { zona: 'Isla Mujeres', ciudad: 'Isla Mujeres' },
   { zona: 'Costa Mujeres', ciudad: 'Costa Mujeres' },
   { zona: 'Puerto Morelos', ciudad: 'Puerto Morelos'}
 ];

const LIMITE_POR_QUERY = 50;
const VARIACIONES_BUSQUEDA = [
  'hotel', 'hotel centro', 'hotel zona hotelera', 'hotel resort', 'hotel playa',
  'hotel boutique', 'hotel económico', 'resort todo incluido',
  'downtown hotel', 'hotel zone resort', 'beachfront hotel',
  'boutique hotel', 'budget hotel', 'all inclusive resort',
  'resort hotel', 'luxury resort'
];

// Normalizador básico de nombres
function normalizeName(str) {
  return str
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "") // quitar acentos
    .replace(/[^\w\s]/g, '') // quitar comas, puntos
    .replace(/\s+/g, ' ') // un solo espacio
    .trim()
    .toLowerCase();
}

async function fetchHotelsPorVariaciones(ciudad) {
  const encontrados = new Map();

  for (const variacion of VARIACIONES_BUSQUEDA) {
    const query = `${variacion} ${ciudad} Mexico`;
    const url = `https://nominatim.openstreetmap.org/search?format=json&q=${encodeURIComponent(query)}&limit=${LIMITE_POR_QUERY}`;

    try {
      const res = await axios.get(url, {
        headers: { 'User-Agent': 'TuProyecto/1.0 (tuemail@tudominio.com)' }
      });

      for (const h of res.data) {
        const key = `${h.lat},${h.lon}`;
        if (!encontrados.has(key)) {
          encontrados.set(key, h);
        }
      }
    } catch (err) {
      console.warn(`❌ Error al buscar: "${query}" —`, err.message);
    }
  }

  return Array.from(encontrados.values());
}

async function importHotels() {
  const conn = await mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME
  });

  let success = 0;
  const clavesNombreZona = new Set();

  for (const { zona, ciudad } of ZONAS) {
    console.log(`⏳ Importando hoteles en ${ciudad}...`);
    const hoteles = await fetchHotelsPorVariaciones(ciudad);

    for (const h of hoteles) {
      const nameRaw = h.display_name.split(',')[0].trim();
      const name = nameRaw;
      const lat = parseFloat(h.lat);
      const lng = parseFloat(h.lon);

      const clave = `${normalizeName(name)}|${zona.toLowerCase()}`;
      if (clavesNombreZona.has(clave)) {
        continue; // ya lo insertamos
      }
      clavesNombreZona.add(clave);

      try {
        await conn.execute(`
          INSERT INTO hotels (name, zone, latitude, longitude)
          VALUES (?, ?, ?, ?)
          ON DUPLICATE KEY UPDATE latitude = VALUES(latitude), longitude = VALUES(longitude)
        `, [name, zona, lat, lng]);
        success++;
        console.log(`✅ Insertado: ${name}`);
      } catch (err) {
        console.warn(`❌ Error con ${name}:`, err.message);
      }
    }
  }

  await conn.end();
  console.log(`✅ Importación completa: ${success} hoteles insertados.`);
  return { success };
}

module.exports = importHotels;
