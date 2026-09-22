CREATE DATABASE ClinicaBoaSaude;
USE ClinicaBoaSaude;

CREATE TABLE Paciente (
    codpac INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    endereço VARCHAR(150),
    telefone VARCHAR(20)
);

CREATE TABLE Medico (
    crm INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    endereço VARCHAR(150),
    telefone VARCHAR(20),
    especialidade VARCHAR(50)
);

CREATE TABLE Convenio (
    codconv INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

CREATE TABLE Consulta (
    codconsulta INT AUTO_INCREMENT PRIMARY KEY,
    data DATE,
    horário TIME,
    medico INT,
    paciente INT,
    convenio INT,
    porcent DECIMAL(5,2),
    FOREIGN KEY (medico) REFERENCES Medico(crm),
    FOREIGN KEY (paciente) REFERENCES Paciente(codpac),
    FOREIGN KEY (convenio) REFERENCES Convenio(codconv)
);

CREATE TABLE Atende (
    medico INT,
    convenio INT,
    PRIMARY KEY (medico, convenio),
    FOREIGN KEY (medico) REFERENCES Medico(crm),
    FOREIGN KEY (convenio) REFERENCES Convenio(codconv)
);

CREATE TABLE Possui (
    paciente INT,
    convenio INT,
    tipo CHAR(1),
    vencimento DATE,
    PRIMARY KEY (paciente, convenio),
    FOREIGN KEY (paciente) REFERENCES Paciente(codpac),
    FOREIGN KEY (convenio) REFERENCES Convenio(codconv)
);

INSERT INTO Paciente (nome, endereço, telefone) VALUES
('João', 'Rua 1', '9809-9756'),
('José', 'Rua B', '3621-8978'),
('Maria', 'Rua 10', '4567-9872'),
('Joana', 'Rua J', '3343-9889');

INSERT INTO Medico (crm, nome, endereço, telefone, especialidade) VALUES
(18739, 'Elias', 'Rua X', '8738-1221', 'Pediatria'),
(7646, 'Ana', 'Av Z', '7829-1233', 'Obstetricia'),
(39872, 'Pedro', 'Tv H', '9888-2333', 'Oftalmologia');

INSERT INTO Convenio (codconv, nome) VALUES
(189, 'Cassi'),
(232, 'Unimed'),
(454, 'Santa Casa'),
(908, 'Copasa'),
(435, 'São Lucas');

INSERT INTO Consulta (data, horário, medico, paciente, convenio, porcent) VALUES
('2013-05-10', '10:00:00', 18739, 1, 189, 5),
('2013-05-12', '10:00:00', 7646, 2, 232, 10),
('2013-05-12', '11:00:00', 18739, 3, 908, 15),
('2013-05-13', '10:00:00', 7646, 4, 435, 13),
('2013-05-14', '13:00:00', 7646, 2, 232, 10),
('2013-05-14', '14:00:00', 39872, 1, 189, 5);

INSERT INTO Atende (medico, convenio) VALUES
(18739, 189),
(18739, 908),
(7646, 232),
(39872, 189);

INSERT INTO Possui (paciente, convenio, tipo, vencimento) VALUES
(1, 189, 'E', '2016-12-31'),
(2, 232, 'S', '2014-12-31'),
(3, 908, 'S', '2017-12-31'),
(4, 435, 'E', '2016-12-31'),
(1, 232, 'S', '2015-12-31');

SELECT nome, telefone FROM Paciente;

SELECT m.nome, COUNT(c.codconsulta) AS quantidade_consultas
FROM Medico m
LEFT JOIN Consulta c ON m.crm = c.medico
GROUP BY m.nome;

SELECT * FROM Medico ORDER BY especialidade DESC;

SELECT p.nome
FROM Paciente p
JOIN Consulta c ON p.codpac = c.paciente
GROUP BY p.nome
HAVING COUNT(c.codconsulta) > 2;

UPDATE Medico
SET endereço = 'Rua Z', telefone = '9838-7867'
WHERE nome = 'Elias';

DELETE FROM Possui
WHERE paciente = (SELECT codpac FROM Paciente WHERE nome = 'José') AND convenio = 232;

DELETE FROM Consulta
WHERE data = '2013-05-14' AND horário = '14:00:00';

ALTER TABLE Medico RENAME COLUMN especialidade TO especializacao;

ALTER TABLE Convenio MODIFY nome VARCHAR(200);

ALTER TABLE Consulta ADD COLUMN Valor DECIMAL(10,2);
UPDATE Consulta SET Valor = 100.00;