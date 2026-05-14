CREATE TYPE vehiculo AS OBJECT (
        matricula VARCHAR2(10),
        marca     VARCHAR2(50),
        modelo    VARCHAR2(50),
        anio      NUMBER(4),
        member    function calcularantiguedad
) not final;
/

CREATE OR REPLACE TYPE cocheelectrico UNDER vehiculo (
        autonomia NUMBER,
        MEMBER PROCEDURE aumentarautonomia (
               p_incremento NUMBER
           )
);
/

CREATE OR REPLACE TYPE moto UNDER vehiculo (
    cilindrada NUMBER
);
/

CREATE OR REPLACE TYPE body CocheElectrico as(
MEMBER
    PROCEDURE aumentarautonomia (
        p_incremento NUMBER
    ) IS
    BEGIN
        self.autonomia := self.autonomia + p_incremento;
    END;

end;
/