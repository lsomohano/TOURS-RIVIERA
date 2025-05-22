const express = require('express');
const router = express.Router();
const { requireAdmin } = require('../../middlewares/auth');
const tourController = require('../../controllers/admin/toursController');
const upload = require('../../config/multer');

router.get('/', requireAdmin, tourController.listarTours);
router.get('/new', requireAdmin, tourController.createForm);
router.post('/new', requireAdmin, upload.single('imagen_destacada'), tourController.crear);
router.get('/:id/edit', requireAdmin,tourController.editForm);
router.post('/:id/edit', requireAdmin, upload.single('imagen_destacada'),tourController.update);
//router.post('/new', requireAdmin, upload.single('imagen_destacada'), tourController.crear);



module.exports = router;
