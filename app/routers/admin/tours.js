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
router.post('/:id/detalles', requireAdmin, tourController.guardarDetalles);

//router.get('/:id/itinerario', requireAdmin, tourController.getItinerario);
router.post('/:id/itinerario', requireAdmin, tourController.crearPasoItinerario);
router.post('/itinerario/:pasoId/update', requireAdmin, tourController.actualizarPasoItinerario);
router.post('/itinerario/:pasoId/delete', requireAdmin, tourController.eliminarPasoItinerario);

router.post("/:id/imagenes/upload", requireAdmin, upload.single("imagen"),tourController.subirImagen);
router.get("/imagenes/:id/delete", requireAdmin, tourController.eliminarImagen);

router.post("/:id/recomendaciones", requireAdmin, tourController.guardarRecomendacion);
router.post("/:id/recomendaciones/:recId/delete", requireAdmin, tourController.eliminarRecomendacion)

router.post('/:id/puntos', requireAdmin, tourController.crear);
router.post('/:id/puntos/:puntoId/delete', requireAdmin, tourController.eliminar);

router.post('/:id/politicas', requireAdmin, tourController.guardarPoliticas);

router.post('/:id/precio-privado', requireAdmin, tourController.guardarPrecioPrivado);

module.exports = router;