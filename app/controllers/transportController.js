// Mostrar el formulario
const TransporteModel = require('../models/TransportacionModel');

exports.formulario = async (req, res) => {
  try {
    const destinos = await TransporteModel.obtenerDestinos();
    const servicios = await TransporteModel.obtenerTiposDeServicio();

    res.render('transportacion/formulario', {
      destinos,
      servicios
    });
  } catch (error) {
    console.error('Error al cargar formulario:', error);
    res.status(500).send('Error interno');
  }
};

// Procesar la reservación
exports.procesarReservacion = (req, res) => {
  const { origen, destino, fecha, hora, pasajeros } = req.body;

  // Aquí podrías guardar la información en la base de datos
  console.log('Reservación:', { origen, destino, fecha, hora, pasajeros });

  // Mostrar la vista de confirmación
  res.render('transportacion/confirmacion', {
    datos: { origen, destino, fecha, hora, pasajeros }
  });
};