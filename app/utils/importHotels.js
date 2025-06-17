require('dotenv').config();
const axios = require('axios');
const mysql = require('mysql2/promise');

const LIMITE_POR_QUERY = 50;
const VARIACIONES_BUSQUEDA = [
  'hotel', 'hotel centro', 'hotel zona hotelera', 'hotel resort', 'hotel playa',
  'hotel boutique', 'hotel económico', 'resort todo incluido',
  'downtown hotel', 'hotel zone resort', 'beachfront hotel',
  'boutique hotel', 'budget hotel', 'all inclusive resort',
  'resort hotel', 'luxury resort'
];

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

  // ✅ Obtenemos las zonas del catálogo
  const [zonas] = await conn.query('SELECT id, name FROM zones');

  let success = 0;
  const clavesNombreZona = new Set();

  for (const zona of zonas) {
    const { id: zone_id, name: zonaName, ciudad } = zona;
    const ciudadBusqueda = ciudad || zonaName;

    console.log(`⏳ Importando hoteles en ${ciudadBusqueda}...`);
    const hoteles = await fetchHotelsPorVariaciones(ciudadBusqueda);

    for (const h of hoteles) {
      const nameRaw = h.display_name.split(',')[0].trim();
      const name = nameRaw;
      const lat = parseFloat(h.lat);
      const lng = parseFloat(h.lon);

      const clave = `${normalizeName(name)}|${zonaName.toLowerCase()}`;
      if (clavesNombreZona.has(clave)) {
        continue;
      }
      clavesNombreZona.add(clave);

      try {
        await conn.execute(`
          INSERT INTO hotels (name, zone_id, latitude, longitude)
          VALUES (?, ?, ?, ?)
          ON DUPLICATE KEY UPDATE latitude = VALUES(latitude), longitude = VALUES(longitude)
        `, [name, zone_id, lat, lng]);
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
