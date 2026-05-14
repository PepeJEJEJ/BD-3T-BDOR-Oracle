DROP TABLE Coches_Electricos;
DROP TABLE Motos;
DROP TYPE BODY CocheElectrico;
DROP TYPE BODY Vehiculo;
DROP TYPE Moto;
DROP TYPE CocheElectrico;
DROP TYPE Vehiculo;


CREATE TYPE vehiculo AS OBJECT (
        matricula VARCHAR2(10),
        marca     VARCHAR2(50),
        modelo    VARCHAR2(50),
        anio      NUMBER(4),
        member function calcularAntiguedad RETURN NUMBER -- SE ME OLVIDO PONERLO
) not final;
/

Create or Replace Type Body vehiculo as -- ESTO TAMBIEN PUES ES UN METODO
    member function calcularantiguedad return number is
    begin
        return extract(year from sysdate) - anio;
    end;
end;
/

CREATE OR REPLACE TYPE CocheElectrico UNDER vehiculo (
    autonomia NUMBER,
    MEMBER PROCEDURE aumentarAutonomia (p_incremento NUMBER)
);
/

CREATE OR REPLACE TYPE Moto UNDER vehiculo (
    cilindrada NUMBER
);
/

CREATE OR REPLACE TYPE body CocheElectrico as
MEMBER PROCEDURE aumentarAutonomia (p_incremento NUMBER) IS
    BEGIN
        autonomia := autonomia + p_incremento;
    END;

end;
/

create table Coches_Electricos of CocheElectrico;
create table Motos of Moto;

DECLARE
    ce CocheElectrico;
BEGIN
    -- Crear objeto
    ce := CocheElectrico('ELEC123','Tesla','Model S',2022,600);

    -- Aumentar autonomía
    ce.aumentarAutonomia(50);

    -- Insertar en tabla correcta
    INSERT INTO Coches_Electricos VALUES (ce);

    -- Mostrar resultado
    DBMS_OUTPUT.PUT_LINE('Matrícula: ' || ce.matricula);
    DBMS_OUTPUT.PUT_LINE('Marca: ' || ce.marca);
    DBMS_OUTPUT.PUT_LINE('Modelo: ' || ce.modelo);
    DBMS_OUTPUT.PUT_LINE('Año: ' || ce.anio);
    DBMS_OUTPUT.PUT_LINE('Autonomía actual: ' || ce.autonomia);
    DBMS_OUTPUT.PUT_LINE('Antigüedad: ' || ce.calcularAntiguedad || ' años');
END;
/

declare
    ce1 CocheElectrico;
begin
    select value(c) into ce1 from Coches_Electricos c where c.matricula = 'ELEC123';
    DBMS_OUTPUT.PUT_LINE('Antigüedad del vehículo: ' || ce1.calcularAntiguedad || ' años');
    ce1.aumentarAutonomia(200);
    update Coches_Electricos cochee set value(cochee)=ce1 where cochee.matricula='ELEC123';
end;
/
