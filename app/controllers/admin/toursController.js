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
        title: 'Admin | Crear Nuevo Tour',
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
      tipo,
      modalidad,
      idioma,
      fecha_inicio,
      fecha_fin
    } = req.body;

    // Conversión segura para numéricos y ENUM válidos
    const duracion = req.body.duracion ? parseInt(req.body.duracion) : null;
    const cupo_maximo = req.body.cupo_maximo ? parseInt(req.body.cupo_maximo) : 0;
    const precio = req.body.precio ? parseFloat(req.body.precio) : 0.0;

    // Validar ENUM tipo
    const tiposValidos = ['aventura', 'relajacion', 'cultural'];
    const tipoValido = tiposValidos.includes(tipo) ? tipo : null;

    // Validar ENUM modalidad (requerido)
    const modalidadesValidas = ['grupo', 'privado'];
    const modalidadValida = modalidadesValidas.includes(modalidad) ? modalidad : 'grupo';

    const disponible = req.body.disponible ? 1 : 0;
    const publicado = req.body.publicado ? 1 : 0;

    let imagen_destacada = null;
    if (req.file) {
      imagen_destacada = `/uploads/${req.file.filename}`;
      console.log('Imagen a guardar:', imagen_destacada);
    }

    await tourModel.create({
      nombre,
      descripcion,
      lugar_salida,
      lugar_destino,
      duracion,
      cupo_maximo,
      precio,
      tipo: tipoValido,
      modalidad: modalidadValida,
      idioma,
      fecha_inicio: fecha_inicio || null,
      fecha_fin: fecha_fin || null,
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
  try {
    const { id } = req.params;
    const [[tour]] = await tourModel.getById(id); // <-- debe devolver un objeto con las propiedades correctas

    if (!tour) {
      return res.status(404).send('Tour no encontrado');
    }

    res.render('admin/tours/edit', {
        tour,
        layout: 'layouts/admin',
        title: 'Admin | Editar Tour',
        botones: []
    });
  } catch (error) {
    console.error('Error al cargar el tour para editar:', error);
    res.status(500).send('Error interno del servidor');
  }
};

exports.update = async (req, res) => {
  const { id } = req.params;

  try {
    const datos = {
      nombre: req.body.nombre,
      descripcion: req.body.descripcion,
      lugar_salida: req.body.lugar_salida,
      lugar_destino: req.body.lugar_destino,
      duracion: req.body.duracion,
      tipo: req.body.tipo,
      modalidad: req.body.modalidad,
      idioma: req.body.idioma,
      precio: req.body.precio,
      cupo_maximo: req.body.cupo_maximo,
      disponible: req.body.disponible || 0,
      publicado: req.body.publicado || 0,
      fecha_inicio: req.body.fecha_inicio,
      fecha_fin: req.body.fecha_fin,
    };

    if (req.file) {
      datos.imagen_destacada = '/uploads/' + req.file.filename;
    }

    await tourModel.update(id, datos);
    res.redirect('/admin/tours');
  } catch (error) {
    console.error('Error al actualizar el tour:', error);
    res.status(500).send('Hubo un error al actualizar el tour');
  }
};
