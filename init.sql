CREATE USER caiyuwang WITH CREATEDB PASSWORD 'YOUR_PASSWORD';

CREATE TABLESPACE caiyuwang_space RELATIVE LOCATION 'tablespace/caiyuwang_space';
GRANT ALL PRIVILEGES ON TABLESPACE caiyuwang_space TO caiyuwang;

DROP DATABASE IF EXISTS movie;
CREATE DATABASE movie WITH TABLESPACE = caiyuwang_space OWNER caiyuwang;

DROP DATABASE IF EXISTS hotel;
CREATE DATABASE hotel WITH TABLESPACE = caiyuwang_space OWNER caiyuwang;