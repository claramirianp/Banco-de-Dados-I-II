CREATE DATABASE IF NOT EXISTS sistema_aeroprontuario;
use sistema_aeroprontuario;

CREATE TABLE aeroporto(
  codigo  VARCHAR(10),
  nome    VARCHAR(100),
  cidade  VARCHAR(80),
  pais    VARCHAR(60),
  PRIMARY KEY(codigo)
);

CREATE TABLE aeronave(
   id          VARCHAR(20),
  modelo      VARCHAR(60),
  fabricante  VARCHAR(60),
  capacidade  INTEGER,
  PRIMARY KEY(id)
);

CREATE TABLE funcionario(
  matricula        VARCHAR(10),
  nome             VARCHAR(100),
  salario          DECIMAL(10,2),
  data_contratacao DATE,
  cargo            VARCHAR(40),
  aeroporto_id     VARCHAR(10),
  PRIMARY KEY(matricula),
  FOREIGN KEY(aeroporto_id) REFERENCES aeroporto(codigo)
);

CREATE TABLE voo(
  numero            VARCHAR(10),
  data_partida      DATE,
  horario_partida   TIME,
  horario_chegada   TIME,
  aeroporto_origem  VARCHAR(10),
  aeroporto_destino VARCHAR(10),
  aeronave_id       VARCHAR(20),
  PRIMARY KEY(numero),
  FOREIGN KEY(aeroporto_origem)  REFERENCES aeroporto(codigo),
  FOREIGN KEY(aeroporto_destino) REFERENCES aeroporto(codigo),
  FOREIGN KEY(aeronave_id)       REFERENCES aeronave(id)
);

CREATE TABLE tripulacao_voo(
  matricula  VARCHAR(10),
  numero_voo VARCHAR(10),
  funcao     VARCHAR(40),
  PRIMARY KEY(matricula, numero_voo),
  FOREIGN KEY(matricula)  REFERENCES funcionario(matricula),
  FOREIGN KEY(numero_voo) REFERENCES voo(numero)
);

CREATE TABLE passageiro(
  codigo     VARCHAR(10),
  nome       VARCHAR(100),
  passaporte VARCHAR(30),
  PRIMARY KEY(codigo)
);

CREATE TABLE bagagem(
  id         VARCHAR(10),
  peso       DECIMAL(5,2),
  passageiro VARCHAR(10),
  numero_voo VARCHAR(10),
  PRIMARY KEY(id),
  FOREIGN KEY(passageiro) REFERENCES passageiro(codigo),
  FOREIGN KEY(numero_voo) REFERENCES voo(numero)
);

INSERT INTO aeroporto (codigo, nome, cidade, pais) VALUES
('GRU', 'Aeroporto Internacional de Guarulhos', 'Guarulhos', 'Brasil'),
('CGH', 'Aeroporto de Congonhas', 'São Paulo', 'Brasil'),
('JFK', 'John F. Kennedy International', 'Nova York', 'EUA'),
('LHR', 'Heathrow Airport', 'Londres', 'Reino Unido'),
('CDG', 'Charles de Gaulle', 'Paris', 'França'),
('FRA', 'Frankfurt Airport', 'Frankfurt', 'Alemanha'),
('HND', 'Haneda Airport', 'Tóquio', 'Japão'),
('DXB', 'Dubai International', 'Dubai', 'Emirados Árabes'),
('SYD', 'Sydney Kingsford Smith', 'Sydney', 'Austrália'),
('EZE', 'Ministro Pistarini', 'Buenos Aires', 'Argentina');

INSERT INTO aeronave (id, modelo, fabricante, capacidade) VALUES
('PR-GUA', 'Boeing 737 MAX', 'Boeing', 180),
('PR-GUB', 'Boeing 737-800', 'Boeing', 160),
('PR-XMA', 'Airbus A320neo', 'Airbus', 174),
('PR-XMB', 'Airbus A321', 'Airbus', 220),
('PR-YLA', 'Embraer E195-E2', 'Embraer', 146),
('PR-YLB', 'Embraer E190', 'Embraer', 114),
('N-101AA', 'Boeing 777-300ER', 'Boeing', 396),
('N-102AA', 'Boeing 787 Dreamliner', 'Boeing', 250),
('F-201AF', 'Airbus A350', 'Airbus', 325),
('F-202AF', 'Airbus A380', 'Airbus', 500);

INSERT INTO funcionario (matricula, nome, salario, data_contratacao, cargo, aeroporto_id) VALUES
('F001', 'Carlos Silva', 4500.00, '2020-01-15', 'Piloto', 'GRU'),
('F002', 'Mariana Costa', 3200.00, '2021-03-10', 'Copiloto', 'GRU'),
('F003', 'João Pedro', 2800.00, '2019-11-20', 'Comissário', 'CGH'),
('F004', 'Ana Beatriz', 2800.00, '2022-05-05', 'Comissária', 'JFK'),
('F005', 'Lucas Almeida', 5500.00, '2018-08-12', 'Piloto', 'LHR'),
('F006', 'Fernanda Lima', 3000.00, '2023-01-20', 'Copiloto', 'CDG'),
('F007', 'Roberto Alves', 2500.00, '2021-07-30', 'Atendente de Solo', 'FRA'),
('F008', 'Camila Rocha', 2500.00, '2020-09-15', 'Despachante', 'HND'),
('F009', 'Marcos Vinicius', 6000.00, '2015-04-10', 'Piloto Chefe', 'DXB'),
('F010', 'Juliana Mendes', 2900.00, '2022-11-01', 'Comissária', 'SYD');

INSERT INTO passageiro (codigo, nome, passaporte) VALUES
('P001', 'Ricardo Oliveira', 'BR123456'),
('P002', 'Amanda Souza', 'BR654321'),
('P003', 'John Doe', 'US987654'),
('P004', 'Emma Smith', 'UK112233'),
('P005', 'Pierre Dubois', 'FR445566'),
('P006', 'Hans Müller', 'DE778899'),
('P007', 'Kenji Tanaka', 'JP990011'),
('P008', 'Fatima Al-Fayed', 'AE223344'),
('P009', 'Oliver Brown', 'AU556677'),
('P010', 'Valentina Rossi', 'AR889900');

INSERT INTO voo (numero, data_partida, horario_partida, horario_chegada, aeroporto_origem, aeroporto_destino, aeronave_id) VALUES
('V1001', '2023-10-01', '08:00:00', '12:00:00', 'GRU', 'JFK', 'N-101AA'),
('V1002', '2023-10-02', '09:30:00', '10:45:00', 'CGH', 'GRU', 'PR-YLA'),
('V1003', '2023-10-03', '14:00:00', '22:00:00', 'JFK', 'LHR', 'N-102AA'),
('V1004', '2023-10-04', '23:00:00', '06:00:00', 'LHR', 'DXB', 'F-202AF'),
('V1005', '2023-10-05', '07:15:00', '09:00:00', 'CDG', 'FRA', 'PR-XMA'),
('V1006', '2023-10-06', '13:00:00', '05:00:00', 'FRA', 'HND', 'F-201AF'),
('V1007', '2023-10-07', '18:45:00', '23:30:00', 'HND', 'SYD', 'N-101AA'),
('V1008', '2023-10-08', '11:20:00', '15:10:00', 'DXB', 'CDG', 'F-202AF'),
('V1009', '2023-10-09', '06:00:00', '09:00:00', 'SYD', 'GRU', 'PR-GUA'),
('V1010', '2023-10-10', '16:00:00', '18:30:00', 'GRU', 'EZE', 'PR-GUB');

INSERT INTO tripulacao_voo (matricula, numero_voo, funcao) VALUES
('F001', 'V1001', 'Piloto Principal'),
('F002', 'V1001', 'Copiloto'),
('F003', 'V1001', 'Comissário Líder'),
('F005', 'V1003', 'Piloto Principal'),
('F006', 'V1003', 'Copiloto'),
('F009', 'V1004', 'Piloto Principal'),
('F004', 'V1004', 'Comissária'),
('F001', 'V1010', 'Piloto Principal'),
('F010', 'V1010', 'Comissária'),
('F005', 'V1006', 'Piloto Principal');

INSERT INTO bagagem (id, peso, passageiro, numero_voo) VALUES
('B001', 23.50, 'P001', 'V1001'),
('B002', 15.00, 'P001', 'V1001'),
('B003', 20.00, 'P002', 'V1002'),
('B004', 32.00, 'P003', 'V1003'),
('B005', 10.50, 'P004', 'V1004'),
('B006', 22.00, 'P005', 'V1005'),
('B007', 18.75, 'P006', 'V1006'),
('B008', 25.00, 'P007', 'V1007'),
('B009', 21.30, 'P008', 'V1008'),
('B010', 19.90, 'P010', 'V1010');

ALTER TABLE aeronave ADD ano_fabricacao INTEGER;
ALTER TABLE aeronave CHANGE capacidade total_assentos SMALLINT;
ALTER TABLE funcionario CHANGE cargo funcao_desempenhada VARCHAR(60);
ALTER TABLE bagagem CHANGE peso peso_kg DECIMAL(6,3);

-- 1: Listar todos os passageiros e seus respectivos passaportes em ordem alfabética.
-- Importância: Útil para verificações rápidas de identidade e auditoria de cadastros.
SELECT nome, passaporte FROM passageiro ORDER BY nome ASC;

-- 2: Mostrar todos os voos (número, origem e destino) que partem do aeroporto de Guarulhos (GRU).
-- Importância: Ajuda o painel de controle do aeroporto a monitorar as partidas locais.
SELECT numero, aeroporto_origem, aeroporto_destino FROM voo WHERE aeroporto_origem = 'GRU';

-- 3: Calcular o peso total de bagagens despachadas no voo 'V1001'.
-- Importância: Crucial para o balanceamento de peso da aeronave e segurança de voo.
SELECT numero_voo, SUM(peso_kg) AS peso_total_bagagem FROM bagagem WHERE numero_voo = 'V1001' GROUP BY numero_voo;

-- 4: Listar os funcionários e seus salários, mostrando apenas os que ganham mais de 3000.
-- Importância: Análise financeira da folha de pagamento para cargos sêniores ou pilotos.
SELECT nome, funcao_desempenhada, salario FROM funcionario WHERE salario > 3000.00;

-- 5: Descobrir qual o modelo de aeronave e o fabricante que farão o voo 'V1003'.
-- Importância: Planejamento de manutenção e alocação de portões de embarque específicos para o tamanho do avião.
SELECT v.numero, a.modelo, a.fabricante 
FROM voo v 
JOIN aeronave a ON v.aeronave_id = a.id 
WHERE v.numero = 'V1003';

-- 6: Listar toda a tripulação (nomes e funções) designada para o voo 'V1001'.
-- Importância: Controle de escala e garantia de que o voo possui a equipe mínima obrigatória por lei.
SELECT f.nome, t.funcao 
FROM tripulacao_voo t 
JOIN funcionario f ON t.matricula = f.matricula 
WHERE t.numero_voo = 'V1001';

-- 7: Contar quantos voos cada aeronave realizou/tem agendado.
-- Importância: Determina o desgaste das aeronaves e ajuda a programar revisões mecânicas.
SELECT aeronave_id, COUNT(numero) AS total_voos 
FROM voo 
GROUP BY aeronave_id;

-- 8: Encontrar os passageiros e o peso de suas bagagens no voo 'V1001'.
-- Importância: Identificar excesso de bagagem individual para cobrança de taxas extras.
SELECT p.nome, b.peso_kg 
FROM bagagem b 
JOIN passageiro p ON b.passageiro = p.codigo 
WHERE b.numero_voo = 'V1001';

-- 9: Exibir a lista de aeroportos localizados no 'Brasil'.
-- Importância: Filtro logístico para análise de rotas domésticas da companhia aérea.
SELECT codigo, nome, cidade FROM aeroporto WHERE pais = 'Brasil';

-- 10: Calcular o salário médio dos funcionários agrupados por aeroporto de base.
-- Importância: Análise de custos operacionais por filial/aeroporto para a área financeira da empresa.
SELECT aeroporto_id, AVG(salario) AS media_salarial 
FROM funcionario 
GROUP BY aeroporto_id;
