const bcrypt = require('bcrypt');
//const db = require('../../db'); // ajusta según la ubicación
const crypto = require('crypto');
const Hotel = require('../../models/hotelsModel');
const Zone  = require('../../models/ZoneModel');

//const fs = require('fs');
//const path = require('path');
const importHotels = require('../../utils/importHotels');
const importHotelsByArea = require('../../utils/importHotelsByArea');


exports.list = async (req, res) => {
  try {
    const hotels = await Hotel.findAll();

    res.render('admin/hotels/index', { 
      hotels,
      layout: 'layouts/admin',
      title: 'Admin | Hoteles',
      botones: [
        { href: '/admin/hotels/new', class: 'btn-primary', text: 'Nuevo Hotel', icon: 'fas fa-plus' }
      ]
    });
  } catch (error) {
    console.error('❌ Error al obtener hoteles:', error);

    // Puedes mostrar una vista de error o redirigir con un mensaje
    res.render('admin/hotels/index', {
      hotels: [],
      layout: 'layouts/admin',
      title: 'Admin | Hoteles',
      error: 'Ocurrió un error al cargar los hoteles.',
      botones: [
        { href: '/admin/hotels/new', class: 'btn-primary', text: 'Nuevo Hotel', icon: 'fas fa-plus' }
      ]
    });
  }
};


exports.showForm = async (req, res) => {
  try {
    const id = req.params.id;
    const hotel = id ? await Hotel.findById(id) : null;
    const zones = await Zone.findAll();

    res.render('admin/hotels/create', { 
      hotel,
      zonas: zones,
      layout: 'layouts/admin',
      title: 'Admin | Hoteles',
      botones: [
        { href: '/admin/hotels', class: 'btn-secondary', text: 'Regresar', icon: 'fas fa-arrow-left' }
      ]
    });
  } catch (error) {
    console.error('❌ Error al cargar el formulario del hotel:', error);

    // Redirige a la lista de hoteles con un mensaje de error en flash o query
    res.redirect('/admin/hotels?error=No se pudo cargar el formulario');
  }
};


exports.save = async (req, res) => {
  const { id, name, zone_id, latitude, longitude } = req.body;

  try {
    if (id) {
      await Hotel.update(id, { name, zone_id, latitude, longitude });
    } else {
      await Hotel.create({ name, zone_id, latitude, longitude });
    }
    req.flash('success', '✅ Hotel guardado correctamente.');
    res.redirect('/admin/hotels');
  } catch (error) {
    console.error('❌ Error al guardar el hotel:', error);

    let message = '❌ Ocurrió un error al guardar el hotel.';

    if (error.code === 'ER_DUP_ENTRY') {
      message = `⚠️ Ya existe un hotel con ese nombre: "${name}".`;
    }

    req.flash('error', message);
    res.redirect(req.get('referer') || '/admin/hotels');
  }
};




exports.delete = async (req, res) => {
  await Hotel.delete(req.params.id);
  res.redirect('/admin/hotels');
};

exports.importarHoteles = async (req, res) => {
  try {
    const resultado = await importHotels();
    req.flash('success', `Importación completada: ${resultado.success} hoteles importados.`);
  } catch (error) {
    console.error('❌ Error al importar hoteles:', error);
    req.flash('error', 'Hubo un error al importar los hoteles.');
  }

  res.redirect('/admin/hotels');
};

exports.importarHotelsByArea = async (req, res) => {
  try {
    const resultado = await importHotelsByArea();
    req.flash('success', `Importación completada: ${resultado.success} hoteles importados.`);
  } catch (error) {
    console.error('❌ Error al importar hoteles:', error);
    req.flash('error', 'Hubo un error al importar los hoteles.');
  }

  res.redirect('/admin/hotels');
};