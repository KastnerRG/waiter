CREATE DATABASE label_studio;

CREATE ROLE label_studio_pg WITH
    LOGIN
    ENCRYPTED PASSWORD 'SCRAM-SHA-256$4096:zj2IBQKWjD8dj0yjaykALQ==$2MxW+lK6FuX3rOA/JgoJEUXgI4ctSyx4tZKR7WtqfY8=:1sONcS0Ww39sW3Ea7PMBMJjrMWEQWBaqGeMfNaW8lMA=';
GRANT ALL PRIVILEGES ON DATABASE label_studio TO label_studio_pg;
\c label_studio postgres
GRANT ALL ON SCHEMA public TO label_studio_pg;