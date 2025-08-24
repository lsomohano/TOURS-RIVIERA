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


-- Volcando estructura de base de datos para tours
CREATE DATABASE IF NOT EXISTS `tours` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `tours`;

-- Volcando estructura para función tours.calcular_precio_privado
DELIMITER //
CREATE FUNCTION `calcular_precio_privado`(p_tour_id INT, p_personas INT) RETURNS decimal(10,2)
    DETERMINISTIC
BEGIN
  DECLARE v_precio_base DECIMAL(10,2);
  DECLARE v_incremento_pct DECIMAL(5,2);
  DECLARE v_aplica_desde INT;
  DECLARE v_total DECIMAL(10,2);

  SELECT precio_base, incremento_pct, aplica_desde
  INTO v_precio_base, v_incremento_pct, v_aplica_desde
  FROM tour_precios_privados
  WHERE tour_id = p_tour_id AND activo = TRUE
  ORDER BY personas_max ASC
  LIMIT 1;

  IF p_personas <= v_aplica_desde THEN
    SET v_total = v_precio_base;
  ELSE
    SET v_total = v_precio_base + (v_precio_base * v_incremento_pct / 100 * (p_personas - v_aplica_desde));
  END IF;

  RETURN ROUND(v_total, 2);
END//
DELIMITER ;

-- Volcando estructura para tabla tours.hotels
CREATE TABLE IF NOT EXISTS `hotels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `latitude` decimal(10,7) NOT NULL,
  `longitude` decimal(10,7) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `zone_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `fk_hotels_zones` (`zone_id`),
  CONSTRAINT `fk_hotels_zones` FOREIGN KEY (`zone_id`) REFERENCES `zones` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=265 DEFAULT CHARSET=latin1;

-- La exportación de datos fue deseleccionada.

-- Volcando estructura para tabla tours.reservas
CREATE TABLE IF NOT EXISTS `reservas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tour_id` int(11) NOT NULL,
  `usuario_id` int(11) DEFAULT NULL,
  `reserva_codigo` varchar(50) DEFAULT NULL,
  `token_pago` varchar(255) DEFAULT NULL,
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
  `punto_encuentro` text,
  `peticiones_especiales` text,
  `fecha_vencimiento` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `tour_id` (`tour_id`),
  KEY `usuario_id` (`usuario_id`),
  CONSTRAINT `reservas_ibfk_1` FOREIGN KEY (`tour_id`) REFERENCES `tours` (`id`),
  CONSTRAINT `reservas_ibfk_2` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=latin1;

-- La exportación de datos fue deseleccionada.

-- Volcando estructura para tabla tours.reservas_transportacion
CREATE TABLE IF NOT EXISTS `reservas_transportacion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_cliente` varchar(100) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `fecha_llegada` date DEFAULT NULL,
  `hora_llegada` time DEFAULT NULL,
  `numero_vuelo_llegada` varchar(50) DEFAULT NULL,
  `hotel_destino` varchar(150) DEFAULT NULL,
  `zona_id` int(11) NOT NULL,
  `tipo_servicio_id` int(11) NOT NULL,
  `solo_ida` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_regreso` date DEFAULT NULL,
  `hora_regreso` time DEFAULT NULL,
  `numero_vuelo_regreso` varchar(50) DEFAULT NULL,
  `pasajeros` int(11) DEFAULT '1',
  `total` decimal(10,2) NOT NULL,
  `estado` varchar(50) DEFAULT 'pendiente',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `zona_id` (`zona_id`),
  KEY `tipo_servicio_id` (`tipo_servicio_id`),
  CONSTRAINT `reservas_transportacion_ibfk_1` FOREIGN KEY (`zona_id`) REFERENCES `zonas_transportacion` (`id`),
  CONSTRAINT `reservas_transportacion_ibfk_2` FOREIGN KEY (`tipo_servicio_id`) REFERENCES `tipos_servicio_transportacion` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- La exportación de datos fue deseleccionada.

-- Volcando estructura para tabla tours.tipos_servicio_transportacion
CREATE TABLE IF NOT EXISTS `tipos_servicio_transportacion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `descripcion` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- La exportación de datos fue deseleccionada.

-- Volcando estructura para tabla tours.tours
CREATE TABLE IF NOT EXISTS `tours` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) NOT NULL,
  `descripcion` text,
  `lugar_salida` varchar(255) DEFAULT NULL,
  `lugar_destino` varchar(255) DEFAULT NULL,
  `duracion` int(11) DEFAULT NULL,
  `tipo` enum('aventura','relajacion','cultural') DEFAULT NULL,
  `modalidad` enum('grupo','privado') NOT NULL DEFAULT 'grupo',
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
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;

-- La exportación de datos fue deseleccionada.

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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

-- La exportación de datos fue deseleccionada.

-- Volcando estructura para tabla tours.tour_fechas_disponibles
CREATE TABLE IF NOT EXISTS `tour_fechas_disponibles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tour_id` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `cupo_maximo` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tour_id` (`tour_id`),
  CONSTRAINT `tour_fechas_disponibles_ibfk_1` FOREIGN KEY (`tour_id`) REFERENCES `tours` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;

-- La exportación de datos fue deseleccionada.

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
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=latin1;

-- La exportación de datos fue deseleccionada.

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
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=latin1;

-- La exportación de datos fue deseleccionada.

-- Volcando estructura para tabla tours.tour_politicas_cancelacion
CREATE TABLE IF NOT EXISTS `tour_politicas_cancelacion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tour_id` int(11) NOT NULL,
  `politicas` text,
  PRIMARY KEY (`id`),
  KEY `tour_id` (`tour_id`),
  CONSTRAINT `tour_politicas_cancelacion_ibfk_1` FOREIGN KEY (`tour_id`) REFERENCES `tours` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

-- La exportación de datos fue deseleccionada.

-- Volcando estructura para tabla tours.tour_precios_privados
CREATE TABLE IF NOT EXISTS `tour_precios_privados` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tour_id` int(11) NOT NULL,
  `personas_max` int(11) NOT NULL,
  `precio_base` decimal(10,2) NOT NULL,
  `incremento_pct` decimal(5,2) DEFAULT NULL,
  `aplica_desde` int(11) DEFAULT NULL,
  `activo` tinyint(1) DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `tour_id` (`tour_id`),
  CONSTRAINT `tour_precios_privados_ibfk_1` FOREIGN KEY (`tour_id`) REFERENCES `tours` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

-- La exportación de datos fue deseleccionada.

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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;

-- La exportación de datos fue deseleccionada.

-- Volcando estructura para tabla tours.tour_recomendaciones
CREATE TABLE IF NOT EXISTS `tour_recomendaciones` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tour_id` int(11) NOT NULL,
  `momento` enum('antes','durante','despues') NOT NULL,
  `recomendacion` text,
  PRIMARY KEY (`id`),
  KEY `tour_id` (`tour_id`),
  CONSTRAINT `tour_recomendaciones_ibfk_1` FOREIGN KEY (`tour_id`) REFERENCES `tours` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=latin1;

-- La exportación de datos fue deseleccionada.

-- Volcando estructura para tabla tours.transfer_rates
CREATE TABLE IF NOT EXISTS `transfer_rates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `zone_id` int(11) NOT NULL,
  `vehicle_type_id` int(11) NOT NULL,
  `one_way_price` decimal(10,2) NOT NULL,
  `round_trip_price` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `zone_id` (`zone_id`,`vehicle_type_id`),
  KEY `vehicle_type_id` (`vehicle_type_id`),
  CONSTRAINT `transfer_rates_ibfk_1` FOREIGN KEY (`zone_id`) REFERENCES `zones` (`id`),
  CONSTRAINT `transfer_rates_ibfk_2` FOREIGN KEY (`vehicle_type_id`) REFERENCES `vehicle_types` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;

-- La exportación de datos fue deseleccionada.

-- Volcando estructura para tabla tours.usuarios
CREATE TABLE IF NOT EXISTS `usuarios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `rol` enum('admin','usuario') DEFAULT 'usuario',
  `creado_en` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

-- La exportación de datos fue deseleccionada.

-- Volcando estructura para tabla tours.vehicle_types
CREATE TABLE IF NOT EXISTS `vehicle_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `pax_min` int(11) NOT NULL,
  `pax_max` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

-- La exportación de datos fue deseleccionada.

-- Volcando estructura para tabla tours.zones
CREATE TABLE IF NOT EXISTS `zones` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `imagen` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;

-- La exportación de datos fue deseleccionada.

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
