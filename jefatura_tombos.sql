-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 02-12-2024 a las 21:00:05
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `jefatura_tombos`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `calabozoXdelincuente` ()   BEGIN
    SELECT calabozo.codigo_calabozo, calabozo.nombre, delincuente.nombre, delincuente.apellido
    FROM calabozo
    INNER JOIN delincuente ON calabozo.codigo_calabozo = delincuente.delin_codCalabozo
    ORDER BY calabozo.codigo_calabozo ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `casosPolicia` ()   BEGIN
    SELECT 
        policia.documento_policia, 
        policia.nombre, 
        policia.apellido, 
        COUNT(casosxpolicias.cxp_docPolicia) AS "Total casos"
    FROM 
        policia INNER JOIN casosxpolicias on policia.documento_policia = casosxpolicias.cxp_docPolicia
    GROUP BY 
        policia.documento_policia, 
        policia.nombre, 
        policia.apellido;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delincuenteXcaso` ()   BEGIN
    SELECT 
		caso.codigo_caso,caso.descripcion,
        COUNT(casosxdelincuente.cxd_ID_delincuente) AS "Total delincuentes"
    FROM 
        caso INNER JOIN casosxdelincuente on caso.codigo_caso = casosxdelincuente.cxd_codigoCaso
    GROUP BY 
		caso.codigo_caso,caso.descripcion;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `policiaXcaso` ()   BEGIN
    SELECT 
		caso.codigo_caso,caso.descripcion,
        COUNT(casosxpolicias.cxp_docPolicia) AS "Total policias"
    FROM 
        caso INNER JOIN casosxpolicias on caso.codigo_caso = casosxpolicias.cxp_codigoCaso
    GROUP BY 
		caso.codigo_caso,caso.descripcion
    HAVING COUNT(casosxpolicias.cxp_docPolicia)>1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `policiaXjefeXcategoria` ()   BEGIN
    SELECT policia.documento_policia,policia.nombre,policia.apellido,categoria.descripcion AS categoria ,policia.funcion,superior.codigo_superior AS superior,superior.nombre AS jefe
    FROM policia
    INNER JOIN categoria ON policia.pol_codCategoria = categoria.codigo_categoria
    INNER JOIN superior ON policia.pol_codSuperior = superior.codigo_superior;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `arma`
--

CREATE TABLE `arma` (
  `codigo_arma` int(11) NOT NULL,
  `referencia` varchar(30) DEFAULT NULL,
  `descripcion` varchar(100) DEFAULT NULL,
  `arma_codClase` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `arma`
--

INSERT INTO `arma` (`codigo_arma`, `referencia`, `descripcion`, `arma_codClase`) VALUES
(1, 'Glock 17', 'Semiautomatica 9mm', 1),
(2, 'Fusil de asalto M16', 'Calibre 5.56 x45mm', 2),
(3, 'AK 47', 'Calibre 7.62 x 39mm', 2),
(4, 'Heckler & koch MP5', 'Calibre 9x19mm', 3),
(5, 'Remington 870', 'Calibre 12', 4),
(6, 'AWP (Arctic Warfare Police)', 'Calibre .308 Winchester', 5),
(7, 'Taser X26', 'Dispara doble dardo', 6),
(8, 'Spray pimienta', 'Rocia gas pimienta', 7);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `calabozo`
--

CREATE TABLE `calabozo` (
  `codigo_calabozo` int(11) NOT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `ubicacion` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `calabozo`
--

INSERT INTO `calabozo` (`codigo_calabozo`, `nombre`, `ubicacion`) VALUES
(1, 'Mi primera puñalada', 'Samber'),
(2, 'Robo Fallido', 'Cali'),
(3, 'Con las manos en la masa', 'Putumayo'),
(4, 'Casi Fue', 'Bogotá'),
(5, 'Uribe Velez', 'Medellín');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `caso`
--

CREATE TABLE `caso` (
  `codigo_caso` int(11) NOT NULL,
  `descripcion` varchar(100) DEFAULT NULL,
  `caso_codJuzgado` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `caso`
--

INSERT INTO `caso` (`codigo_caso`, `descripcion`, `caso_codJuzgado`) VALUES
(1, 'Violencia Intrafamiliar', 1),
(2, 'Hurto', 2),
(3, 'Robo a mano armada', 3),
(4, 'Lesiones personales', 4),
(5, 'Asesinato', 5),
(6, 'Violación', 6),
(7, 'Fraude electoral', 7);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `casosxdelincuente`
--

CREATE TABLE `casosxdelincuente` (
  `cxd_ID_delincuente` int(11) DEFAULT NULL,
  `cxd_codigoCaso` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `casosxdelincuente`
--

INSERT INTO `casosxdelincuente` (`cxd_ID_delincuente`, `cxd_codigoCaso`) VALUES
(1, 7),
(1, 4),
(1, 3),
(2, 6),
(2, 2),
(3, 5),
(4, 5),
(5, 1),
(5, 5),
(6, 7),
(7, 1),
(7, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `casosxpolicias`
--

CREATE TABLE `casosxpolicias` (
  `cxp_docPolicia` int(11) DEFAULT NULL,
  `cxp_codigoCaso` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `casosxpolicias`
--

INSERT INTO `casosxpolicias` (`cxp_docPolicia`, `cxp_codigoCaso`) VALUES
(1010, 7),
(1010, 5),
(1010, 1),
(1712, 2),
(2278, 3),
(2278, 6),
(5724, 4),
(6354, 4),
(6684, 1),
(6684, 6),
(6684, 3),
(6852, 5),
(7725, 6),
(7836, 1),
(7845, 3),
(7845, 7),
(7845, 2),
(9652, 4),
(9964, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categoria`
--

CREATE TABLE `categoria` (
  `codigo_categoria` int(11) NOT NULL,
  `descripcion` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `categoria`
--

INSERT INTO `categoria` (`codigo_categoria`, `descripcion`) VALUES
(1, 'Patrullero'),
(2, 'Intendente'),
(3, 'Comisario'),
(4, 'Capitan'),
(5, 'Coronel'),
(6, 'Teniente'),
(7, 'Sargento'),
(8, 'Cabo'),
(9, 'Mayor');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clase_arma`
--

CREATE TABLE `clase_arma` (
  `codigo_clase` int(11) NOT NULL,
  `clase` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `clase_arma`
--

INSERT INTO `clase_arma` (`codigo_clase`, `clase`) VALUES
(1, 'Pistola'),
(2, 'Fusil'),
(3, 'Subfusil'),
(4, 'Escopeta'),
(5, 'Francotirador'),
(6, 'Electrochoque'),
(7, 'No letales');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `delincuente`
--

CREATE TABLE `delincuente` (
  `ID_delincuente` int(11) NOT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `apellido` varchar(100) DEFAULT NULL,
  `telefono` varchar(10) DEFAULT NULL,
  `delin_codCalabozo` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `delincuente`
--

INSERT INTO `delincuente` (`ID_delincuente`, `nombre`, `apellido`, `telefono`, `delin_codCalabozo`) VALUES
(1, 'Judas Yonofui', 'Garavito Escobar', '3995556644', 3),
(2, 'Valentina Alejandra', 'Leal Cuervo', '3115558877', 2),
(3, 'Yorfredys Manuel', 'Celestino Mutis', '32224455', 5),
(4, 'Mayerly', 'Romero Incapie', '3556564488', 4),
(5, 'Yurany Mercedes', 'Rosario Tirejas', '3667778899', 1),
(6, 'Pancracio Stiven', 'Benavidez Rojas', '3446668877', 2),
(7, 'Millos Alejandro', 'Costazul Locas', '3556661122', 5);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `juzgado`
--

CREATE TABLE `juzgado` (
  `codigo_juzgado` int(11) NOT NULL,
  `nombreJuez` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `juzgado`
--

INSERT INTO `juzgado` (`codigo_juzgado`, `nombreJuez`) VALUES
(1, 'Judas Aristoteles Gomez gomez'),
(2, 'Elver Aldair Gomez Torba'),
(3, 'Maria Pancracia de Granados'),
(4, 'José Smith Zupelano Perez'),
(5, 'Maria Fredesbinda Morales Bocanegra'),
(6, 'La Roca Martinez Martillo'),
(7, 'Arnulfo Jose Santos Borre');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `policia`
--

CREATE TABLE `policia` (
  `documento_policia` int(11) NOT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `apellido` varchar(100) DEFAULT NULL,
  `funcion` varchar(100) DEFAULT NULL,
  `pol_codCategoria` int(11) DEFAULT NULL,
  `pol_codArma` int(11) DEFAULT NULL,
  `pol_codSuperior` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `policia`
--

INSERT INTO `policia` (`documento_policia`, `nombre`, `apellido`, `funcion`, `pol_codCategoria`, `pol_codArma`, `pol_codSuperior`) VALUES
(1010, 'Eldormido Armando', 'Casas Ruda', 'Vigilante', 1, 6, 4),
(1712, 'Milagros', 'CortaVista Buenavista', 'Recepción', 2, 7, 5),
(2278, 'Giovani Alberto', 'Posada Fuentes', 'Conductor', 3, 7, 6),
(5724, 'Santafe', 'Nowin Cardenal', 'Patrullar', 4, 5, 1),
(6354, 'Dogor Braulio', 'Pachon Rueda', 'Conductor', 5, 4, 2),
(6684, 'Yuyeimi Alejandra', 'Papona Mamoncillo', 'Jefe Bodega', 7, 1, 5),
(6852, 'Emanuel Santiago', 'Abril Muñoz', 'Vigilante', 2, 3, 4),
(7725, 'Pedro Zanahorio', 'Huertas Campos', 'Auxiliar', 6, 3, 3),
(7836, 'Dayana Petrona', 'Detona Sinfuente', 'Explosivos', 2, 7, 7),
(7845, 'Faustino Reinaldo', 'Valderama Diaz', 'Francotirador', 3, 1, 4),
(9652, 'Tirofijo', 'Falla Angulo', 'Francotirador', 3, 8, 6),
(9964, 'Gina Tecachi', 'Six Nine', 'Patrullera', 5, 2, 5);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `superior`
--

CREATE TABLE `superior` (
  `codigo_superior` int(11) NOT NULL,
  `nombre` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `superior`
--

INSERT INTO `superior` (`codigo_superior`, `nombre`) VALUES
(1, 'Cristian Fenereldo Muñe Orozco'),
(2, 'Ruperto Stiven Suarez Moncada'),
(3, 'Joaquin Silvestre Godo Moreno'),
(4, 'Yoximar Yuliana Palmira Hincapie'),
(5, 'Luz Hermencia Bojaca Pelaez'),
(6, 'Yorvis Cleiner Maduro Bolivar'),
(7, 'Ana Bienestarina Delgado Chango');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `arma`
--
ALTER TABLE `arma`
  ADD PRIMARY KEY (`codigo_arma`),
  ADD KEY `arma_codClase` (`arma_codClase`);

--
-- Indices de la tabla `calabozo`
--
ALTER TABLE `calabozo`
  ADD PRIMARY KEY (`codigo_calabozo`);

--
-- Indices de la tabla `caso`
--
ALTER TABLE `caso`
  ADD PRIMARY KEY (`codigo_caso`),
  ADD KEY `caso_codJuzgado` (`caso_codJuzgado`);

--
-- Indices de la tabla `casosxdelincuente`
--
ALTER TABLE `casosxdelincuente`
  ADD KEY `cxd_ID_delincuente` (`cxd_ID_delincuente`),
  ADD KEY `cxd_codigoCaso` (`cxd_codigoCaso`);

--
-- Indices de la tabla `casosxpolicias`
--
ALTER TABLE `casosxpolicias`
  ADD KEY `cxp_docPolicia` (`cxp_docPolicia`),
  ADD KEY `cxp_codigoCaso` (`cxp_codigoCaso`);

--
-- Indices de la tabla `categoria`
--
ALTER TABLE `categoria`
  ADD PRIMARY KEY (`codigo_categoria`);

--
-- Indices de la tabla `clase_arma`
--
ALTER TABLE `clase_arma`
  ADD PRIMARY KEY (`codigo_clase`);

--
-- Indices de la tabla `delincuente`
--
ALTER TABLE `delincuente`
  ADD PRIMARY KEY (`ID_delincuente`),
  ADD KEY `delin_codCalabozo` (`delin_codCalabozo`);

--
-- Indices de la tabla `juzgado`
--
ALTER TABLE `juzgado`
  ADD PRIMARY KEY (`codigo_juzgado`);

--
-- Indices de la tabla `policia`
--
ALTER TABLE `policia`
  ADD PRIMARY KEY (`documento_policia`),
  ADD KEY `pol_codCategoria` (`pol_codCategoria`),
  ADD KEY `pol_codArma` (`pol_codArma`),
  ADD KEY `pol_codSuperior` (`pol_codSuperior`);

--
-- Indices de la tabla `superior`
--
ALTER TABLE `superior`
  ADD PRIMARY KEY (`codigo_superior`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `arma`
--
ALTER TABLE `arma`
  MODIFY `codigo_arma` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `calabozo`
--
ALTER TABLE `calabozo`
  MODIFY `codigo_calabozo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `caso`
--
ALTER TABLE `caso`
  MODIFY `codigo_caso` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `categoria`
--
ALTER TABLE `categoria`
  MODIFY `codigo_categoria` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `clase_arma`
--
ALTER TABLE `clase_arma`
  MODIFY `codigo_clase` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `delincuente`
--
ALTER TABLE `delincuente`
  MODIFY `ID_delincuente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `juzgado`
--
ALTER TABLE `juzgado`
  MODIFY `codigo_juzgado` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `superior`
--
ALTER TABLE `superior`
  MODIFY `codigo_superior` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `arma`
--
ALTER TABLE `arma`
  ADD CONSTRAINT `arma_ibfk_1` FOREIGN KEY (`arma_codClase`) REFERENCES `clase_arma` (`codigo_clase`);

--
-- Filtros para la tabla `caso`
--
ALTER TABLE `caso`
  ADD CONSTRAINT `caso_ibfk_1` FOREIGN KEY (`caso_codJuzgado`) REFERENCES `juzgado` (`codigo_juzgado`);

--
-- Filtros para la tabla `casosxdelincuente`
--
ALTER TABLE `casosxdelincuente`
  ADD CONSTRAINT `casosxdelincuente_ibfk_1` FOREIGN KEY (`cxd_ID_delincuente`) REFERENCES `delincuente` (`ID_delincuente`),
  ADD CONSTRAINT `casosxdelincuente_ibfk_2` FOREIGN KEY (`cxd_codigoCaso`) REFERENCES `caso` (`codigo_caso`);

--
-- Filtros para la tabla `casosxpolicias`
--
ALTER TABLE `casosxpolicias`
  ADD CONSTRAINT `casosxpolicias_ibfk_1` FOREIGN KEY (`cxp_docPolicia`) REFERENCES `policia` (`documento_policia`),
  ADD CONSTRAINT `casosxpolicias_ibfk_2` FOREIGN KEY (`cxp_codigoCaso`) REFERENCES `caso` (`codigo_caso`);

--
-- Filtros para la tabla `delincuente`
--
ALTER TABLE `delincuente`
  ADD CONSTRAINT `delincuente_ibfk_1` FOREIGN KEY (`delin_codCalabozo`) REFERENCES `calabozo` (`codigo_calabozo`);

--
-- Filtros para la tabla `policia`
--
ALTER TABLE `policia`
  ADD CONSTRAINT `policia_ibfk_1` FOREIGN KEY (`pol_codCategoria`) REFERENCES `categoria` (`codigo_categoria`),
  ADD CONSTRAINT `policia_ibfk_2` FOREIGN KEY (`pol_codArma`) REFERENCES `arma` (`codigo_arma`),
  ADD CONSTRAINT `policia_ibfk_3` FOREIGN KEY (`pol_codSuperior`) REFERENCES `superior` (`codigo_superior`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
