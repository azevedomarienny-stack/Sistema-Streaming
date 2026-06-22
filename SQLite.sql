PRAGMA foreign_keys = ON;

CREATE TABLE perfis_acesso (
    id_perfil INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_perfil TEXT NOT NULL UNIQUE,
    descricao TEXT
);

CREATE TABLE planos (
    id_plano INTEGER PRIMARY KEY,
    nome_plano TEXT NOT NULL UNIQUE,
    valor REAL NOT NULL CHECK(valor >= 0),
    quantidade_telas INTEGER NOT NULL CHECK(quantidade_telas > 0)
);

CREATE TABLE usuarios (
    id_usuario INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    senha TEXT NOT NULL,
    data_nascimento DATE NOT NULL,
    id_plano INTEGER,
    id_perfil INTEGER NOT NULL,
    ativo INTEGER DEFAULT 1,
    logado INTEGER DEFAULT 0,

    FOREIGN KEY (id_plano) REFERENCES planos(id_plano),
    FOREIGN KEY (id_perfil) REFERENCES perfis_acesso(id_perfil)
);

CREATE TABLE perfis_streaming (
    id_perfil_streaming INTEGER PRIMARY KEY AUTOINCREMENT,
    id_usuario INTEGER NOT NULL,
    nome_perfil_streaming TEXT NOT NULL,
    tipo_perfil TEXT DEFAULT 'Adulto'
        CHECK(tipo_perfil IN ('Adulto','Infantil')),

    UNIQUE(id_usuario, nome_perfil_streaming),

    FOREIGN KEY (id_usuario)
        REFERENCES usuarios(id_usuario)
        ON DELETE CASCADE
);

INSERT INTO perfis_acesso (nome_perfil, descricao)
VALUES
('Admin', 'Gerenciamento Total do Sistema'),
('Cliente', 'Acesso aos Conteudos de Streaming');

INSERT INTO planos
(id_plano, nome_plano, valor, quantidade_telas)
VALUES
(1, 'Premium', 20.99, 4),
(2, 'Comum', 14.99, 2),
(3, 'Basico', 9.99, 1),
(4, 'Familia', 29.99, 3),
(5, 'Ultra 4K', 39.99, 4);

INSERT INTO usuarios
(nome, email, senha, data_nascimento, id_plano, id_perfil)
VALUES
(
    'Administrador Geral',
    'admin@streaming.com',
    'admin1234567890',
    '1999-01-01',
    NULL,
    1
);


SELECT name
FROM sqlite_master
WHERE type = 'trigger';

CREATE TRIGGER trg_limite_perfis
BEFORE INSERT ON perfis_streaming
FOR EACH ROW
WHEN (
    SELECT COUNT(*)
    FROM perfis_streaming
    WHERE id_usuario = NEW.id_usuario
) >= 4
BEGIN
    SELECT RAISE(ABORT, 'Limite de 4 perfis atingido');
END;


SELECT *
FROM perfis_streaming
WHERE id_usuario = 2;


INSERT INTO perfis_streaming
(id_usuario, nome_perfil_streaming, tipo_perfil)
VALUES
(2, 'Perfil Extra', 'Adulto');

SELECT * FROM usuarios;

SELECT * FROM planos;

SELECT * FROM perfis_streaming;

INSERT INTO perfis_streaming
(id_usuario, nome_perfil_streaming, tipo_perfil)
VALUES
(2, 'Perfil Extra', 'Adulto');