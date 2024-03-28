-- Ji Benassuti dos Santos - AMS1

-- #CREATE DATABASE:
-- $>       sqlite3.exe FlyTag.db
-- sqlite>  .read ./FlyTag.sql

-- #SUMÁRIO DE TERMOS:
-- todas as senhas serão encriptadas em SHA-512 e terão suas HASHes armazenadas;

-- os telefones irão seguir o padrão "22 55555-4444",
-- as datas/hora o padrão ISO8601 "YYYY-MM-DD HH:MM:SS.SSS";

ATTACH DATABASE 'FlyTag.db' as FlyTag;

CREATE TABLE FlyTag.aeroporto(
  id_aeroporto INTEGER PRIMARY KEY AUTOINCREMENT,
  nome TEXT CHECK(LENGTH(nome) <= 128) NOT NULL,
  icao TEXT CHECK(LENGTH(icao) <= 4) NOT NULL,
  iata TEXT CHECK(LENGTH(iata) <= 3) NOT NULL
);

CREATE TABLE FlyTag.cliente(
  id_cliente INTEGER PRIMARY KEY AUTOINCREMENT,
  nome TEXT CHECK(LENGTH(nome) <= 128) NOT NULL,
  email TEXT CHECK(LENGTH(email) <= 128) NOT NULL,
  senha TEXT CHECK(LENGTH(senha) <= 128) NOT NULL,
  data_nasc TEXT CHECK(LENGTH(data_nasc) <= 10) NOT NULL,
  passaporte TEXT CHECK(LENGTH(passaporte) <= 65),
  documento TEXT CHECK(LENGTH(documento) <= 65)
);

CREATE TABLE FlyTag.funcionario(
  id_funcionario INTEGER PRIMARY KEY AUTOINCREMENT,
  id_aeroporto INTEGER NOT NULL,
  nome TEXT CHECK(LENGTH(nome) <= 128) NOT NULL,
  email TEXT CHECK(LENGTH(email) <= 128) NOT NULL,
  senha TEXT CHECK(LENGTH(senha) <= 128) NOT NULL,
  data_nasc TEXT CHECK(LENGTH(data_nasc) <= 10) NOT NULL,
  administrador BOOLEAN NOT NULL 
);

CREATE TABLE FlyTag.localidade(
  id_local INTEGER PRIMARY KEY AUTOINCREMENT,
  id_aeroporto INTEGER NOT NULL,
  nome TEXT CHECK(LENGTH(nome) <= 65) NOT NULL,
  descricao TEXT CHECK(LENGTH(descricao) <= 128) NOT NULL,
  ativo BOOLEAN NOT NULL
);

CREATE TABLE FlyTag.mala(
  id_mala INTEGER PRIMARY KEY AUTOINCREMENT,
  id_cliente INTEGER NOT NULL,
  id_local INTEGER NOT NULL,
  peso REAL NOT NULL,
  datahora TEXT CHECK(LENGTH(datahora) <= 23) NOT NULL,
  extraviada BOOLEAN NOT NULL
);

-- INSERTS

INSERT INTO FlyTag.aeroporto(nome, icao, iata) VALUES ('Viracopos/Campinas International Airport', 'SBKP', 'VCP');

INSERT INTO FlyTag.cliente(nome, email, senha, data_nasc) VALUES ('Ji Benassuti', 'teste@email.com', '3c9909afec25354d551dae21590bb26e38d53f2173b8d3dc3eee4c047e7ab1c1eb8b85103e3be7ba613b31bb5c9c36214dc9f14a42fd7a2fdb84856bca5c44c2', '2005-04-07');

INSERT INTO FlyTag.funcionario(id_aeroporto, nome, email, senha, data_nasc, administrador) VALUES ((SELECT id_aeroporto FROM aeroporto WHERE id_aeroporto = 1), 'Ji Benassuti', 'teste@email.com', '3c9909afec25354d551dae21590bb26e38d53f2173b8d3dc3eee4c047e7ab1c1eb8b85103e3be7ba613b31bb5c9c36214dc9f14a42fd7a2fdb84856bca5c44c2', '2005-04-07', 1);

INSERT INTO FlyTag.localidade(id_aeroporto, nome, descricao, ativo) VALUES ((SELECT id_aeroporto FROM aeroporto WHERE id_aeroporto = 1), 'GATE-001', 'Primeiro portão de despache', 1);

INSERT INTO FlyTag.mala(id_cliente, id_local, peso, datahora, extraviada) VALUES ((SELECT id_cliente FROM cliente WHERE id_cliente = 1), (SELECT id_local FROM localidade WHERE id_local = 1), 12.86, '2023-11-29 13:28:47.002', 0);
INSERT INTO FlyTag.mala(id_cliente, id_local, peso, datahora, extraviada) VALUES ((SELECT id_cliente FROM cliente WHERE id_cliente = 1), (SELECT id_local FROM localidade WHERE id_local = 1), 13.02, '2023-11-29 13:31:17.584', 0);
INSERT INTO FlyTag.mala(id_cliente, id_local, peso, datahora, extraviada) VALUES ((SELECT id_cliente FROM cliente WHERE id_cliente = 1), (SELECT id_local FROM localidade WHERE id_local = 1), 30.89, '2023-11-29 12:40:30.183', 1);