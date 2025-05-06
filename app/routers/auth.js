// routes/auth.js
const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');

// SIN /admin aquí
router.get('/login', authController.showLogin);
router.post('/login', authController.login);
router.get('/logout', authController.logout);

module.exports = router;