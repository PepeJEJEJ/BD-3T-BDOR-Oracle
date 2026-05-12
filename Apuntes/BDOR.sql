-- BORRAR:
-- LAS CLASES QUE HEREDAN DE OTRAS SE BORRAN 1º
DROP TABLE Alumnos CASCADE CONSTRAINTS;
DROP TABLE Profesores CASCADE CONSTRAINTS;

DROP TYPE Profesor FORCE;
DROP TYPE Alumno FORCE;
DROP TYPE Persona FORCE;
DROP TYPE Direccion FORCE;

CREATE TYPE Direccion AS OBJECT (
    calle VARCHAR2(50),
    ciudad VARCHAR2(20),
    codigo_postal NUMBER(5)
);

create or replace type Persona as Object (
    nombre varchar2(50),
    apellidos varchar2 (100),
    domicilio Direccion, -- Herencia
    fecha_nac date,
    member function nombreCompleto return Varchar2 -- Funcion
)not final; -- PONER SIEMPRE QUE HAYA UNA FUNCION

-- IMPLEMENTAR EL METODO:
CREATE OR REPLACE TYPE BODY Persona AS

    MEMBER FUNCTION nombreCompleto RETURN VARCHAR2 IS
    BEGIN
        RETURN nombre || ' ' || apellidos;
    END;

END; -- El cuerpo del tipo contiene la implementación de los métodos.

-- SUBTIPOS:
CREATE OR REPLACE TYPE Alumno UNDER Persona ( -- Under persona indica herencia (Alumno Hereda de Persona)
    matricula VARCHAR2(20),
    calificacion NUMBER
);
/