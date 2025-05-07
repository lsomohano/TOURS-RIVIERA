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
  `usuario_id` int(11) NOT NULL,
  `cantidad_personas` int(11) NOT NULL,
  `fecha_reserva` date NOT NULL,
  `estado` enum('pendiente','pagado','cancelado') DEFAULT 'pendiente',
  `metodo_pago` enum('stripe','efectivo','transferencia') DEFAULT 'stripe',
  `stripe_session_id` varchar(255) DEFAULT NULL,
  `total_pagado` decimal(10,2) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `tour_id` (`tour_id`),
  KEY `usuario_id` (`usuario_id`),
  CONSTRAINT `reservas_ibfk_1` FOREIGN KEY (`tour_id`) REFERENCES `tours` (`id`),
  CONSTRAINT `reservas_ibfk_2` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla tours.reservas: ~0 rows (aproximadamente)

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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla tours.tours: ~0 rows (aproximadamente)

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
