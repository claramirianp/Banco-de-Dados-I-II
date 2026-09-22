-- ATIVIDADE PRATICA: innodb_flush_log_at_trx_commit
-- DROP DATABASE IF EXISTS atividade_transacoes;
-- CREATE DATABASE atividade_transacoes;
USE atividade_transacoes;

CREATE TABLE vendas (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    codigo_cliente INT NOT NULL,
    produto VARCHAR(100) NOT NULL,
    quantidade INT NOT NULL,
    valor_unitario DECIMAL(10,2) NOT NULL,
    data_venda DATETIME(6) NOT NULL,
    PRIMARY KEY (id)
) ENGINE=InnoDB;

SET @quantidade_transacoes = 10000;

DELIMITER $$
DROP PROCEDURE IF EXISTS executar_carga $$
CREATE PROCEDURE executar_carga(IN total INT)
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= total DO
        START TRANSACTION;
        INSERT INTO vendas
            (codigo_cliente, produto, quantidade, valor_unitario, data_venda)
        VALUES
            ((i MOD 5000) + 1,
             CONCAT('Produto ', (i MOD 500) + 1),
             (i MOD 10) + 1,
             ((i MOD 10000) + 100) / 100,
             NOW(6));
        COMMIT;
        SET i = i + 1;
    END WHILE;
END $$
DELIMITER ;

-- Confirme o valor usado nesta rodada.
SELECT
    @@GLOBAL.innodb_flush_log_at_trx_commit AS innodb_flush_log_at_trx_commit,
    @quantidade_transacoes AS quantidade_de_transacoes;

-- Anote as metricas ANTES.
SHOW GLOBAL STATUS LIKE 'Innodb_data_fsyncs';
SHOW GLOBAL STATUS LIKE 'Innodb_os_log_written';

-- Executa e cronometra a carga.
SET @inicio = NOW(6);
CALL executar_carga(@quantidade_transacoes);
SET @fim = NOW(6);

SELECT
    @inicio AS inicio,
    @fim AS fim,
    ROUND(TIMESTAMPDIFF(MICROSECOND, @inicio, @fim) / 1000000, 4)
        AS tempo_total_segundos,
    @quantidade_transacoes AS total_de_commits,
    ROUND(
        @quantidade_transacoes /
        (TIMESTAMPDIFF(MICROSECOND, @inicio, @fim) / 1000000), 2
    ) AS commits_por_segundo;

SELECT COUNT(*) AS registros_inseridos FROM vendas;

-- Anote as metricas DEPOIS.
SHOW GLOBAL STATUS LIKE 'Innodb_data_fsyncs';
SHOW GLOBAL STATUS LIKE 'Innodb_os_log_written';

-- Repita o script completo para cada valor solicitado pelo professor:
-- innodb_flush_log_at_trx_commit = 1, 0 e 2.
-- Mantenha a mesma quantidade de transacoes em todas as rodadas.

-- DROP DATABASE atividade_transacoes;
SELECT @@GLOBAL.innodb_flush_log_at_trx_commit;