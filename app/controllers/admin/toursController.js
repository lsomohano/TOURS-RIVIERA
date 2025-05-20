const bcrypt = require('bcrypt');
//const db = require('../../db'); // ajusta según la ubicación
const tourModel = require('../../models/TourModel');

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

exports.create = async (req, res) => {
  const tour = await Tour.create(req.body);
  await TourDetalles.create({ ...req.body.detalles, tour_id: tour.id });
  // Aquí también puedes procesar imágenes si las subes
  res.redirect('/admin/tours');
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
