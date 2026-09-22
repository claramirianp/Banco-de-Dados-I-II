DROP DATABASE IF EXISTS sistema_academia;
CREATE DATABASE IF NOT EXISTS sistema_academia;
use sistema_academia;

CREATE TABLE unidade_academia (
  codigo VARCHAR(10),
  nome VARCHAR(100),
  endereco VARCHAR(150),
  gerente_responsavel VARCHAR(100),
  data_assuncao_gerente DATE,
  PRIMARY KEY(codigo)
);

CREATE TABLE funcionario_academia (
  matricula VARCHAR(10),
  nome VARCHAR(100),
  endereco VARCHAR(150),
  telefone VARCHAR(20),
  salario DECIMAL(10,2),
  data_admissao DATE,
  cargo VARCHAR(40), -- ex: instrutor, nutricionista, fisioterapeuta, recepcionista
  especialidade VARCHAR(60), -- preenchido quando aplicável
  unidade_codigo VARCHAR(10),
  PRIMARY KEY(matricula),
  FOREIGN KEY(unidade_codigo) REFERENCES unidade_academia(codigo)
);

CREATE TABLE plano_treinamento (
  codigo VARCHAR(10),
  nome VARCHAR(60),
  valor_mensal DECIMAL(6,2),
  duracao_contratual VARCHAR(30),
  beneficios_associados TEXT,
  PRIMARY KEY(codigo)
);

CREATE TABLE aluno (
  codigo_unico VARCHAR(10),
  matricula VARCHAR(20),
  nome VARCHAR(100),
  data_nascimento DATE,
  endereco VARCHAR(150),
  telefone VARCHAR(20),
  data_ingresso DATE,
  plano_codigo VARCHAR(10),
  PRIMARY KEY(codigo_unico),
  FOREIGN KEY(plano_codigo) REFERENCES plano_treinamento(codigo)
);

CREATE TABLE historico_plano_aluno (
  id VARCHAR(10),
  aluno_codigo VARCHAR(10),
  plano_anterior VARCHAR(10),
  plano_novo VARCHAR(10),
  data_alteracao DATE,
  PRIMARY KEY(id),
  FOREIGN KEY(aluno_codigo) REFERENCES aluno(codigo_unico)
);

CREATE TABLE ficha_treino_cabecalho (
  id VARCHAR(10),
  aluno_codigo VARCHAR(10),
  instrutor_matricula VARCHAR(10),
  data_criacao DATE,
  PRIMARY KEY(id),
  FOREIGN KEY(aluno_codigo) REFERENCES aluno(codigo_unico),
  FOREIGN KEY(instrutor_matricula) REFERENCES funcionario_academia(matricula)
);

CREATE TABLE exercicio (
  codigo VARCHAR(10),
  nome VARCHAR(60),
  PRIMARY KEY(codigo)
);

CREATE TABLE ficha_exercicio (
  ficha_id VARCHAR(10),
  exercicio_codigo VARCHAR(10),
  numero_series INTEGER,
  repeticoes INTEGER,
  carga VARCHAR(20),
  tempo_descanso VARCHAR(20),
  PRIMARY KEY(ficha_id, exercicio_codigo),
  FOREIGN KEY(ficha_id) REFERENCES ficha_treino_cabecalho(id),
  FOREIGN KEY(exercicio_codigo) REFERENCES exercicio(codigo)
);

CREATE TABLE modalidade (
  codigo VARCHAR(10),
  nome VARCHAR(50), -- ex: musculação, pilates, spinning, natação
  PRIMARY KEY(codigo)
);

CREATE TABLE modalidade_instrutor (
  modalidade_codigo VARCHAR(10),
  instrutor_matricula VARCHAR(10),
  PRIMARY KEY(modalidade_codigo, instrutor_matricula),
  FOREIGN KEY(modalidade_codigo) REFERENCES modalidade(codigo),
  FOREIGN KEY(instrutor_matricula) REFERENCES funcionario_academia(matricula)
);

CREATE TABLE aula_agenda (
  id VARCHAR(10),
  modalidade_codigo VARCHAR(10),
  horario_especifico TIMESTAMP,
  limite_maximo_participantes INTEGER,
  PRIMARY KEY(id),
  FOREIGN KEY(modalidade_codigo) REFERENCES modalidade(codigo)
);

CREATE TABLE inscricao_aula (
  aluno_codigo VARCHAR(10),
  aula_id VARCHAR(10),
  PRIMARY KEY(aluno_codigo, aula_id),
  FOREIGN KEY(aluno_codigo) REFERENCES aluno(codigo_unico),
  FOREIGN KEY(aula_id) REFERENCES aula_agenda(id)
);

CREATE TABLE frequencia_aluno (
  id VARCHAR(10),
  aluno_codigo VARCHAR(10),
  data_participacao TIMESTAMP,
  PRIMARY KEY(id),
  FOREIGN KEY(aluno_codigo) REFERENCES aluno(codigo_unico)
);

CREATE TABLE avaliacao_fisica (
  id VARCHAR(10),
  aluno_codigo VARCHAR(10),
  profissional_matricula VARCHAR(10), -- nutricionista ou fisioterapeuta
  data_avaliacao DATE,
  peso DECIMAL(5,2),
  altura DECIMAL(3,2),
  percentual_gordura DECIMAL(4,2),
  massa_muscular DECIMAL(5,2),
  observacoes TEXT,
  PRIMARY KEY(id),
  FOREIGN KEY(aluno_codigo) REFERENCES aluno(codigo_unico),
  FOREIGN KEY(profissional_matricula) REFERENCES funcionario_academia(matricula)
);

INSERT INTO unidade_academia (codigo, nome, endereco, gerente_responsavel, data_assuncao_gerente) VALUES
('UN01', 'Academia TopFit Centro', 'Rua Principal, 100 - Centro', 'Marcos Roberto Santos', '2020-01-10'),
('UN02', 'Academia TopFit Zona Sul', 'Av. Atlântica, 450 - Praia', 'Juliana Maria Alencar', '2021-06-15'),
('UN03', 'Academia TopFit Norte', 'Rua das Flores, 880 - Industrial', 'Ricardo Fonseca Silva', '2022-03-01'),
('UN04', 'Academia TopFit Jardins', 'Alameda Lorena, 1200 - Jardins', 'Patricia Costa Ramos', '2019-11-20'),
('UN05', 'Academia TopFit Oeste', 'Av. das Nações, 3100 - Pinheiros', 'Daniel Alves Peixoto', '2023-02-15'),
('UN06', 'Academia TopFit Premium', 'Av. Paulista, 2000 - Bela Vista', 'Amanda Borges Lima', '2024-01-05'),
('UN07', 'Academia TopFit Express', 'Rua Bahia, 45 - Savassi', 'Felipe Vieira Castro', '2023-08-22'),
('UN08', 'Academia TopFit Club', 'Av. do Contorno, 6500 - Lourdes', 'Bruna Mendes Rocha', '2021-10-10'),
('UN09', 'Academia TopFit FitBox', 'Rua Piauí, 112 - Funcionários', 'Gustavo Nunes Melo', '2024-05-12'),
('UN10', 'Academia TopFit Cross', 'Av. Brasil, 99 - Santa Efigênia', 'Rodrigo Neves Souza', '2022-07-19');

INSERT INTO funcionario_academia (matricula, nome, endereco, telefone, salario, data_admissao, cargo, especialidade, unidade_codigo) VALUES
('FUN01', 'Arthur Zanetti', 'Rua A, 12', '(11) 98888-1111', 3500.00, '2021-02-10', 'Instrutor', 'Musculação e Hipertrofia', 'UN01'),
('FUN02', 'Diego Hypolito', 'Rua B, 34', '(11) 98888-2222', 3200.00, '2022-05-15', 'Instrutor', 'Treinamento Funcional', 'UN01'),
('FUN03', 'Mayra Aguiar', 'Av. X, 56', '(21) 97777-3333', 4200.00, '2020-08-20', 'Fisioterapeuta', 'Reabilitação Esportiva', 'UN02'),
('FUN04', 'Robert Scheidt', 'Rua C, 78', '(11) 96666-4444', 4500.00, '2019-03-01', 'Nutricionista', 'Nutrição Esportiva', 'UN04'),
('FUN05', 'Rebeca Andrade', 'Av. Y, 90', '(11) 95555-5555', 3100.00, '2023-01-10', 'Instrutor', 'Pilates e Flexibilidade', 'UN06'),
('FUN06', 'Cesar Cielo', 'Rua D, 11', '(11) 94444-6666', 3600.00, '2021-11-14', 'Instrutor', 'Natação e Cardio', 'UN02'),
('FUN07', 'Marta Vieira', 'Av. Z, 23', '(31) 93333-7777', 2200.00, '2023-06-01', 'Recepcionista', NULL, 'UN03'),
('FUN08', 'Ronaldo Nazário', 'Rua E, 45', '(31) 92222-8888', 2200.00, '2024-02-18', 'Recepcionista', NULL, 'UN01'),
('FUN09', 'Isaquias Queiroz', 'Av. W, 67', '(21) 91111-9999', 4000.00, '2022-09-05', 'Fisioterapeuta', 'Quiropraxia', 'UN05'),
('FUN10', 'Alison Dos Santos', 'Rua F, 89', '(11) 90000-0000', 3300.00, '2023-10-01', 'Instrutor', 'Cross Training', 'UN10');

INSERT INTO plano_treinamento (codigo, nome, valor_mensal, duracao_contratual, beneficios_associados) VALUES
('PL01', 'Plano Mensal Básico', 119.90, '1 Mês', 'Acesso à área de musculação de uma unidade única.'),
('PL02', 'Plano Trimestral Padrão', 99.90, '3 Meses', 'Acesso à musculação e área de cardio da unidade.'),
('PL03', 'Plano Semestral Ativo', 89.90, '6 Meses', 'Musculação, cardio e 1 modalidade coletiva.'),
('PL04', 'Plano Anual Gold', 79.90, '12 Meses', 'Livre acesso a musculação, cardio e todas as aulas.'),
('PL05', 'Plano Black Total', 149.90, '12 Meses', 'Acesso ilimitado a todas as unidades da rede + 1 convidado.'),
('PL06', 'Plano Premium Vip', 299.90, '12 Meses', 'Plano Black + 2 avaliações físicas e nutricionais por mês.'),
('PL07', 'Plano Estudante Universitário', 69.90, '6 Meses', 'Acesso exclusivo em horário de menor movimento (9h às 15h).'),
('PL08', 'Plano Corporativo Parceiro', 59.90, '12 Meses', 'Desconto folha corporativa. Musculação básica inclusa.'),
('PL09', 'Plano Sênior Ativo', 65.90, '1 Mês', 'Direcionado para +60 anos com hidroginástica inclusa.'),
('PL10', 'Plano Cross&Box Exclusivo', 189.90, '3 Meses', 'Acesso total às boxes de Crossfit e artes marciais.');

INSERT INTO aluno (codigo_unico, matricula, nome, data_nascimento, endereco, telefone, data_ingresso, plano_codigo) VALUES
('AL01', '20260001', 'Carlos Henrique Souza', '1995-04-12', 'Rua X, 10 - Centro', '(11) 91234-5678', '2026-01-05', 'PL05'),
('AL02', '20260002', 'Mariana Oliveira Reis', '1998-09-22', 'Av. Central, 450 - Sul', '(11) 92345-6789', '2026-01-10', 'PL04'),
('AL03', '20260003', 'João Gabriel Lima', '1990-01-30', 'Rua Piauí, 88 - Barroca', '(31) 93456-7890', '2026-02-01', 'PL01'),
('AL04', '20260004', 'Fernanda Mel Costa', '2002-11-15', 'Av. Contorno, 1200 - Lourdes', '(31) 94567-8901', '2026-02-15', 'PL07'),
('AL05', '20260005', 'Roberto Carlos Silva', '1975-06-08', 'Rua Rio de Janeiro, 33', '(11) 95678-9012', '2026-03-01', 'PL03'),
('AL06', '20260006', 'Aline Medeiros Ramos', '1988-03-19', 'Alameda Santos, 900', '(11) 96789-0123', '2026-03-10', 'PL06'),
('AL07', '20260007', 'Pedro Antunes Prado', '2000-07-25', 'Rua Ceará, 55 - Centro', '(31) 97890-1234', '2026-04-01', 'PL05'),
('AL08', '20260008', 'Camila Guimarães Neves', '1993-05-14', 'Rua Amazonas, 310', '(21) 98901-2345', '2026-04-12', 'PL02'),
('AL09', '20260009', 'Lucas Vinícius Borges', '1961-10-05', 'Rua Bahia, 770 - Savassi', '(31) 99012-3456', '2026-05-02', 'PL09'),
('AL10', '20260010', 'Beatriz Rocha Faria', '1997-12-25', 'Rua Paraíba, 13 - Funcionários', '(31) 90123-4567', '2026-05-18', 'PL10');

INSERT INTO historico_plano_aluno (id, aluno_codigo, plano_anterior, plano_novo, data_alteracao) VALUES
('HP01', 'AL01', 'PL01', 'PL05', '2026-02-05'),
('HP02', 'AL02', 'PL02', 'PL04', '2026-03-10'),
('HP03', 'AL06', 'PL05', 'PL06', '2026-04-15'),
('HP04', 'AL07', 'PL01', 'PL05', '2026-05-01'),
('HP05', 'AL03', 'PL02', 'PL01', '2026-05-20'),
('HP06', 'AL05', 'PL01', 'PL03', '2026-04-01'),
('HP07', 'AL04', 'PL01', 'PL07', '2026-03-15'),
('HP08', 'AL08', 'PL03', 'PL02', '2026-06-01'),
('HP09', 'AL10', 'PL04', 'PL10', '2026-06-10'),
('HP10', 'AL02', 'PL01', 'PL02', '2026-02-10');

INSERT INTO ficha_treino_cabecalho (id, aluno_codigo, instrutor_matricula, data_criacao) VALUES
('FCH01', 'AL01', 'FUN01', '2026-01-06'),
('FCH02', 'AL02', 'FUN01', '2026-01-11'),
('FCH03', 'AL03', 'FUN02', '2026-02-02'),
('FCH04', 'AL04', 'FUN02', '2026-02-16'),
('FCH05', 'AL05', 'FUN01', '2026-03-02'),
('FCH06', 'AL06', 'FUN05', '2026-03-12'),
('FCH07', 'AL07', 'FUN10', '2026-04-02'),
('FCH08', 'AL08', 'FUN02', '2026-04-13'),
('FCH09', 'AL09', 'FUN05', '2026-05-03'),
('FCH10', 'AL10', 'FUN10', '2026-05-19');

INSERT INTO exercicio (codigo, nome) VALUES
('EX01', 'Supino Reto com Barra'),
('EX02', 'Agachamento Livre com Barra'),
('EX03', 'Leg Press 45 Graus'),
('EX04', 'Puxada Aberta na Polia'),
('EX05', 'Rosca Direta com Halteres'),
('EX06', 'Tríceps Corda na Polia'),
('EX07', 'Elevação Lateral de Ombros'),
('EX08', 'Cadeira Extensora'),
('EX09', 'Mesa Flexora de Isquiotibiais'),
('EX10', 'Prancha Abdominal Isométrica');

INSERT INTO ficha_exercicio (ficha_id, exercicio_codigo, numero_series, repeticoes, carga, tempo_descanso) VALUES
('FCH01', 'EX01', 4, 10, '30kg cada lado', '60 segundos'),
('FCH01', 'EX04', 4, 12, '50kg total', '60 segundos'),
('FCH02', 'EX02', 4, 8, '20kg cada lado', '90 segundos'),
('FCH02', 'EX03', 3, 12, '140kg total', '60 segundos'),
('FCH03', 'EX05', 3, 15, '10kg por halter', '45 segundos'),
('FCH03', 'EX06', 3, 15, '25kg na polia', '45 segundos'),
('FCH05', 'EX01', 4, 12, '15kg cada lado', '60 segundos'),
('FCH05', 'EX08', 3, 15, '40kg totais', '45 segundos'),
('FCH07', 'EX02', 5, 5, '50kg cada lado', '120 segundos'),
('FCH10', 'EX10', 3, 1, 'Peso Corporal', '60 segundos');

INSERT INTO modalidade (codigo, nome) VALUES
('MD01', 'Musculação'),
('MD02', 'Pilates Solo'),
('MD03', 'Spinning Indoor'),
('MD04', 'Natação Livre'),
('MD05', 'Treinamento Funcional'),
('MD06', 'Crossfit Integrado'),
('MD07', 'Zumba Fitness'),
('MD08', 'Hidroginástica Senior'),
('MD09', 'Muay Thai'),
('MD10', 'Yoga e Meditação');

INSERT INTO modalidade_instrutor (modalidade_codigo, instrutor_matricula) VALUES
('MD01', 'FUN01'),
('MD01', 'FUN02'),
('MD02', 'FUN05'),
('MD03', 'FUN02'),
('MD04', 'FUN06'),
('MD05', 'FUN02'),
('MD05', 'FUN10'),
('MD06', 'FUN10'),
('MD08', 'FUN06'),
('MD10', 'FUN05');

INSERT INTO aula_agenda (id, modalidade_codigo, horario_especifico, limite_maximo_participantes) VALUES
('AU01', 'MD03', '2026-06-25 07:00:00', 25),
('AU02', 'MD02', '2026-06-25 08:30:00', 15),
('AU03', 'MD05', '2026-06-25 18:00:00', 30),
('AU04', 'MD06', '2026-06-25 19:15:00', 20),
('AU05', 'MD07', '2026-06-26 17:00:00', 40),
('AU06', 'MD09', '2026-06-26 20:00:00', 18),
('AU07', 'MD08', '2026-06-27 09:00:00', 20),
('AU08', 'MD10', '2026-06-27 10:30:00', 12),
('AU09', 'MD03', '2026-06-29 07:00:00', 25),
('AU10', 'MD06', '2026-06-29 19:15:00', 20);

INSERT INTO inscricao_aula (aluno_codigo, aula_id) VALUES
('AL01', 'AU01'),
('AL02', 'AU01'),
('AL04', 'AU02'),
('AL05', 'AU03'),
('AL06', 'AU02'),
('AL07', 'AU04'),
('AL08', 'AU01'),
('AL09', 'AU07'),
('AL10', 'AU04'),
('AL03', 'AU03');

INSERT INTO frequencia_aluno (id, aluno_codigo, data_participacao) VALUES
('FR01', 'AL01', '2026-06-24 06:45:10'),
('FR02', 'AL02', '2026-06-24 07:02:00'),
('FR03', 'AL03', '2026-06-24 12:15:44'),
('FR04', 'AL05', '2026-06-24 17:55:00'),
('FR05', 'AL07', '2026-06-24 19:00:12'),
('FR06', 'AL10', '2026-06-24 19:10:55'),
('FR07', 'AL04', '2026-06-25 08:15:00'),
('FR08', 'AL06', '2026-06-25 08:22:30'),
('FR09', 'AL08', '2026-06-25 06:55:18'),
('FR10', 'AL09', '2026-06-25 08:50:00');

INSERT INTO avaliacao_fisica (id, aluno_codigo, profissional_matricula, data_avaliacao, peso, altura, percentual_gordura, massa_muscular, observacoes) VALUES
('AV01', 'AL01', 'FUN04', '2026-01-05', 82.50, 1.78, 18.50, 38.20, 'Foco inicial em queima de gordura e adaptação'),
('AV02', 'AL02', 'FUN04', '2026-01-10', 64.00, 1.65, 24.10, 26.50, 'Objetivo definido: Hipertrofia de membros inferiores'),
('AV03', 'AL06', 'FUN03', '2026-03-10', 58.20, 1.62, 16.00, 28.00, 'Paciente atleta de alto rendimento. Sem queixas de dor'),
('AV04', 'AL01', 'FUN04', '2026-04-05', 79.90, 1.78, 14.20, 40.10, 'Excelente evolução. Redução de BF e ganho de massa magra'),
('AV05', 'AL08', 'FUN04', '2026-04-12', 71.30, 1.70, 28.50, 27.20, 'Início do cronograma alimentar voltado a déficit calórico'),
('AV06', 'AL09', 'FUN03', '2026-05-02', 88.00, 1.74, 32.00, 31.00, 'Aluno idoso. Foco total em mobilidade e ganho de força articular'),
('AV07', 'AL10', 'FUN04', '2026-05-18', 69.50, 1.68, 22.00, 30.50, 'Avaliação de bioimpedância estável. Pronto para rotina Cross'),
('AV08', 'AL02', 'FUN04', '2026-04-10', 65.50, 1.65, 21.00, 28.10, 'Evolução antropométrica satisfatória dentro da meta'),
('AV09', 'AL04', 'FUN03', '2026-02-15', 55.00, 1.60, 20.50, 24.00, 'Leve assimetria escapular identificada. Recomendado RPG'),
('AV10', 'AL03', 'FUN04', '2026-02-01', 95.00, 1.82, 29.90, 36.00, 'Condicionamento cardiovascular inicial classificado como baixo');

ALTER TABLE plano_treinamento ADD taxa_adesao DECIMAL(6,2) DEFAULT 0.00;
ALTER TABLE aluno CHANGE telefone celular_contato VARCHAR(25);
ALTER TABLE aula_agenda CHANGE limite_maximo_participantes vagas_totais SMALLINT;
ALTER TABLE avaliacao_fisica CHANGE observacoes parecer_clinico TEXT;

-- 1: Listar todas as unidades da academia e seus gerentes responsáveis.
-- Importância: Guia de contatos internos para a diretoria regional.
SELECT nome, gerente_responsavel, endereco FROM unidade_academia ORDER BY nome;

-- 2: Contar o número de alunos matriculados por plano de treinamento.
-- Importância: Identificar os planos mais lucrativos e populares para guiar o marketing.
SELECT p.nome AS plano, COUNT(a.codigo_unico) AS total_alunos
FROM aluno a
JOIN plano_treinamento p ON a.plano_codigo = p.codigo
GROUP BY p.nome;

-- 3: Mostrar funcionários que são Nutricionistas ou Fisioterapeutas.
-- Importância: Agendamento clínico e organização da agenda de serviços extras da academia.
SELECT nome, cargo, especialidade 
FROM funcionario_academia 
WHERE cargo IN ('Nutricionista', 'Fisioterapeuta');

-- 4: Buscar o histórico de trocas de plano do aluno 'AL01'.
-- Importância: Rastrear o comportamento de consumo (se fez upgrade ou downgrade do plano).
SELECT plano_anterior, plano_novo, data_alteracao 
FROM historico_plano_aluno 
WHERE aluno_codigo = 'AL01' 
ORDER BY data_alteracao DESC;

-- 5: Listar todos os exercícios que compõem a ficha de treino 'FCH01'.
-- Importância: Visualização do treino do aluno no aplicativo do celular da academia.
SELECT e.nome, fe.numero_series, fe.repeticoes, fe.carga 
FROM ficha_exercicio fe
JOIN exercicio e ON fe.exercicio_codigo = e.codigo
WHERE fe.ficha_id = 'FCH01';

-- 6: Obter as aulas agendadas para 'Crossfit Integrado' (MD06) com horários e vagas.
-- Importância: Alimentar a tela de reserva de vagas no aplicativo do aluno.
SELECT a.horario_especifico, a.vagas_totais 
FROM aula_agenda a
JOIN modalidade m ON a.modalidade_codigo = m.codigo
WHERE m.codigo = 'MD06';

-- 7: Mostrar alunos com percentual de gordura corporal menor que 20%.
-- Importância: Acompanhamento de metas avançadas de composição corporal pelos treinadores.
SELECT al.nome, av.percentual_gordura, av.parecer_clinico 
FROM avaliacao_fisica av
JOIN aluno al ON av.aluno_codigo = al.codigo_unico
WHERE av.percentual_gordura < 20.00;

-- 8: Verificar a frequência (check-in) de todos os alunos na data '2026-06-24'.
-- Importância: Mapear horários de pico para otimizar o ar-condicionado, limpeza e equipe no salão.
SELECT al.nome, fa.data_participacao 
FROM frequencia_aluno fa
JOIN aluno al ON fa.aluno_codigo = al.codigo_unico
WHERE DATE(fa.data_participacao) = '2026-06-24';

-- 9: Identificar quem são os instrutores autorizados a dar aulas de 'Pilates Solo'.
-- Importância: Substituição de professores em caso de faltas, garantindo que o substituto tenha qualificação.
SELECT f.nome 
FROM modalidade_instrutor mi
JOIN funcionario_academia f ON mi.instrutor_matricula = f.matricula
JOIN modalidade m ON mi.modalidade_codigo = m.codigo
WHERE m.nome = 'Pilates Solo';

-- 10: Calcular a receita bruta MENSAL ESTIMADA baseada nos alunos ativos.
-- Importância: Fluxo de caixa corporativo e previsão de faturamento do mês atual.
SELECT SUM(p.valor_mensal) AS receita_mensal_estimada 
FROM aluno a
JOIN plano_treinamento p ON a.plano_codigo = p.codigo;