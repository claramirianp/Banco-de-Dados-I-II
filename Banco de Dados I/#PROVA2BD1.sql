-- CREATE DATABASE Cervejarias;

USE Cervejarias;

CREATE TABLE Fabricante (nome VARCHAR(50) PRIMARY KEY);

CREATE TABLE Cerveja (nome VARCHAR(50) PRIMARY KEY, fabricante VARCHAR(50), FOREIGN KEY (fabricante) REFERENCES Fabricante(nome));

CREATE TABLE Pessoa (nome VARCHAR(50) PRIMARY KEY);

CREATE TABLE Bar (nome VARCHAR(50) PRIMARY KEY);

CREATE TABLE Frequenta (pessoa VARCHAR(50), bar VARCHAR(50), FOREIGN KEY (pessoa) REFERENCES Pessoa(nome), FOREIGN KEY (bar) REFERENCES Bar(nome));

CREATE TABLE Vende (bar VARCHAR(50), cerveja VARCHAR(50), preco DECIMAL(10,2), PRIMARY KEY (bar, cerveja), FOREIGN KEY (bar) REFERENCES Bar(nome), FOREIGN KEY (cerveja) REFERENCES Cerveja(nome));


INSERT INTO Fabricante VALUES ('Ambev'), ('Colonia'), ('Sudbrack'), ('Schincariol');

INSERT INTO Cerveja VALUES ('Antarctica Original', 'Ambev'), ('Bohemia Weiss', 'Ambev'), ('Brahma Extra', 'Ambev'), ('Budweiser', 'Ambev'), ('Colonia Pilsen', 'Colonia'), ('Eisenbahn Dunkel', 'Sudbrack'), ('Nova Schin Pilsen', 'Schincariol'), ('Primus', 'Schincariol'), ('Skol', 'Ambev');

INSERT INTO Pessoa VALUES ('Clara'), ('Vinicius'), ('Marcelo'), ('Rodrigo'), ('Robert'), ('Eleissa'), ('Dom Francisco');

INSERT INTO Bar VALUES ('Dom Francisco'), ('Lico');

INSERT INTO Frequenta VALUES ('Clara', 'Dom Francisco'), ('Vinicius', 'Dom Francisco'), ('Marcelo', 'Dom Francisco'), ('Rodrigo', 'Dom Francisco'), ('Robert', 'Lico'), ('Eleissa', 'Dom Francisco');

INSERT INTO Vende VALUES ('Dom Francisco', 'Brahma Extra', 13.00), ('Dom Francisco', 'Budweiser', 11.50), ('Dom Francisco', 'Nova Schin Pilsen', 9.00), ('Lico', 'Primus', 9.50);


-- 3

-- a

UPDATE Vende SET preco = preco * 1.5 WHERE bar = 'Dom Francisco' AND cerveja IN (SELECT nome FROM Cerveja WHERE fabricante = 'Ambev');

-- b

UPDATE Frequenta SET bar = 'Lico' WHERE pessoa = 'Clara';

-- c

ALTER TABLE Pessoa ADD COLUMN idade INT;

-- d

DELETE FROM Vende WHERE cerveja = 'Bohemia Weiss';

DELETE FROM Cerveja WHERE nome = 'Bohemia Weiss';


-- 4

-- a

SELECT DISTINCT F.pessoa FROM Frequenta F JOIN Vende V ON F.bar = V.bar;

-- b

SELECT nome FROM Cerveja WHERE fabricante = 'Ambev' AND nome NOT IN (SELECT cerveja FROM Vende WHERE bar = 'Dom Francisco');

-- c

SELECT nome FROM Pessoa WHERE nome NOT IN (SELECT pessoa FROM Frequenta);

-- d

SELECT AVG(preco) FROM Vende;

-- e

SELECT DISTINCT V.bar FROM Vende V JOIN Frequenta F ON V.bar = F.bar WHERE F.pessoa = 'Eleissa';

-- f

SELECT DISTINCT C.fabricante FROM Cerveja C JOIN Vende V ON C.nome = V.cerveja JOIN Frequenta F ON V.bar = F.bar WHERE F.pessoa = 'Vinicius';

-- g

SELECT fabricante FROM Cerveja GROUP BY fabricante HAVING COUNT(*) = 1;

-- h

SELECT nome FROM Bar WHERE nome NOT IN (SELECT bar FROM Vende);

-- i

SELECT cerveja FROM Vende WHERE preco = (SELECT MIN(preco) FROM Vende);

-- j

SELECT * FROM Pessoa ORDER BY idade ASC; 