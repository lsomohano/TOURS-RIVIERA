const bcrypt = require('bcrypt');
const tourModel = require('../../models/TourModel');
const tourDetalles = require('../../models/TourDetallesModel');
const tourItinerarios = require('../../models/TourItinerariosModel');
const tourImagenes = require('../../models/TourImagenesModel');
const recomendacionesModel = require("../../models/TourRecomendacionesModel");
const PuntoEncuentro = require('../../models/TourPuntoEncuentroModel');
const TourPoliticas = require('../../models/TourPoliticasCancelacionModel');
const PrecioPrivado = require('../../models/TourPrecioPrivadoModel');
const FechasModel = require('../../models/TourfechasModel');
const path = require('path');
const fs = require("fs");

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
        botones: [
          { href: '/admin/tours', class: 'btn-secondary', text: 'Regresar', icon: 'fas fa-arrow-left' }
        ]
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

//Edición del tour
exports.editForm = async (req, res) => {
  try {
    const { id } = req.params;
    const [[tour]] = await tourModel.getById(id); // <-- debe devolver un objeto con las propiedades correctas
    const [[detalles]] = await tourDetalles.getDetalles(id);
    const [itinerario] = await tourItinerarios.getItinerario(id);
    const [imagenes] = await tourImagenes.getImagenes(id);
    const [recomendaciones] = await recomendacionesModel.getRecomendaciones(id);
    const [puntos] = await PuntoEncuentro.listarPorTour(id);
    const politicas = await TourPoliticas.obtenerPorTour(id);
    const precioPrivado = await PrecioPrivado.obtenerPorTour(id);
    const PreciosPrivadosCalculados = await PrecioPrivado.getPreciosPrivadosCalculados(id);
    const [fechas] = await FechasModel.getFechasByTourId(id);

    if (!tour) {
      return res.status(404).send('Tour no encontrado');
    }

    res.render('admin/tours/edit', {
        tour,
        detalles,
        itinerario,
        imagenes,
        recomendaciones,
        puntos,
        politicas,
        precioPrivado,
        PreciosPrivadosCalculados,
        fechas,
        layout: 'layouts/admin',
        title: `Editar Tour - ${tour.nombre}`,
        botones: [
          { href: '/admin/tours', class: 'btn-secondary', text: 'Regresar', icon: 'fas fa-arrow-left' }
        ]
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
    res.redirect(`/admin/tours/${id}/edit`);
  } catch (error) {
    console.error('Error al actualizar el tour:', error);
    res.status(500).send('Hubo un error al actualizar el tour');
  }
};

//Agregar los detalles del tour.
exports.guardarDetalles = async (req, res) => {
  const tourId = req.params.id;
  const data = req.body;

  try {
    const [rows] = await tourDetalles.getDetalles(tourId);

    if (rows.length > 0) {
      await tourDetalles.updateDetalles(tourId, data);
    } else {
      await tourDetalles.createDetalles(tourId, data);
    }

    res.redirect(`/admin/tours/${tourId}/edit#detalles`);
  } catch (err) {
    console.error(err);
    res.status(500).send("Error al guardar los detalles del tour");
  }
};

//Gestión de Itinerario del tour
exports.crearPasoItinerario = async (req, res) => {
  const tourId = req.params.id;
  const paso = req.body;

  try {
    await tourItinerarios.createItinerarioPaso(tourId, paso);
    res.redirect(`/admin/tours/${tourId}/edit#itinerario`);
  } catch (err) {
    console.error(err);
    res.status(500).send("Error al crear paso del itinerario");
  }
};

exports.actualizarPasoItinerario = async (req, res) => {
  const pasoId = req.params.pasoId;
  const tourId = req.body.tour_id;
  const paso = req.body;

  try {
    await tourItinerarios.updateItinerarioPaso(pasoId, paso);
    res.redirect(`/admin/tours/${tourId}/edit#itinerario`);
    //res.redirect('back');
  } catch (err) {
    console.error(err);
    res.status(500).send("Error al actualizar paso del itinerario");
  }
};

exports.eliminarPasoItinerario = async (req, res) => {
  const pasoId = req.params.pasoId;
  const tourId = req.body.tour_id;
  try {
    await tourItinerarios.deleteItinerarioPaso(pasoId);
    res.redirect(`/admin/tours/${tourId}/edit#itinerario`);
    //res.redirect('back');
  } catch (err) {
    console.error(err);
    res.status(500).send("Error al eliminar paso del itinerario");
  }
};

//Modulo de galeria.
exports.subirImagen = async (req, res) => {
  try {
    const { descripcion } = req.body;
    const { filename } = req.file;
    const tourId = req.params.id;

    const url_imagen = `/uploads/${filename}`;

    await tourImagenes.crear(tourId, url_imagen, descripcion);

    res.redirect(`/admin/tours/${tourId}/edit#galeria`);
  } catch (error) {
    console.error("Error al subir imagen:", error);
    res.status(500).send("Error interno al subir la imagen");
  }
};

exports.eliminarImagen = async (req, res) => {
  try {
    const { id } = req.params;
    const imagen = await tourImagenes.obtenerPorId(id);

    if (imagen) {
      const rutaArchivo = path.join(__dirname, "..", "public", imagen.url_imagen);
      if (fs.existsSync(rutaArchivo)) fs.unlinkSync(rutaArchivo); // Borrar imagen

      await tourImagenes.eliminar(id);
    }

    res.redirect(`/admin/tours/${req.query.tourId}/edit#galeria`);
  } catch (error) {
    console.error("Error al eliminar imagen:", error);
    res.status(500).send("Error al eliminar la imagen");
  }
};

//Modulos de recomendaciones.
exports.guardarRecomendacion = async (req, res) => {
  const { id } = req.params;
  const { momento, recomendacion } = req.body;

  try {
    await recomendacionesModel.agregarRecomendacion(id, momento, recomendacion);
    res.redirect(`/admin/tours/${id}/edit#recomenda`);
  } catch (error) {
    console.error("Error al guardar recomendación:", error);
    res.status(500).send("Error al guardar recomendación");
  }
};

exports.eliminarRecomendacion = async (req, res) => {
  const { id, recId } = req.params;

  try {
    await recomendacionesModel.eliminarRecomendacion(recId);
    res.redirect(`/admin/tours/${id}/edit#recomenda`);
  } catch (error) {
    console.error("Error al eliminar recomendación:", error);
    res.status(500).send("Error al eliminar recomendación");
  }
};

//Puntos encuentros 
exports.crear = async (req, res) => {
  const { direccion, coordenadas, hora } = req.body;
  const { id: tour_id } = req.params;

  try {
    await PuntoEncuentro.crear({ tour_id, direccion, coordenadas, hora });
    res.redirect(`/admin/tours/${tour_id}/edit#puntos`);
  } catch (err) {
    console.error('Error al crear punto:', err);
    res.status(500).send('Error al crear punto de encuentro');
  }
};

exports.eliminar = async (req, res) => {
  const { id: tour_id, puntoId } = req.params;

  try {
    await PuntoEncuentro.eliminar(puntoId);
    res.redirect(`/admin/tours/${tour_id}/edit#puntos`);
  } catch (err) {
    console.error('Error al eliminar punto:', err);
    res.status(500).send('Error al eliminar punto');
  }
};

//Crear policas de privacidad.
exports.guardarPoliticas = async (req, res) => {
  const { id } = req.params;
  const { politicas } = req.body;
  try {
    await TourPoliticas.guardar(id, politicas);
    res.redirect(`/admin/tours/${id}/edit#politicas`);
  } catch (error) {
    console.error("Error al guardar políticas:", error);
    res.status(500).send("Error al guardar políticas de cancelación");
  }
};

// Guardar precio privado
exports.guardarPrecioPrivado = async (req, res) => {
  const tourId = req.params.id;

  const datos = {
    personas_max: parseInt(req.body.personas_max),
    precio_base: parseFloat(req.body.precio_base),
    incremento_pct: req.body.incremento_pct ? parseFloat(req.body.incremento_pct) : null,
    aplica_desde: req.body.aplica_desde ? parseInt(req.body.aplica_desde) : null,
    activo: req.body.activo ? 1 : 0
  };

  try {
    await PrecioPrivado.guardar(tourId, datos);
    res.redirect(`/admin/tours/${tourId}/edit#precio_privado`);
  } catch (error) {
    console.error('Error al guardar el precio privado:', error);
    res.status(500).send('Error interno al guardar el precio privado.');
  }
};

//Agregar fechas disponibles.
exports.agregarFecha = async (req, res) => {
    const { fecha, cupo_maximo, tab } = req.body;
    const { tourId } = req.params;

    try {
      await FechasModel.agregarFecha(tourId, fecha, cupo_maximo);
      res.redirect(`/admin/tours/${tourId}/edit${tab || '#fechas'}`);
    } catch (error) {
      console.error('Error al agregar fecha:', error);
      res.redirect('back');
    }
};

exports.eliminarFecha = async (req, res) => {
    const { id } = req.params;
    const { tour_id, tab } = req.body;

    try {
      await FechasModel.eliminarFecha(id);
      res.redirect(`/admin/tours/${tour_id}/edit${tab || '#fechas'}`);
    } catch (error) {
      console.error('Error al eliminar fecha:', error);
      res.redirect('back');
    }
};