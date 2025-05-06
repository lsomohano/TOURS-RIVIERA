const express = require('express');
const router = express.Router();
const adminController = require('../controllers/adminController');
const { isAdmin } = require('../middlewares/auth');

router.get('/', isAdmin, adminController.dashboard);
router.get('/reservas', isAdmin, adminController.listarReservas);
router.get('/tours', isAdmin, adminController.listarTours);

module.exports = router;