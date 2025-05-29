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
  `punto_encuentro` text,
  `peticiones_especiales` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `tour_id` (`tour_id`),
  KEY `usuario_id` (`usuario_id`),
  CONSTRAINT `reservas_ibfk_1` FOREIGN KEY (`tour_id`) REFERENCES `tours` (`id`),
  CONSTRAINT `reservas_ibfk_2` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla tours.reservas: ~13 rows (aproximadamente)
INSERT INTO `reservas` (`id`, `tour_id`, `usuario_id`, `reserva_codigo`, `nombre_cliente`, `email`, `telefono`, `cantidad_personas`, `fecha_reserva`, `estado`, `metodo_pago`, `stripe_session_id`, `costo_unitario`, `total_pagado`, `punto_encuentro`, `peticiones_especiales`, `created_at`, `updated_at`) VALUES
	(1, 1, NULL, NULL, 'Leonel Somohano Carmona', NULL, NULL, 2, '2025-05-10', 'pagado', 'stripe', 'cs_test_a1G6nVT9NDX0wTPZrg1wbgaoguYHloIR8DtSJrGykyRU0W76xdeiap5oja', NULL, NULL, NULL, NULL, '2025-05-08 04:34:55', '2025-05-08 04:35:42'),
	(2, 2, NULL, NULL, 'Leonel Somohano Carmona', NULL, NULL, 3, '2025-05-16', 'pagado', 'stripe', 'cs_test_a1JQoDFCpRVrqmMztES2iKBMhVlWXsaU73on3npB1Phb6mEqPWOlkenelV', 129.50, 388.50, NULL, NULL, '2025-05-08 04:58:15', '2025-05-08 04:58:59'),
	(3, 3, NULL, 'RSV-000003', 'Leonel Somohano Carmona', 'lsomohano20@hotmail.com', '9982140871', 4, '2025-05-23', 'pagado', 'stripe', 'cs_test_a15HJshdumG9DAf5ZRbvhIjNR2mdtGUH6HYK5Omm5q7otXTwfSCeWN9aEU', 75.00, 300.00, NULL, NULL, '2025-05-08 05:17:21', '2025-05-08 05:18:19'),
	(4, 4, NULL, 'RSV-000004', 'Leonel Somohano Carmona', 'lsomohano20@hotmail.com', '9982140871', 3, '2025-05-22', 'pendiente', 'stripe', NULL, 89.99, 269.97, NULL, NULL, '2025-05-10 04:09:05', '2025-05-10 04:09:05'),
	(5, 4, NULL, 'RSV-000005', 'Leonel Somohano Carmona', 'lsomohano20@hotmail.com', '9982140871', 3, '2025-05-22', 'pendiente', 'stripe', NULL, 89.99, 269.97, NULL, NULL, '2025-05-10 04:31:32', '2025-05-10 04:31:32'),
	(6, 4, NULL, 'RSV-000006', 'Leonel Somohano Carmona', 'lsomohano20@hotmail.com', '9982140871', 3, '2025-05-22', 'pendiente', 'stripe', NULL, 89.99, 269.97, NULL, NULL, '2025-05-10 04:35:17', '2025-05-10 04:35:17'),
	(7, 4, NULL, 'RSV-000007', 'Leonel Somohano Carmona', 'lsomohano20@hotmail.com', '9982140871', 3, '2025-05-22', 'pagado', 'stripe', 'cs_test_a1st0ltA1o7hnlwqTeMmBq9cOlwID3kKV74YObgyDLRhYmtR0eGj9KmpVd', 89.99, 269.97, NULL, NULL, '2025-05-10 04:41:35', '2025-05-10 04:43:07'),
	(8, 8, NULL, 'RSV-000008', 'Leonel Somohano Carmona', 'lsomohano@avasa.com.mx', '9982140871', 5, '2025-05-17', 'pagado', 'stripe', 'cs_test_a1rrFDsdhmaqQq6o3rxqD68fWwIkHqjHKZFrawUJUnIKmYgpzwDlworVXz', 1300.00, 6500.00, NULL, NULL, '2025-05-13 12:36:21', '2025-05-13 12:37:56'),
	(9, 8, NULL, 'RSV-000009', 'Leonel Somohano Carmona', 'lsomohano@avasa.com.mx', '9982140871', 6, '2025-05-17', 'pendiente', 'stripe', 'cs_test_a1eGxr9qhVLBJFRaSIWWr56HDZGEekUExBUAPKX9Is3qzWmsFtR2cqfh8J', 1300.00, 7800.00, NULL, NULL, '2025-05-13 12:49:12', '2025-05-13 12:49:13'),
	(10, 8, NULL, 'RSV-000010', 'Leonel Somohano Carmona', 'lsomohano@avasa.com.mx', '9982140871', 4, '2025-05-16', 'pendiente', 'stripe', NULL, 206.50, NULL, 'Hotel Riu Palace Riviera Maya, 9 Y 10 Lote 1 Fase II, Avenida Paseo Xaman-Ha, Playacar Fase 2, Playa del Carmen, Quintana Roo, 77710, México', '', '2025-05-13 13:58:27', '2025-05-13 13:58:27'),
	(11, 8, NULL, 'RSV-000011', 'Leonel Somohano Carmona', 'lsomohano@avasa.com.mx', '9982140871', 4, '2025-05-16', 'pagado', 'stripe', 'cs_test_a1lv6CnhftzmhVzyNn5I90FHjC29B5J1SD7UvSrqp0SVCBLOXCB6TxqWkk', 206.50, 826.00, 'Hotel Riu Palace Riviera Maya, 9 Y 10 Lote 1 Fase II, Avenida Paseo Xaman-Ha, Playacar Fase 2, Playa del Carmen, Quintana Roo, 77710, México', '', '2025-05-13 14:15:22', '2025-05-13 14:16:19'),
	(12, 7, NULL, 'RSV-000012', 'Leonel Somohano Carmona', 'lsomohano@avasa.com.mx', '9982140871', 4, '2025-05-24', 'pagado', 'stripe', 'cs_test_a1fOvi74q2qvEkkpCpwY548WGdopsUbV38gDPDesn2XVEDR9VUivvLDqNP', 210.00, 840.00, 'Hotel Real Zací, Anillo Periférico de Valladolid, Valladolid, Yucatán, 97784, México', '', '2025-05-13 14:19:34', '2025-05-13 14:20:27'),
	(13, 7, NULL, 'RSV-000013', 'Leonel Somohano Carmona', 'lsomohano20@hotmail.com', '9982140871', 5, '2025-05-17', 'pagado', 'stripe', 'cs_test_a1FVzSc0jKyUnW43SImOLPXhkzHvHFznlx3JelBhIUvcZ4ALDLOYuW3qrN', 192.00, 960.00, 'Hotel Riu Palace Mexico, Ha Mz3 Lt4, Avenida Paseo Xaman-Ha, Playacar Fase 2, Playa del Carmen, Quintana Roo, 77710, México', '', '2025-05-13 16:02:35', '2025-05-13 16:05:18'),
	(14, 5, NULL, 'RSV-000014', 'Leonel Somohano Carmona', 'lsomohano@avasa.com.mx', '9982140871', 5, '2025-05-23', 'pendiente', 'transferencia', 'cs_test_a11miyZvaTp1tnKlnEMWvmAy5yLBzvoj9dH9sRm9vS7PzJrQL3PbxarMEb', 129.50, 647.50, 'Hotel Riu Palace Riviera Maya, 9 Y 10 Lote 1 Fase II, Avenida Paseo Xaman-Ha, Playacar Fase 2, Playa del Carmen, Quintana Roo, 77710, México', NULL, '2025-05-14 01:46:06', '2025-05-14 01:46:06'),
	(15, 5, NULL, 'RSV-000015', 'Leonel Somohano Carmona', 'lsomohano@avasa.com.mx', '9982140871', 5, '2025-05-24', 'pendiente', 'efectivo', NULL, 129.50, 647.50, 'Hotel Riu Palace Mexico, Ha Mz3 Lt4, Avenida Paseo Xaman-Ha, Playacar Fase 2, Playa del Carmen, Quintana Roo, 77710, México', NULL, '2025-05-14 02:22:43', '2025-05-14 02:22:43'),
	(16, 4, NULL, 'RSV-000016', 'Leonel Somohano Carmona', 'lsomohano@avasa.com.mx', '9982140871', 2, '2025-05-23', 'pagado', 'stripe', 'cs_test_a1xfaQW35hOaQvY0bxHxrMtccusNEik9tDSqKxifsKsOF4v632SFNdwitV', 1500.00, 3000.00, 'Riu Latino, Boulevard Costa Mujeres, Costa Mujeres, Isla Mujeres, Quintana Roo, 77440, México', NULL, '2025-05-14 03:04:57', '2025-05-14 03:05:28'),
	(17, 7, NULL, 'RSV-000017', 'Leonel Somohano Carmona', 'lsomohano@avasa.com.mx', '9982140871', 5, '2025-05-22', 'pendiente', 'efectivo', NULL, 211.90, 1059.50, 'lkdsfh kdhf isfhsofiahdsaofidshfpoads', '', '2025-05-14 03:38:57', '2025-05-14 03:38:57'),
	(18, 4, NULL, 'RSV-000018', 'Leonel Somohano Carmona', 'lsomohano@avasa.com.mx', '9982140871', 3, '2025-05-24', 'pendiente', 'efectivo', NULL, 1500.00, 4500.00, 'Hotel Riu Palace Peninsula, Km 5,5 Lote 6-C, Boulevard Kukulcán, Distrito 8, Cancún, Benito Juárez, Quintana Roo, 77500, México', NULL, '2025-05-14 04:49:57', '2025-05-14 04:49:57');

-- Volcando estructura para tabla tours.tarifas_transporte
CREATE TABLE IF NOT EXISTS `tarifas_transporte` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `origen` varchar(100) NOT NULL,
  `destino` varchar(100) NOT NULL,
  `tipo_servicio` enum('compartido','privado','privado_redondo') NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  `max_pasajeros` int(11) DEFAULT NULL,
  `activo` tinyint(1) DEFAULT '1',
  `creado_en` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla tours.tarifas_transporte: ~10 rows (aproximadamente)
INSERT INTO `tarifas_transporte` (`id`, `origen`, `destino`, `tipo_servicio`, `precio`, `max_pasajeros`, `activo`, `creado_en`) VALUES
	(1, 'Aeropuerto', 'Cancún Hotel Zone', 'compartido', 15.00, NULL, 1, '2025-05-13 21:45:55'),
	(2, 'Aeropuerto', 'Cancún Hotel Zone', 'privado', 35.00, 4, 1, '2025-05-13 21:45:55'),
	(3, 'Aeropuerto', 'Playa del Carmen', 'privado', 60.00, 4, 1, '2025-05-13 21:45:55'),
	(4, 'Aeropuerto', 'Tulum', 'privado', 100.00, 4, 1, '2025-05-13 21:45:55'),
	(5, 'Aeropuerto', 'Tulum', 'privado_redondo', 180.00, 4, 1, '2025-05-13 21:45:55'),
	(6, 'Aeropuerto', 'Cancún Hotel Zone', 'compartido', 15.00, NULL, 1, '2025-05-13 21:46:01'),
	(7, 'Aeropuerto', 'Cancún Hotel Zone', 'privado', 35.00, 4, 1, '2025-05-13 21:46:01'),
	(8, 'Aeropuerto', 'Playa del Carmen', 'privado', 60.00, 4, 1, '2025-05-13 21:46:01'),
	(9, 'Aeropuerto', 'Tulum', 'privado', 100.00, 4, 1, '2025-05-13 21:46:01'),
	(10, 'Aeropuerto', 'Tulum', 'privado_redondo', 180.00, 4, 1, '2025-05-13 21:46:01');

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

-- Volcando datos para la tabla tours.tours: ~8 rows (aproximadamente)
INSERT INTO `tours` (`id`, `nombre`, `descripcion`, `lugar_salida`, `lugar_destino`, `duracion`, `tipo`, `modalidad`, `idioma`, `precio`, `cupo_maximo`, `disponible`, `imagen_destacada`, `fecha_inicio`, `fecha_fin`, `publicado`, `created_at`, `updated_at`) VALUES
	(1, 'Tour a Chichén Itzá', 'Explora una de las siete maravillas del mundo moderno con guía profesional, comida incluida y visita a un cenote.', 'Cancún', 'Chichén Itzá', 10, 'aventura', 'grupo', 'es', 1450.00, 40, 1, '/images/chichenitza.jpeg', '2025-06-01', '2025-12-31', 1, '2025-05-08 03:58:46', '2025-05-10 21:19:45'),
	(2, 'Aventura en Xcaret', 'Disfruta un día completo en el parque Xcaret con actividades acuáticas, cultura mexicana y espectáculo nocturno.', 'Cancún, Playa del Carmen, Tulum', 'Xcaret', 12, 'aventura', 'grupo', 'es', 129.50, 50, 1, '/images/xcaret.jpg', '2025-06-01', '2025-12-31', 1, '2025-05-08 03:58:46', '2025-05-22 13:38:46'),
	(3, 'Tour de Cenotes Secretos', 'Nada en tres impresionantes cenotes ocultos en la selva maya. Incluye transporte y refrigerios.', 'Tulum', 'Ruta de los Cenotes', 6, 'relajacion', 'grupo', 'es', 850.00, 20, 1, '/uploads/imagen_destacada-1748105928885-664054336.jpg', '2025-06-15', '2025-12-15', 0, '2025-05-08 03:58:46', '2025-05-24 16:58:48'),
	(4, 'Chichén Itzá Tour', 'Explore one of the New Seven Wonders of the World with a professional guide, lunch included, and a cenote visit.', 'Cancun', 'Chichén Itzá', 10, 'aventura', 'grupo', 'en', 1500.00, 40, 1, '/images/chichenitza.jpeg', '2025-06-01', '2025-12-31', 1, '2025-05-08 03:59:19', '2025-05-10 21:19:48'),
	(5, 'Xcaret Adventure', 'Enjoy a full day at Xcaret Park with water activities, Mexican culture, and a night show.', 'Playa del Carmen', 'Xcaret', 12, 'aventura', 'grupo', 'en', 129.50, 50, 1, '/images/xcaret.jpg', '2025-06-01', '2025-12-31', 1, '2025-05-08 03:59:19', '2025-05-10 21:19:39'),
	(6, 'Secret Cenotes Tour', 'Swim in three stunning hidden cenotes in the Mayan jungle. Includes transportation and snacks.', 'Tulum', 'Cenote Route', 6, 'relajacion', 'grupo', 'en', 850.00, 20, 1, '/uploads/imagen_destacada-1748319236687-897403475.jpg', '2025-06-15', '2025-12-15', 1, '2025-05-08 03:59:19', '2025-05-27 04:13:56'),
	(7, 'Tour Privado a Chichén Itzá', 'Experiencia exclusiva para visitar Chichén Itzá con guía privado y transporte cómodo.', 'Hotel del cliente', 'Chichén Itzá', 8, 'cultural', 'privado', 'es', 1200.00, 6, 1, '/images/chichenitza.jpeg', '2025-06-01', '2025-12-31', 1, '2025-05-10 21:52:24', '2025-05-27 04:05:54'),
	(8, 'Aventura Privada en Cenotes', 'Nada en cenotes escondidos con un guía privado y horario flexible.', 'Playa del Carmen', 'Ruta de los Cenotes', 6, 'aventura', 'privado', 'es', 1300.00, 4, 1, '/uploads/imagen_destacada-1748318849957-842832297.jpg', '2025-06-01', '2025-12-31', 1, '2025-05-10 21:52:24', '2025-05-27 04:07:29'),
	(9, 'Motos acuaticas Laguana', 'Motos acuaticas Laguana', 'Cancún', 'Cancún', 2, 'aventura', 'privado', 'es', 1500.00, 2, 1, '/uploads/imagen_destacada-1747920529189-254728545.jpg', '2025-05-19', '2025-05-29', 0, '2025-05-22 04:17:47', '2025-05-22 13:28:49');

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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla tours.tour_detalles: ~3 rows (aproximadamente)
INSERT INTO `tour_detalles` (`id`, `tour_id`, `duracion`, `lenguaje`, `incluye`, `no_incluye`, `porque_hacerlo`, `que_esperar`, `recomendaciones`) VALUES
	(1, 4, '6 horas', 'Español, Inglés', 'Transporte, guía certificado, entradas', 'Comidas, propinas', 'Es una experiencia única para conocer la historia maya', 'Explora ruinas, nada en un cenote y disfruta del paisaje', 'Llega 15 minutos antes, lleva bloqueador biodegradable y ropa cómoda'),
	(2, 7, '8 horas', 'Español', 'Transporte privado, guía especializado, entradas a Chichén Itzá', 'Alimentos y bebidas, propinas', 'Conocer una de las nuevas maravillas del mundo, aprender sobre la historia y la cultura maya.', 'Esperarás un recorrido cómodo y educativo, con tiempo suficiente para explorar cada zona arqueológica.', 'Llevar protector solar, agua, ropa cómoda y zapato cerrado.'),
	(3, 7, '6 horas', 'Español', 'Transporte privado, guía especializado, entrada a los cenotes', 'Alimentos y bebidas, propinas', 'Disfrutarás de la belleza natural de los cenotes, con la posibilidad de nadar en aguas cristalinas.', 'Esperarás un día de aventura, con un recorrido que incluye varias paradas en cenotes únicos.', 'Llevar traje de baño, toalla, protector solar, y sandalias o zapatos acuáticos.'),
	(4, 3, '12hrs', 'Ingles, Español', '<p><strong style="margin: 0px; padding: 0px; color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, Arial, sans-serif; font-size: 14px; text-align: justify;">Lorem Ipsum</strong><span style="color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, Arial, sans-serif; font-size: 14px; text-align: justify;">&nbsp;is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.</span></p>', '<p><strong style="margin: 0px; padding: 0px; color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, Arial, sans-serif; font-size: 14px; text-align: justify;">Lorem Ipsum</strong><span style="color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, Arial, sans-serif; font-size: 14px; text-align: justify;">&nbsp;is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.</span></p>', '<p><strong style="margin: 0px; padding: 0px; color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, Arial, sans-serif; font-size: 14px; text-align: justify;">Lorem Ipsum</strong><span style="color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, Arial, sans-serif; font-size: 14px; text-align: justify;">&nbsp;is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.</span></p>', '<p><strong style="margin: 0px; padding: 0px; color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, Arial, sans-serif; font-size: 14px; text-align: justify;">Lorem Ipsum</strong><span style="color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, Arial, sans-serif; font-size: 14px; text-align: justify;">&nbsp;is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.</span></p>', '<p><strong style="margin: 0px; padding: 0px; color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, Arial, sans-serif; font-size: 14px; text-align: justify;">Lorem Ipsum</strong><span style="color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, Arial, sans-serif; font-size: 14px; text-align: justify;">&nbsp;is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.</span></p>'),
	(5, 6, '12hrs', 'Ingles, Español', '<p><strong style="margin: 0px; padding: 0px; color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, Arial, sans-serif; font-size: 14px; text-align: justify;">Lorem Ipsum</strong><span style="color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, Arial, sans-serif; font-size: 14px; text-align: justify;">&nbsp;is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.</span></p>', '<p><strong style="margin: 0px; padding: 0px; color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, Arial, sans-serif; font-size: 14px; text-align: justify;">Lorem Ipsum</strong><span style="color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, Arial, sans-serif; font-size: 14px; text-align: justify;">&nbsp;is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.</span></p>', '<p><strong style="margin: 0px; padding: 0px; color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, Arial, sans-serif; font-size: 14px; text-align: justify;">Lorem Ipsum</strong><span style="color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, Arial, sans-serif; font-size: 14px; text-align: justify;">&nbsp;is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.</span></p>', '<p><strong style="margin: 0px; padding: 0px; color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, Arial, sans-serif; font-size: 14px; text-align: justify;">Lorem Ipsum</strong><span style="color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, Arial, sans-serif; font-size: 14px; text-align: justify;">&nbsp;is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.</span></p>', '<p><strong style="margin: 0px; padding: 0px; color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, Arial, sans-serif; font-size: 14px; text-align: justify;">Lorem Ipsum</strong><span style="color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, Arial, sans-serif; font-size: 14px; text-align: justify;">&nbsp;is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.</span></p>');

-- Volcando estructura para tabla tours.tour_fechas_disponibles
CREATE TABLE IF NOT EXISTS `tour_fechas_disponibles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tour_id` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `cupo_maximo` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tour_id` (`tour_id`),
  CONSTRAINT `tour_fechas_disponibles_ibfk_1` FOREIGN KEY (`tour_id`) REFERENCES `tours` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla tours.tour_fechas_disponibles: ~8 rows (aproximadamente)
INSERT INTO `tour_fechas_disponibles` (`id`, `tour_id`, `fecha`, `cupo_maximo`) VALUES
	(2, 4, '2025-05-21', 15),
	(3, 7, '2025-06-15', 20),
	(4, 7, '2025-06-20', 15),
	(5, 8, '2025-06-18', 25),
	(6, 8, '2025-06-25', 30),
	(7, 4, '2025-05-27', 10),
	(8, 4, '2025-05-28', 10),
	(9, 4, '2025-05-29', 5),
	(10, 6, '2025-05-31', 8);

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
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla tours.tour_imagenes: ~23 rows (aproximadamente)
INSERT INTO `tour_imagenes` (`id`, `tour_id`, `url_imagen`, `descripcion`, `orden`) VALUES
	(3, 4, '/images/default-tour.jpg', 'Imagen de prueba', 1),
	(6, 7, '/images/chichenitza.jpeg', 'Vista panorámica del tour', 1),
	(7, 7, '/images/cenotes.jpg', 'Aventura en el bosque tropical', 2),
	(8, 7, '/images/parques.jpg', 'Descanso en la playa', 3),
	(9, 7, '/images/piramides.jpg', 'Recorrido por la selva', 4),
	(10, 7, '/images/cenote.jpg', 'Cultura y tradiciones locales', 5),
	(11, 1, '/images/cenotes.jpg', 'Encuentro con fauna exótica', 6),
	(12, 8, '/images/cenote.jpg', 'Aventura en las montañas', 1),
	(13, 8, '/images/default-tour.jpg', 'Exploración en el cañón', 2),
	(14, 8, '/images/piramides.jpg', 'Paseo en bote por el río', 3),
	(15, 8, '/images/cenotes.jpg', 'Visita a una comunidad local', 4),
	(16, 8, '/images/xcaret.jpg', 'Rappel en las cascadas', 5),
	(17, 2, '/images/tour8_imagen6.jpg', 'Caminata nocturna por la selva', 6),
	(18, 3, '/uploads/imagen-1748187997481-392520228.jpg', '', 0),
	(20, 3, '/uploads/imagen-1748190162699-755511509.jpg', '', 0),
	(22, 4, '/uploads/imagen-1748312037419-267851687.jpg', '', 0),
	(23, 4, '/uploads/imagen-1748312055004-150134338.jpg', '', 0),
	(24, 4, '/uploads/imagen-1748312076293-576623671.jpg', '', 0),
	(25, 4, '/uploads/imagen-1748318657224-403322008.jpg', '', 0),
	(26, 6, '/uploads/imagen-1748319371415-914908488.jpg', '', 0),
	(27, 6, '/uploads/imagen-1748319380003-389993003.jpg', '', 0),
	(28, 6, '/uploads/imagen-1748319387091-760280048.jpg', '', 0),
	(29, 6, '/uploads/imagen-1748319396210-221965504.jpg', '', 0),
	(30, 6, '/uploads/imagen-1748319435381-282716596.jpg', '', 0);

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
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla tours.tour_itinerario: ~14 rows (aproximadamente)
INSERT INTO `tour_itinerario` (`id`, `tour_id`, `paso_numero`, `descripcion`, `hora_aprox`) VALUES
	(1, 4, 1, 'Recogida en el punto de encuentro', '08:00:00'),
	(2, 4, 2, 'Llegada al sitio arqueológico', '09:30:00'),
	(3, 4, 3, 'Tiempo libre para fotos y exploración', '11:00:00'),
	(4, 4, 4, 'Visita al cenote', '12:30:00'),
	(5, 7, 1, 'Inicio del tour con una breve introducción en el punto de salida.', '08:00:00'),
	(6, 7, 2, 'Exploración de la selva con guías locales, destacando fauna y flora.', '09:30:00'),
	(7, 7, 3, 'Almuerzo en un sitio con vista panorámica, comida tradicional local.', '12:00:00'),
	(8, 8, 1, 'Encuentro en el punto de salida y breve explicación del itinerario.', '07:30:00'),
	(9, 8, 2, 'Recorrido en bote por el cañón y observación de la fauna local.', '10:00:00'),
	(10, 8, 3, 'Rappel en la cascada, con instrucciones de seguridad antes de la actividad.', '13:00:00'),
	(11, 3, 1, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. ', '08:00:00'),
	(13, 3, 2, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry.', '08:30:00'),
	(15, 3, 3, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. ', '09:00:00'),
	(16, 4, 5, 'Almuerzo - Comidad buffette', '14:00:00'),
	(17, 6, 1, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.', '08:00:00'),
	(18, 6, 2, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.', '08:30:00');

-- Volcando estructura para tabla tours.tour_politicas_cancelacion
CREATE TABLE IF NOT EXISTS `tour_politicas_cancelacion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tour_id` int(11) NOT NULL,
  `politicas` text,
  PRIMARY KEY (`id`),
  KEY `tour_id` (`tour_id`),
  CONSTRAINT `tour_politicas_cancelacion_ibfk_1` FOREIGN KEY (`tour_id`) REFERENCES `tours` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla tours.tour_politicas_cancelacion: ~3 rows (aproximadamente)
INSERT INTO `tour_politicas_cancelacion` (`id`, `tour_id`, `politicas`) VALUES
	(1, 4, 'Cancelación gratuita hasta 24 horas antes del tour. No hay reembolsos después de ese periodo. dddd'),
	(2, 7, 'Cancelación sin cargo hasta 48 horas antes del inicio del tour. Después de ese tiempo, se cobrará un 30% del valor total del tour.'),
	(3, 8, 'Cancelación gratuita hasta 72 horas antes del tour. Si se cancela con menos de 72 horas, se retendrá un 50% del precio total.'),
	(4, 3, 'Prueba, There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don\'t look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn\'t anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc. '),
	(5, 6, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.');

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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla tours.tour_precios_privados: ~2 rows (aproximadamente)
INSERT INTO `tour_precios_privados` (`id`, `tour_id`, `personas_max`, `precio_base`, `incremento_pct`, `aplica_desde`, `activo`, `created_at`, `updated_at`) VALUES
	(1, 7, 10, 650.00, 21.00, 2, 1, '2025-05-11 20:46:16', '2025-05-14 03:21:19'),
	(2, 8, 10, 590.00, 20.00, 2, 1, '2025-05-11 20:46:48', '2025-05-11 20:46:48'),
	(3, 3, 10, 600.00, 25.00, 2, 1, '2025-05-25 20:28:01', '2025-05-25 20:42:46'),
	(4, 4, 10, 600.00, 25.00, 2, 1, '2025-05-27 01:29:41', '2025-05-27 01:29:41'),
	(5, 6, 8, 700.00, 25.00, 2, 1, '2025-05-27 04:18:39', '2025-05-27 04:18:39');

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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla tours.tour_puntos_encuentro: ~3 rows (aproximadamente)
INSERT INTO `tour_puntos_encuentro` (`id`, `tour_id`, `direccion`, `coordenadas`, `hora`) VALUES
	(2, 3, 'Calle 80 MZ26 LT2 ED1 DP402', '21.1952787,-86.8236295', '08:00:00'),
	(3, 3, 'Calle 80 MZ26 LT2 ED1 DP402', '21.1952787,-86.8236295', '09:00:00'),
	(4, 4, 'Malecon las Americas', '21.14635398059483, -86.82137411140395', '08:00:00'),
	(5, 8, 'Malecon las Americas', '21.14635398059483, -86.82137411140395', '09:00:00'),
	(6, 6, 'Malecon las Americas', '21.14635398059483, -86.82137411140395', '08:00:00');

-- Volcando estructura para tabla tours.tour_recomendaciones
CREATE TABLE IF NOT EXISTS `tour_recomendaciones` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tour_id` int(11) NOT NULL,
  `momento` enum('antes','durante','despues') NOT NULL,
  `recomendacion` text,
  PRIMARY KEY (`id`),
  KEY `tour_id` (`tour_id`),
  CONSTRAINT `tour_recomendaciones_ibfk_1` FOREIGN KEY (`tour_id`) REFERENCES `tours` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla tours.tour_recomendaciones: ~36 rows (aproximadamente)
INSERT INTO `tour_recomendaciones` (`id`, `tour_id`, `momento`, `recomendacion`) VALUES
	(1, 4, 'antes', 'Descansa bien la noche anterior'),
	(2, 4, 'durante', 'Hidrátate constantemente'),
	(3, 4, 'despues', 'Comparte tus fotos en redes sociales y etiqueta al tour'),
	(4, 4, 'antes', 'Prepara tu camara para tomar muchas fotos'),
	(5, 4, 'durante', 'No te separes del grupo'),
	(6, 4, 'durante', 'Usa bloqueador solar'),
	(7, 4, 'despues', 'Verifica que no olvidas nada en el transporte'),
	(8, 7, 'antes', 'Llevar ropa cómoda y protector solar.'),
	(9, 7, 'antes', 'Asegúrate de tener tu cámara lista para capturar increíbles momentos.'),
	(10, 7, 'antes', 'Revisa el pronóstico del clima para estar preparado para cualquier cambio.'),
	(11, 7, 'durante', 'Mantente hidratado y sigue las indicaciones de los guías para aprovechar al máximo el recorrido.'),
	(12, 7, 'durante', 'Disfruta del paisaje y no olvides preguntar a los guías sobre la historia del lugar.'),
	(13, 7, 'durante', 'Haz descansos cuando lo necesites y sigue el ritmo del grupo.'),
	(14, 7, 'despues', 'Comparte tus fotos y recuerdos del tour con los demás participantes.'),
	(15, 7, 'despues', 'Deja una reseña para ayudar a mejorar la experiencia para futuros turistas.'),
	(16, 7, 'despues', 'Si tienes algún comentario o sugerencia, no dudes en enviarlo a nuestro equipo de atención al cliente.'),
	(17, 8, 'antes', 'Es recomendable llevar zapatos cómodos y una mochila ligera.'),
	(18, 8, 'antes', 'Revisa los horarios de salida y llega al punto de encuentro con tiempo.'),
	(19, 8, 'antes', 'Te sugerimos llevar una botella de agua y algo de comida ligera.'),
	(20, 8, 'durante', 'Escucha siempre las indicaciones del guía y permanece dentro del grupo.'),
	(21, 8, 'durante', 'Disfruta de la experiencia y aprovecha para aprender sobre la cultura local.'),
	(22, 8, 'durante', 'Si tienes alguna pregunta o inquietud, no dudes en preguntar al guía.'),
	(23, 8, 'despues', '¡No olvides tomar una foto grupal al final del recorrido!'),
	(24, 8, 'despues', 'Te agradecemos por tu participación, esperamos que hayas disfrutado el tour.'),
	(25, 8, 'despues', 'Si te gustó la experiencia, compártela con tus amigos y familiares.'),
	(26, 3, 'antes', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. '),
	(27, 3, 'durante', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. '),
	(28, 3, 'despues', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. '),
	(29, 3, 'antes', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. '),
	(30, 3, 'durante', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. '),
	(31, 4, 'antes', 'vamos a agregar una  de prueba para eliminar,'),
	(32, 6, 'antes', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.'),
	(33, 6, 'antes', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.'),
	(34, 6, 'durante', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.'),
	(35, 6, 'antes', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.'),
	(36, 6, 'despues', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.'),
	(37, 6, 'despues', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.');

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

-- Volcando datos para la tabla tours.usuarios: ~1 rows (aproximadamente)
INSERT INTO `usuarios` (`id`, `nombre`, `email`, `password`, `rol`, `creado_en`) VALUES
	(1, 'Admin Pruebas Mod', 'admin@demo.com', '$2b$10$zN2P6iRWtnLwX6.2iKU6eeQpRz0UIJTK/MCToh9hq5aj0U7OxiFSS', 'admin', '2025-05-16 12:50:03');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
