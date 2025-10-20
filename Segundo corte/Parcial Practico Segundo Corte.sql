#drop database TechNova;
CREATE DATABASE TechNova;
USE TechNova;

CREATE TABLE Departamento (
id_departamento INT AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(100) NOT NULL,
presupuesto DECIMAL(12,2) CHECK (presupuesto > 0)
);

CREATE TABLE Empleado (
id_empleado INT AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(100),
cargo VARCHAR(50),
salario DECIMAL(10,2) CHECK (salario > 0),
fecha_ingreso DATE
/*id_departamento INT,
FOREIGN KEY (id_departamento) REFERENCES Departamento(id_departamento)
Esta referencia crea una dependencia circular:

proyecto >-- departamento -< empleado
	|-------< asignacion >-------|
    
Para romper la dependencia circular, se elimina la referencia entre empleado y departamento:
empleado -------< asignacion >------- proyecto >-- departamento 
	
*/
);

CREATE TABLE Proyecto (
id_proyecto INT AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(100),
fecha_inicio DATE,
presupuesto DECIMAL(12,2),
id_departamento INT,
FOREIGN KEY (id_departamento) REFERENCES Departamento(id_departamento)
);

CREATE TABLE Asignacion (
id_asignacion INT AUTO_INCREMENT PRIMARY KEY,
id_empleado INT,
id_proyecto INT,
horas_trabajadas INT CHECK (horas_trabajadas >= 0),
FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado),
FOREIGN KEY (id_proyecto) REFERENCES Proyecto(id_proyecto)
);

INSERT INTO Departamento (nombre, presupuesto) VALUES ("recursos humanos", 500000.00), ("IT", 750000.50), ("ventas", 850000.20);

INSERT INTO Empleado (nombre, cargo, salario, fecha_ingreso) 
VALUES 
("tomas", "tech lead", 3000.00, "2020/07/02"),
("felipe", "sales analyst", 5000.20, "2021/08/23"),
("jaime", "lider rh", 3500.30, "2015/02/15"),
("juan jose", "junior dev", 2500.10, "2023/09/24"),
("angel", "lider publicidad", 4600.20, "2024/03/12");

INSERT INTO Proyecto (nombre, fecha_inicio, presupuesto, id_departamento) 
VALUES ("novaventa", "2025/10/20", 600500.30, 2),("farmago", "2021/03/20", 320500.12, 2),("foodya", "2022/05/20", 530250.30, 3);

INSERT INTO Asignacion (id_empleado, id_proyecto, horas_trabajadas) VALUES (1,1,30),(2,1,40),(3,2,50),(4,2,60),(5,2,70);

#Trigger: BEFORE INSERT en Proyecto que impida registrar el 4.º proyecto
DELIMITER $$
CREATE TRIGGER Proyecto4
BEFORE INSERT ON Proyecto
FOR EACH ROW
BEGIN
	DECLARE n_proyectos INT;
	SELECT COUNT(*) INTO n_proyectos FROM Proyecto WHERE id_departamento = NEW.id_departamento AND CURDATE() >= fecha_inicio;
    IF n_proyectos >= 3 THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El departamento no puede tener mas de 3 proyectos activos...';
    END IF;
END $$
DELIMITER ;
INSERT INTO Proyecto (nombre, fecha_inicio, presupuesto, id_departamento) VALUES ("xxxxxxxx", "2025/10/20", 600500.30, 2);

#Función: ProyectosDepartamento(id_dep)
#drop function ProyectosDepartamento;
DELIMITER $$
CREATE FUNCTION ProyectosDepartamento(
	id_dep INT
)
RETURNS VARCHAR(100)
NOT DETERMINISTIC
BEGIN
	DECLARE v_proyecto VARCHAR(100);
	SELECT CONCAT(nombre," ",fecha_inicio, " ",presupuesto) INTO v_proyecto FROM Proyecto WHERE id_departamento = id_dep LIMIT 1;
    RETURN v_proyecto;
END $$
DELIMITER ;
SELECT ProyectosDepartamento(3);

# Procedimiento: listar departamentos con proyectos límite
DELIMITER $$
CREATE PROCEDURE ProyectosLimite()
BEGIN
	SELECT * FROM Proyecto WHERE CURDATE() >= fecha_inicio;
END $$
DELIMITER ;
CALL ProyectosLimite();

#Transacción: si se inserta un 4.º proyecto → ROLLBACK.
DELIMITER $$
CREATE PROCEDURE Proyecto4Trans(
    IN nom_proy VARCHAR(100),
    IN fecha DATE,
    IN pres DECIMAL(10,2),
    IN id_dep INT
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		ROLLBACK;
		SELECT "No se puede insertar un 4to proyecto en el departamento especificado" as Mensaje;
    END;
    
    START TRANSACTION;
	INSERT INTO Proyecto (nombre, fecha_inicio, presupuesto, id_departamento) VALUES (nom_proy, fecha, pres, id_dep);
    COMMIT;
    SELECT "Proyecto Insertado" as Mensaje;
END$$
DELIMITER ;
CALL Proyecto4Trans("xxxx","");