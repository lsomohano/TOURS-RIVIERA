const bcrypt = require('bcrypt');
//const db = require('../../db'); // ajusta según la ubicación
const UsuarioModel = require('../../models/usuarioModel');

exports.listarUsuarios = async (req, res) => {
  try {
    const usuarios = await UsuarioModel.obtenerTodos();
    res.render('admin/usuarios/index', { 
        usuarios,
        layout: 'layouts/admin',
        title: 'Admin | Usuarios',
        botones: [
            { href: '/admin/usuarios/new', class: 'btn-primary', text: 'Nuevo Usuario', icon: 'fas fa-plus' }
        ]
    });
  } catch (error) {
    console.error(error);
    req.flash('error', 'Error al cargar usuarios');
    res.redirect('/admin');
  }
};

exports.formNuevoUsuario = (req, res) => {
    res.render('admin/usuarios/new', { 
        layout: 'layouts/admin',
        title: 'Admin | Nuevo Usuario',
        botones: []
    });
};

exports.crearUsuario = async (req, res) => {
  const { nombre, email, rol, password } = req.body;
  try {
    const hashedPassword = await bcrypt.hash(password, 10);
    UsuarioModel.crearUsuario(nombre, email, rol, hashedPassword);
    req.flash('success', 'Usuario creado correctamente');
    res.redirect('/admin/usuarios');
  } catch (error) {
    console.error(error);
    req.flash('error', 'No se pudo crear el usuario');
    res.redirect('/admin/usuarios/new');
  }
};

exports.editarUsuario = async (req, res) => {
  const { id } = req.params;
  try {
      const usuario = await UsuarioModel.findById(req.params.id);
      if (!usuario) return res.status(404).send('Usuario no encontrado');
      res.render('admin/usuarios/edit', {
        layout: 'layouts/admin',
        title: 'Admin | Editar Usuario',
        botones: [],
        usuario
      });
    } catch (err) {
      console.error(err);
      res.status(500).send('Error al obtener usuario');
    }
};

exports.actualizarUsuario = async (req, res) => {
  const { id } = req.params;
  const { nombre, email, rol } = req.body;
  try {
    await UsuarioModel.updateById(req.params.id, nombre, email, rol);
    req.flash('success', 'Usuario actualizado');
    res.redirect('/admin/usuarios');
  } catch (error) {
    console.error(error);
    req.flash('error', 'No se pudo actualizar');
    res.redirect(`/admin/usuarios/${id}/edit`);
  }
};

exports.eliminarUsuario = async (req, res) => {
  const { id } = req.params;
  try {
     await UsuarioModel.deleteById(id);
    req.flash('success', 'Usuario eliminado');
    res.redirect('/admin/usuarios');
  } catch (error) {
    console.error(error);
    req.flash('error', 'Error al eliminar');
    res.redirect('/admin/usuarios');
  }
};
