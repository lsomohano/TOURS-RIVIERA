const bcrypt = require('bcrypt');
//const db = require('../../db'); // ajusta según la ubicación
const reservasModel = require('../../models/reservasModel');

exports.listarReservas = async (req, res) => {
  try {
    const [reservas] = await reservasModel.getReservaConTourLista();
    res.render('admin/reservas/index', { 
        reservas,
        layout: 'layouts/admin',
        title: 'Admin | Reservaciones',
        botones: [
          
          {href: '/admin/usuarios/new', class: 'btn-primary', text: 'Nueva Reserva', icon: 'fas fa-plus' }
        ]
    });
  } catch (error) {
    console.error(error);
    req.flash('error', 'Error al cargar reservaciones');
    res.redirect('/admin');
  }
};
