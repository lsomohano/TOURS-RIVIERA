const TourModel = require('../models/TourModel');
const TourExtrasModel = require('../models/TourExtrasModel'); // ya lo tienes creado

exports.index = async (req, res) => {
  try {
    const idioma = req.getLocale() || 'en';
    const filters = req.query;
    const page = parseInt(req.query.page) || 1;
    const limit = 9;

    const [[countResult]] = await TourModel.getCount(filters, idioma);
    const totalTours = countResult.total;
    const totalPages = Math.ceil(totalTours / limit);

    const [tours] = await TourModel.getPaginated(filters, page, limit, idioma);

    res.render('tours', {
      tours,
      locale: req.getLocale(),
      //locale: idioma,
      currentUrl: req.originalUrl,
      query: req.query,
      page,
      countResult,
      totalTours,
      totalPages,
      limit,
      req
    });
  } catch (err) {
    console.error('Error al obtener tours:', err);
    res.status(500).send('Error interno');
  }
};

// Página de detalle de un tour
exports.detalle = async (req, res) => {
  const tourId = req.params.id;

  try {
    const [[tour]] = await TourModel.getById(tourId);
    if (!tour) return res.status(404).send('Tour no encontrado');

    const [[detalles]] = await TourExtrasModel.getDetalles(tourId);
    const [imagenes] = await TourExtrasModel.getImagenes(tourId);
    const [fechas] = await TourExtrasModel.getFechasDisponibles(tourId);
    const [[punto]] = await TourExtrasModel.getPuntoEncuentro(tourId);
    const [[politicas]] = await TourExtrasModel.getPoliticas(tourId);
    const [itinerario] = await TourExtrasModel.getItinerario(tourId);
    const [recomendaciones] = await TourExtrasModel.getRecomendaciones(tourId);
    const preciosCalculados = await TourExtrasModel.getPreciosPrivadosCalculados(tourId);
    //const [preciosCalculados] = await TourExtrasModel.getPreciosPrivadosCalculados(tourId); // nuevo

    res.render('tour-detalle', {
      layout: 'layouts/layouts_tours_datalles',
      tour: {
        ...tour,
        precio: Number(tour.precio) || 0  // Asegura que sea número para evitar .toFixed error
      },
      detalles: detalles || {},
      imagenes: imagenes || [],
      fechas: fechas || [],
      punto: punto || {},
      politicas: politicas || {},
      itinerario: itinerario || [],
      recomendaciones: recomendaciones || [],
       preciosPrivadosCalculados: preciosCalculados || {},
      locale: req.getLocale(),
      currentUrl: req.originalUrl
    });

  } catch (err) {
    console.error('Error al cargar detalles del tour:', err);
    res.status(500).send('Error interno');
  }
};