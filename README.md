# BD-3T-BDOR-Oracle
Bases de Datos Objeto-Relacionales
1. Introducción
Las bases de datos objeto-relacionales (BDOR) son una evolución de las bases de datos relacionales tradicionales.
Su objetivo es combinar:

el modelo relacional clásico (tablas, filas y columnas)
con conceptos de programación orientada a objetos (POO).
Oracle permite trabajar con:

objetos,
herencia,
métodos,
constructores,
colecciones,
polimorfismo,
etc.
Esto hace posible representar estructuras más complejas y cercanas al mundo real.

¿Por qué surgieron las BDOR?
En aplicaciones desarrolladas en Java, C# o C++, normalmente trabajamos con objetos:

Cliente
Pedido
Producto
Empleado
Sin embargo, las bases de datos tradicionales almacenan:

tablas,
filas,
columnas.
Las BDOR intentan reducir esa diferencia permitiendo almacenar y manipular objetos directamente dentro de Oracle.

Aunque hoy en día lo más habitual es usar:

bases de datos relacionales clásicas
junto con ORM como Hibernate/JPA (lo veremos en 2º curso)
Oracle sigue soportando programación orientada a objetos dentro de la base de datos.

Objetivos de esta práctica
Con esta práctica aprenderemos:

qué es un tipo objeto,
cómo crear objetos en Oracle,
cómo usar herencia,
cómo definir métodos,
cómo crear tablas de objetos,
cómo insertar y consultar objetos
2. Conceptos básicos de BDOR
Tipo objeto
Es parecido a una clase en Java.

Contiene:

atributos → datos
métodos → comportamiento
Ejemplo conceptual:

Persona
 ├── nombre
 ├── apellidos
 └── calcularEdad()
Herencia
Permite crear subtipos a partir de un tipo base.

Ejemplo:

Persona
 ├── Alumno
 └── Profesor
Los subtipos heredan:

atributos
métodos
del tipo padre.

En Oracle esto se implementa con:

UNDER
Métodos MEMBER
Son métodos asociados a una instancia concreta del objeto.

Ejemplo:

profesor1.aumentarSalario()
3. Ejemplo práctico completo
En esta práctica se desarrollará un pequeño sistema de gestión académica utilizando:

tipos objeto,
herencia,
tablas objeto,
métodos,
funciones,
polimorfismo.
4. Eliminación previa de objetos
Primero eliminamos tablas y tipos si ya existen:

DROP TABLE Alumnos CASCADE CONSTRAINTS;
DROP TABLE Profesores CASCADE CONSTRAINTS;

DROP TYPE Profesor FORCE;
DROP TYPE Alumno FORCE;
DROP TYPE Persona FORCE;
DROP TYPE Direccion FORCE;
5. Creación de un tipo objeto simple
Tipo Dirección
Creamos un objeto que represente una dirección.

CREATE TYPE Direccion AS OBJECT (
    calle VARCHAR2(50),
    ciudad VARCHAR2(20),
    codigo_postal NUMBER(5)
);
Explicación
Aquí estamos creando un tipo objeto llamado:

Direccion
con:

calle
ciudad
código postal
Este objeto podrá utilizarse dentro de otros objetos.

6. Creación del tipo base Persona
CREATE OR REPLACE TYPE Persona AS OBJECT (
    nombre VARCHAR2(50),
    apellidos VARCHAR2(100),
    domicilio Direccion, --Aquí un atributo es otro objeto.
    fecha_nac DATE,

     MEMBER FUNCTION nombreCompleto RETURN VARCHAR2 -- Es un método asociado a cada instancia del objeto.
) NOT FINAL; -- Permite que otros tipos hereden de Persona.
/
7. Implementación del método
CREATE OR REPLACE TYPE BODY Persona AS

    MEMBER FUNCTION nombreCompleto RETURN VARCHAR2 IS
    BEGIN
        RETURN nombre || ' ' || apellidos;
    END;

END; -- El cuerpo del tipo contiene la implementación de los métodos.
8. Creación del subtipo Alumno
CREATE OR REPLACE TYPE Alumno UNDER Persona ( -- Under persona indica herencia
    matricula VARCHAR2(20),
    calificacion NUMBER
);
/
9. Creación del subtipo Profesor
CREATE OR REPLACE TYPE Profesor UNDER Persona (
    asignatura VARCHAR2(50),
    salario NUMBER,
    MEMBER PROCEDURE aumentarSalario(cantidad NUMBER)
);

-- Profesor hereda de Persona y añade: asignatura y salario. Además incorpora un procedimiento propio.
10. Implementación del procedimiento
CREATE OR REPLACE TYPE BODY Profesor AS

    MEMBER PROCEDURE aumentarSalario(cantidad NUMBER) IS
    BEGIN
        SELF.salario := SELF.salario + cantidad;
    END;

END;
-- El método modifica el atributo salario del objeto. SELF es el propio objeto sobre el que estás trabajando. 
-- La idea es igual que this en Java.
11. Creación de tablas objeto
CREATE TABLE Alumnos OF Alumno;
CREATE TABLE Profesores OF Profesor;

/* Cada fila representa una instancia completa del tipo objeto definido en Oracle. */
12. Inserción de objetos
Insertar alumno
INSERT INTO Alumnos VALUES (

    Alumno(
        'Ramón',
        'Sánchez',
        Direccion('Calle Real','Sevilla',41001),
        '2000-05-10',
        'A001',
        9.5
    )

);
/
Insertar profesor
INSERT INTO Profesores VALUES (
    Profesor(
        'Juan',
        'Martinez',
        Direccion('Avenida Sol','Madrid',28001),
        '1980-03-20',
        'Bases de Datos',
        2000
    )
);
-- Aquí usamos el constructor para crear objetos. Oracle almacena esos objetos directamente en la tabla.
13. Consultas sobre objetos
SELECT * FROM Alumnos;
SELECT * FROM Profesores;
14. Uso de VALUE
DECLARE
    a Alumno; --creo una variable objeto del tipo alumno
BEGIN
    SELECT VALUE(al) --devuélveme el objeto completo
    INTO a
    FROM Alumnos al -- la tabla objeto
    WHERE al.nombre = 'Ramón';

    DBMS_OUTPUT.PUT_LINE(
        'Nombre completo: ' || a.nombreCompleto()
    );
END;
15. Modificación de objetos
DECLARE

    p Profesor;

BEGIN

    -- Obtener objeto desde la tabla
    SELECT VALUE(pr)
    INTO p
    FROM Profesores pr
    WHERE pr.nombre = 'Juan';

    -- Mostrar salario original
    DBMS_OUTPUT.PUT_LINE(
        'Salario original: ' || p.salario
    );

    -- Modificar objeto en memoria
    p.aumentarSalario(300);

    -- Mostrar salario modificado
    DBMS_OUTPUT.PUT_LINE(
        'Salario tras aumento: ' || p.salario
    );

    -- Guardar cambios en tabla
    UPDATE Profesores pr
    SET VALUE(pr) = p
    WHERE pr.nombre = 'Juan';

END;
16. Conclusiones
Las bases de datos objeto-relacionales permiten incorporar conceptos de programación orientada a objetos dentro de Oracle.

Con esta práctica hemos trabajado:

tipos objeto,
herencia,
métodos,
constructores,
tablas objeto,
inserciones de objetos,
consultas,
Aunque actualmente las aplicaciones suelen utilizar:

Java + Hibernate/JPA
junto con bases relacionales tradicionales,
las BDOR siguen siendo importantes para comprender:

la evolución de las bases de datos,
la integración entre POO y SQL,
y el funcionamiento interno de Oracle.
