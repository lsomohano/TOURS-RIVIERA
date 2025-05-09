-- --------------------------------------------------------
-- Host:                         localhost
-- Versión del servidor:         5.7.44 - MySQL Community Server (GPL)
-- SO del servidor:              Linux
-- HeidiSQL Versión:             12.8.0.6908
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- Volcando estructura para tabla tours.reservas
CREATE TABLE IF NOT EXISTS `reservas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tour_id` int(11) NOT NULL,
  `usuario_id` int(11) DEFAULT NULL,
  `reserva_codigo` varchar(50) DEFAULT NULL,
  `nombre_cliente` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `telefono` varchar(255) DEFAULT NULL,
  `cantidad_personas` int(11) NOT NULL,
  `fecha_reserva` date NOT NULL,
  `estado` enum('pendiente','pagado','cancelado') DEFAULT 'pendiente',
  `metodo_pago` enum('stripe','efectivo','transferencia') DEFAULT 'stripe',
  `stripe_session_id` varchar(255) DEFAULT NULL,
  `costo_unitario` decimal(20,2) DEFAULT NULL,
  `total_pagado` decimal(20,2) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `tour_id` (`tour_id`),
  KEY `usuario_id` (`usuario_id`),
  CONSTRAINT `reservas_ibfk_1` FOREIGN KEY (`tour_id`) REFERENCES `tours` (`id`),
  CONSTRAINT `reservas_ibfk_2` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla tours.reservas: ~3 rows (aproximadamente)
INSERT INTO `reservas` (`id`, `tour_id`, `usuario_id`, `reserva_codigo`, `nombre_cliente`, `email`, `telefono`, `cantidad_personas`, `fecha_reserva`, `estado`, `metodo_pago`, `stripe_session_id`, `costo_unitario`, `total_pagado`, `created_at`, `updated_at`) VALUES
	(1, 1, NULL, NULL, 'Leonel Somohano Carmona', NULL, NULL, 2, '2025-05-10', 'pagado', 'stripe', 'cs_test_a1G6nVT9NDX0wTPZrg1wbgaoguYHloIR8DtSJrGykyRU0W76xdeiap5oja', NULL, NULL, '2025-05-08 04:34:55', '2025-05-08 04:35:42'),
	(2, 2, NULL, NULL, 'Leonel Somohano Carmona', NULL, NULL, 3, '2025-05-16', 'pagado', 'stripe', 'cs_test_a1JQoDFCpRVrqmMztES2iKBMhVlWXsaU73on3npB1Phb6mEqPWOlkenelV', 129.50, 388.50, '2025-05-08 04:58:15', '2025-05-08 04:58:59'),
	(3, 3, NULL, 'RSV-000003', 'Leonel Somohano Carmona', 'lsomohano20@hotmail.com', '9982140871', 4, '2025-05-23', 'pagado', 'stripe', 'cs_test_a15HJshdumG9DAf5ZRbvhIjNR2mdtGUH6HYK5Omm5q7otXTwfSCeWN9aEU', 75.00, 300.00, '2025-05-08 05:17:21', '2025-05-08 05:18:19');

-- Volcando estructura para tabla tours.tours
CREATE TABLE IF NOT EXISTS `tours` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) NOT NULL,
  `descripcion` text,
  `lugar_salida` varchar(255) DEFAULT NULL,
  `lugar_destino` varchar(255) DEFAULT NULL,
  `duracion` int(11) DEFAULT NULL,
  `idioma` varchar(50) DEFAULT 'es',
  `precio` decimal(10,2) NOT NULL,
  `cupo_maximo` int(11) DEFAULT '0',
  `disponible` tinyint(1) DEFAULT '1',
  `imagen_destacada` varchar(255) DEFAULT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL,
  `publicado` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla tours.tours: ~6 rows (aproximadamente)
INSERT INTO `tours` (`id`, `nombre`, `descripcion`, `lugar_salida`, `lugar_destino`, `duracion`, `idioma`, `precio`, `cupo_maximo`, `disponible`, `imagen_destacada`, `fecha_inicio`, `fecha_fin`, `publicado`, `created_at`, `updated_at`) VALUES
	(1, 'Tour a Chichén Itzá', 'Explora una de las siete maravillas del mundo moderno con guía profesional, comida incluida y visita a un cenote.', 'Cancún', 'Chichén Itzá', 10, 'es', 89.99, 40, 1, '/images/chichen.jpg', '2025-06-01', '2025-12-31', 1, '2025-05-08 03:58:46', '2025-05-08 04:01:49'),
	(2, 'Aventura en Xcaret', 'Disfruta un día completo en el parque Xcaret con actividades acuáticas, cultura mexicana y espectáculo nocturno.', 'Playa del Carmen', 'Xcaret', 12, 'es', 129.50, 50, 1, '/images/xcaret.jpg', '2025-06-01', '2025-12-31', 1, '2025-05-08 03:58:46', '2025-05-08 04:01:55'),
	(3, 'Tour de Cenotes Secretos', 'Nada en tres impresionantes cenotes ocultos en la selva maya. Incluye transporte y refrigerios.', 'Tulum', 'Ruta de los Cenotes', 6, 'es', 75.00, 20, 1, '/images/cenotes.jpg', '2025-06-15', '2025-12-15', 1, '2025-05-08 03:58:46', '2025-05-08 04:01:59'),
	(4, 'Chichén Itzá Tour', 'Explore one of the New Seven Wonders of the World with a professional guide, lunch included, and a cenote visit.', 'Cancun', 'Chichén Itzá', 10, 'en', 89.99, 40, 1, '/images/chichen.jpg', '2025-06-01', '2025-12-31', 1, '2025-05-08 03:59:19', '2025-05-08 04:02:06'),
	(5, 'Xcaret Adventure', 'Enjoy a full day at Xcaret Park with water activities, Mexican culture, and a night show.', 'Playa del Carmen', 'Xcaret', 12, 'en', 129.50, 50, 1, '/images/xcaret.jpg', '2025-06-01', '2025-12-31', 1, '2025-05-08 03:59:19', '2025-05-08 04:02:12'),
	(6, 'Secret Cenotes Tour', 'Swim in three stunning hidden cenotes in the Mayan jungle. Includes transportation and snacks.', 'Tulum', 'Cenote Route', 6, 'en', 75.00, 20, 1, '/images/cenotes.jpg', '2025-06-15', '2025-12-15', 1, '2025-05-08 03:59:19', '2025-05-08 04:02:20');

-- Volcando estructura para tabla tours.tour_detalles
CREATE TABLE IF NOT EXISTS `tour_detalles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tour_id` int(11) NOT NULL,
  `duracion` varchar(100) DEFAULT NULL,
  `lenguaje` varchar(100) DEFAULT NULL,
  `incluye` text,
  `no_incluye` text,
  `porque_hacerlo` text,
  `que_esperar` text,
  `recomendaciones` text,
  PRIMARY KEY (`id`),
  KEY `tour_id` (`tour_id`),
  CONSTRAINT `tour_detalles_ibfk_1` FOREIGN KEY (`tour_id`) REFERENCES `tours` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla tours.tour_detalles: ~1 rows (aproximadamente)
INSERT INTO `tour_detalles` (`id`, `tour_id`, `duracion`, `lenguaje`, `incluye`, `no_incluye`, `porque_hacerlo`, `que_esperar`, `recomendaciones`) VALUES
	(1, 1, '6 horas', 'Español, Inglés', 'Transporte, guía certificado, entradas', 'Comidas, propinas', 'Es una experiencia única para conocer la historia maya', 'Explora ruinas, nada en un cenote y disfruta del paisaje', 'Llega 15 minutos antes, lleva bloqueador biodegradable y ropa cómoda');

-- Volcando estructura para tabla tours.tour_fechas_disponibles
CREATE TABLE IF NOT EXISTS `tour_fechas_disponibles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tour_id` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `cupo_maximo` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tour_id` (`tour_id`),
  CONSTRAINT `tour_fechas_disponibles_ibfk_1` FOREIGN KEY (`tour_id`) REFERENCES `tours` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla tours.tour_fechas_disponibles: ~2 rows (aproximadamente)
INSERT INTO `tour_fechas_disponibles` (`id`, `tour_id`, `fecha`, `cupo_maximo`) VALUES
	(1, 1, '2025-05-20', 20),
	(2, 1, '2025-05-21', 15);

-- Volcando estructura para tabla tours.tour_imagenes
CREATE TABLE IF NOT EXISTS `tour_imagenes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tour_id` int(11) NOT NULL,
  `url_imagen` varchar(255) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `orden` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `tour_id` (`tour_id`),
  CONSTRAINT `tour_imagenes_ibfk_1` FOREIGN KEY (`tour_id`) REFERENCES `tours` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla tours.tour_imagenes: ~2 rows (aproximadamente)
INSERT INTO `tour_imagenes` (`id`, `tour_id`, `url_imagen`, `descripcion`, `orden`) VALUES
	(1, 1, 'https://ejemplo.com/img/tour1-1.jpg', 'Vista general del sitio arqueológico', 1),
	(2, 1, 'https://ejemplo.com/img/tour1-2.jpg', 'Cenote para nadar', 2);

-- Volcando estructura para tabla tours.tour_itinerario
CREATE TABLE IF NOT EXISTS `tour_itinerario` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tour_id` int(11) NOT NULL,
  `paso_numero` int(11) DEFAULT NULL,
  `descripcion` text,
  `hora_aprox` time DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tour_id` (`tour_id`),
  CONSTRAINT `tour_itinerario_ibfk_1` FOREIGN KEY (`tour_id`) REFERENCES `tours` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla tours.tour_itinerario: ~4 rows (aproximadamente)
INSERT INTO `tour_itinerario` (`id`, `tour_id`, `paso_numero`, `descripcion`, `hora_aprox`) VALUES
	(1, 1, 1, 'Recogida en el punto de encuentro', '08:00:00'),
	(2, 1, 2, 'Llegada al sitio arqueológico', '09:30:00'),
	(3, 1, 3, 'Tiempo libre para fotos y exploración', '11:00:00'),
	(4, 1, 4, 'Visita al cenote', '12:30:00');

-- Volcando estructura para tabla tours.tour_politicas_cancelacion
CREATE TABLE IF NOT EXISTS `tour_politicas_cancelacion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tour_id` int(11) NOT NULL,
  `politicas` text,
  PRIMARY KEY (`id`),
  KEY `tour_id` (`tour_id`),
  CONSTRAINT `tour_politicas_cancelacion_ibfk_1` FOREIGN KEY (`tour_id`) REFERENCES `tours` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla tours.tour_politicas_cancelacion: ~1 rows (aproximadamente)
INSERT INTO `tour_politicas_cancelacion` (`id`, `tour_id`, `politicas`) VALUES
	(1, 1, 'Cancelación gratuita hasta 24 horas antes del tour. No hay reembolsos después de ese periodo.');

-- Volcando estructura para tabla tours.tour_puntos_encuentro
CREATE TABLE IF NOT EXISTS `tour_puntos_encuentro` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tour_id` int(11) NOT NULL,
  `direccion` text,
  `coordenadas` varchar(100) DEFAULT NULL,
  `hora` time DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tour_id` (`tour_id`),
  CONSTRAINT `tour_puntos_encuentro_ibfk_1` FOREIGN KEY (`tour_id`) REFERENCES `tours` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla tours.tour_puntos_encuentro: ~1 rows (aproximadamente)
INSERT INTO `tour_puntos_encuentro` (`id`, `tour_id`, `direccion`, `coordenadas`, `hora`) VALUES
	(1, 1, 'Parqueadero del hotel Xcaret', '20.6597,-103.3496', '08:00:00');

-- Volcando estructura para tabla tours.tour_recomendaciones
CREATE TABLE IF NOT EXISTS `tour_recomendaciones` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tour_id` int(11) NOT NULL,
  `momento` enum('antes','durante','despues') NOT NULL,
  `recomendacion` text,
  PRIMARY KEY (`id`),
  KEY `tour_id` (`tour_id`),
  CONSTRAINT `tour_recomendaciones_ibfk_1` FOREIGN KEY (`tour_id`) REFERENCES `tours` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla tours.tour_recomendaciones: ~3 rows (aproximadamente)
INSERT INTO `tour_recomendaciones` (`id`, `tour_id`, `momento`, `recomendacion`) VALUES
	(1, 1, 'antes', 'Descansa bien la noche anterior'),
	(2, 1, 'durante', 'Hidrátate constantemente'),
	(3, 1, 'despues', 'Comparte tus fotos en redes sociales y etiqueta al tour');

-- Volcando estructura para tabla tours.usuarios
CREATE TABLE IF NOT EXISTS `usuarios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(20) DEFAULT 'admin',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla tours.usuarios: ~1 rows (aproximadamente)
INSERT INTO `usuarios` (`id`, `username`, `password`, `role`) VALUES
	(1, 'admin', '$2a$10$g1ZrF9XoH4WnAkU3cD4WeeQ6HRKjBqUI9lYpE/BGm5XutjvG/MTzG', 'admin');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
