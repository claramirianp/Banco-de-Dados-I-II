-- ============================================================
-- TESTE DE DESEMPENHO: innodb_flush_log_at_trx_commit
-- MySQL / InnoDB
--
-- Objetivo:
-- Executar muitas transações pequenas, cada uma contendo:
--     INSERT
--     COMMIT
--
-- Execute este mesmo script separadamente com:
--     innodb_flush_log_at_trx_commit = 1
--     innodb_flush_log_at_trx_commit = 0
--     innodb_flush_log_at_trx_commit = 2
--
-- ============================================================


DROP DATABASE IF EXISTS teste_redo_commit;
CREATE DATABASE teste_redo_commit;
USE teste_redo_commit;


CREATE TABLE registros (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    codigo INT NOT NULL,
    descricao VARCHAR(100) NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    criado_em DATETIME(6) NOT NULL,
    PRIMARY KEY (id)
) ENGINE=InnoDB;


-- Quantidade de INSERTs/COMMITs.
-- Comece com 10000.
-- Se terminar rápido demais na sua máquina, teste 100000 ou 500000.
SET @quantidade_registros = 10000;


DELIMITER $$

DROP PROCEDURE IF EXISTS executar_teste_commit $$

CREATE PROCEDURE executar_teste_commit(IN total INT)
BEGIN
    DECLARE i INT DEFAULT 1;

    WHILE i <= total DO

        START TRANSACTION;

        INSERT INTO registros
            (codigo, descricao, valor, criado_em)
        VALUES
            (
                i,
                CONCAT('Registro de teste número ', i),
                (i MOD 10000) / 100,
                NOW(6)
            );

        COMMIT;

        SET i = i + 1;

    END WHILE;
END $$

DELIMITER ;


-- ------------------------------------------------------------
-- MÉTRICAS ANTES DO TESTE
-- ------------------------------------------------------------

SELECT
    @@GLOBAL.innodb_flush_log_at_trx_commit
        AS innodb_flush_log_at_trx_commit,
    @quantidade_registros
        AS quantidade_de_transacoes;

SHOW GLOBAL STATUS LIKE 'Innodb_data_fsyncs';
SHOW GLOBAL STATUS LIKE 'Innodb_os_log_written';


-- ------------------------------------------------------------
-- EXECUÇÃO E MEDIÇÃO DO TEMPO
-- ------------------------------------------------------------

SET @inicio = NOW(6);

CALL executar_teste_commit(@quantidade_registros);

SET @fim = NOW(6);


-- ------------------------------------------------------------
-- RESULTADO
-- ------------------------------------------------------------

SELECT
    @inicio AS inicio,
    @fim AS fim,
    TIMESTAMPDIFF(MICROSECOND, @inicio, @fim) / 1000000
        AS tempo_total_segundos,
    @quantidade_registros
        AS total_de_commits,
    ROUND(
        @quantidade_registros /
        (TIMESTAMPDIFF(MICROSECOND, @inicio, @fim) / 1000000),
        2
    ) AS commits_por_segundo;


SELECT COUNT(*) AS registros_inseridos
FROM registros;


-- ------------------------------------------------------------
-- MÉTRICAS DEPOIS DO TESTE
-- ------------------------------------------------------------

SHOW GLOBAL STATUS LIKE 'Innodb_data_fsyncs';
SHOW GLOBAL STATUS LIKE 'Innodb_os_log_written';


-- ------------------------------------------------------------
-- LIMPEZA OPCIONAL
-- ------------------------------------------------------------
-- DROP DATABASE teste_redo_commit;

SHOW VARIABLES LIKE 'innodb_buffer_pool_size';

SHOW STATUS LIKE 'Innodb_buffer_pool_read_requests';
SHOW STATUS LIKE 'Innodb_buffer_pool_reads';
SHOW STATUS LIKE 'Innodb_buffer_pool_pages_free';
SHOW STATUS LIKE 'Innodb_buffer_pool_pages_total';

-- Hit Ratio = (1 - (Innodb_buffer_pool_reads / Innodb_buffer_pool_read_requests)) × 100
-- Hit Ratio =  (1 - (1030 / 19638)) x 100
-- Hit Ratio = 94,7550667
-- % Livres = (Innodb_buffer_pool_pages_free / Innodb_buffer_pool_pages_total) × 100
-- % Livres = ( 6998 / 8192 ) x 100 
-- % Livres = 85,424804688

SET GLOBAL innodb_flush_log_at_trx_commit = 1;

SHOW VARIABLES LIKE 'innodb_flush_log_at_trx_commit';
-- 128MB
-- Hit Ratio = (1 - (Innodb_buffer_pool_reads / Innodb_buffer_pool_read_requests)) × 100
-- Hit Ratio =  (1 - ( 1027 / 17001 )) x 100
-- Hit Ratio = 93,9591789
-- % Livres = (Innodb_buffer_pool_pages_free / Innodb_buffer_pool_pages_total) × 100
-- % Livres = ( 64356 / 65536 ) x 100 
-- % Livres = 98,199462891

-- 1G
-- Hit Ratio = (1 - (Innodb_buffer_pool_reads / Innodb_buffer_pool_read_requests)) × 100
-- Hit Ratio =  (1 - ( 1049 / 83433 )) x 100
-- Hit Ratio = 98,7427037
-- % Livres = (Innodb_buffer_pool_pages_free / Innodb_buffer_pool_pages_total) × 100
-- % Livres = ( 64278 / 65536 ) x 100 
-- % Livres = 98,080444336

SHOW GLOBAL STATUS LIKE 'Innodb_os_log_written';
SHOW STATUS LIKE 'Innodb_redo_log_logical_size';
SELECT * FROM performance_schema.global_status WHERE VARIABLE_NAME LIKE '%redo_log%';
SHOW VARIABLES LIKE 'innodb_redo_log_capacity';

SET GLOBAL local_infile = 1;
USE teste_redo_commit;
USE teste_redo_commit;

CREATE TABLE user_behavior (
    csv_index BIGINT UNSIGNED,
    user_id CHAR(9) NOT NULL,
    session_id VARCHAR(100) NOT NULL,
    app_id CHAR(10) NOT NULL,
    session_duration_minutes FLOAT,
    daily_usage_time_minutes FLOAT,
    clicks INT UNSIGNED,
    scrolls INT UNSIGNED,
    retention_days INT UNSIGNED,
    uninstall_flag TINYINT UNSIGNED,
    interaction_timestamp VARCHAR(20),
    engagement_score FLOAT,
    churn_prediction_score FLOAT,
    anomaly_behavior_flag TINYINT UNSIGNED,
    fraud_detection_signal TINYINT UNSIGNED,
    screen_views INT UNSIGNED,
    notification_clicked VARCHAR(5)
);

LOAD DATA LOCAL INFILE '/home/cm/Downloads/user_behavior.csv'
INTO TABLE user_behavior
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) FROM user_behavior;
SHOW DATABASES;

