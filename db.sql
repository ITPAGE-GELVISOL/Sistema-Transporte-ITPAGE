-- ============================================================
-- Script PostgreSQL gerado a partir do diagrama ER
-- ============================================================

-- ------------------------------------------------------------
-- tb01_perfil
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tb01_perfil (
    id          SERIAL PRIMARY KEY,
    descricao   VARCHAR(100) NOT NULL UNIQUE
);
insert into tb01_perfil(descricao) VALUES ('Admin'),('Secretaria'),('Motorista');


-- ------------------------------------------------------------
-- tb02_funcionario
-- Depende de: tb01_perfil
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tb02_funcionario (
    id          SERIAL PRIMARY KEY,
    id_perfil   INT NOT NULL REFERENCES tb01_perfil(id) ON DELETE RESTRICT,
    nome        VARCHAR(255) NOT NULL,
    telefone    VARCHAR(50) UNIQUE,
    senha_hash  VARCHAR(255) NOT NULL,
    salt_hash   VARCHAR(255) NOT NULL,
    estado      BOOLEAN      NOT NULL DEFAULT TRUE
);

-- ------------------------------------------------------------
-- tb03_veiculo
-- Depende de: tb02_funcionario (id_admin = funcionário administrador)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tb03_veiculo (
    id          SERIAL PRIMARY KEY,
    id_admin    INT NOT NULL REFERENCES tb02_funcionario(id) ON DELETE RESTRICT,
    marca       VARCHAR(100),
    matricula   VARCHAR(50)  NOT NULL UNIQUE,
    estado      BOOLEAN      NOT NULL DEFAULT TRUE
);

-- ------------------------------------------------------------
-- tb04_veiculo_motorista  (tabela de associação)
-- Depende de: tb03_veiculo, tb02_funcionario (motorista)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tb04_veiculo_motorista (
    id SERIAL PRIMARY KEY,
    id_veiculo   INT NOT NULL REFERENCES tb03_veiculo(id) ON DELETE CASCADE,
    id_motorista INT NOT NULL REFERENCES tb02_funcionario(id) ON DELETE CASCADE,
    UNIQUE(id_veiculo, id_motorista)
);

-- ------------------------------------------------------------
-- tb05_aluno
-- Depende de: tb03_veiculo, tb02_funcionario (secretaria)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tb05_aluno (
    id             SERIAL PRIMARY KEY,
    id_veiculo     INT NOT NULL REFERENCES tb03_veiculo(id) ON DELETE SET NULL,
    id_secretaria  INT NOT NULL REFERENCES tb02_funcionario(id) ON DELETE RESTRICT,
    nome           VARCHAR(255) NOT NULL,
    telefone       VARCHAR(50) UNIQUE,
    foto           VARCHAR(500),
    estado         BOOLEAN NOT NULL DEFAULT TRUE
);

-- ------------------------------------------------------------
-- tb06_cobranca
-- Depende de: tb02_funcionario (admin)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tb06_cobranca (
    id SERIAL PRIMARY KEY,
    id_admin INT NOT NULL REFERENCES tb02_funcionario(id) ON DELETE RESTRICT,
    cobranca TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ------------------------------------------------------------
-- tb07_pagamento
-- Depende de: tb02_funcionario (secretaria), tb06_cobranca, 
tb05_aluno
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tb07_pagamento (
    id SERIAL PRIMARY KEY,
    id_secretaria INT NOT NULL REFERENCES tb02_funcionario(id) ON DELETE RESTRICT,
    id_cobranca INT NOT NULL REFERENCES tb06_cobranca(id) ON DELETE RESTRICT,
    id_aluno INT NOT NULL REFERENCES tb05_aluno(id) ON DELETE RESTRICT,
    data TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP    
);

