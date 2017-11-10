--
 -- Add users and roles tables, along with a many-to-many join table
 --

 CREATE TABLE users (
     id            SERIAL PRIMARY KEY,
     username      TEXT,
     password      TEXT,
     email_address TEXT,
     first_name    TEXT,
     last_name     TEXT,
     active        INTEGER
 );

 CREATE TABLE roles (
     id   SERIAL PRIMARY KEY,
     role TEXT
 );

 CREATE TABLE user_roles (
     user_id INTEGER REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
     role_id INTEGER REFERENCES roles(id) ON DELETE CASCADE ON UPDATE CASCADE,
     PRIMARY KEY (user_id, role_id)
 );

 -- psql -U postgres -W dbtodo -f todo2.sql
 -- Load up some initial test data
 --http://search.cpan.org/dist/Catalyst-Manual/lib/Catalyst/Manual/Tutorial/10_Appendices.pod
 INSERT INTO users (username, password, email_address, first_name, last_name, active)
     VALUES ('test01', 'mypass', 't01@na.com', 'Joe',  'Blow', 1);
 INSERT INTO users (username, password, email_address, first_name, last_name, active)
     VALUES ('test02', 'mypass', 't02@na.com', 'Jane', 'Doe',  1);
 INSERT INTO users (username, password, email_address, first_name, last_name, active)
     VALUES ('test03', 'mypass', 't03@na.com', 'No',   'Go',   0);
 INSERT INTO roles (role) VALUES ('user');
 INSERT INTO roles (role) VALUES ('admin');
 INSERT INTO user_roles VALUES (1, 1);
 INSERT INTO user_roles VALUES (1, 2);
 INSERT INTO user_roles VALUES (2, 1);
 INSERT INTO user_roles VALUES (3, 1);
