const express = require('express');
const router = express.Router();
const { requireAdmin } = require('../../middlewares/auth');
const tourController = require('../../controllers/admin/toursController');


router.get('/', requireAdmin, tourController.listarTours);
router.get('/new', tourController.createForm);
router.post('/new', tourController.create);
router.get('/edit/:id', tourController.editForm);
router.post('/edit/:id', tourController.update);

module.exports = router;
