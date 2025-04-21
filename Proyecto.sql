CREATE DATABASE IF NOT EXISTS aeropuerto;
USE aeropuerto;

drop table if exists azafatos cascade;
drop table if exists embarcar cascade;
drop table if exists pasajeros cascade;
drop table if exists piloto cascade;
drop table if exists tiene cascade;
drop table if exists empleados cascade;
drop table if exists vuelos cascade;
drop table if exists lugar cascade;
drop view if exists antigüedad_empleados cascade;
/*
 creamos la tabla principal, le añadimos la llave primaria que es "código",
 y de paso añadimos las claves foráneas siendo estas "código_destino" y "código_origen"
 */
CREATE TABLE vuelos (
    código INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATE NOT NULL,
    numero_vuelo VARCHAR(10) NOT NULL,
    hora_salida TIME NOT NULL,
    hora_llegada TIME NOT NULL,
    tipo ENUM ('Nacional', 'Internacional') NOT NULL,
    código_destino INT NOT NULL,
    código_origen INT NOT NULL
);
/*
  creamos la tabla pasajeros, siendo la llave primaria "dni"
 */
CREATE TABLE pasajeros (
    dni CHAR(9) PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL,
    apellidos VARCHAR (50) NOT NULL,
    teléfono INT(9) NOT NULL,
    mail VARCHAR(35)
);
/*
 Creamos la tabla embarcar siendo una relación entre la tabla "pasajeros" y la tabla "vuelos"
 */
CREATE TABLE embarcar (
    código INT,
    dni CHAR(9)
);
/*
 Añadimos las claves foráneas a la tabla embarcar.
 */
ALTER TABLE embarcar
    ADD CONSTRAINT fk_1
        FOREIGN KEY (código) REFERENCES vuelos(código)
            ON DELETE RESTRICT
            ON UPDATE CASCADE,
    ADD CONSTRAINT fk_2
        FOREIGN KEY (dni) REFERENCES pasajeros(dni)
            ON DELETE CASCADE
            ON UPDATE CASCADE;
/*
 Creamos la tabla empleados con clave primaria "dni"
 */
CREATE TABLE empleados (
    dni CHAR(9) PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL,
    apellidos VARCHAR(50) NOT NULL,
    fecha_contrato DATE NOT NULL,
    salario NUMERIC (7,2) NOT NULL,
    tipo ENUM ('Piloto', 'Azafatos') NOT NULL
);
/*
 Creamos una vista en para empleados para poder ver la antigüedad de un empleado de una forma más fácil.
 */
CREATE VIEW antigüedad_empleados AS
SELECT
    nombre,
    DATE(CURDATE()) - DATE(fecha_contrato) AS antigüedad
FROM
    empleados
WHERE
    fecha_contrato IS NOT NULL;
/*
 Creamos la tabla piloto siendo esta una jerárquica de la tabla empleados
 */
CREATE TABLE piloto (
    dni CHAR(9),
    dni_copiloto CHAR(9),
    numero_vuelos INT NOT NULL
);
/*
 añadimos las claves foráneas a piloto relacionándolo asi con los empleados
 */
ALTER TABLE piloto
    ADD CONSTRAINT fk_3
        FOREIGN KEY (dni) REFERENCES empleados(dni)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    ADD CONSTRAINT fk_4
        FOREIGN KEY (dni_copiloto) REFERENCES empleados(dni)
            ON DELETE CASCADE
            ON UPDATE CASCADE;
/*
 Creamos la tabla azafatos siendo una tabla jerárquica relacionada con empleados
 */
CREATE TABLE azafatos (
    dni CHAR(9),
    sexo ENUM ('H', 'M') NOT NULL,
    edad INT (3) NOT NULL
);
/*
 añadimos las claves foráneas a azafatos relacionándola asi con la tabla empleados
 */
ALTER TABLE azafatos
    ADD CONSTRAINT fk_5
        FOREIGN KEY (dni) REFERENCES empleados(dni)
            ON DELETE CASCADE
            ON UPDATE CASCADE;
/*
 creamos la tabla tiene, que esta relaciona los empleados con el vuelo
 */
CREATE TABLE tiene (
    dni CHAR(9),
    código INT
);
/*
 añadimos las claves foráneas a la tabla tiene relacionando "dni" con empleados y "código"
 con vuelos.
 */
ALTER TABLE tiene
    ADD CONSTRAINT fk_6
        FOREIGN KEY (dni) REFERENCES empleados(dni)
            ON DELETE RESTRICT
            ON UPDATE CASCADE,
    ADD CONSTRAINT fk_7
        FOREIGN KEY (código) REFERENCES vuelos(código)
            ON DELETE RESTRICT
            ON UPDATE CASCADE;
/*
 creamos la tabla lugar a la que añadimos la clave primaria "código"
 */
CREATE TABLE lugar (
    código INT AUTO_INCREMENT PRIMARY KEY,
    numero_pista INT(2) NOT NULL,
    numero_hangar INT(3) NOT NULL,
    localidad VARCHAR(20) NOT NULL,
    pais VARCHAR(20) NOT NULL
);

/*
 le añadimos las claves foráneas a vuelos relacionándola asi con lugar de destino y lugar de origen.
 */
ALTER TABLE vuelos
    ADD CONSTRAINT fk_8
        FOREIGN KEY (código_destino) REFERENCES lugar(código)
            ON DELETE RESTRICT
            ON UPDATE CASCADE,
    ADD CONSTRAINT fk_9
        FOREIGN KEY (código_origen) REFERENCES lugar(código)
            ON DELETE RESTRICT
            ON UPDATE CASCADE;

/* Insercion de datos */
SET FOREIGN_KEY_CHECKS = 0;

-- Tabla "azafatos"
INSERT INTO azafatos (dni, sexo, edad) VALUES ('52115920r', 'M', '96');
INSERT INTO azafatos (dni, sexo, edad) VALUES ('81882867D', 'H', '57');
INSERT INTO azafatos (dni, sexo, edad) VALUES ('91346111b', 'M', '103');
INSERT INTO azafatos (dni, sexo, edad) VALUES ('87333555P', 'M', '14');
INSERT INTO azafatos (dni, sexo, edad) VALUES ('15504831f', 'M', '112');
INSERT INTO azafatos (dni, sexo, edad) VALUES ('00240303F', 'M', '76');
INSERT INTO azafatos (dni, sexo, edad) VALUES ('91346111b', 'M', '0');
INSERT INTO azafatos (dni, sexo, edad) VALUES ('00240303F', 'H', '111');
INSERT INTO azafatos (dni, sexo, edad) VALUES ('00240303F', 'H', '65');
INSERT INTO azafatos (dni, sexo, edad) VALUES ('59982916v', 'H', '113');
INSERT INTO azafatos (dni, sexo, edad) VALUES ('59985226t', 'H', '114');
INSERT INTO azafatos (dni, sexo, edad) VALUES ('91346111b', 'M', '48');
INSERT INTO azafatos (dni, sexo, edad) VALUES ('83583042h', 'M', '45');
INSERT INTO azafatos (dni, sexo, edad) VALUES ('83583042h', 'M', '33');
INSERT INTO azafatos (dni, sexo, edad) VALUES ('81762715z', 'M', '41');

-- Tabla "embarcar"
INSERT INTO embarcar (código, dni) VALUES ('14', '722941118');
INSERT INTO embarcar (código, dni) VALUES ('2', '304663965');
INSERT INTO embarcar (código, dni) VALUES ('4', '811245115');
INSERT INTO embarcar (código, dni) VALUES ('10', '051180198');
INSERT INTO embarcar (código, dni) VALUES ('13', '152144557');
INSERT INTO embarcar (código, dni) VALUES ('3', '626138646');
INSERT INTO embarcar (código, dni) VALUES ('12', '165358280');
INSERT INTO embarcar (código, dni) VALUES ('14', '393296501');
INSERT INTO embarcar (código, dni) VALUES ('9', '722941118');
INSERT INTO embarcar (código, dni) VALUES ('1', '393296501');
INSERT INTO embarcar (código, dni) VALUES ('14', '579677923');
INSERT INTO embarcar (código, dni) VALUES ('2', '811245115');
INSERT INTO embarcar (código, dni) VALUES ('3', '434931569');
INSERT INTO embarcar (código, dni) VALUES ('11', '811245115');
INSERT INTO embarcar (código, dni) VALUES ('13', '626138646');

INSERT INTO empleados (dni, nombre, apellidos, fecha_contrato, salario, tipo) VALUES ('59982916v', 'Ashton', 'Finnan', '2024-06-11 16:57:24', '36908.76', 'Azafatos');
INSERT INTO empleados (dni, nombre, apellidos, fecha_contrato, salario, tipo) VALUES ('59985226t', 'Quincey', 'Edward', '2024-12-30 06:08:53', '53231.31', 'Azafatos');
INSERT INTO empleados (dni, nombre, apellidos, fecha_contrato, salario, tipo) VALUES ('72433676P', 'Lenore', 'Foale', '2024-11-22 04:06:30', '35365.68', 'Azafatos');
INSERT INTO empleados (dni, nombre, apellidos, fecha_contrato, salario, tipo) VALUES ('76200302o', 'El', 'Richarz', '2024-04-13 15:52:02', '43604.40', 'Azafatos');
INSERT INTO empleados (dni, nombre, apellidos, fecha_contrato, salario, tipo) VALUES ('87333555P', 'Babbie', 'Bucktharp', '2024-12-17 08:59:14', '52766.04', 'Piloto');
INSERT INTO empleados (dni, nombre, apellidos, fecha_contrato, salario, tipo) VALUES ('42956087M', 'Yule', 'Keasley', '2024-05-17 23:20:35', '40249.86', 'Piloto');
INSERT INTO empleados (dni, nombre, apellidos, fecha_contrato, salario, tipo) VALUES ('15504831f', 'Elwood', 'Henrys', '2025-01-09 10:30:58', '42888.36', 'Piloto');
INSERT INTO empleados (dni, nombre, apellidos, fecha_contrato, salario, tipo) VALUES ('91346111b', 'Malvina', 'Burden', '2025-01-31 13:30:10', '36096.33', 'Azafatos');
INSERT INTO empleados (dni, nombre, apellidos, fecha_contrato, salario, tipo) VALUES ('54660242S', 'Dorey', 'Saunderson', '2024-11-28 05:37:12', '55106.16', 'Azafatos');
INSERT INTO empleados (dni, nombre, apellidos, fecha_contrato, salario, tipo) VALUES ('81882867D', 'Darline', 'Matfield', '2024-03-12 00:16:32', '50084.28', 'Piloto');
INSERT INTO empleados (dni, nombre, apellidos, fecha_contrato, salario, tipo) VALUES ('00240303F', 'Louisette', 'Maciocia', '2024-11-11 06:49:19', '50019.57', 'Azafatos');
INSERT INTO empleados (dni, nombre, apellidos, fecha_contrato, salario, tipo) VALUES ('83583042h', 'Orren', 'Downe', '2024-10-12 03:19:33', '46709.71', 'Azafatos');
INSERT INTO empleados (dni, nombre, apellidos, fecha_contrato, salario, tipo) VALUES ('52115920r', 'Elwyn', 'Struis', '2025-01-04 23:44:14', '42865.95', 'Piloto');
INSERT INTO empleados (dni, nombre, apellidos, fecha_contrato, salario, tipo) VALUES ('95430294I', 'Duffy', 'Burdis', '2024-02-21 03:47:39', '39318.98', 'Azafatos');
INSERT INTO empleados (dni, nombre, apellidos, fecha_contrato, salario, tipo) VALUES ('81762715z', 'Petr', 'Broggelli', '2025-01-30 05:18:40', '44130.14', 'Azafatos');

INSERT INTO lugar (código, numero_pista, numero_hangar, localidad, pais) VALUES ('1', '23', '229', 'Monte Castro', 'United States');
INSERT INTO lugar (código, numero_pista, numero_hangar, localidad, pais) VALUES ('2', '36', '983', 'Villa Crespo', 'United States');
INSERT INTO lugar (código, numero_pista, numero_hangar, localidad, pais) VALUES ('3', '75', '584', 'San Telmo', 'United States');
INSERT INTO lugar (código, numero_pista, numero_hangar, localidad, pais) VALUES ('4', '76', '86', 'San Telmo', 'United States');
INSERT INTO lugar (código, numero_pista, numero_hangar, localidad, pais) VALUES ('5', '37', '830', 'Parque Patricios', 'United States');
INSERT INTO lugar (código, numero_pista, numero_hangar, localidad, pais) VALUES ('6', '34', '738', 'Centro', 'United States');
INSERT INTO lugar (código, numero_pista, numero_hangar, localidad, pais) VALUES ('7', '92', '78', 'Parque Patricios', 'United States');
INSERT INTO lugar (código, numero_pista, numero_hangar, localidad, pais) VALUES ('8', '77', '758', 'Palermo', 'United States');
INSERT INTO lugar (código, numero_pista, numero_hangar, localidad, pais) VALUES ('9', '0', '764', 'Caballito', 'United States');
INSERT INTO lugar (código, numero_pista, numero_hangar, localidad, pais) VALUES ('10', '96', '404', 'Bella Vista', 'United States');
INSERT INTO lugar (código, numero_pista, numero_hangar, localidad, pais) VALUES ('11', '7', '420', 'Caballito', 'United States');
INSERT INTO lugar (código, numero_pista, numero_hangar, localidad, pais) VALUES ('12', '9', '582', 'Recoleta', 'United States');
INSERT INTO lugar (código, numero_pista, numero_hangar, localidad, pais) VALUES ('13', '82', '556', 'Parque Patricios', 'United States');
INSERT INTO lugar (código, numero_pista, numero_hangar, localidad, pais) VALUES ('14', '79', '126', 'Liniers', 'United States');
INSERT INTO lugar (código, numero_pista, numero_hangar, localidad, pais) VALUES ('15', '45', '351', 'Centro', 'United States');

INSERT INTO pasajeros (dni, nombre, apellidos, teléfono, mail) VALUES ('105238012', 'Griffith', 'Cockrem', '(212) 042-7894', 'griffith.cockrem@gmail.com');
INSERT INTO pasajeros (dni, nombre, apellidos, teléfono, mail) VALUES ('811245115', 'Mattie', 'Boole', '(240) 167-1329', 'mattie.boole@yahoo.com');
INSERT INTO pasajeros (dni, nombre, apellidos, teléfono, mail) VALUES ('660512335', 'Ginger', 'Dunsire', '(865) 931-7497', 'ginger.dunsire@gmail.com');
INSERT INTO pasajeros (dni, nombre, apellidos, teléfono, mail) VALUES ('434931569', 'Donetta', 'Nazair', '(602) 492-8827', 'donetta.nazair@gmail.com');
INSERT INTO pasajeros (dni, nombre, apellidos, teléfono, mail) VALUES ('722941118', 'Ebony', 'Axelbee', '(304) 882-5656', 'ebony.axelbee@hotmail.com');
INSERT INTO pasajeros (dni, nombre, apellidos, teléfono, mail) VALUES ('817683229', 'Jacquelyn', 'Martinuzzi', '(915) 133-1431', 'jacquelyn.martinuzzi@yahoo.com');
INSERT INTO pasajeros (dni, nombre, apellidos, teléfono, mail) VALUES ('579677923', 'Myles', 'Boulstridge', '(661) 735-2745', 'myles.boulstridge@yahoo.com');
INSERT INTO pasajeros (dni, nombre, apellidos, teléfono, mail) VALUES ('393296501', 'Tucker', 'Wilderspoon', '(415) 469-8374', 'tucker.wilderspoon@libero.it');
INSERT INTO pasajeros (dni, nombre, apellidos, teléfono, mail) VALUES ('165358280', 'Patti', 'Fosberry', '(719) 621-6997', 'patti.fosberry@yahoo.com');
INSERT INTO pasajeros (dni, nombre, apellidos, teléfono, mail) VALUES ('152144557', 'Celia', 'Ellery', '(518) 393-4101', 'celia.ellery@hotmail.com');
INSERT INTO pasajeros (dni, nombre, apellidos, teléfono, mail) VALUES ('643499360', 'Delmer', 'Hadland', '(216) 099-2037', 'delmer.hadland@gmail.com');
INSERT INTO pasajeros (dni, nombre, apellidos, teléfono, mail) VALUES ('051180198', 'Nicolai', 'Malter', '(317) 048-9470', 'nicolai.malter@hotmail.com');
INSERT INTO pasajeros (dni, nombre, apellidos, teléfono, mail) VALUES ('626138646', 'Nissy', 'Steventon', '(267) 551-5368', 'nissy.steventon@yahoo.com');
INSERT INTO pasajeros (dni, nombre, apellidos, teléfono, mail) VALUES ('304663965', 'Thedrick', 'Hazell', '(571) 471-8237', 'thedrick.hazell@hotmail.com');
INSERT INTO pasajeros (dni, nombre, apellidos, teléfono, mail) VALUES ('231982248', 'Raff', 'Fantin', '(517) 438-1498', 'raff.fantin@yahoo.com');

-- Tabla "piloto"
INSERT INTO piloto (dni, dni_copiloto, numero_vuelos) VALUES ('15504831f', '42956087M', '23');
INSERT INTO piloto (dni, dni_copiloto, numero_vuelos) VALUES ('59982916v', '72433676P', '405');
INSERT INTO piloto (dni, dni_copiloto, numero_vuelos) VALUES ('76200302o', '72433676P', '3723');
INSERT INTO piloto (dni, dni_copiloto, numero_vuelos) VALUES ('42956087M', '81882867D', '4349');
INSERT INTO piloto (dni, dni_copiloto, numero_vuelos) VALUES ('91346111b', '95430294I', '573');
INSERT INTO piloto (dni, dni_copiloto, numero_vuelos) VALUES ('59982916v', '83583042h', '3068');
INSERT INTO piloto (dni, dni_copiloto, numero_vuelos) VALUES ('87333555P', '76200302o', '1742');
INSERT INTO piloto (dni, dni_copiloto, numero_vuelos) VALUES ('15504831f', '59982916v', '2877');
INSERT INTO piloto (dni, dni_copiloto, numero_vuelos) VALUES ('59982916v', '42956087M', '1455');
INSERT INTO piloto (dni, dni_copiloto, numero_vuelos) VALUES ('52115920r', '59985226t', '2355');
INSERT INTO piloto (dni, dni_copiloto, numero_vuelos) VALUES ('87333555P', '76200302o', '4281');
INSERT INTO piloto (dni, dni_copiloto, numero_vuelos) VALUES ('81762715z', '00240303F', '142');
INSERT INTO piloto (dni, dni_copiloto, numero_vuelos) VALUES ('59985226t', '83583042h', '1269');
INSERT INTO piloto (dni, dni_copiloto, numero_vuelos) VALUES ('59985226t', '15504831f', '1554');
INSERT INTO piloto (dni, dni_copiloto, numero_vuelos) VALUES ('87333555P', '00240303F', '1961');

-- Tabla "tiene"
INSERT INTO tiene (dni, código) VALUES ('42956087M', '6');
INSERT INTO tiene (dni, código) VALUES ('00240303F', '13');
INSERT INTO tiene (dni, código) VALUES ('00240303F', '14');
INSERT INTO tiene (dni, código) VALUES ('81762715z', '13');
INSERT INTO tiene (dni, código) VALUES ('81762715z', '5');
INSERT INTO tiene (dni, código) VALUES ('72433676P', '9');
INSERT INTO tiene (dni, código) VALUES ('54660242S', '8');
INSERT INTO tiene (dni, código) VALUES ('87333555P', '10');
INSERT INTO tiene (dni, código) VALUES ('54660242S', '9');
INSERT INTO tiene (dni, código) VALUES ('87333555P', '9');
INSERT INTO tiene (dni, código) VALUES ('42956087M', '13');
INSERT INTO tiene (dni, código) VALUES ('91346111b', '14');
INSERT INTO tiene (dni, código) VALUES ('76200302o', '10');
INSERT INTO tiene (dni, código) VALUES ('81882867D', '8');
INSERT INTO tiene (dni, código) VALUES ('42956087M', '8');

INSERT INTO vuelos (código, fecha, numero_vuelo, hora_salida, hora_llegada, tipo, código_destino, código_origen) VALUES ('1', '2024-07-25 20:00:59', 'GE4901', '2024-03-08 01:29:56', '2024-03-14 02:33:03', 'Nacional', '13', '8');
INSERT INTO vuelos (código, fecha, numero_vuelo, hora_salida, hora_llegada, tipo, código_destino, código_origen) VALUES ('2', '2024-05-12 11:50:05', 'PT433', '2024-10-28 06:19:01', '2024-11-03 20:08:22', 'Internacional', '8', '15');
INSERT INTO vuelos (código, fecha, numero_vuelo, hora_salida, hora_llegada, tipo, código_destino, código_origen) VALUES ('3', '2024-11-07 18:51:19', 'DF861', '2024-08-01 23:44:51', '2024-08-05 05:35:19', 'Internacional', '3', '8');
INSERT INTO vuelos (código, fecha, numero_vuelo, hora_salida, hora_llegada, tipo, código_destino, código_origen) VALUES ('4', '2024-04-29 10:21:58', 'QO1170', '2024-08-15 18:40:39', '2024-08-25 18:08:48', 'Internacional', '1', '15');
INSERT INTO vuelos (código, fecha, numero_vuelo, hora_salida, hora_llegada, tipo, código_destino, código_origen) VALUES ('5', '2024-02-05 14:36:12', 'ZC1946', '2024-04-27 15:31:45', '2024-05-07 11:46:11', 'Internacional', '1', '10');
INSERT INTO vuelos (código, fecha, numero_vuelo, hora_salida, hora_llegada, tipo, código_destino, código_origen) VALUES ('6', '2024-06-11 00:32:58', 'UX5549', '2024-10-22 10:07:54', '2024-10-28 08:08:54', 'Nacional', '14', '9');
INSERT INTO vuelos (código, fecha, numero_vuelo, hora_salida, hora_llegada, tipo, código_destino, código_origen) VALUES ('7', '2024-03-26 17:08:09', 'VD3799', '2024-10-25 07:40:15', '2024-11-03 08:39:37', 'Nacional', '11', '9');
INSERT INTO vuelos (código, fecha, numero_vuelo, hora_salida, hora_llegada, tipo, código_destino, código_origen) VALUES ('8', '2024-09-17 23:04:49', 'MB0182', '2024-08-12 10:13:30', '2024-08-13 21:30:48', 'Internacional', '1', '5');
INSERT INTO vuelos (código, fecha, numero_vuelo, hora_salida, hora_llegada, tipo, código_destino, código_origen) VALUES ('9', '2024-07-08 06:39:16', 'HL909', '2024-11-19 17:07:58', '2024-11-25 05:52:58', 'Internacional', '7', '5');
INSERT INTO vuelos (código, fecha, numero_vuelo, hora_salida, hora_llegada, tipo, código_destino, código_origen) VALUES ('10', '2025-01-18 09:51:15', 'IU342', '2024-08-10 18:26:48', '2024-08-11 04:47:37', 'Nacional', '15', '10');
INSERT INTO vuelos (código, fecha, numero_vuelo, hora_salida, hora_llegada, tipo, código_destino, código_origen) VALUES ('11', '2024-04-21 10:44:28', 'ZQ6849', '2024-12-11 08:40:50', '2024-12-13 10:49:48', 'Internacional', '11', '5');
INSERT INTO vuelos (código, fecha, numero_vuelo, hora_salida, hora_llegada, tipo, código_destino, código_origen) VALUES ('12', '2024-08-19 03:28:06', 'VK669', '2024-04-29 08:27:58', '2024-04-30 16:10:26', 'Internacional', '10', '8');
INSERT INTO vuelos (código, fecha, numero_vuelo, hora_salida, hora_llegada, tipo, código_destino, código_origen) VALUES ('13', '2025-01-26 02:32:32', 'VH3714', '2024-12-14 02:53:43', '2024-12-21 15:20:47', 'Nacional', '15', '10');
INSERT INTO vuelos (código, fecha, numero_vuelo, hora_salida, hora_llegada, tipo, código_destino, código_origen) VALUES ('14', '2024-10-01 05:09:47', 'WH0902', '2024-09-24 12:11:54', '2024-09-30 19:40:26', 'Nacional', '9', '15');
INSERT INTO vuelos (código, fecha, numero_vuelo, hora_salida, hora_llegada, tipo, código_destino, código_origen) VALUES ('15', '2024-09-30 22:55:44', 'VC534', '2024-12-06 10:32:41', '2024-12-10 17:00:09', 'Nacional', '14', '4');

SET FOREIGN_KEY_CHECKS = 1;