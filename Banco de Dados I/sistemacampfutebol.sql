CREATE DATABASE IF NOT EXISTS sistema_campeonato;
use sistema_campeonato;

CREATE TABLE campeonato (
  id VARCHAR(10),
  nome VARCHAR(100),
  temporada VARCHAR(20),
  regulamento TEXT,
  data_inicio DATE,
  data_termino DATE,
  PRIMARY KEY(id)
);

CREATE TABLE clube (
  codigo VARCHAR(10),
  nome VARCHAR(100),
  cidade VARCHAR(80),
  estadio_principal VARCHAR(100),
  presidente VARCHAR(100),
  PRIMARY KEY(codigo)
);

CREATE TABLE contrato_comissao (
  id VARCHAR(10),
  clube_codigo VARCHAR(10),
  nome_profissional VARCHAR(100),
  cargo VARCHAR(50), -- ex: treinador, auxiliar, etc.
  data_inicio DATE,
  salario DECIMAL(10,2),
  situacao_contratual VARCHAR(30),
  PRIMARY KEY(id),
  FOREIGN KEY(clube_codigo) REFERENCES clube(codigo)
);

CREATE TABLE jogador (
  numero_registro VARCHAR(20),
  nome VARCHAR(100),
  nacionalidade VARCHAR(50),
  data_nascimento DATE,
  posicao VARCHAR(30),
  clube_atual VARCHAR(10),
  PRIMARY KEY(numero_registro),
  FOREIGN KEY(clube_atual) REFERENCES clube(codigo)
);

CREATE TABLE historico_transferencia (
  id VARCHAR(10),
  jogador_registro VARCHAR(20),
  clube_origem VARCHAR(10),
  clube_destino VARCHAR(10),
  data_transferencia DATE,
  PRIMARY KEY(id),
  FOREIGN KEY(jogador_registro) REFERENCES jogador(numero_registro),
  FOREIGN KEY(clube_origem) REFERENCES clube(codigo),
  FOREIGN KEY(clube_destino) REFERENCES clube(codigo)
);

CREATE TABLE partida (
  id VARCHAR(10),
  campeonato_id VARCHAR(10),
  data_partida DATE,
  horario TIME,
  estadio VARCHAR(100),
  clube_mandante VARCHAR(10),
  clube_visitante VARCHAR(10),
  PRIMARY KEY(id),
  FOREIGN KEY(campeonato_id) REFERENCES campeonato(id),
  FOREIGN KEY(clube_mandante) REFERENCES clube(codigo),
  FOREIGN KEY(clube_visitante) REFERENCES clube(codigo)
);

CREATE TABLE arbitro (
  codigo VARCHAR(10),
  nome VARCHAR(100),
  PRIMARY KEY(codigo)
);

CREATE TABLE arbitro_partida (
  arbitro_codigo VARCHAR(10),
  partida_id VARCHAR(10),
  funcao VARCHAR(40), -- ex: Principal, Assistente 1, Quarto Árbitro
  PRIMARY KEY(arbitro_codigo, partida_id),
  FOREIGN KEY(arbitro_codigo) REFERENCES arbitro(codigo),
  FOREIGN KEY(partida_id) REFERENCES partida(id)
);

CREATE TABLE evento_partida (
  id VARCHAR(10),
  partida_id VARCHAR(10),
  tipo_evento VARCHAR(40), -- ex: gol, cartao amarelo, substituicao
  jogador_envolvido VARCHAR(20),
  minuto_ocorrencia INTEGER,
  observacoes TEXT,
  PRIMARY KEY(id),
  FOREIGN KEY(partida_id) REFERENCES partida(id),
  FOREIGN KEY(jogador_envolvido) REFERENCES jogador(numero_registro)
);

CREATE TABLE participacao_campeonato (
  clube_codigo VARCHAR(10),
  campeonato_id VARCHAR(10),
  pontuacao_acumulada INTEGER,
  quantidade_vitorias INTEGER,
  quantidade_empates INTEGER,
  quantidade_derrotas INTEGER,
  gols_marcados INTEGER,
  gols_sofridos INTEGER,
  PRIMARY KEY(clube_codigo, campeonato_id),
  FOREIGN KEY(clube_codigo) REFERENCES clube(codigo),
  FOREIGN KEY(campeonato_id) REFERENCES campeonato(id)
);

CREATE TABLE torcedor (
  cpf VARCHAR(14),
  nome VARCHAR(100),
  programa_socio_torcedor VARCHAR(50),
  PRIMARY KEY(cpf)
);

CREATE TABLE ingresso (
  id VARCHAR(20),
  partida_id VARCHAR(10),
  torcedor_cpf VARCHAR(14),
  valor DECIMAL(6,2),
  PRIMARY KEY(id),
  FOREIGN KEY(partida_id) REFERENCES partida(id),
  FOREIGN KEY(torcedor_cpf) REFERENCES torcedor(cpf)
);

INSERT INTO campeonato (id, nome, temporada, regulamento, data_inicio, data_termino) VALUES
('C01', 'Campeonato Brasileiro', '2026', 'Pontos Corridos', '2026-04-12', '2026-12-06'),
('C02', 'Copa do Brasil', '2026', 'Mata-mata', '2026-02-18', '2026-10-21'),
('C03', 'Taça Libertadores', '2026', 'Fase de Grupos e Eliminatórias', '2026-03-04', '2026-11-28'),
('C04', 'Campeonato Paulista', '2026', 'Grupos e Quartas', '2026-01-15', '2026-04-05'),
('C05', 'Campeonato Carioca', '2026', 'Taça Guanabara', '2026-01-14', '2026-04-05'),
('C06', 'Campeonato Mineiro', '2026', 'Fase Única e Semifinais', '2026-01-21', '2026-04-02'),
('C07', 'Campeonato Gaúcho', '2026', 'Pontos Corridos e Finais', '2026-01-20', '2026-04-01'),
('C08', 'Copa Sul-Americana', '2026', 'Fase de Grupos e Eliminatórias', '2026-03-05', '2026-11-25'),
('C09', 'Recopa Sul-Americana', '2026', 'Finais de Ida e Volta', '2026-02-11', '2026-02-18'),
('C10', 'Mundial de Clubes', '2026', 'Eliminatória Direta', '2026-12-10', '2026-12-20');

INSERT INTO clube (codigo, nome, cidade, estadio_principal, presidente) VALUES
('CL01', 'Flamengo', 'Rio de Janeiro', 'Maracanã', 'Rodolfo Landim'),
('CL02', 'Palmeiras', 'São Paulo', 'Allianz Parque', 'Leila Pereira'),
('CL03', 'Atlético Mineiro', 'Belo Horizonte', 'Arena MRV', 'Sérgio Coelho'),
('CL04', 'Grêmio', 'Porto Alegre', 'Arena do Grêmio', 'Alberto Guerra'),
('CL05', 'São Paulo FC', 'São Paulo', 'MorumBIS', 'Julio Casares'),
('CL06', 'Fluminense', 'Rio de Janeiro', 'Maracanã', 'Mário Bittencourt'),
('CL07', 'Internacional', 'Porto Alegre', 'Beira-Rio', 'Alessandro Barcellos'),
('CL08', 'Cruzeiro', 'Belo Horizonte', 'Mineirão', 'Pedro Lourenço'),
('CL09', 'Corinthians', 'São Paulo', 'Neo Química Arena', 'Augusto Melo'),
('CL10', 'Botafogo', 'Rio de Janeiro', 'Nilton Santos', 'John Textor');

INSERT INTO contrato_comissao (id, clube_codigo, nome_profissional, cargo, data_inicio, salario, situacao_contratual) VALUES
('CC01', 'CL01', 'Tite', 'Treinador', '2024-10-10', 800000.00, 'Ativo'),
('CC02', 'CL02', 'Abel Ferreira', 'Treinador', '2020-11-01', 1200000.00, 'Ativo'),
('CC03', 'CL03', 'Gabriel Milito', 'Treinador', '2024-03-25', 500000.00, 'Ativo'),
('CC04', 'CL04', 'Renato Gaúcho', 'Treinador', '2023-01-01', 600000.00, 'Ativo'),
('CC05', 'CL05', 'Luis Zubeldía', 'Treinador', '2024-04-20', 450000.00, 'Ativo'),
('CC06', 'CL01', 'Cléber Xavier', 'Auxiliar Técnico', '2024-10-10', 150000.00, 'Ativo'),
('CC07', 'CL02', 'Vitor Castanheira', 'Auxiliar Técnico', '2020-11-01', 180000.00, 'Ativo'),
('CC08', 'CL06', 'Mano Menezes', 'Treinador', '2024-07-01', 400000.00, 'Ativo'),
('CC09', 'CL07', 'Roger Machado', 'Treinador', '2024-07-20', 350000.00, 'Ativo'),
('CC10', 'CL10', 'Artur Jorge', 'Treinador', '2024-04-05', 550000.00, 'Ativo');

INSERT INTO jogador (numero_registro, nome, nacionalidade, data_nascimento, posicao, clube_atual) VALUES
('J01', 'Pedro Guilherme', 'Brasileira', '1997-06-20', 'Centroavante', 'CL01'),
('J02', 'Giorgian De Arrascaeta', 'Uruguaia', '1994-06-01', 'Meia', 'CL01'),
('J03', 'Raphael Veiga', 'Brasileira', '1995-06-19', 'Meia', 'CL02'),
('J04', 'Gustavo Gómez', 'Paraguaia', '1993-05-06', 'Zagueiro', 'CL02'),
('J05', 'Hulk', 'Brasileira', '1986-07-25', 'Atacante', 'CL03'),
('J06', 'Paulino', 'Brasileira', '2000-07-15', 'Atacante', 'CL03'),
('J07', 'Yeferson Soteldo', 'Venezuelana', '1997-06-30', 'Ponta', 'CL04'),
('J08', 'Lucas Moura', 'Brasileira', '1992-08-13', 'Meia-Atacante', 'CL05'),
('J09', 'Ganso', 'Brasileira', '1989-10-12', 'Meia', 'CL06'),
('J10', 'Matheus Pereira', 'Brasileira', '1996-05-05', 'Meia', 'CL08');

INSERT INTO historico_transferencia (id, jogador_registro, clube_origem, clube_destino, data_transferencia) VALUES
('HT01', 'J01', 'CL06', 'CL01', '2020-01-23'),
('HT02', 'J02', 'CL08', 'CL01', '2019-01-12'),
('HT03', 'J05', 'CL01', 'CL03', '2021-01-29'),
('HT04', 'J07', 'CL09', 'CL04', '2024-01-02'),
('HT05', 'J10', 'CL02', 'CL08', '2023-07-15'),
('HT06', 'J03', 'CL03', 'CL02', '2017-01-01'),
('HT07', 'J08', 'CL01', 'CL05', '2023-08-01'),
('HT08', 'J06', 'CL05', 'CL03', '2023-01-10'),
('HT09', 'J09', 'CL05', 'CL06', '2019-01-31'),
('HT10', 'J04', 'CL06', 'CL02', '2018-08-01');

INSERT INTO partida (id, campeonato_id, data_partida, horario, estadio, clube_mandante, clube_visitante) VALUES
('PT01', 'C01', '2026-05-10', '16:00:00', 'Maracanã', 'CL01', 'CL02'),
('PT02', 'C01', '2026-05-11', '18:30:00', 'Arena MRV', 'CL03', 'CL04'),
('PT03', 'C01', '2026-05-17', '16:00:00', 'MorumBIS', 'CL05', 'CL06'),
('PT04', 'C02', '2026-06-03', '21:30:00', 'Mineirão', 'CL08', 'CL09'),
('PT05', 'C03', '2026-07-14', '21:30:00', 'Nilton Santos', 'CL10', 'CL01'),
('PT06', 'C01', '2026-08-20', '20:00:00', 'Beira-Rio', 'CL07', 'CL03'),
('PT07', 'C04', '2026-02-15', '19:00:00', 'Allianz Parque', 'CL02', 'CL05'),
('PT08', 'C05', '2026-02-22', '16:00:00', 'Maracanã', 'CL06', 'CL10'),
('PT09', 'C02', '2026-09-10', '21:45:00', 'Neo Química Arena', 'CL09', 'CL07'),
('PT10', 'C01', '2026-10-04', '16:00:00', 'Arena do Grêmio', 'CL04', 'CL08');

INSERT INTO arbitro (codigo, nome) VALUES
('A01', 'Anderson Daronco'),
('A02', 'Wilton Pereira Sampaio'),
('A03', 'Raphael Claus'),
('A04', 'Flavio Rodrigues de Souza'),
('A05', 'Ramon Abatti Abel'),
('A06', 'Edina Alves Batista'),
('A07', 'Rodrigo José Pereira de Lima'),
('A08', 'Paulo Cesar Zanovelli'),
('A09', 'Rafael Rodrigo Klein'),
('A10', 'Bruno Arleu de Araujo');

INSERT INTO arbitro_partida (arbitro_codigo, partida_id, funcao) VALUES
('A01', 'PT01', 'Principal'),
('A03', 'PT01', 'VAR'),
('A02', 'PT02', 'Principal'),
('A04', 'PT03', 'Principal'),
('A05', 'PT04', 'Principal'),
('A06', 'PT05', 'Principal'),
('A07', 'PT06', 'Principal'),
('A08', 'PT07', 'Principal'),
('A09', 'PT08', 'Principal'),
('A10', 'PT09', 'Principal');

INSERT INTO evento_partida (id, partida_id, tipo_evento, jogador_envolvido, minuto_ocorrencia, observacoes) VALUES
('EV01', 'PT01', 'Gol', 'J01', 14, 'Chute de perna direita dentro da área'),
('EV02', 'PT01', 'Cartão Amarelo', 'J04', 32, 'Falta tática para impedir contra-ataque'),
('EV03', 'PT01', 'Gol', 'J03', 45, 'Cobrança de pênalti'),
('EV04', 'PT02', 'Gol', 'J05', 67, 'Falta direta de longa distância'),
('EV05', 'PT03', 'Substituição', 'J08', 75, 'Entrada por cansaço físico'),
('EV06', 'PT04', 'Gol', 'J10', 89, 'Chute de fora da área no ângulo'),
('EV07', 'PT05', 'Cartão Amarelo', 'J02', 22, 'Reclamação acintosa com a arbitragem'),
('EV08', 'PT06', 'Gol', 'J06', 5, 'Cabeceio após cobrança de escanteio'),
('EV09', 'PT07', 'Cartão Vermelho', 'J03', 81, 'Segunda advertência por falta dura'),
('EV10', 'PT08', 'Gol', 'J09', 54, 'Toque sutil por cobertura');

INSERT INTO participacao_campeonato (clube_codigo, campeonato_id, pontuacao_acumulada, quantidade_vitorias, quantidade_empates, quantidade_derrotas, gols_marcados, gols_sofridos) VALUES
('CL01', 'C01', 65, 19, 8, 5, 55, 28),
('CL02', 'C01', 62, 18, 8, 6, 48, 25),
('CL03', 'C01', 52, 14, 10, 8, 42, 34),
('CL04', 'C01', 48, 13, 9, 10, 38, 36),
('CL05', 'C01', 50, 14, 8, 10, 40, 32),
('CL06', 'C01', 45, 12, 9, 11, 35, 33),
('CL07', 'C01', 47, 13, 8, 11, 37, 35),
('CL08', 'C01', 41, 11, 8, 13, 32, 40),
('CL09', 'C01', 38, 9, 11, 12, 29, 36),
('CL10', 'C01', 58, 17, 7, 8, 46, 30);

INSERT INTO torcedor (cpf, nome, programa_socio_torcedor) VALUES
('111.111.111-11', 'Lucas Silva Nogueira', 'Nação Rubro-Negra'),
('222.222.222-22', 'Beatriz Dias Rocha', 'Avanti Palmeiras'),
('333.333.333-33', 'Matheus Costa Lima', 'Galo Na Veia'),
('444.444.444-44', 'Fernanda Souza Alves', 'Sócio Grêmio'),
('555.555.555-55', 'Rodrigo Ramos Ferreira', 'Sócio Torcedor Tricolor'),
('666.666.666-66', 'Camila Oliveira Melo', 'Sócio Futebol'),
('777.777.777-77', 'Thiago Martins Santos', 'Nada Vai Nos Separar'),
('888.888.888-88', 'Amanda Vieira Borges', 'Sócio 5 Estrelas'),
('999.999.999-99', 'Felipe Castro Neves', 'Fiel Torcedor'),
('000.000.000-00', 'Juliana Barbosa Peixoto', 'Camisa 7');

INSERT INTO ingresso (id, partida_id, torcedor_cpf, valor) VALUES
('ING01', 'PT01', '111.111.111-11', 120.00),
('ING02', 'PT01', '222.222.222-22', 150.00),
('ING03', 'PT02', '333.333.333-33', 80.00),
('ING04', 'PT03', '555.555.555-55', 60.00),
('ING05', 'PT03', '666.666.666-66', 60.00),
('ING06', 'PT04', '999.999.999-99', 90.00),
('ING07', 'PT05', '000.000.000-00', 100.00),
('ING08', 'PT06', '333.333.333-33', 70.00),
('ING09', 'PT07', '222.222.222-22', 130.00),
('ING10', 'PT10', '444.444.444-44', 50.00);

ALTER TABLE clube ADD ano_fundacao INTEGER;
ALTER TABLE clube CHANGE presidente nome_presidente VARCHAR(120);
ALTER TABLE jogador CHANGE nacionalidade pais_origem VARCHAR(60);
ALTER TABLE torcedor CHANGE programa_socio_torcedor plano_socio VARCHAR(80);

-- 1: Listar os clubes e seus respectivos presidentes em ordem alfabética.
-- Importância: Catálogo básico para contatos institucionais e organização da liga.
SELECT nome, nome_presidente FROM clube ORDER BY nome ASC;

-- 2: Contar a quantidade de jogadores agrupados por país de origem.
-- Importância: Avaliar o nível de internacionalização do campeonato.
SELECT pais_origem, COUNT(numero_registro) AS total_jogadores 
FROM jogador 
GROUP BY pais_origem;

-- 3: Listar todos os contratos ativos com salários superiores a 500.000.
-- Importância: Análise financeira dos custos com comissão técnica nos clubes.
SELECT nome_profissional, cargo, salario 
FROM contrato_comissao 
WHERE salario > 500000.00 AND situacao_contratual = 'Ativo';

-- 4: Mostrar o histórico de transferências do jogador 'J01' (Pedro Guilherme).
-- Importância: Rastrear a valorização e o caminho de carreira de um atleta específico.
SELECT c_origem.nome AS origem, c_destino.nome AS destino, data_transferencia 
FROM historico_transferencia ht
JOIN clube c_origem ON ht.clube_origem = c_origem.codigo
JOIN clube c_destino ON ht.clube_destino = c_destino.codigo
WHERE ht.jogador_registro = 'J01';

-- 5: Calcular o total arrecadado com ingressos para a partida 'PT01'.
-- Importância: Fundamental para a prestação de contas de bilheteria (borderô) do clube mandante.
SELECT partida_id, SUM(valor) AS receita_total 
FROM ingresso 
WHERE partida_id = 'PT01' 
GROUP BY partida_id;

-- 6: Listar os árbitros e suas funções na partida 'PT01'.
-- Importância: Transparência e auditoria de quem foi a equipe de arbitragem em jogos específicos.
SELECT a.nome, ap.funcao 
FROM arbitro_partida ap
JOIN arbitro a ON ap.arbitro_codigo = a.codigo
WHERE ap.partida_id = 'PT01';

-- 7: Obter o saldo de gols (marcados - sofridos) dos clubes no Campeonato Brasileiro ('C01').
-- Importância: Critério de desempate essencial na tabela de classificação.
SELECT c.nome, pc.gols_marcados, pc.gols_sofridos, (pc.gols_marcados - pc.gols_sofridos) AS saldo_gols
FROM participacao_campeonato pc
JOIN clube c ON pc.clube_codigo = c.codigo
WHERE pc.campeonato_id = 'C01'
ORDER BY saldo_gols DESC;

-- 8: Listar todos os eventos de 'Cartão Vermelho' no campeonato.
-- Importância: Análise disciplinar para o Tribunal de Justiça Desportiva (STJD).
SELECT p.data_partida, j.nome AS jogador_expulso, ep.minuto_ocorrencia 
FROM evento_partida ep
JOIN partida p ON ep.partida_id = p.id
JOIN jogador j ON ep.jogador_envolvido = j.numero_registro
WHERE ep.tipo_evento = 'Cartão Vermelho';

-- 9: Mostrar os detalhes das partidas (mandante x visitante) que ocorrem no 'Maracanã'.
-- Importância: Planejamento de logística, segurança pública e trânsito para a região do estádio.
SELECT data_partida, horario, c1.nome AS mandante, c2.nome AS visitante 
FROM partida p
JOIN clube c1 ON p.clube_mandante = c1.codigo
JOIN clube c2 ON p.clube_visitante = c2.codigo
WHERE estadio = 'Maracanã';

-- 10: Contar quantos ingressos foram comprados por torcedores do plano 'Avanti Palmeiras'.
-- Importância: Avaliar o engajamento e o retorno financeiro de um programa de sócio específico.
SELECT t.plano_socio, COUNT(i.id) AS ingressos_comprados
FROM ingresso i
JOIN torcedor t ON i.torcedor_cpf = t.cpf
WHERE t.plano_socio = 'Avanti Palmeiras'
GROUP BY t.plano_socio;