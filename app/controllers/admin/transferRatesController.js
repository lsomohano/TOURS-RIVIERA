const TransferRate = require('../../models/transferRatesModel');
const Zone = require('../../models/ZoneModel');
const VehicleType = require('../../models/vehicleTypeModel');

exports.list = async (req, res) => {
  try {
    const rates = await TransferRate.findAll();

    res.render('admin/transfer_rates/index', {
      title: 'Admin | Tarifas de Traslado',
      layout: 'layouts/admin',
      tarifas: rates,
      botones: [
        { href: '/admin/transfer-rates/new', class: 'btn-primary', text: 'Nueva Tarifa', icon: 'fas fa-plus' }
      ]
    });
  } catch (error) {
    console.error('❌ Error al listar tarifas:', error);
    res.redirect('/admin'); // o mostrar error en la vista
  }
};

exports.form = async (req, res) => {
  try {
    const zones = await Zone.findAll();
    const vehicleTypes = await VehicleType.findAll();
    res.render('admin/transfer_rates/form', {
      title: 'Admin | Nueva Tarifa',
      action: '/admin/transfer-rates/create',
      zones,
      vehicleTypes,
      layout: 'layouts/admin',
      rate: {},
      botones: [
        { href: '/admin/transfer-rates/', class: 'btn-secondary', text: 'Regresar', icon: 'fas fa-arrow-left' }
      ]
    });
  } catch (error) {
    console.error('❌ Error al mostrar formulario:', error);
    res.status(500).send('Error al mostrar formulario');
  }
};

exports.create = async (req, res) => {
  try {
    const { zone_id, vehicle_type_id, one_way_price, round_trip_price } = req.body;
    await TransferRate.create({ zone_id, vehicle_type_id, one_way_price, round_trip_price });
    res.redirect('/admin/transfer-rates');
  } catch (error) {
    console.error('❌ Error al crear tarifa:', error);
    res.status(500).send('Error al crear tarifa');
  }
};

exports.edit = async (req, res) => {
  try {
    const { id } = req.params;
    const rate = await TransferRate.findById(id);
    if (!rate) return res.status(404).send('Tarifa no encontrada');

    const zones = await Zone.findAll();
    const vehicleTypes = await VehicleType.findAll();

    res.render('admin/transfer_rates/form', {
      title: 'Editar Tarifa',
      action: `/admin/transfer-rates/${id}/update`,
      rate,
      zones,
      vehicleTypes,
      layout: 'layouts/admin',
      botones: [
        { href: '/admin/transfer-rates/', class: 'btn-secondary', text: 'Regresar', icon: 'fas fa-arrow-left' }
      ]
    });
  } catch (error) {
    console.error('❌ Error al mostrar formulario de edición:', error);
    res.status(500).send('Error al mostrar formulario de edición');
  }
};

exports.update = async (req, res) => {
  try {
    const { id } = req.params;
    const { zone_id, vehicle_type_id, one_way_price, round_trip_price } = req.body;
    await TransferRate.update(id, { zone_id, vehicle_type_id, one_way_price, round_trip_price });
    res.redirect('/admin/transfer-rates');
  } catch (error) {
    console.error('❌ Error al actualizar tarifa:', error);
    res.status(500).send('Error al actualizar tarifa');
  }
};

exports.delete = async (req, res) => {
  try {
    const { id } = req.params;
    await TransferRate.delete(id);
    res.redirect('/admin/transfer-rates');
  } catch (error) {
    console.error('❌ Error al eliminar tarifa:', error);
    res.status(500).send('Error al eliminar tarifa');
  }
};
