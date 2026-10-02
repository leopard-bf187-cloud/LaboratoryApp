--
-- PostgreSQL database dump
--

\restrict oASIbFAjYfMGCd21lAU0cYOBNelaihmJyHZssnO5GCJbm5SFjPU6S7a4cVM1jHG

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: entries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.entries (
    id integer NOT NULL,
    mood_id integer NOT NULL,
    title character varying(100) NOT NULL,
    mood_date date NOT NULL,
    energy_level character varying(32) NOT NULL,
    note text NOT NULL,
    author character varying(50) NOT NULL,
    tags text[] DEFAULT '{}'::text[] NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.entries OWNER TO postgres;

--
-- Name: entries_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.entries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.entries_id_seq OWNER TO postgres;

--
-- Name: entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.entries_id_seq OWNED BY public.entries.id;


--
-- Name: moods; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.moods (
    id integer NOT NULL,
    code character varying(32) NOT NULL,
    title character varying(64) NOT NULL,
    icon character varying(16) NOT NULL
);


ALTER TABLE public.moods OWNER TO postgres;

--
-- Name: moods_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.moods_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.moods_id_seq OWNER TO postgres;

--
-- Name: moods_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.moods_id_seq OWNED BY public.moods.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.schema_migrations (
    id integer NOT NULL,
    migration character varying(255) NOT NULL,
    applied_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO postgres;

--
-- Name: schema_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.schema_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.schema_migrations_id_seq OWNER TO postgres;

--
-- Name: schema_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.schema_migrations_id_seq OWNED BY public.schema_migrations.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(50) NOT NULL,
    email character varying(120) NOT NULL,
    password_hash character varying(255) NOT NULL,
    role character varying(20) DEFAULT 'user'::character varying NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT users_role_check CHECK (((role)::text = ANY ((ARRAY['user'::character varying, 'admin'::character varying])::text[])))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: entries id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entries ALTER COLUMN id SET DEFAULT nextval('public.entries_id_seq'::regclass);


--
-- Name: moods id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.moods ALTER COLUMN id SET DEFAULT nextval('public.moods_id_seq'::regclass);


--
-- Name: schema_migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schema_migrations ALTER COLUMN id SET DEFAULT nextval('public.schema_migrations_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: entries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.entries (id, mood_id, title, mood_date, energy_level, note, author, tags, created_at, updated_at, user_id) FROM stdin;
1	1	asdf	2026-05-03	low	asdasdfasfdasdfasdfasdf	admin	{study,work,family}	2026-05-03 21:54:23.563755	2026-05-03 21:54:23.563755	1
2	1	gddfggfdfg	2026-05-03	low	qwsjghfyeiklkvisjqnrrweor	leopard	{study,work,family}	2026-05-03 21:55:38.287345	2026-05-03 21:55:38.287345	2
3	4	hrenovo	2026-05-03	low	описываю что сделал за сегодня, вроде дошел до RC сборки этого сайта	leopard2 (между прочим)	{study,work,family,sport,rest}	2026-05-03 22:16:29.442361	2026-05-03 22:16:29.442361	3
4	4	вот и баг нашел с капчей	2026-05-03	low	сраная капча не сработала, исправляем	leopard (запись н2)	{study}	2026-05-03 22:18:02.555667	2026-05-03 22:18:02.555667	2
\.


--
-- Data for Name: moods; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.moods (id, code, title, icon) FROM stdin;
1	happy	Радостное	😊
2	calm	Спокойное	😌
3	sad	Грустное	😢
4	angry	Злое	😠
5	tired	Уставшее	😴
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.schema_migrations (id, migration, applied_at) FROM stdin;
1	001_create_mood_diary_tables.php	2026-05-03 21:51:58.867736
2	002_add_users_and_auth.php	2026-05-03 21:53:28.368425
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, email, password_hash, role, created_at, updated_at) FROM stdin;
1	admin	admin@example.com	$2y$12$DfGG11vsQDS6rJFcC7i.BOnCoaF0C4pDeFQhYFfBX8y2yJDbOu1Fu	admin	2026-05-03 21:53:28.368425	2026-05-03 21:53:28.368425
2	leopard	leopard251005@gmail.com	$2y$12$ObOmBvmqA9Zb4GqhRo1.HOw853/sxbwJhPq9TSZSVSB2VX9.Lxgmu	user	2026-05-03 21:54:55.811594	2026-05-03 21:54:55.811594
3	leopard2	leopard@email.com	$2y$12$8ujabK1/8wdvL6ruZocpyuGN2nZK6WqCxijfLChZ8CRW5Q/fG7LXK	user	2026-05-03 22:15:23.267921	2026-05-03 22:15:23.267921
4	leopard_bf187	leopard@bytesforge.org	$2y$12$6f44/TWCufh7Nln02vutCOEs/hny53.JvVGUX0hI71NRNlW/kynCe	admin	2026-05-03 22:19:09.710351	2026-05-03 22:19:09.710351
\.


--
-- Name: entries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.entries_id_seq', 4, true);


--
-- Name: moods_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.moods_id_seq', 25, true);


--
-- Name: schema_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.schema_migrations_id_seq', 2, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 4, true);


--
-- Name: entries entries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entries
    ADD CONSTRAINT entries_pkey PRIMARY KEY (id);


--
-- Name: moods moods_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.moods
    ADD CONSTRAINT moods_code_key UNIQUE (code);


--
-- Name: moods moods_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.moods
    ADD CONSTRAINT moods_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_migration_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_migration_key UNIQUE (migration);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: entries entries_mood_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entries
    ADD CONSTRAINT entries_mood_id_fkey FOREIGN KEY (mood_id) REFERENCES public.moods(id) ON DELETE RESTRICT;


--
-- Name: entries entries_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entries
    ADD CONSTRAINT entries_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict oASIbFAjYfMGCd21lAU0cYOBNelaihmJyHZssnO5GCJbm5SFjPU6S7a4cVM1jHG

