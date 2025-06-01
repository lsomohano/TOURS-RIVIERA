const Transportacion = require('../../models/TransportacionModel');

exports.listarTransportaciones = async (req, res) => {
  try {
    const reservas = await Transportacion.findAll(); // Asumiendo que usas `.getAll()` que devuelve [rows]
    res.render('admin/transportacion/index', {
      reservas,
      layout: 'layouts/admin',
      title: 'Admin | Transportación',
      botones: [
        { href: '/admin/transportacion/new', class: 'btn-primary', text: 'Nueva Transportación', icon: 'fas fa-plus'}
      ]
    });
  } catch (error) {
    console.error(error);
    req.flash('error', 'Error al cargar transportaciones');
    res.redirect('/admin');
  }
};

exports.formNueva = (req, res) => {
  res.render('admin/transportacion/form', {
    layout: 'layouts/admin',
    title: 'Nueva Transportación',
    reserva: {},
    action: '/admin/transportacion/create'
  });
};

exports.crear = async (req, res) => {
  try {
    await Transportacion.create(req.body);
    res.redirect('/admin/transportacion');
  } catch (error) {
    console.error(error);
    res.render('admin/transportacion/form', {
      layout: 'layouts/admin',
      title: 'Nueva Transportación',
      reserva: req.body,
      action: '/admin/transportacion/create',
      error: 'Error al crear transportación'
    });
  }
};

exports.formEditar = async (req, res) => {
  try {
    const reserva = await Transportacion.findById(req.params.id);
    if (!reserva) {
      req.flash('error', 'Transportación no encontrada');
      return res.redirect('/admin/transportacion');
    }

    res.render('admin/transportacion/form', {
      layout: 'layouts/admin',
      title: 'Editar Transportación',
      reserva,
      action: `/admin/transportacion/${req.params.id}/update`
    });
  } catch (error) {
    console.error(error);
    req.flash('error', 'Error al cargar transportación');
    res.redirect('/admin/transportacion');
  }
};

exports.actualizar = async (req, res) => {
  try {
    await Transportacion.update(req.params.id, req.body);
    res.redirect('/admin/transportacion');
  } catch (error) {
    console.error(error);
    res.render('admin/transportacion/form', {
      layout: 'layouts/admin',
      title: 'Editar Transportación',
      reserva: req.body,
      action: `/admin/transportacion/${req.params.id}/update`,
      error: 'Error al actualizar transportación'
    });
  }
};

exports.eliminar = async (req, res) => {
  try {
    await Transportacion.delete(req.params.id);
    res.redirect('/admin/transportacion');
  } catch (error) {
    console.error(error);
    req.flash('error', 'Error al eliminar transportación');
    res.redirect('/admin/transportacion');
  }
};
