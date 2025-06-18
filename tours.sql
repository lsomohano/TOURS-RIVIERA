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
) ENGINE=InnoDB AUTO_INCREMENT=107 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla tours.hotels: ~90 rows (aproximadamente)
INSERT INTO `hotels` (`id`, `name`, `latitude`, `longitude`, `created_at`, `zone_id`) VALUES
	(1, 'Melody Maker Cancun', 21.1128230, -86.7599040, '2025-06-17 12:19:04', 3),
	(2, 'Hotel Kavia Plus Cancun', 21.1605084, -86.8286232, '2025-06-17 12:19:04', 3),
	(3, 'Selina Hotel Cancun Lagoon Zona Hotelera', 21.1341645, -86.7494873, '2025-06-17 12:19:04', 3),
	(4, 'Hotel Riu Cancun', 21.1380282, -86.7487755, '2025-06-17 12:19:04', 3),
	(5, 'Hotel NYX Cancun', 21.1142721, -86.7586579, '2025-06-17 12:19:04', 3),
	(6, 'Omni Cancun Hotel & Villas', 21.0748861, -86.7758040, '2025-06-17 12:19:04', 3),
	(7, 'Hard Rock Hotel Cancun', 21.0894363, -86.7699219, '2025-06-17 12:19:04', 3),
	(8, 'SLS Cancun Hotel & Residences', 21.1669201, -86.8041045, '2025-06-17 12:19:04', 3),
	(9, 'Royal Resort The Royal Cancun', 21.1441010, -86.7839096, '2025-06-17 12:19:04', 3),
	(10, 'Hilton Cancun Mar Caribe All-Inclusive Resort', 21.0717298, -86.7768739, '2025-06-17 12:19:04', 3),
	(11, 'INTERCONTINENTAL PRESIDENTE CANCUN RESORT', 21.1357875, -86.7544262, '2025-06-17 12:19:04', 3),
	(12, 'Now Emerald Cancun', 21.0538088, -86.7819167, '2025-06-17 12:19:04', 3),
	(13, 'Seadust Cancun Family Resort', 21.0687965, -86.7779629, '2025-06-17 12:19:04', 3),
	(14, 'Iberostar Selection Cancun', 21.0673847, -86.7780992, '2025-06-17 12:19:04', 3),
	(15, 'Cancun International Suites', 21.1606746, -86.8281608, '2025-06-17 12:19:04', 3),
	(16, 'Selina Hostel Cancun', 21.1631505, -86.8262359, '2025-06-17 12:19:04', 3),
	(17, 'GAMMA Cancun Centro', 21.1611645, -86.8250484, '2025-06-17 12:19:04', 3),
	(18, 'Hostel Mundo Joven Cancun', 21.1648280, -86.8281531, '2025-06-17 12:19:04', 3),
	(19, 'Ibis Cancun Centro', 21.1436005, -86.8250955, '2025-06-17 12:19:04', 3),
	(20, 'Cancun Allen', 21.1643314, -86.8303614, '2025-06-17 12:19:05', 3),
	(21, 'GR Solaris Cancun', 21.0550820, -86.7816620, '2025-06-17 12:19:05', 3),
	(22, 'Cancun Clipper Club', 21.1344859, -86.7497372, '2025-06-17 12:19:05', 3),
	(23, 'Tulipanes Cancun', 21.0811596, -86.8448611, '2025-06-17 12:19:05', 3),
	(24, 'Dreams Riviera Cancun Resort & Spa', 20.8719893, -86.8674122, '2025-06-17 12:19:05', 3),
	(25, 'Comfort Inn Cancun', 21.0443233, -86.8499517, '2025-06-17 12:19:05', 3),
	(26, 'Marriott Courtyard Cancun Airport', 21.0500846, -86.8507659, '2025-06-17 12:19:05', 3),
	(27, 'Hyatt Ziva Cancun', 21.1358966, -86.7415084, '2025-06-17 12:19:05', 3),
	(28, 'Emporio Cancun', 21.0732025, -86.7764466, '2025-06-17 12:19:05', 3),
	(29, 'Marriott Cancun Resort', 21.0861662, -86.7713399, '2025-06-17 12:19:05', 3),
	(30, 'Hotel Krystal Cancún', 21.1343014, -86.7446827, '2025-06-17 12:19:05', 3),
	(31, 'Kempinski Hotel Cancún', 21.0932322, -86.7682271, '2025-06-17 12:19:05', 3),
	(32, 'Westin Resort Cancun', 21.0393718, -86.7821657, '2025-06-17 12:19:05', 3),
	(33, 'JW Marriott Cancun Resort', 21.0874481, -86.7708391, '2025-06-17 12:19:05', 3),
	(34, 'Gran Oasis Cancun', 21.0778211, -86.7747174, '2025-06-17 12:19:05', 3),
	(35, 'Royal Solaris Cancun', 21.0495678, -86.7824479, '2025-06-17 12:19:05', 3),
	(36, 'Club Regina Cancun', 21.0403875, -86.7822999, '2025-06-17 12:19:05', 3),
	(37, 'Bell Air Cancun', 21.0467442, -86.7827151, '2025-06-17 12:19:05', 3),
	(38, 'Cancun Bay Resort', 21.1495220, -86.7932494, '2025-06-17 12:19:05', 3),
	(39, 'Temptation Resort Spa Cancun', 21.1484808, -86.7922146, '2025-06-17 12:19:05', 3),
	(40, 'Oleo Cancun Playa', 21.0456333, -86.7827814, '2025-06-17 12:19:05', 3),
	(41, 'Club Med Cancun', 21.0359149, -86.7793395, '2025-06-17 12:19:05', 3),
	(42, 'Hyatt Zilara Cancun', 21.1191472, -86.7564783, '2025-06-17 12:19:05', 3),
	(43, 'Cyan cancun', 21.0468190, -86.7829331, '2025-06-17 12:19:05', 3),
	(44, 'Iberostar Selection Coral Cancún', 21.0675339, -86.7784243, '2025-06-17 12:19:05', 3),
	(45, 'Occidental Costa Cancún', 21.1450655, -86.7891542, '2025-06-17 12:19:06', 3),
	(46, 'Krystal Urban Cancún & Beach Club', 21.1502519, -86.8195293, '2025-06-17 12:19:06', 3),
	(47, 'La Quinta by Wyndham Cancún', 21.1519368, -86.8242552, '2025-06-17 12:19:06', 3),
	(48, 'Ambiance Suites Cancún', 21.1510050, -86.8252975, '2025-06-17 12:19:06', 3),
	(49, 'La Villa du Golf à Cancún', 21.1315522, -86.7590136, '2025-06-17 12:19:06', 3),
	(50, 'One Cancún Centro hotel', 21.1350809, -86.8281718, '2025-06-17 12:19:06', 3),
	(51, 'Dreams Vista Cancún Golf & Spa Resort', 21.1773953, -86.8072928, '2025-06-17 12:19:06', 3),
	(52, 'Breathless Riviera Cancun Resort', 20.9017547, -86.8505483, '2025-06-17 12:19:06', 3),
	(53, 'Secrets Riviera Cancun Resort', 20.9004542, -86.8515166, '2025-06-17 12:19:06', 3),
	(54, 'Hilton Cancun', 20.9532088, -86.8362585, '2025-06-17 12:19:06', 3),
	(55, 'All Ritmo Cancún Resort', 21.2018121, -86.8054093, '2025-06-17 12:19:06', 3),
	(59, 'Le Blanc Spa Resort', 21.1252515, -86.7526544, '2025-06-17 12:19:24', 1),
	(60, 'Hotel Riu Palace Costa Mujeres', 21.3015307, -86.8143725, '2025-06-17 12:19:43', 4),
	(61, 'Grand Palladium Costa Mujeres Resort & Spa', 21.2667543, -86.8165490, '2025-06-17 12:19:43', 4),
	(62, 'Hotel Atelier Playa Mujeres', 21.2533848, -86.8118013, '2025-06-17 12:19:43', 4),
	(63, 'ESDUMA LA PERLA HOTEL ISLA MUJERES', 21.2585941, -86.7464248, '2025-06-17 12:20:02', 9),
	(64, 'Isla Mujeres Palace Hotel', 21.2185005, -86.7288315, '2025-06-17 12:20:02', 9),
	(65, 'Ocean Drive Hotel Isla Mujeres', 21.2582106, -86.7475564, '2025-06-17 12:20:02', 9),
	(66, 'WorldMark Isla Mujeres', 21.2364055, -86.7379783, '2025-06-17 12:20:02', 9),
	(67, 'Selina Isla Mujeres', 21.2584654, -86.7478880, '2025-06-17 12:20:02', 9),
	(68, 'Mayan Monkey Isla Mujeres', 21.2162022, -86.7255150, '2025-06-17 12:20:02', 9),
	(71, 'The Beloved Hotel Playa Mujeres', 21.2413215, -86.8051829, '2025-06-17 12:20:02', 9),
	(72, 'Playa la Media Luna Hotel', 21.2606585, -86.7481063, '2025-06-17 12:20:02', 9),
	(73, 'Playa del Carmen Hotel by H&A', 20.6253911, -87.0768048, '2025-06-17 12:20:20', 2),
	(74, 'Residence Inn by Marriott Playa del Carmen', 20.6140514, -87.0978369, '2025-06-17 12:20:20', 2),
	(75, 'Paradisus Playa del Carmen La Perla', 20.6471538, -87.0567122, '2025-06-17 12:20:20', 2),
	(76, 'Villa Flamingos Playa Del Carmen', 20.6549353, -87.0931948, '2025-06-17 12:20:20', 2),
	(77, 'Hostal Kin Hostel Playa Del Carmen', 20.6199564, -87.0937774, '2025-06-17 12:20:20', 2),
	(78, 'aloft Playa del Carmen', 20.6347362, -87.0682647, '2025-06-17 12:20:20', 2),
	(79, 'The Yucatan Playa del Carmen All-Inclusive Resort', 20.6329340, -87.0673638, '2025-06-17 12:20:20', 2),
	(80, 'Hostel Tropico 20º Playa del Carmen', 20.6258087, -87.0797212, '2025-06-17 12:20:20', 2),
	(81, 'HM Playa del Carmen', 20.6315136, -87.0715711, '2025-06-17 12:20:20', 2),
	(82, 'Holiday Inn Express & Suites Playa del Carmen', 20.6305526, -87.0715870, '2025-06-17 12:20:20', 2),
	(83, 'Hilton Playa del Carmen', 20.6296862, -87.0682891, '2025-06-17 12:20:20', 2),
	(84, 'Paradisus Playa del Carmen La Esmeralda', 20.6495021, -87.0544618, '2025-06-17 12:20:20', 2),
	(85, 'Grand Hyatt Playa del Carmen', 20.6306073, -87.0673581, '2025-06-17 12:20:20', 2),
	(86, 'Panama Jack Resorts Gran Porto Playa del Carmen', 20.6287765, -87.0685509, '2025-06-17 12:20:20', 2),
	(87, 'Cocos Cabañas Playa del Carmen Adults Only', 20.6643339, -87.0321169, '2025-06-17 12:20:20', 2),
	(89, 'Hotel Playa Maya', 20.6251202, -87.0723297, '2025-06-17 12:20:20', 2),
	(90, 'PLAYA 38 HOTEL BOUTIQUE', 20.6387062, -87.0695609, '2025-06-17 12:20:20', 2),
	(91, 'Hotel Playa Plaza', 20.6330692, -87.0734030, '2025-06-17 12:20:20', 2),
	(92, 'Soho Playa Hotel', 20.6319215, -87.0695431, '2025-06-17 12:20:21', 2),
	(93, 'Porto Playa Condo Hotel', 20.6289999, -87.0700117, '2025-06-17 12:20:21', 2),
	(94, 'Balam Playa Hôtel', 20.6241566, -87.0765102, '2025-06-17 12:20:21', 2),
	(95, 'Viceroy Riviera Maya', 20.6634792, -87.0320300, '2025-06-17 12:20:21', 2),
	(96, 'Hotel Riu Playacar', 20.6082438, -87.0905538, '2025-06-17 12:20:38', 6),
	(97, 'Hotel Riu Yucatan', 20.6051592, -87.0922350, '2025-06-17 12:20:38', 6),
	(98, 'Sandos Playacar', 20.6056198, -87.0979890, '2025-06-17 12:20:38', 6),
	(99, 'Royal Hideaway Playacar', 20.6087814, -87.0887121, '2025-06-17 12:20:38', 6),
	(100, 'Occidental Allegro Playacar', 20.6095069, -87.0872386, '2025-06-17 12:20:38', 6),
	(101, 'Playacar Palace', 20.6201522, -87.0765331, '2025-06-17 12:20:38', 6),
	(103, 'Excellence Playa Mujeres', 21.2429736, -86.8053606, '2025-06-17 12:51:14', 4),
	(104, 'Secrets Playa Mujeres Resort', 21.2649399, -86.8142599, '2025-06-17 12:57:43', 4),
	(105, 'Majestic Elegance Costa Mujeres', 21.2812124, -86.8178960, '2025-06-17 12:58:24', 4),
	(106, 'Planet Hollywood Cancun', 21.2901517, -86.8182871, '2025-06-17 12:59:15', 4);

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
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla tours.reservas: ~21 rows (aproximadamente)
INSERT INTO `reservas` (`id`, `tour_id`, `usuario_id`, `reserva_codigo`, `token_pago`, `nombre_cliente`, `email`, `telefono`, `cantidad_personas`, `fecha_reserva`, `estado`, `metodo_pago`, `stripe_session_id`, `costo_unitario`, `total_pagado`, `punto_encuentro`, `peticiones_especiales`, `fecha_vencimiento`, `created_at`, `updated_at`) VALUES
	(1, 1, NULL, NULL, NULL, 'Leonel Somohano Carmona', 'lsomohano20@hotmail.com', '9982140871', 2, '2025-05-10', 'cancelado', 'stripe', 'cs_test_a1G6nVT9NDX0wTPZrg1wbgaoguYHloIR8DtSJrGykyRU0W76xdeiap5oja', NULL, NULL, '', '', NULL, '2025-05-08 04:34:55', '2025-05-31 23:03:45'),
	(2, 2, NULL, NULL, NULL, 'Leonel Somohano Carmona', 'lsomohano20@hotmail.com', '9982140871', 3, '2025-05-16', 'cancelado', 'stripe', 'cs_test_a1JQoDFCpRVrqmMztES2iKBMhVlWXsaU73on3npB1Phb6mEqPWOlkenelV', 129.50, 388.50, '', '', NULL, '2025-05-08 04:58:15', '2025-05-31 23:35:03'),
	(3, 3, NULL, 'RSV-000003', NULL, 'Leonel Somohano Carmona', 'lsomohano20@hotmail.com', '9982140871', 4, '2025-05-23', 'cancelado', 'stripe', 'cs_test_a15HJshdumG9DAf5ZRbvhIjNR2mdtGUH6HYK5Omm5q7otXTwfSCeWN9aEU', 75.00, 300.00, '', '', NULL, '2025-05-08 05:17:21', '2025-05-31 23:37:20'),
	(4, 4, NULL, 'RSV-000004', NULL, 'Leonel Somohano Carmona', 'lsomohano20@hotmail.com', '9982140871', 3, '2025-05-22', 'cancelado', 'stripe', NULL, 89.99, 269.97, '', '', NULL, '2025-05-10 04:09:05', '2025-06-01 00:18:56'),
	(5, 4, NULL, 'RSV-000005', NULL, 'Leonel Somohano Carmona', 'lsomohano20@hotmail.com', '9982140871', 3, '2025-05-22', 'pendiente', 'stripe', NULL, 89.99, 269.97, NULL, NULL, NULL, '2025-05-10 04:31:32', '2025-05-10 04:31:32'),
	(6, 4, NULL, 'RSV-000006', NULL, 'Leonel Somohano Carmona', 'lsomohano20@hotmail.com', '9982140871', 3, '2025-05-22', 'pendiente', 'stripe', NULL, 89.99, 269.97, NULL, NULL, NULL, '2025-05-10 04:35:17', '2025-05-10 04:35:17'),
	(7, 4, NULL, 'RSV-000007', NULL, 'Leonel Somohano Carmona', 'lsomohano20@hotmail.com', '9982140871', 3, '2025-05-22', 'pagado', 'stripe', 'cs_test_a1st0ltA1o7hnlwqTeMmBq9cOlwID3kKV74YObgyDLRhYmtR0eGj9KmpVd', 89.99, 269.97, NULL, NULL, NULL, '2025-05-10 04:41:35', '2025-05-10 04:43:07'),
	(8, 8, NULL, 'RSV-000008', NULL, 'Leonel Somohano Carmona', 'lsomohano@avasa.com.mx', '9982140871', 5, '2025-05-17', 'pagado', 'stripe', 'cs_test_a1rrFDsdhmaqQq6o3rxqD68fWwIkHqjHKZFrawUJUnIKmYgpzwDlworVXz', 1300.00, 6500.00, NULL, NULL, NULL, '2025-05-13 12:36:21', '2025-05-13 12:37:56'),
	(9, 8, NULL, 'RSV-000009', NULL, 'Leonel Somohano Carmona', 'lsomohano@avasa.com.mx', '9982140871', 6, '2025-05-17', 'pendiente', 'stripe', 'cs_test_a1eGxr9qhVLBJFRaSIWWr56HDZGEekUExBUAPKX9Is3qzWmsFtR2cqfh8J', 1300.00, 7800.00, NULL, NULL, NULL, '2025-05-13 12:49:12', '2025-05-13 12:49:13'),
	(10, 8, NULL, 'RSV-000010', NULL, 'Leonel Somohano Carmona', 'lsomohano@avasa.com.mx', '9982140871', 4, '2025-05-16', 'pendiente', 'stripe', NULL, 206.50, NULL, 'Hotel Riu Palace Riviera Maya, 9 Y 10 Lote 1 Fase II, Avenida Paseo Xaman-Ha, Playacar Fase 2, Playa del Carmen, Quintana Roo, 77710, México', '', NULL, '2025-05-13 13:58:27', '2025-05-13 13:58:27'),
	(11, 8, NULL, 'RSV-000011', NULL, 'Leonel Somohano Carmona', 'lsomohano@avasa.com.mx', '9982140871', 4, '2025-05-16', 'pagado', 'stripe', 'cs_test_a1lv6CnhftzmhVzyNn5I90FHjC29B5J1SD7UvSrqp0SVCBLOXCB6TxqWkk', 206.50, 826.00, 'Hotel Riu Palace Riviera Maya, 9 Y 10 Lote 1 Fase II, Avenida Paseo Xaman-Ha, Playacar Fase 2, Playa del Carmen, Quintana Roo, 77710, México', '', NULL, '2025-05-13 14:15:22', '2025-05-13 14:16:19'),
	(12, 7, NULL, 'RSV-000012', NULL, 'Leonel Somohano Carmona', 'lsomohano@avasa.com.mx', '9982140871', 4, '2025-05-24', 'pagado', 'stripe', 'cs_test_a1fOvi74q2qvEkkpCpwY548WGdopsUbV38gDPDesn2XVEDR9VUivvLDqNP', 210.00, 840.00, 'Hotel Real Zací, Anillo Periférico de Valladolid, Valladolid, Yucatán, 97784, México', '', NULL, '2025-05-13 14:19:34', '2025-05-13 14:20:27'),
	(13, 7, NULL, 'RSV-000013', NULL, 'Leonel Somohano Carmona', 'lsomohano20@hotmail.com', '9982140871', 5, '2025-05-17', 'pagado', 'stripe', 'cs_test_a1FVzSc0jKyUnW43SImOLPXhkzHvHFznlx3JelBhIUvcZ4ALDLOYuW3qrN', 192.00, 960.00, 'Hotel Riu Palace Mexico, Ha Mz3 Lt4, Avenida Paseo Xaman-Ha, Playacar Fase 2, Playa del Carmen, Quintana Roo, 77710, México', '', NULL, '2025-05-13 16:02:35', '2025-05-13 16:05:18'),
	(14, 5, NULL, 'RSV-000014', NULL, 'Leonel Somohano Carmona', 'lsomohano@avasa.com.mx', '9982140871', 5, '2025-05-23', 'pendiente', 'transferencia', 'cs_test_a11miyZvaTp1tnKlnEMWvmAy5yLBzvoj9dH9sRm9vS7PzJrQL3PbxarMEb', 129.50, 647.50, 'Hotel Riu Palace Riviera Maya, 9 Y 10 Lote 1 Fase II, Avenida Paseo Xaman-Ha, Playacar Fase 2, Playa del Carmen, Quintana Roo, 77710, México', '', NULL, '2025-05-14 01:46:06', '2025-06-01 00:11:39'),
	(15, 5, NULL, 'RSV-000015', NULL, 'Leonel Somohano Carmona', 'lsomohano@avasa.com.mx', '9982140871', 5, '2025-05-24', 'pendiente', 'efectivo', NULL, 129.50, 647.50, 'Hotel Riu Palace Mexico, Ha Mz3 Lt4, Avenida Paseo Xaman-Ha, Playacar Fase 2, Playa del Carmen, Quintana Roo, 77710, México', NULL, NULL, '2025-05-14 02:22:43', '2025-05-14 02:22:43'),
	(16, 4, NULL, 'RSV-000016', NULL, 'Leonel Somohano Carmona', 'lsomohano@avasa.com.mx', '9982140871', 2, '2025-05-23', 'pagado', 'stripe', 'cs_test_a1xfaQW35hOaQvY0bxHxrMtccusNEik9tDSqKxifsKsOF4v632SFNdwitV', 1500.00, 3000.00, 'Riu Latino, Boulevard Costa Mujeres, Costa Mujeres, Isla Mujeres, Quintana Roo, 77440, México', NULL, NULL, '2025-05-14 03:04:57', '2025-05-14 03:05:28'),
	(17, 7, NULL, 'RSV-000017', NULL, 'Leonel Somohano Carmona', 'lsomohano@avasa.com.mx', '9982140871', 5, '2025-05-22', 'pendiente', 'efectivo', NULL, 211.90, 1059.50, 'lkdsfh kdhf isfhsofiahdsaofidshfpoads', '', NULL, '2025-05-14 03:38:57', '2025-05-14 03:38:57'),
	(18, 4, NULL, 'RSV-000018', NULL, 'Leonel Somohano Carmona', 'lsomohano@avasa.com.mx', '9982140871', 3, '2025-05-24', 'pendiente', 'efectivo', NULL, 1500.00, 4500.00, 'Hotel Riu Palace Peninsula, Km 5,5 Lote 6-C, Boulevard Kukulcán, Distrito 8, Cancún, Benito Juárez, Quintana Roo, 77500, México', NULL, NULL, '2025-05-14 04:49:57', '2025-05-14 04:49:57'),
	(19, 5, NULL, NULL, '7f94b1a8da0a773336dffb54a1a86b08', 'Leonel Somohano Carmona', 'lsomohano20@gmail.com', '9982140871', 2, '2025-06-01', 'cancelado', 'stripe', 'cs_test_a1poXLvC5eh9iITIlCkihiHhfAJev5Z8cOsVAWCnjPyUYxKGLkmpGX1tP6', 500.00, 1000.00, 'Hotel Riu Palace Riviera Maya, 9 Y 10 Lote 1 Fase II, Avenida Paseo Xaman-Ha, Playacar Fase 2, Playa del Carmen, Quintana Roo, 77710, México', 'ninguna', NULL, '2025-05-30 13:29:46', '2025-05-31 16:19:10'),
	(20, 6, NULL, NULL, 'd0a1ec697618978cc618c2218c4421d3', 'Leonel Somohano Carmona', 'lsomohano20@hotmail.com', '9982140871', 3, '2025-05-31', 'pagado', 'stripe', 'cs_test_a1B6wChvXssYp9wxK3X6YTANVvYoYjhUAC1hPAxEqKGinHuWlp44DrYFIq', 600.00, 1800.00, 'Hotel Riu Palace Riviera Maya, 9 Y 10 Lote 1 Fase II, Avenida Paseo Xaman-Ha, Playacar Fase 2, Playa del Carmen, Quintana Roo, 77710, México', 'ok', NULL, '2025-05-30 13:57:57', '2025-05-31 15:49:09'),
	(21, 9, NULL, NULL, 'b00e26fa9e726040b46ce28c2725b489', 'Leonel Somohano Carmona', 'lsomohano20@hotmail.com', '9982140871', 1, '2025-06-01', 'pagado', 'stripe', 'cs_test_a1aA44zzQRFMR6sgp61RcYYpcP84it1zUPRDtoxxb7pmoDBHcRKQmeBx98', 1600.00, 1600.00, 'Playa Las Perlas, Distrito 8, Cancún, Benito Juárez, Quintana Roo, México', '', NULL, '2025-06-01 00:28:47', '2025-06-01 00:30:07'),
	(22, 1, NULL, NULL, 'c64f91d81a98e4b9b421ab50171b116e', 'Leonel Somohano Carmona', 'lsomohano20@hotmail.com', '9982140871', 1, '2025-06-04', 'pendiente', 'stripe', NULL, 1600.00, 1600.00, 'Hotel Riu Yucatan, Condominio Playacar, Avenida Paseo Xaman-Ha, Playacar Fase 2, Playa del Carmen, Quintana Roo, 77710, México', '', '2025-05-02 00:53:20', '2025-06-01 00:53:20', '2025-06-01 01:18:30'),
	(23, 2, NULL, 'RSV-000023', NULL, 'Leonel Somohano Carmona', 'lsomohano20@hotmail.com', '9982140871', 2, '2025-05-24', 'pagado', 'stripe', 'cs_test_a1ztec3xHdLC3zOuffJsUDXC4s3Ts2b4j30oE6ANq0DQHPPPflvDjJZlIh', 129.50, 259.00, 'Fiesta Inn Cancún Las Américas, Avenida Bonampak, Supermanzana 6, Distrito 1, Cancún, Benito Juárez, Quintana Roo, 77500, México', NULL, NULL, '2025-06-01 02:48:11', '2025-06-01 02:48:54'),
	(24, 5, NULL, 'RSV-000024', NULL, 'Leonel Somohano Carmona', 'lsomohano20@hotmail.com', '9982140871', 2, '2025-06-08', 'pagado', 'stripe', 'cs_test_a1zXoqhIGBKMxqRF5kQyrB3Y3BshWV8GQspEKrpEX7H5x5WQLPOU5UQqWB', 129.50, 259.00, 'All Ritmo Cancún Resort, Avenida José López Portillo, Distrito 3, Cancún, Benito Juárez, Quintana Roo, 77520, México', NULL, NULL, '2025-06-01 03:25:26', '2025-06-01 03:26:07'),
	(25, 6, NULL, 'RSV-000025', NULL, 'Leonel Somohano Carmona', 'lsomohano20@hotmail.com', '9982140871', 2, '2025-05-30', 'pagado', 'stripe', 'cs_test_a1DyyQqVTuilIcAA9oeOUje6LutSH3SyepHGJraqbC0LEYToqFyJs0GKQc', 850.00, 1700.00, 'Hyatt Zilara Cancun, Boulevard Kukulcán, Distrito 8, Cancún, Benito Juárez, Quintana Roo, 77500, México', NULL, NULL, '2025-06-01 03:33:41', '2025-06-01 03:40:04');

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

-- Volcando datos para la tabla tours.reservas_transportacion: ~0 rows (aproximadamente)

-- Volcando estructura para tabla tours.tipos_servicio_transportacion
CREATE TABLE IF NOT EXISTS `tipos_servicio_transportacion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `descripcion` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla tours.tipos_servicio_transportacion: ~0 rows (aproximadamente)

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
	(9, 'Jet Ski Adventure at Nichupté Lagoon – Cancún', 'Feel the adrenaline rush as you ride a jet ski across the crystal-clear waters of the stunning Nichupté Lagoon! This experience is perfect for thrill-seekers and nature lovers alike, right in the heart of Cancún.\r\n\r\nExplore the mangrove-lined channels, speed across calm waters, and enjoy breathtaking views that combine the wild side of the lagoon with the modern skyline of the Hotel Zone. Whether solo or with a partner, it’s an unforgettable ride.', 'Cancún', 'Cancún', 1, 'aventura', 'privado', 'en', 1500.00, 2, 1, '/uploads/imagen_destacada-1748722897173-51029250.jpg', '2025-05-19', '2025-05-29', 0, '2025-05-22 04:17:47', '2025-05-31 20:21:37');

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

-- Volcando datos para la tabla tours.tour_detalles: ~3 rows (aproximadamente)
INSERT INTO `tour_detalles` (`id`, `tour_id`, `duracion`, `lenguaje`, `incluye`, `no_incluye`, `porque_hacerlo`, `que_esperar`, `recomendaciones`) VALUES
	(1, 4, '6 horas', 'Español, Inglés', 'Transporte, guía certificado, entradas', 'Comidas, propinas', 'Es una experiencia única para conocer la historia maya', 'Explora ruinas, nada en un cenote y disfruta del paisaje', 'Llega 15 minutos antes, lleva bloqueador biodegradable y ropa cómoda'),
	(2, 7, '8 horas', 'Español', 'Transporte privado, guía especializado, entradas a Chichén Itzá', 'Alimentos y bebidas, propinas', 'Conocer una de las nuevas maravillas del mundo, aprender sobre la historia y la cultura maya.', 'Esperarás un recorrido cómodo y educativo, con tiempo suficiente para explorar cada zona arqueológica.', 'Llevar protector solar, agua, ropa cómoda y zapato cerrado.'),
	(3, 7, '6 horas', 'Español', 'Transporte privado, guía especializado, entrada a los cenotes', 'Alimentos y bebidas, propinas', 'Disfrutarás de la belleza natural de los cenotes, con la posibilidad de nadar en aguas cristalinas.', 'Esperarás un día de aventura, con un recorrido que incluye varias paradas en cenotes únicos.', 'Llevar traje de baño, toalla, protector solar, y sandalias o zapatos acuáticos.'),
	(4, 3, '12hrs', 'Ingles, Español', '<p><strong style="margin: 0px; padding: 0px; color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, Arial, sans-serif; font-size: 14px; text-align: justify;">Lorem Ipsum</strong><span style="color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, Arial, sans-serif; font-size: 14px; text-align: justify;">&nbsp;is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.</span></p>', '<p><strong style="margin: 0px; padding: 0px; color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, Arial, sans-serif; font-size: 14px; text-align: justify;">Lorem Ipsum</strong><span style="color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, Arial, sans-serif; font-size: 14px; text-align: justify;">&nbsp;is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.</span></p>', '<p><strong style="margin: 0px; padding: 0px; color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, Arial, sans-serif; font-size: 14px; text-align: justify;">Lorem Ipsum</strong><span style="color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, Arial, sans-serif; font-size: 14px; text-align: justify;">&nbsp;is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.</span></p>', '<p><strong style="margin: 0px; padding: 0px; color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, Arial, sans-serif; font-size: 14px; text-align: justify;">Lorem Ipsum</strong><span style="color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, Arial, sans-serif; font-size: 14px; text-align: justify;">&nbsp;is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.</span></p>', '<p><strong style="margin: 0px; padding: 0px; color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, Arial, sans-serif; font-size: 14px; text-align: justify;">Lorem Ipsum</strong><span style="color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, Arial, sans-serif; font-size: 14px; text-align: justify;">&nbsp;is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.</span></p>'),
	(5, 6, '12hrs', 'Ingles, Español', '<p><strong style="margin: 0px; padding: 0px; color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, Arial, sans-serif; font-size: 14px; text-align: justify;">Lorem Ipsum</strong><span style="color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, Arial, sans-serif; font-size: 14px; text-align: justify;">&nbsp;is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.</span></p>', '<p><strong style="margin: 0px; padding: 0px; color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, Arial, sans-serif; font-size: 14px; text-align: justify;">Lorem Ipsum</strong><span style="color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, Arial, sans-serif; font-size: 14px; text-align: justify;">&nbsp;is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.</span></p>', '<p><strong style="margin: 0px; padding: 0px; color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, Arial, sans-serif; font-size: 14px; text-align: justify;">Lorem Ipsum</strong><span style="color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, Arial, sans-serif; font-size: 14px; text-align: justify;">&nbsp;is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.</span></p>', '<p><strong style="margin: 0px; padding: 0px; color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, Arial, sans-serif; font-size: 14px; text-align: justify;">Lorem Ipsum</strong><span style="color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, Arial, sans-serif; font-size: 14px; text-align: justify;">&nbsp;is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.</span></p>', '<p><strong style="margin: 0px; padding: 0px; color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, Arial, sans-serif; font-size: 14px; text-align: justify;">Lorem Ipsum</strong><span style="color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, Arial, sans-serif; font-size: 14px; text-align: justify;">&nbsp;is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.</span></p>'),
	(6, 9, '1hr', 'Ingles, Español', 'Jet ski for 1 or 2 people (depending on the option chosen).\r\nSafety briefing and equipment (life jacket).\r\nProfessional guide and support throughout the activity.\r\nFree time to ride and take photos.', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.');

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
	(10, 6, '2025-05-31', 8),
	(11, 9, '2025-06-01', 2);

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

-- Volcando datos para la tabla tours.tour_imagenes: ~28 rows (aproximadamente)
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
	(30, 6, '/uploads/imagen-1748319435381-282716596.jpg', '', 0),
	(31, 9, '/uploads/imagen-1748721521644-826728957.jpg', '', 0),
	(32, 9, '/uploads/imagen-1748721540862-164085336.jpg', '', 0),
	(33, 9, '/uploads/imagen-1748721548707-82520953.jpg', '', 0),
	(34, 9, '/uploads/imagen-1748721592596-550310934.webp', '', 0),
	(35, 9, '/uploads/imagen-1748721604910-881923731.webp', '', 0);

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

-- Volcando datos para la tabla tours.tour_itinerario: ~19 rows (aproximadamente)
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
	(18, 6, 2, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.', '08:30:00'),
	(22, 9, 1, 'Check-in and instructions', '08:00:00'),
	(23, 9, 2, 'Beginning of the tour', '08:30:00'),
	(24, 9, 3, 'Drop-off at the same location', '10:00:00');

-- Volcando estructura para tabla tours.tour_politicas_cancelacion
CREATE TABLE IF NOT EXISTS `tour_politicas_cancelacion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tour_id` int(11) NOT NULL,
  `politicas` text,
  PRIMARY KEY (`id`),
  KEY `tour_id` (`tour_id`),
  CONSTRAINT `tour_politicas_cancelacion_ibfk_1` FOREIGN KEY (`tour_id`) REFERENCES `tours` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla tours.tour_politicas_cancelacion: ~3 rows (aproximadamente)
INSERT INTO `tour_politicas_cancelacion` (`id`, `tour_id`, `politicas`) VALUES
	(1, 4, 'Cancelación gratuita hasta 24 horas antes del tour. No hay reembolsos después de ese periodo. dddd'),
	(2, 7, 'Cancelación sin cargo hasta 48 horas antes del inicio del tour. Después de ese tiempo, se cobrará un 30% del valor total del tour.'),
	(3, 8, 'Cancelación gratuita hasta 72 horas antes del tour. Si se cancela con menos de 72 horas, se retendrá un 50% del precio total.'),
	(4, 3, 'Prueba, There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don\'t look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn\'t anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc. '),
	(5, 6, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.'),
	(6, 9, 'We understand that plans can change, and we aim to be as flexible as possible. Please review our cancellation terms before booking:\r\n\r\nFree cancellation up to 24 hours before the start of the activity.\r\n\r\nCancellations made less than 24 hours before the scheduled time will incur a 50% cancellation fee.\r\n\r\nNo-shows or cancellations within 4 hours of the activity will be charged 100% of the total amount.\r\n\r\nIn case of bad weather or safety concerns, the tour may be rescheduled or fully refunded.\r\n\r\nChanges to your reservation are subject to availability and must be requested at least 24 hours in advance.\r\n\r\nTo cancel or reschedule, please contact us at:');

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

-- Volcando datos para la tabla tours.tour_precios_privados: ~2 rows (aproximadamente)
INSERT INTO `tour_precios_privados` (`id`, `tour_id`, `personas_max`, `precio_base`, `incremento_pct`, `aplica_desde`, `activo`, `created_at`, `updated_at`) VALUES
	(1, 7, 10, 650.00, 21.00, 2, 1, '2025-05-11 20:46:16', '2025-05-14 03:21:19'),
	(2, 8, 10, 590.00, 20.00, 2, 1, '2025-05-11 20:46:48', '2025-05-11 20:46:48'),
	(3, 3, 10, 600.00, 25.00, 2, 1, '2025-05-25 20:28:01', '2025-05-25 20:42:46'),
	(4, 4, 10, 600.00, 25.00, 2, 1, '2025-05-27 01:29:41', '2025-05-27 01:29:41'),
	(5, 6, 8, 700.00, 25.00, 2, 1, '2025-05-27 04:18:39', '2025-05-27 04:18:39'),
	(6, 9, 2, 1600.00, 25.00, 2, 1, '2025-05-31 20:01:15', '2025-05-31 20:01:15');

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

-- Volcando datos para la tabla tours.tour_puntos_encuentro: ~3 rows (aproximadamente)
INSERT INTO `tour_puntos_encuentro` (`id`, `tour_id`, `direccion`, `coordenadas`, `hora`) VALUES
	(2, 3, 'Calle 80 MZ26 LT2 ED1 DP402', '21.1952787,-86.8236295', '08:00:00'),
	(3, 3, 'Calle 80 MZ26 LT2 ED1 DP402', '21.1952787,-86.8236295', '09:00:00'),
	(4, 4, 'Malecon las Americas', '21.14635398059483, -86.82137411140395', '08:00:00'),
	(5, 8, 'Malecon las Americas', '21.14635398059483, -86.82137411140395', '09:00:00'),
	(6, 6, 'Malecon las Americas', '21.14635398059483, -86.82137411140395', '08:00:00'),
	(7, 9, 'Playa Las Perlas, Blvd. Kukulcan km. 2.0, Kukulcan Boulevard, Zona Hotelera, 77500 Cancún, Q.R.', '21.1569919,-86.8010237', '08:00:00');

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
	(37, 6, 'despues', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.'),
	(38, 9, 'antes', 'Bring swimsuit, towel, and biodegradable sunscreen'),
	(39, 9, 'durante', 'Not allowed under the influence of alcohol or drugs'),
	(40, 9, 'antes', 'Minimum age to drive: 18 years'),
	(41, 9, 'antes', 'Passengers from 10 years old (check restrictions)');

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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla tours.transfer_rates: ~4 rows (aproximadamente)
INSERT INTO `transfer_rates` (`id`, `zone_id`, `vehicle_type_id`, `one_way_price`, `round_trip_price`) VALUES
	(1, 2, 1, 63.00, 106.00),
	(2, 2, 2, 70.00, 126.00),
	(3, 2, 3, 89.00, 133.00),
	(4, 2, 4, 123.00, 220.00),
	(5, 3, 1, 53.00, 98.00),
	(6, 3, 2, 68.00, 112.00);

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

-- Volcando estructura para tabla tours.vehicle_types
CREATE TABLE IF NOT EXISTS `vehicle_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `pax_min` int(11) NOT NULL,
  `pax_max` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla tours.vehicle_types: ~4 rows (aproximadamente)
INSERT INTO `vehicle_types` (`id`, `name`, `pax_min`, `pax_max`) VALUES
	(1, 'Estandar', 1, 3),
	(2, 'Estandar', 4, 7),
	(3, 'Estandar', 8, 10),
	(4, 'Deluxe', 1, 6);

-- Volcando estructura para tabla tours.zones
CREATE TABLE IF NOT EXISTS `zones` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla tours.zones: ~9 rows (aproximadamente)
INSERT INTO `zones` (`id`, `name`, `created_at`) VALUES
	(1, 'Cancun Zona Hotelera', '2025-06-15 00:44:04'),
	(2, 'Playa del Carmen', '2025-06-15 00:44:22'),
	(3, 'Cancun', '2025-06-15 00:44:51'),
	(4, 'Costa Mujeres', '2025-06-15 00:45:02'),
	(5, 'Puerto Morelos', '2025-06-15 00:45:47'),
	(6, 'Playacar', '2025-06-15 00:46:02'),
	(7, 'Tulum', '2025-06-15 00:47:52'),
	(8, 'Tulum Zona Hotelera', '2025-06-15 00:48:13'),
	(9, 'Isla Mujeres', '2025-06-16 08:37:06');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
