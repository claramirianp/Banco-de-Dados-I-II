CREATE DATABASE IF NOT EXISTS sistema_labiot;
use sistema_labiot;

CREATE TABLE ambiente (
  codigo VARCHAR(10),
  nome VARCHAR(60),
  localizacao VARCHAR(100),
  PRIMARY KEY(codigo)
);

CREATE TABLE pesquisador (
  matricula VARCHAR(10),
  nome VARCHAR(100),
  titulacao VARCHAR(40),
  area_atuacao VARCHAR(60),
  PRIMARY KEY(matricula)
);

CREATE TABLE dispositivo (
  identificador VARCHAR(20),
  tipo VARCHAR(40), -- ex: braço robótico, sensor IoT, câmera inteligente
  fabricante VARCHAR(60),
  modelo VARCHAR(60),
  data_aquisicao DATE,
  PRIMARY KEY(identificador)
);

CREATE TABLE experimento (
  codigo VARCHAR(10),
  ambiente_codigo VARCHAR(10),
  PRIMARY KEY(codigo),
  FOREIGN KEY(ambiente_codigo) REFERENCES ambiente(codigo)
);

CREATE TABLE pesquisador_experimento (
  pesquisador_matricula VARCHAR(10),
  experimento_codigo VARCHAR(10),
  PRIMARY KEY(pesquisador_matricula, experimento_codigo),
  FOREIGN KEY(pesquisador_matricula) REFERENCES pesquisador(matricula),
  FOREIGN KEY(experimento_codigo) REFERENCES experimento(codigo)
);

CREATE TABLE dispositivo_experimento (
  dispositivo_id VARCHAR(20),
  experimento_codigo VARCHAR(10),
  PRIMARY KEY(dispositivo_id, experimento_codigo),
  FOREIGN KEY(dispositivo_id) REFERENCES dispositivo(identificador),
  FOREIGN KEY(experimento_codigo) REFERENCES experimento(codigo)
);

CREATE TABLE evento_experimento (
  id VARCHAR(10),
  experimento_codigo VARCHAR(10),
  dispositivo_id VARCHAR(20),
  data_hora TIMESTAMP,
  tipo VARCHAR(40),
  prioridade VARCHAR(20),
  PRIMARY KEY(id),
  FOREIGN KEY(experimento_codigo) REFERENCES experimento(codigo),
  FOREIGN KEY(dispositivo_id) REFERENCES dispositivo(identificador)
);

CREATE TABLE execucao_tarefa_robo (
  id VARCHAR(10),
  dispositivo_id VARCHAR(20), -- Deve ser um robô
  experimento_codigo VARCHAR(10),
  tarefa_realizada VARCHAR(150),
  horario_inicio TIME,
  horario_termino TIME,
  resultado_obtido TEXT,
  PRIMARY KEY(id),
  FOREIGN KEY(dispositivo_id) REFERENCES dispositivo(identificador),
  FOREIGN KEY(experimento_codigo) REFERENCES experimento(codigo)
);

INSERT INTO ambiente (codigo, nome, localizacao) VALUES
('AM01', 'Laboratório de Robótica Industrial', 'Bloco A, Sala 102'),
('AM02', 'Núcleo de Internet das Coisas (IoT)', 'Bloco B, Sala 204'),
('AM03', 'Sala de Sistemas Embarcados', 'Bloco A, Sala 105'),
('AM04', 'Oficina de Prototipagem Rápida', 'Bloco C, Galpão 1'),
('AM05', 'Laboratório de Visão Computacional', 'Bloco B, Sala 208'),
('AM06', 'Sala de Redes de Sensores Sem Fio', 'Bloco C, Sala 12'),
('AM07', 'Espaço de Inteligência Artificial Prática', 'Bloco D, Sala 301'),
('AM08', 'Laboratório de Automação Residencial', 'Bloco B, Sala 210'),
('AM09', 'Oficina de Mecatrônica Aplicada', 'Bloco C, Galpão 2'),
('AM10', 'Estúdio de Drones e Veículos Autônomos', 'Bloco D, Área Externa 02');

INSERT INTO pesquisador (matricula, nome, titulacao, area_atuacao) VALUES
('PQ01', 'Dr. Alexandre Portela', 'Doutorado', 'Robótica Manipuladora'),
('PQ02', 'Dra. Patricia Medeiros', 'Doutorado', 'Redes de Sensores e IoT'),
('PQ03', 'Me. Gabriel Justino', 'Mestrado', 'Sistemas Embarcados'),
('PQ04', 'Dra. Letícia Linhares', 'Doutorado', 'Visão Computacional'),
('PQ05', 'Me. Bruno Guimarães', 'Mestrado', 'Inteligência Artificial'),
('PQ06', 'Dr. Fernando Albuquerque', 'Doutorado', 'Veículos Autônomos'),
('PQ07', 'Esp. Cíntia Nogueira', 'Especialização', 'Automação Predial'),
('PQ08', 'Dr. Ricardo Fagundes', 'Doutorado', 'Processamento de Sinais'),
('PQ09', 'Me. Vanessa Cavalcanti', 'Mestrado', 'Sistemas Ciber-físicos'),
('PQ10', 'Dr. Igor Valente', 'Doutorado', 'Controle e Automação');

INSERT INTO dispositivo (identificador, tipo, fabricante, modelo, data_aquisicao) VALUES
('DSP01', 'Braço Robótico', 'KUKA', 'KR 6 R900', '2022-03-15'),
('DSP02', 'Braço Robótico', 'Universal Robots', 'UR5e', '2023-01-20'),
('DSP03', 'Sensor Ultrassônico', 'Arduino', 'HC-SR04', '2024-05-10'),
('DSP04', 'Módulo Câmera Inteligente', 'Raspberry Pi', 'Camera Module 3', '2023-06-12'),
('DSP05', 'Placa de Desenvolvimento', 'Espressif', 'ESP32-WROOM', '2024-02-18'),
('DSP06', 'Sensor de Umidade e Temp', 'Bosch', 'BME280', '2024-03-01'),
('DSP07', 'Microcontrolador Avançado', 'STMicroelectronics', 'STM32F4', '2022-11-14'),
('DSP08', 'Gateway Industrial IoT', 'Siemens', 'SIMATIC IOT2050', '2023-09-05'),
('DSP09', 'Drone de Pesquisa', 'DJI', 'Matrice 300 RTK', '2024-01-10'),
('DSP10', 'Lidar 3D Scanner', 'Velodyne', 'Puck VLP-16', '2023-07-22');

INSERT INTO experimento (codigo, ambiente_codigo) VALUES
('EXP01', 'AM01'),
('EXP02', 'AM02'),
('EXP03', 'AM03'),
('EXP04', 'AM05'),
('EXP05', 'AM01'),
('EXP06', 'AM02'),
('EXP07', 'AM06'),
('EXP08', 'AM07'),
('EXP09', 'AM10'),
('EXP10', 'AM08');

INSERT INTO pesquisador_experimento (pesquisador_matricula, experimento_codigo) VALUES
('PQ01', 'EXP01'),
('PQ03', 'EXP01'),
('PQ02', 'EXP02'),
('PQ09', 'EXP02'),
('PQ03', 'EXP03'),
('PQ04', 'EXP04'),
('PQ01', 'EXP05'),
('PQ05', 'EXP08'),
('PQ06', 'EXP09'),
('PQ07', 'EXP10');

INSERT INTO dispositivo_experimento (dispositivo_id, experimento_codigo) VALUES
('DSP01', 'EXP01'),
('DSP02', 'EXP05'),
('DSP03', 'EXP02'),
('DSP05', 'EXP02'),
('DSP06', 'EXP02'),
('DSP07', 'EXP03'),
('DSP04', 'EXP04'),
('DSP08', 'EXP06'),
('DSP09', 'EXP09'),
('DSP10', 'EXP09');

INSERT INTO evento_experimento (id, experimento_codigo, dispositivo_id, data_hora, tipo, prioridade) VALUES
('EV01', 'EXP02', 'DSP05', '2026-06-15 10:30:00', 'Conexão Estabelecida', 'Baixa'),
('EV02', 'EXP02', 'DSP06', '2026-06-15 10:35:12', 'Leitura de Telemetria', 'Baixa'),
('EV03', 'EXP01', 'DSP01', '2026-06-16 14:02:45', 'Início de Ciclo G-Code', 'Média'),
('EV04', 'EXP04', 'DSP04', '2026-06-16 16:20:00', 'Captura de Frame OK', 'Baixa'),
('EV05', 'EXP02', 'DSP05', '2026-06-17 02:11:03', 'Queda de Sinal Wi-Fi', 'Alta'),
('EV06', 'EXP09', 'DSP09', '2026-06-18 09:00:00', 'Decolagem Autônoma', 'Média'),
('EV07', 'EXP09', 'DSP10', '2026-06-18 09:05:22', 'Mapeamento de Nuvem 3D', 'Baixa'),
('EV08', 'EXP01', 'DSP01', '2026-06-19 11:44:10', 'Sobrecarga de Junta Interrompida', 'Crítica'),
('EV09', 'EXP03', 'DSP07', '2026-06-20 15:30:00', 'Reset por Watchdog', 'Alta'),
('EV10', 'EXP06', 'DSP08', '2026-06-21 08:00:00', 'Sincronização de Logs Nuvem', 'Baixa');

INSERT INTO execucao_tarefa_robo (id, dispositivo_id, experimento_codigo, tarefa_realizada, horario_inicio, horario_termino, resultado_obtido) VALUES
('TR01', 'DSP01', 'EXP01', 'Soldagem de Chassi de Alumínio estrutural', '08:30:00', '08:45:12', 'Sucesso: Cordão de solda uniforme sem bolhas'),
('TR02', 'DSP01', 'EXP01', 'Paletização de Caixas de Teste 5kg', '09:00:00', '09:30:00', 'Sucesso: 20 unidades organizadas perfeitamente'),
('TR03', 'DSP02', 'EXP05', 'Pick and Place de Componentes Eletrônicos', '14:15:00', '14:22:10', 'Sucesso: Precisão milimétrica garantida'),
('TR04', 'DSP02', 'EXP05', 'Aplicação de Adesivo Líquido Vedante', '15:00:00', '15:05:40', 'Falha: Obstrução parcial do bico ejetor'),
('TR05', 'DSP01', 'EXP01', 'Polimento de Superfície Esférica Metálica', '16:00:00', '16:45:00', 'Sucesso: Rugosidade dentro da tolerância esperada'),
('TR06', 'DSP09', 'EXP09', 'Inspeção Visual de Linha de Alta Tensão', '10:00:00', '10:35:00', 'Sucesso: Identificado ponto de aquecimento'),
('TR07', 'DSP02', 'EXP05', 'Parafusamento de Tampa Protetora ABS', '11:20:00', '11:28:15', 'Sucesso: Torque ideal de 3Nm atingido'),
('TR08', 'DSP01', 'EXP01', 'Movimentação em Trajetória Singular Complexa', '13:00:00', '13:02:11', 'Falha: Interrupção automática por limite de software'),
('TR09', 'DSP09', 'EXP09', 'Varredura de Obstáculos de Solo com Lidar', '15:30:00', '16:00:00', 'Sucesso: Renderização em tempo real executada'),
('TR10', 'DSP02', 'EXP05', 'Montagem de Kit de Sensores Educacionais', '16:30:00', '17:15:00', 'Sucesso: 10 kits finalizados sem erros de encaixe');

ALTER TABLE dispositivo ADD status_operacional VARCHAR(20) DEFAULT 'Ativo';
ALTER TABLE pesquisador CHANGE titulacao grau_academico VARCHAR(50);
ALTER TABLE ambiente CHANGE localizacao bloco_sala VARCHAR(120);
ALTER TABLE evento_experimento CHANGE prioridade nivel_criticidade VARCHAR(30);

-- 1: Listar pesquisadores com Doutorado e suas áreas de atuação.
-- Importância: Mapear os especialistas sêniores do laboratório para liderança de projetos.
SELECT nome, area_atuacao FROM pesquisador WHERE grau_academico = 'Doutorado';

-- 2: Contar a quantidade de dispositivos separados por fabricante.
-- Importância: Análise de dependência de fornecedores para futuras licitações de compras.
SELECT fabricante, COUNT(identificador) AS total_dispositivos 
FROM dispositivo 
GROUP BY fabricante;

-- 3: Listar os experimentos alocados na 'Sala 102' (AM01) e seus dispositivos.
-- Importância: Controle de inventário para evitar conflitos de reserva de equipamentos na mesma sala.
SELECT e.codigo AS experimento, d.tipo, d.modelo 
FROM dispositivo_experimento de
JOIN experimento e ON de.experimento_codigo = e.codigo
JOIN dispositivo d ON de.dispositivo_id = d.identificador
WHERE e.ambiente_codigo = 'AM01';

-- 4: Mostrar todos os eventos experimentais com nível de criticidade 'Crítica' ou 'Alta'.
-- Importância: Detecção rápida de falhas graves e prevenção de acidentes com os robôs.
SELECT data_hora, tipo, nivel_criticidade 
FROM evento_experimento 
WHERE nivel_criticidade IN ('Alta', 'Crítica') 
ORDER BY data_hora DESC;

-- 5: Identificar quais pesquisadores estão trabalhando no experimento 'EXP02'.
-- Importância: Controle de acesso e responsabilização pelo uso dos dados do experimento.
SELECT p.nome, p.area_atuacao 
FROM pesquisador_experimento pe
JOIN pesquisador p ON pe.pesquisador_matricula = p.matricula
WHERE pe.experimento_codigo = 'EXP02';

-- 6: Listar as tarefas de robôs que resultaram em 'Falha'.
-- Importância: Levantar dados para refatoração do código dos robôs ou calibração mecânica.
SELECT dispositivo_id, tarefa_realizada, resultado_obtido 
FROM execucao_tarefa_robo 
WHERE resultado_obtido LIKE 'Falha%';

-- 7: Mostrar o tempo total (em minutos) de operação das tarefas do robô 'DSP01'.
-- Importância: Cálculo de MTBF (Tempo Médio Entre Falhas) para programar manutenção preventiva.
SELECT tarefa_realizada, TIMESTAMPDIFF(MINUTE, horario_inicio, horario_termino) AS duracao_minutos 
FROM execucao_tarefa_robo 
WHERE dispositivo_id = 'DSP01';

-- 8: Encontrar ambientes que não possuem experimentos ativos.
-- Importância: Otimização de espaço físico, indicando salas livres para novos projetos.
SELECT a.nome, a.bloco_sala 
FROM ambiente a
LEFT JOIN experimento e ON a.codigo = e.ambiente_codigo
WHERE e.codigo IS NULL;

-- 9: Exibir a linha do tempo de eventos de um dispositivo IoT específico ('DSP05').
-- Importância: Auditoria técnica para debugar problemas de conexão do dispositivo.
SELECT data_hora, tipo, nivel_criticidade 
FROM evento_experimento 
WHERE dispositivo_id = 'DSP05' 
ORDER BY data_hora ASC;

-- 10: Listar os dispositivos adquiridos no ano de 2024.
-- Importância: Fechamento de balanço patrimonial e controle de garantia de fábrica.
SELECT identificador, tipo, modelo 
FROM dispositivo 
WHERE YEAR(data_aquisicao) = 2024;