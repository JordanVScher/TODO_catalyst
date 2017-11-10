DROP TABLE IF EXISTS items;

CREATE TABLE items (
id SERIAL PRIMARY KEY,
nome TEXT ,
data timestamp,
status TEXT
);

INSERT INTO items (nome, data, status) VALUES ('Fazer um TODO',now(),'Fazendo');
INSERT INTO items (nome, data, status) VALUES ('Fazer um Bolo',now(),'Feito!');
INSERT INTO items (nome, data, status) VALUES ('Compras',now(),'Feito!');
INSERT INTO items (nome, data, status) VALUES ('Estudar Perl',now(),'Fazendo');
INSERT INTO items (nome, data, status) VALUES ('Estudar Catalyst',now(),'Fazendo');
