--
-- PostgreSQL PSA initial database
--

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;
SET search_path = public, pg_catalog;
SET default_tablespace = '';
SET default_with_oids = false;


DROP TABLE IF EXISTS psa_user_in_group;
CREATE TABLE psa_user_in_group (
    user_id integer NOT NULL,
    group_id integer DEFAULT 1 NOT NULL
);


DROP TABLE IF EXISTS psa_group;
CREATE TABLE psa_group (
    id integer NOT NULL,
    name character varying(50) NOT NULL
);
COMMENT ON COLUMN psa_group.id IS 'Group ID';
COMMENT ON COLUMN psa_group.name IS 'Group name';


DROP SEQUENCE IF EXISTS psa_group_id_seq;
CREATE SEQUENCE psa_group_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
ALTER SEQUENCE psa_group_id_seq OWNED BY psa_group.id;
SELECT pg_catalog.setval('psa_group_id_seq', 1, true);


DROP TABLE IF EXISTS psa_log;
CREATE TABLE psa_log (
    id integer NOT NULL,
    log_time timestamp without time zone,
    message text,
    client_ip character varying(40),
    user_id integer,
    username character varying(50),
    group_id integer,
    groupname character varying(50),
    function text,
    type character varying(100),
    request_uri character varying(250),
    user_agent character varying(150),
    referer character varying(250)
);
COMMENT ON COLUMN psa_log.log_time IS 'Log creation time';
COMMENT ON COLUMN psa_log.message IS 'Log message';
COMMENT ON COLUMN psa_log.client_ip IS 'Client IP address';
COMMENT ON COLUMN psa_log.user_id IS 'User ID';
COMMENT ON COLUMN psa_log.username IS 'Username';
COMMENT ON COLUMN psa_log.group_id IS 'Group ID';
COMMENT ON COLUMN psa_log.groupname IS 'Group name';
COMMENT ON COLUMN psa_log.function IS 'Function, method or debug backtrace that created log';
COMMENT ON COLUMN psa_log.type IS 'Type of log message';


DROP SEQUENCE IF EXISTS psa_log_id_seq;
CREATE SEQUENCE psa_log_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
ALTER SEQUENCE psa_log_id_seq OWNED BY psa_log.id;
SELECT pg_catalog.setval('psa_log_id_seq', 1, true);


DROP TABLE IF EXISTS psa_profile_log;
CREATE TABLE psa_profile_log (
    id integer NOT NULL,
    method character varying(100),
    method_arguments text,
    total_time real,
    client_ip character varying(40),
    log_time timestamp without time zone,
    request_id character varying(50)
);
COMMENT ON COLUMN psa_profile_log.method IS 'Action method';
COMMENT ON COLUMN psa_profile_log.method_arguments IS 'Arguments passed to the action method. Output of print_r() function.';
COMMENT ON COLUMN psa_profile_log.total_time IS 'Total execution time of the method in seconds';
COMMENT ON COLUMN psa_profile_log.client_ip IS 'Client ip address';
COMMENT ON COLUMN psa_profile_log.log_time IS 'Log creation time';


DROP SEQUENCE IF EXISTS psa_profile_log_id_seq;
CREATE SEQUENCE psa_profile_log_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
ALTER SEQUENCE psa_profile_log_id_seq OWNED BY psa_profile_log.id;
SELECT pg_catalog.setval('psa_profile_log_id_seq', 1, true);


DROP TABLE IF EXISTS psa_user;
CREATE TABLE psa_user (
    id integer NOT NULL,
    username character varying(50) NOT NULL,
    password character varying(250) NOT NULL,
    last_login integer
);
COMMENT ON COLUMN psa_user.id IS 'User ID';
COMMENT ON COLUMN psa_user.username IS 'Username';
COMMENT ON COLUMN psa_user.password IS 'Password hash';
COMMENT ON COLUMN psa_user.last_login IS 'Unix timestamp when user has last logged in.';


DROP SEQUENCE IF EXISTS psa_user_id_seq;
CREATE SEQUENCE psa_user_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
ALTER SEQUENCE psa_user_id_seq OWNED BY psa_user.id;
SELECT pg_catalog.setval('psa_user_id_seq', 1, true);



ALTER TABLE psa_group ALTER COLUMN id SET DEFAULT nextval('psa_group_id_seq'::regclass);

ALTER TABLE psa_log ALTER COLUMN id SET DEFAULT nextval('psa_log_id_seq'::regclass);

ALTER TABLE psa_profile_log ALTER COLUMN id SET DEFAULT nextval('psa_profile_log_id_seq'::regclass);

ALTER TABLE psa_user ALTER COLUMN id SET DEFAULT nextval('psa_user_id_seq'::regclass);

INSERT INTO psa_group (id, name) VALUES (1, 'psa');

INSERT INTO psa_user (id, username, password, last_login) VALUES (1, 'psa', 'a54ed3383c2aa9fc7aa86257ffae23f08b833255d8b20729cf7128c908123749', NULL);

INSERT INTO psa_user_in_group (user_id, group_id) VALUES (1, 1);

ALTER TABLE ONLY psa_group
    ADD CONSTRAINT psa_group_pkey PRIMARY KEY (id);

ALTER TABLE ONLY psa_log
    ADD CONSTRAINT psa_log_pkey PRIMARY KEY (id);

ALTER TABLE ONLY psa_profile_log
    ADD CONSTRAINT psa_profile_log_pkey PRIMARY KEY (id);

ALTER TABLE ONLY psa_user_in_group
    ADD CONSTRAINT psa_user_in_group_pkey PRIMARY KEY (group_id, user_id);

ALTER TABLE ONLY psa_user
    ADD CONSTRAINT psa_user_pkey PRIMARY KEY (id);

DROP INDEX IF EXISTS group_id;
CREATE INDEX group_id ON psa_user_in_group USING btree (group_id);

DROP INDEX IF EXISTS groupname;
CREATE UNIQUE INDEX groupname ON psa_group USING btree (name);

DROP INDEX IF EXISTS user_id;
CREATE INDEX user_id ON psa_user_in_group USING btree (user_id);

DROP INDEX IF EXISTS username;
CREATE UNIQUE INDEX username ON psa_user USING btree (username);

ALTER TABLE ONLY psa_user_in_group
    ADD CONSTRAINT "FK_psa_user_in_group_gid" FOREIGN KEY (group_id) REFERENCES psa_group(id) ON DELETE CASCADE;

ALTER TABLE ONLY psa_user_in_group
    ADD CONSTRAINT "FK_psa_user_in_group_uid" FOREIGN KEY (user_id) REFERENCES psa_user(id) ON DELETE CASCADE;
