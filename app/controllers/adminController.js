// controllers/adminController.js
const Reserva = require('../models/reservasModel');
const Tour = require('../models/TourModel');

module.exports = {
  dashboard: async (req, res) => {
    const totalReservasHoy = await Reserva.countToday();
    const totalIngresosHoy = await Reserva.sumIngresosToday();
    res.render('admin/dashboard', { totalReservasHoy, totalIngresosHoy });
  },

  listarReservas: async (req, res) => {
    const reservas = await Reserva.getAll();
    res.render('admin/reservas', { reservas });
  },

  listarTours: async (req, res) => {
    const tours = await Tour.getAll();
    res.render('admin/tours', { tours });
  }
};
