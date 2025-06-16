require('dotenv').config();
const axios = require('axios');
const mysql = require('mysql2/promise');

// Definimos viewboxes aproximados para cada zona
// Formato: lng_min,lat_max,lng_max,lat_min
const VIEWBOXES = [
  { zona: 'Cancun', viewbox: '-86.95,21.22,-86.65,21.00' },
  { zona: 'Playa del Carmen', viewbox: '-87.10,20.70,-87.05,20.55' },
  { zona: 'Tulum', viewbox: '-87.45,20.25,-87.30,20.10' }
];

const LIMITE = 100; // Máximo 100 por solicitud pública

async function fetchHotelsByArea(viewbox) {
  const url = `https://nominatim.openstreetmap.org/search?format=json&amenity=hotel&viewbox=${viewbox}&bounded=1&limit=${LIMITE}`;
  const res = await axios.get(url, {
    headers: { 'User-Agent': 'TuProyecto/1.0 (tuemail@tudominio.com)' }
  });
  return res.data;
}

async function importHotelsByArea() {
  const conn = await mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME
  });

  let success = 0;

  for (const { zona, viewbox } of VIEWBOXES) {
    console.log(`⏳ Importando hoteles en zona ${zona} (viewbox ${viewbox})...`);
    const hoteles = await fetchHotelsByArea(viewbox);

    for (const h of hoteles) {
      const name = h.display_name.split(',')[0].trim();
      const lat  = parseFloat(h.lat);
      const lng  = parseFloat(h.lon);

      try {
        await conn.execute(`
          INSERT INTO hotels (name, zone, latitude, longitude)
          VALUES (?, ?, ?, ?)
          ON DUPLICATE KEY UPDATE latitude = VALUES(latitude), longitude = VALUES(longitude)
        `, [name, zona, lat, lng]);
        success++;
        console.log(`✅ Insertado: ${name} (${zona})`);
      } catch (err) {
        console.warn(`❌ Error insertando ${name}:`, err.message);
      }
    }
  }

  await conn.end();
  console.log(`✅ Importación completa: ${success} hoteles insertados/actualizados.`);
  return { success };
}

module.exports = importHotelsByArea;

// Si quieres ejecutarlo standalone:
// if (require.main === module) importHotelsByArea();
