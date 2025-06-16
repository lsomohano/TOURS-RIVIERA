const Zone = require('../../models/ZoneModel');

exports.list = async (req, res) => {
  const zones = await Zone.findAll();
  res.render('admin/zones/index', { 
        zones,
        layout: 'layouts/admin',
        title: 'Admin | Zonas',
        botones: [
          {href: '/admin/zones/new', class: 'btn-primary', text: 'Nueva Zona', icon: 'fas fa-plus' }
        ]
  });
  
};

exports.showForm = async (req, res) => {
  const zone = req.params.id ? await Zone.findById(req.params.id) : null;
  res.render('admin/zones/form', {
    layout: 'layouts/admin',
    title: zone ? 'Editar Zona' : 'Nueva Zona',
    botones: [{ texto: 'Volver', href: '/admin/zones', clase: 'btn btn-secondary' }],
    zone
  });
};

exports.save = async (req, res) => {
  const { id, name } = req.body;
  if (id) await Zone.update(id, name);
  else await Zone.create(name);
  res.redirect('/admin/zones');
};

exports.delete = async (req, res) => {
  await Zone.delete(req.params.id);
  res.redirect('/admin/zones');
};
