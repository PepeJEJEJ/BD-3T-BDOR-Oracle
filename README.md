# BD-3T-BDOR-Oracle
---

# Bases de Datos Objeto‑Relacionales (BDOR) en Oracle

## 📌 Introducción
Las **bases de datos objeto‑relacionales (BDOR)** son una evolución del modelo relacional clásico. Combinan:

- Tablas, filas y columnas (modelo relacional)
- Objetos, herencia, métodos y polimorfismo (POO)

Oracle permite trabajar directamente con:

**objetos, tipos, herencia, métodos, constructores, colecciones**, etc., lo que facilita representar estructuras más cercanas al mundo real.

---

## 🤔 ¿Por qué surgieron las BDOR?
En lenguajes como **Java, C# o C++** trabajamos con objetos:

- Cliente  
- Pedido  
- Producto  
- Empleado  

Pero las bases de datos tradicionales almacenan:

- tablas  
- filas  
- columnas  

Las BDOR reducen esta brecha permitiendo almacenar **objetos completos** dentro de Oracle.

Aunque hoy en día se usa más:

- **BD relacionales + ORM (Hibernate/JPA)**

Oracle sigue soportando programación orientada a objetos dentro de la base de datos.

---

## 🎯 Objetivos de esta práctica
Aprenderás a:

- Crear **tipos objeto**
- Usar **herencia**
- Definir **métodos y procedimientos**
- Crear **tablas de objetos**
- Insertar y consultar **instancias de objetos**
- Aplicar **polimorfismo** en Oracle

---

## 🧩 1. Conceptos básicos

### 🔷 Tipo Objeto
Equivalente a una clase en Java.

Incluye:

- **Atributos** → datos  
- **Métodos** → comportamiento  

Ejemplo conceptual:

```
Persona
 ├── nombre
 ├── apellidos
 └── calcularEdad()
```

### 🔷 Herencia
Permite crear subtipos:

```
Persona
 ├── Alumno
 └── Profesor
```

Los subtipos heredan atributos y métodos.

En Oracle se implementa con:

```
UNDER
```

### 🔷 Métodos MEMBER
Son métodos asociados a una instancia:

```
profesor1.aumentarSalario()
```

---

## 🧪 2. Ejemplo práctico completo
Se desarrollará un pequeño sistema académico usando:

- Tipos objeto  
- Herencia  
- Métodos  
- Tablas objeto  
- Polimorfismo  

---

## 🧹 3. Eliminación previa de objetos

```sql
DROP TABLE Alumnos CASCADE CONSTRAINTS;
DROP TABLE Profesores CASCADE CONSTRAINTS;

DROP TYPE Profesor FORCE;
DROP TYPE Alumno FORCE;
DROP TYPE Persona FORCE;
DROP TYPE Direccion FORCE;
```

---

## 🏗️ 4. Creación de tipos objeto

### 📍 Tipo `Direccion`

```sql
CREATE TYPE Direccion AS OBJECT (
    calle VARCHAR2(50),
    ciudad VARCHAR2(20),
    codigo_postal NUMBER(5)
);
```

---

### 📍 Tipo base `Persona`

```sql
CREATE OR REPLACE TYPE Persona AS OBJECT (
    nombre VARCHAR2(50),
    apellidos VARCHAR2(100),
    domicilio Direccion,
    fecha_nac DATE,

    MEMBER FUNCTION nombreCompleto RETURN VARCHAR2
) NOT FINAL;
/
```

#### Implementación del método

```sql
CREATE OR REPLACE TYPE BODY Persona AS
    MEMBER FUNCTION nombreCompleto RETURN VARCHAR2 IS
    BEGIN
        RETURN nombre || ' ' || apellidos;
    END;
END;
/
```

---

## 🎓 5. Subtipo `Alumno`

```sql
CREATE OR REPLACE TYPE Alumno UNDER Persona (
    matricula VARCHAR2(20),
    calificacion NUMBER
);
/
```

---

## 👨‍🏫 6. Subtipo `Profesor`

```sql
CREATE OR REPLACE TYPE Profesor UNDER Persona (
    asignatura VARCHAR2(50),
    salario NUMBER,
    MEMBER PROCEDURE aumentarSalario(cantidad NUMBER)
);
/
```

### Implementación del procedimiento

```sql
CREATE OR REPLACE TYPE BODY Profesor AS
    MEMBER PROCEDURE aumentarSalario(cantidad NUMBER) IS
    BEGIN
        SELF.salario := SELF.salario + cantidad;
    END;
END;
/
```

---

## 🗄️ 7. Creación de tablas objeto

```sql
CREATE TABLE Alumnos OF Alumno;
CREATE TABLE Profesores OF Profesor;
```

Cada fila almacena **un objeto completo**.

---

## ✍️ 8. Inserción de objetos

### Alumno

```sql
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
```

### Profesor

```sql
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
/
```

---

## 🔍 9. Consultas sobre objetos

```sql
SELECT * FROM Alumnos;
SELECT * FROM Profesores;
```

---

## 📦 10. Uso de `VALUE`

```sql
DECLARE
    a Alumno;
BEGIN
    SELECT VALUE(al)
    INTO a
    FROM Alumnos al
    WHERE al.nombre = 'Ramón';

    DBMS_OUTPUT.PUT_LINE(
        'Nombre completo: ' || a.nombreCompleto()
    );
END;
/
```

---

## 🔧 11. Modificación de objetos

```sql
DECLARE
    p Profesor;
BEGIN
    SELECT VALUE(pr)
    INTO p
    FROM Profesores pr
    WHERE pr.nombre = 'Juan';

    DBMS_OUTPUT.PUT_LINE('Salario original: ' || p.salario);

    p.aumentarSalario(300);

    DBMS_OUTPUT.PUT_LINE('Salario tras aumento: ' || p.salario);

    UPDATE Profesores pr
    SET VALUE(pr) = p
    WHERE pr.nombre = 'Juan';
END;
/
```

---

## 🏁 Conclusiones
Las BDOR permiten integrar conceptos de POO dentro de Oracle:

- Tipos objeto  
- Herencia  
- Métodos  
- Tablas objeto  
- Inserción y consulta de objetos  

Aunque hoy se usa más **Java + Hibernate/JPA**, las BDOR son clave para entender:

- La evolución de las bases de datos  
- La integración entre POO y SQL  
- El funcionamiento interno de Oracle  

---
