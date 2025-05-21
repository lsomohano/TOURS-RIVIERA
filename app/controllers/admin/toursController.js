const bcrypt = require('bcrypt');
//const db = require('../../db'); // ajusta según la ubicación
const tourModel = require('../../models/TourModel');
const path = require('path');

exports.listarTours = async (req, res) => {
  try {
    const [tours] = await tourModel.getAllAdmin();
    res.render('admin/tours/index', { 
        tours,
        layout: 'layouts/admin',
        title: 'Admin | Tours',
        botones: [
          
          {href: '/admin/tours/new', class: 'btn-primary', text: 'Nuevo Tour', icon: 'fas fa-plus' }
        ]
    });
  } catch (error) {
    console.error(error);
    req.flash('error', 'Error al cargar tours');
    res.redirect('/admin');
  }
};

exports.createForm = async (req, res) => {
  res.render('admin/tours/new',{
        layout: 'layouts/admin',
        title: 'Admin | Tours',
        botones: []
  });
};

exports.crear = async (req, res) => {
  try {
    const {
      nombre,
      descripcion,
      lugar_salida,
      lugar_destino,
      duracion,
      cupo_maximo,
      precio,
      tipo,
      modalidad,
      idioma,
      fecha_inicio,
      fecha_fin,
    } = req.body;

    const disponible = req.body.disponible ? 1 : 0;
    const publicado = req.body.publicado ? 1 : 0;

    // Imagen
    let imagen_destacada = '';
    if (req.file) {
      imagen_destacada = `/uploads/${req.file.filename}`;
    }

    // Aquí haces el insert a tu base de datos, por ejemplo:
    await tourModel.create({
      nombre,
      descripcion,
      lugar_salida,
      lugar_destino,
      duracion,
      cupo_maximo,
      precio,
      tipo,
      modalidad,
      idioma,
      fecha_inicio,
      fecha_fin,
      disponible,
      publicado,
      imagen_destacada
    });

    res.redirect('/admin/tours');
  } catch (error) {
    console.error(error);
    res.status(500).send('Error al crear el tour');
  }
};

exports.editForm = async (req, res) => {
  const tour = await Tour.findByPk(req.params.id);
  const detalles = await TourDetalles.findOne({ where: { tour_id: tour.id } });
  const imagenes = await TourImagenes.findAll({ where: { tour_id: tour.id } });
  res.render('admin/tours/edit', { tour, detalles, imagenes });
};

exports.update = async (req, res) => {
  await Tour.update(req.body, { where: { id: req.params.id } });
  await TourDetalles.update(req.body.detalles, { where: { tour_id: req.params.id } });
  // Actualizar imágenes si corresponde
  res.redirect('/admin/tours');
};
