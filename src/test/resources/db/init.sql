--
-- PostgreSQL database dump
--

-- Dumped from database version 9.4.26
-- Dumped by pg_dump version 14.7 (Ubuntu 14.7-0ubuntu0.22.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
-- SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
-- SET row_security = off;

SET default_tablespace = '';

--
-- Name: core_admin_dashboard; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.core_admin_dashboard (
    dashboard_name character varying(100) NOT NULL,
    dashboard_column integer NOT NULL,
    dashboard_order integer NOT NULL
);


ALTER TABLE public.core_admin_dashboard OWNER TO idstore;

--
-- Name: core_admin_mailinglist; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.core_admin_mailinglist (
    id_mailinglist integer NOT NULL,
    name character varying(100) NOT NULL,
    description character varying(255) NOT NULL,
    workgroup character varying(50) NOT NULL
);


ALTER TABLE public.core_admin_mailinglist OWNER TO idstore;

--
-- Name: core_admin_mailinglist_filter; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.core_admin_mailinglist_filter (
    id_mailinglist integer DEFAULT 0 NOT NULL,
    workgroup character varying(50) NOT NULL,
    role character varying(50) NOT NULL
);


ALTER TABLE public.core_admin_mailinglist_filter OWNER TO idstore;

--
-- Name: core_admin_mailinglist_id_mailinglist_seq; Type: SEQUENCE; Schema: public; Owner: idstore
--

CREATE SEQUENCE public.core_admin_mailinglist_id_mailinglist_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_admin_mailinglist_id_mailinglist_seq OWNER TO idstore;

--
-- Name: core_admin_mailinglist_id_mailinglist_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: idstore
--

ALTER SEQUENCE public.core_admin_mailinglist_id_mailinglist_seq OWNED BY public.core_admin_mailinglist.id_mailinglist;


--
-- Name: core_admin_right; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.core_admin_right (
    id_right character varying(255) DEFAULT ''::character varying NOT NULL,
    name character varying(255) DEFAULT NULL::character varying,
    level_right smallint,
    admin_url character varying(255) DEFAULT NULL::character varying,
    description character varying(255) DEFAULT NULL::character varying,
    is_updatable integer DEFAULT 0 NOT NULL,
    plugin_name character varying(50) DEFAULT NULL::character varying,
    id_feature_group character varying(50) DEFAULT NULL::character varying,
    icon_url character varying(255) DEFAULT NULL::character varying,
    documentation_url character varying(255) DEFAULT NULL::character varying,
    id_order integer,
    is_external_feature smallint DEFAULT 0
);


ALTER TABLE public.core_admin_right OWNER TO idstore;

--
-- Name: core_admin_role; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.core_admin_role (
    role_key character varying(50) DEFAULT ''::character varying NOT NULL,
    role_description character varying(100) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.core_admin_role OWNER TO idstore;

--
-- Name: core_admin_role_resource; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.core_admin_role_resource (
    rbac_id integer NOT NULL,
    role_key character varying(50) DEFAULT ''::character varying NOT NULL,
    resource_type character varying(50) DEFAULT ''::character varying NOT NULL,
    resource_id character varying(50) DEFAULT ''::character varying NOT NULL,
    permission character varying(50) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.core_admin_role_resource OWNER TO idstore;

--
-- Name: core_admin_role_resource_rbac_id_seq; Type: SEQUENCE; Schema: public; Owner: idstore
--

CREATE SEQUENCE public.core_admin_role_resource_rbac_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_admin_role_resource_rbac_id_seq OWNER TO idstore;

--
-- Name: core_admin_role_resource_rbac_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: idstore
--

ALTER SEQUENCE public.core_admin_role_resource_rbac_id_seq OWNED BY public.core_admin_role_resource.rbac_id;


--
-- Name: core_admin_user; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.core_admin_user (
    id_user integer NOT NULL,
    access_code character varying(100) DEFAULT ''::character varying NOT NULL,
    last_name character varying(100) DEFAULT ''::character varying NOT NULL,
    first_name character varying(100) DEFAULT ''::character varying NOT NULL,
    email character varying(256) DEFAULT '0'::character varying NOT NULL,
    status smallint DEFAULT 0 NOT NULL,
    password text,
    locale character varying(10) DEFAULT 'fr'::character varying NOT NULL,
    level_user smallint DEFAULT 0 NOT NULL,
    reset_password smallint DEFAULT 0 NOT NULL,
    accessibility_mode smallint DEFAULT 0 NOT NULL,
    password_max_valid_date timestamp without time zone,
    account_max_valid_date bigint,
    nb_alerts_sent integer DEFAULT 0 NOT NULL,
    last_login timestamp without time zone DEFAULT '1980-01-01 00:00:00'::timestamp without time zone,
    workgroup_key character varying(50) DEFAULT 'all'::character varying
);


ALTER TABLE public.core_admin_user OWNER TO idstore;

--
-- Name: core_admin_user_anonymize_field; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.core_admin_user_anonymize_field (
    field_name character varying(100) NOT NULL,
    anonymize smallint NOT NULL
);


ALTER TABLE public.core_admin_user_anonymize_field OWNER TO idstore;

--
-- Name: core_admin_user_field; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.core_admin_user_field (
    id_user_field integer NOT NULL,
    id_user integer,
    id_attribute integer,
    id_field integer,
    id_file integer,
    user_field_value text
);


ALTER TABLE public.core_admin_user_field OWNER TO idstore;

--
-- Name: core_admin_user_field_id_user_field_seq; Type: SEQUENCE; Schema: public; Owner: idstore
--

CREATE SEQUENCE public.core_admin_user_field_id_user_field_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_admin_user_field_id_user_field_seq OWNER TO idstore;

--
-- Name: core_admin_user_field_id_user_field_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: idstore
--

ALTER SEQUENCE public.core_admin_user_field_id_user_field_seq OWNED BY public.core_admin_user_field.id_user_field;


--
-- Name: core_admin_user_id_user_seq; Type: SEQUENCE; Schema: public; Owner: idstore
--

CREATE SEQUENCE public.core_admin_user_id_user_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_admin_user_id_user_seq OWNER TO idstore;

--
-- Name: core_admin_user_id_user_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: idstore
--

ALTER SEQUENCE public.core_admin_user_id_user_seq OWNED BY public.core_admin_user.id_user;


--
-- Name: core_admin_user_preferences; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.core_admin_user_preferences (
    id_user character varying(100) NOT NULL,
    pref_key character varying(100) NOT NULL,
    pref_value text
);


ALTER TABLE public.core_admin_user_preferences OWNER TO idstore;

--
-- Name: core_admin_workgroup; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.core_admin_workgroup (
    workgroup_key character varying(50) NOT NULL,
    workgroup_description character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE public.core_admin_workgroup OWNER TO idstore;

--
-- Name: core_admin_workgroup_user; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.core_admin_workgroup_user (
    workgroup_key character varying(50) NOT NULL,
    id_user integer NOT NULL
);


ALTER TABLE public.core_admin_workgroup_user OWNER TO idstore;

--
-- Name: core_attribute; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.core_attribute (
    id_attribute integer NOT NULL,
    type_class_name character varying(255) DEFAULT NULL::character varying,
    title text,
    help_message text,
    is_mandatory smallint DEFAULT 0,
    is_shown_in_search smallint DEFAULT 0,
    is_shown_in_result_list smallint DEFAULT 0,
    is_field_in_line smallint DEFAULT 0,
    attribute_position integer DEFAULT 0,
    plugin_name character varying(255) DEFAULT NULL::character varying,
    anonymize smallint
);


ALTER TABLE public.core_attribute OWNER TO idstore;

--
-- Name: core_attribute_field; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.core_attribute_field (
    id_field integer NOT NULL,
    id_attribute integer,
    title character varying(255) DEFAULT NULL::character varying,
    default_value text,
    is_default_value smallint DEFAULT 0,
    height integer,
    width integer,
    max_size_enter integer,
    is_multiple smallint DEFAULT 0,
    field_position integer
);


ALTER TABLE public.core_attribute_field OWNER TO idstore;

--
-- Name: core_attribute_field_id_field_seq; Type: SEQUENCE; Schema: public; Owner: idstore
--

CREATE SEQUENCE public.core_attribute_field_id_field_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_attribute_field_id_field_seq OWNER TO idstore;

--
-- Name: core_attribute_field_id_field_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: idstore
--

ALTER SEQUENCE public.core_attribute_field_id_field_seq OWNED BY public.core_attribute_field.id_field;


--
-- Name: core_attribute_id_attribute_seq; Type: SEQUENCE; Schema: public; Owner: idstore
--

CREATE SEQUENCE public.core_attribute_id_attribute_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_attribute_id_attribute_seq OWNER TO idstore;

--
-- Name: core_attribute_id_attribute_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: idstore
--

ALTER SEQUENCE public.core_attribute_id_attribute_seq OWNED BY public.core_attribute.id_attribute;


--
-- Name: core_connections_log; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.core_connections_log (
    access_code character varying(100) DEFAULT NULL::character varying,
    ip_address character varying(63) DEFAULT NULL::character varying,
    date_login timestamp without time zone DEFAULT now() NOT NULL,
    login_status integer
);


ALTER TABLE public.core_connections_log OWNER TO idstore;

--
-- Name: core_dashboard; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.core_dashboard (
    dashboard_name character varying(100) NOT NULL,
    dashboard_column integer NOT NULL,
    dashboard_order integer NOT NULL
);


ALTER TABLE public.core_dashboard OWNER TO idstore;

--
-- Name: core_datastore; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.core_datastore (
    entity_key character varying(255) NOT NULL,
    entity_value text
);


ALTER TABLE public.core_datastore OWNER TO idstore;

--
-- Name: core_feature_group; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.core_feature_group (
    id_feature_group character varying(50) DEFAULT ''::character varying NOT NULL,
    feature_group_description character varying(255) DEFAULT NULL::character varying,
    feature_group_label character varying(100) DEFAULT NULL::character varying,
    feature_group_order integer
);


ALTER TABLE public.core_feature_group OWNER TO idstore;

--
-- Name: core_file; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.core_file (
    id_file integer NOT NULL,
    title text,
    id_physical_file integer,
    file_size integer,
    mime_type character varying(255) DEFAULT NULL::character varying,
    date_creation timestamp without time zone
);


ALTER TABLE public.core_file OWNER TO idstore;

--
-- Name: core_file_id_file_seq; Type: SEQUENCE; Schema: public; Owner: idstore
--

CREATE SEQUENCE public.core_file_id_file_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_file_id_file_seq OWNER TO idstore;

--
-- Name: core_file_id_file_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: idstore
--

ALTER SEQUENCE public.core_file_id_file_seq OWNED BY public.core_file.id_file;


--
-- Name: core_id_generator; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.core_id_generator (
    class_name character varying(250) DEFAULT ''::character varying NOT NULL,
    current_value integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.core_id_generator OWNER TO idstore;

--
-- Name: core_indexer_action; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.core_indexer_action (
    id_action integer NOT NULL,
    id_document character varying(255) NOT NULL,
    id_task integer DEFAULT 0 NOT NULL,
    indexer_name character varying(255) NOT NULL,
    id_portlet integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.core_indexer_action OWNER TO idstore;

--
-- Name: core_indexer_action_id_action_seq; Type: SEQUENCE; Schema: public; Owner: idstore
--

CREATE SEQUENCE public.core_indexer_action_id_action_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_indexer_action_id_action_seq OWNER TO idstore;

--
-- Name: core_indexer_action_id_action_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: idstore
--

ALTER SEQUENCE public.core_indexer_action_id_action_seq OWNED BY public.core_indexer_action.id_action;


--
-- Name: core_level_right; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.core_level_right (
    id_level smallint DEFAULT 0 NOT NULL,
    name character varying(80) DEFAULT NULL::character varying
);


ALTER TABLE public.core_level_right OWNER TO idstore;

--
-- Name: core_mail_item; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.core_mail_item (
    id_mail_queue integer DEFAULT 0 NOT NULL,
    mail_item bytea
);


ALTER TABLE public.core_mail_item OWNER TO idstore;

--
-- Name: core_mail_queue; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.core_mail_queue (
    id_mail_queue integer NOT NULL,
    is_locked smallint DEFAULT 0
);


ALTER TABLE public.core_mail_queue OWNER TO idstore;

--
-- Name: core_mail_queue_id_mail_queue_seq; Type: SEQUENCE; Schema: public; Owner: idstore
--

CREATE SEQUENCE public.core_mail_queue_id_mail_queue_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_mail_queue_id_mail_queue_seq OWNER TO idstore;

--
-- Name: core_mail_queue_id_mail_queue_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: idstore
--

ALTER SEQUENCE public.core_mail_queue_id_mail_queue_seq OWNED BY public.core_mail_queue.id_mail_queue;


--
-- Name: core_mode; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.core_mode (
    id_mode integer DEFAULT 0 NOT NULL,
    description_mode character varying(255),
    path character varying(50) DEFAULT ''::character varying NOT NULL,
    output_xsl_method character varying(50) DEFAULT NULL::character varying,
    output_xsl_version character varying(50) DEFAULT NULL::character varying,
    output_xsl_media_type character varying(50) DEFAULT NULL::character varying,
    output_xsl_encoding character varying(50) DEFAULT NULL::character varying,
    output_xsl_indent character varying(50) DEFAULT NULL::character varying,
    output_xsl_omit_xml_dec character varying(50) DEFAULT NULL::character varying,
    output_xsl_standalone character varying(50) DEFAULT NULL::character varying
);


ALTER TABLE public.core_mode OWNER TO idstore;

--
-- Name: core_page; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.core_page (
    id_page integer NOT NULL,
    id_parent integer DEFAULT 0,
    name character varying(50) DEFAULT ''::character varying NOT NULL,
    description text,
    date_update timestamp without time zone DEFAULT now() NOT NULL,
    status smallint,
    page_order integer DEFAULT 0,
    id_template integer,
    date_creation timestamp without time zone,
    role character varying(50) DEFAULT NULL::character varying,
    code_theme character varying(80) DEFAULT NULL::character varying,
    node_status smallint DEFAULT 1 NOT NULL,
    image_content bytea,
    mime_type character varying(255) DEFAULT 'NULL'::character varying,
    meta_keywords character varying(255) DEFAULT NULL::character varying,
    meta_description character varying(255) DEFAULT NULL::character varying,
    id_authorization_node integer,
    display_date_update smallint DEFAULT 0 NOT NULL,
    is_manual_date_update smallint DEFAULT 0 NOT NULL
);


ALTER TABLE public.core_page OWNER TO idstore;

--
-- Name: core_page_id_page_seq; Type: SEQUENCE; Schema: public; Owner: idstore
--

CREATE SEQUENCE public.core_page_id_page_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_page_id_page_seq OWNER TO idstore;

--
-- Name: core_page_id_page_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: idstore
--

ALTER SEQUENCE public.core_page_id_page_seq OWNED BY public.core_page.id_page;


--
-- Name: core_page_template; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.core_page_template (
    id_template integer NOT NULL,
    description character varying(50) DEFAULT NULL::character varying,
    file_name character varying(100) DEFAULT NULL::character varying,
    picture character varying(50) DEFAULT NULL::character varying
);


ALTER TABLE public.core_page_template OWNER TO idstore;

--
-- Name: core_page_template_id_template_seq; Type: SEQUENCE; Schema: public; Owner: idstore
--

CREATE SEQUENCE public.core_page_template_id_template_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_page_template_id_template_seq OWNER TO idstore;

--
-- Name: core_page_template_id_template_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: idstore
--

ALTER SEQUENCE public.core_page_template_id_template_seq OWNED BY public.core_page_template.id_template;


--
-- Name: core_physical_file; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.core_physical_file (
    id_physical_file integer NOT NULL,
    file_value bytea
);


ALTER TABLE public.core_physical_file OWNER TO idstore;

--
-- Name: core_physical_file_id_physical_file_seq; Type: SEQUENCE; Schema: public; Owner: idstore
--

CREATE SEQUENCE public.core_physical_file_id_physical_file_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_physical_file_id_physical_file_seq OWNER TO idstore;

--
-- Name: core_physical_file_id_physical_file_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: idstore
--

ALTER SEQUENCE public.core_physical_file_id_physical_file_seq OWNED BY public.core_physical_file.id_physical_file;


--
-- Name: core_portal_component; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.core_portal_component (
    id_portal_component integer DEFAULT 0 NOT NULL,
    name character varying(50) DEFAULT NULL::character varying
);


ALTER TABLE public.core_portal_component OWNER TO idstore;

--
-- Name: core_portlet; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.core_portlet (
    id_portlet integer NOT NULL,
    id_portlet_type character varying(50) DEFAULT NULL::character varying,
    id_page integer,
    name character varying(70) DEFAULT NULL::character varying,
    date_update timestamp without time zone DEFAULT now() NOT NULL,
    status smallint DEFAULT 0 NOT NULL,
    portlet_order integer,
    column_no integer,
    id_style integer,
    accept_alias smallint,
    date_creation timestamp without time zone,
    display_portlet_title integer DEFAULT 0 NOT NULL,
    role character varying(50) DEFAULT NULL::character varying,
    device_display_flags integer DEFAULT 15 NOT NULL
);


ALTER TABLE public.core_portlet OWNER TO idstore;

--
-- Name: core_portlet_alias; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.core_portlet_alias (
    id_portlet integer DEFAULT 0 NOT NULL,
    id_alias integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.core_portlet_alias OWNER TO idstore;

--
-- Name: core_portlet_id_portlet_seq; Type: SEQUENCE; Schema: public; Owner: idstore
--

CREATE SEQUENCE public.core_portlet_id_portlet_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_portlet_id_portlet_seq OWNER TO idstore;

--
-- Name: core_portlet_id_portlet_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: idstore
--

ALTER SEQUENCE public.core_portlet_id_portlet_seq OWNED BY public.core_portlet.id_portlet;


--
-- Name: core_portlet_type; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.core_portlet_type (
    id_portlet_type character varying(50) DEFAULT '0'::character varying NOT NULL,
    name character varying(255) DEFAULT NULL::character varying,
    url_creation character varying(255) DEFAULT NULL::character varying,
    url_update character varying(255) DEFAULT NULL::character varying,
    home_class character varying(255) DEFAULT NULL::character varying,
    plugin_name character varying(50) DEFAULT NULL::character varying,
    url_docreate character varying(255) DEFAULT NULL::character varying,
    create_script character varying(255) DEFAULT NULL::character varying,
    create_specific character varying(255) DEFAULT NULL::character varying,
    create_specific_form character varying(255) DEFAULT NULL::character varying,
    url_domodify character varying(255) DEFAULT NULL::character varying,
    modify_script character varying(255) DEFAULT NULL::character varying,
    modify_specific character varying(255) DEFAULT NULL::character varying,
    modify_specific_form character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE public.core_portlet_type OWNER TO idstore;

--
-- Name: core_role; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.core_role (
    role character varying(50) DEFAULT ''::character varying NOT NULL,
    role_description character varying(255) DEFAULT NULL::character varying,
    workgroup_key character varying(50) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.core_role OWNER TO idstore;

--
-- Name: core_search_parameter; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.core_search_parameter (
    parameter_key character varying(100) NOT NULL,
    parameter_value text
);


ALTER TABLE public.core_search_parameter OWNER TO idstore;

--
-- Name: core_style; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.core_style (
    id_style integer DEFAULT 0 NOT NULL,
    description_style character varying(100) DEFAULT ''::character varying NOT NULL,
    id_portlet_type character varying(50) DEFAULT NULL::character varying,
    id_portal_component integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.core_style OWNER TO idstore;

--
-- Name: core_style_mode_stylesheet; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.core_style_mode_stylesheet (
    id_style integer DEFAULT 0 NOT NULL,
    id_mode integer DEFAULT 0 NOT NULL,
    id_stylesheet integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.core_style_mode_stylesheet OWNER TO idstore;

--
-- Name: core_stylesheet; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.core_stylesheet (
    id_stylesheet integer NOT NULL,
    description character varying(255),
    file_name character varying(255),
    source bytea
);


ALTER TABLE public.core_stylesheet OWNER TO idstore;

--
-- Name: core_stylesheet_id_stylesheet_seq; Type: SEQUENCE; Schema: public; Owner: idstore
--

CREATE SEQUENCE public.core_stylesheet_id_stylesheet_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_stylesheet_id_stylesheet_seq OWNER TO idstore;

--
-- Name: core_stylesheet_id_stylesheet_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: idstore
--

ALTER SEQUENCE public.core_stylesheet_id_stylesheet_seq OWNED BY public.core_stylesheet.id_stylesheet;


--
-- Name: core_template; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.core_template (
    template_name character varying(100) NOT NULL,
    template_value text
);


ALTER TABLE public.core_template OWNER TO idstore;

--
-- Name: core_text_editor; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.core_text_editor (
    editor_name character varying(255) NOT NULL,
    editor_description character varying(255) NOT NULL,
    backoffice smallint NOT NULL
);


ALTER TABLE public.core_text_editor OWNER TO idstore;

--
-- Name: core_user_password_history; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.core_user_password_history (
    id_user integer NOT NULL,
    password text NOT NULL,
    date_password_change timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.core_user_password_history OWNER TO idstore;

--
-- Name: core_user_preferences; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.core_user_preferences (
    id_user character varying(100) NOT NULL,
    pref_key character varying(100) NOT NULL,
    pref_value text
);


ALTER TABLE public.core_user_preferences OWNER TO idstore;

--
-- Name: core_user_right; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.core_user_right (
    id_right character varying(255) DEFAULT ''::character varying NOT NULL,
    id_user integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.core_user_right OWNER TO idstore;

--
-- Name: core_user_role; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.core_user_role (
    role_key character varying(50) DEFAULT ''::character varying NOT NULL,
    id_user integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.core_user_role OWNER TO idstore;

--
-- Name: core_xsl_export; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.core_xsl_export (
    id_xsl_export integer NOT NULL,
    title character varying(255) DEFAULT NULL::character varying,
    description character varying(255) DEFAULT NULL::character varying,
    extension character varying(255) DEFAULT NULL::character varying,
    id_file integer,
    plugin character varying(255) DEFAULT ''::character varying
);


ALTER TABLE public.core_xsl_export OWNER TO idstore;

--
-- Name: core_xsl_export_id_xsl_export_seq; Type: SEQUENCE; Schema: public; Owner: idstore
--

CREATE SEQUENCE public.core_xsl_export_id_xsl_export_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_xsl_export_id_xsl_export_seq OWNER TO idstore;

--
-- Name: core_xsl_export_id_xsl_export_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: idstore
--

ALTER SEQUENCE public.core_xsl_export_id_xsl_export_seq OWNED BY public.core_xsl_export.id_xsl_export;

--
-- Name: identitystore_attribute; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.identitystore_attribute (
    id_attribute integer NOT NULL,
    name character varying(100) DEFAULT ''::character varying NOT NULL,
    key_name character varying(100) DEFAULT ''::character varying NOT NULL,
    description character varying,
    key_type integer DEFAULT 0 NOT NULL,
    certifiable smallint DEFAULT 0,
    pivot smallint DEFAULT 0,
    key_weight integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.identitystore_attribute OWNER TO idstore;

--
-- Name: identitystore_identity_attribute_certificate; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.identitystore_identity_attribute_certificate (
    id_attribute_certificate integer NOT NULL,
    certifier_code character varying(255) DEFAULT ''::character varying NOT NULL,
    certificate_date timestamp without time zone NOT NULL,
    expiration_date timestamp without time zone
);


ALTER TABLE public.identitystore_identity_attribute_certificate OWNER TO idstore;

--
-- Name: identitystore_attribute_certificat_id_attribute_certificate_seq; Type: SEQUENCE; Schema: public; Owner: idstore
--

CREATE SEQUENCE public.identitystore_attribute_certificat_id_attribute_certificate_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.identitystore_attribute_certificat_id_attribute_certificate_seq OWNER TO idstore;

--
-- Name: identitystore_attribute_certificat_id_attribute_certificate_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: idstore
--

ALTER SEQUENCE public.identitystore_attribute_certificat_id_attribute_certificate_seq OWNED BY public.identitystore_identity_attribute_certificate.id_attribute_certificate;


--
-- Name: identitystore_service_contract_attribute_certification; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.identitystore_service_contract_attribute_certification (
    id_service_contract integer NOT NULL,
    id_attribute integer NOT NULL,
    id_ref_attribute_certification_processus integer NOT NULL
);


ALTER TABLE public.identitystore_service_contract_attribute_certification OWNER TO idstore;

--
-- Name: identitystore_attribute_id_attribute_seq; Type: SEQUENCE; Schema: public; Owner: idstore
--

CREATE SEQUENCE public.identitystore_attribute_id_attribute_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.identitystore_attribute_id_attribute_seq OWNER TO idstore;

--
-- Name: identitystore_attribute_id_attribute_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: idstore
--

ALTER SEQUENCE public.identitystore_attribute_id_attribute_seq OWNED BY public.identitystore_attribute.id_attribute;


--
-- Name: identitystore_service_contract_attribute_requirement; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.identitystore_service_contract_attribute_requirement (
    id_service_contract integer NOT NULL,
    id_attribute integer NOT NULL,
    id_ref_certification_level integer NOT NULL
);


ALTER TABLE public.identitystore_service_contract_attribute_requirement OWNER TO idstore;

--
-- Name: identitystore_service_contract_attribute_right; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.identitystore_service_contract_attribute_right (
    id_service_contract integer NOT NULL,
    id_attribute integer NOT NULL,
    searchable smallint DEFAULT 0 NOT NULL,
    readable smallint DEFAULT 0 NOT NULL,
    writable smallint DEFAULT 0 NOT NULL
);


ALTER TABLE public.identitystore_service_contract_attribute_right OWNER TO idstore;

--
-- Name: identitystore_client_application; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.identitystore_client_application (
    id_client_app integer NOT NULL,
    name character varying(100) NOT NULL,
    code character varying(100) NOT NULL
);


ALTER TABLE public.identitystore_client_application OWNER TO idstore;

--
-- Name: identitystore_client_application_certifiers; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.identitystore_client_application_certifiers (
    id_client_app integer NOT NULL,
    certifier_code character varying(255) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.identitystore_client_application_certifiers OWNER TO idstore;

--
-- Name: identitystore_client_application_id_client_app_seq; Type: SEQUENCE; Schema: public; Owner: idstore
--

CREATE SEQUENCE public.identitystore_client_application_id_client_app_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.identitystore_client_application_id_client_app_seq OWNER TO idstore;

--
-- Name: identitystore_client_application_id_client_app_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: idstore
--

ALTER SEQUENCE public.identitystore_client_application_id_client_app_seq OWNED BY public.identitystore_client_application.id_client_app;


--
-- Name: identitystore_identity_attribute_history ; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.identitystore_identity_attribute_history  (
    id_history integer NOT NULL,
    change_type integer NOT NULL,
    change_satus character varying(255) NOT NULL,
    change_message character varying(255) DEFAULT NULL::character varying,
    author_type character varying(255) NOT NULL,
    author_name character varying(255) DEFAULT NULL::character varying,
    client_code character varying(255) DEFAULT NULL::character varying,
    id_identity integer NOT NULL,
    attribute_key character varying(50) NOT NULL,
    attribute_value character varying(255) DEFAULT NULL::character varying,
    certification_process character varying(255) DEFAULT NULL::character varying,
    certification_date timestamp without time zone,
    modification_date timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.identitystore_identity_attribute_history  OWNER TO idstore;

--
-- Name: identitystore_identity_attribute_history _id_history_seq; Type: SEQUENCE; Schema: public; Owner: idstore
--

CREATE SEQUENCE public.identitystore_identity_attribute_history _id_history_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.identitystore_identity_attribute_history _id_history_seq OWNER TO idstore;

--
-- Name: identitystore_identity_attribute_history _id_history_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: idstore
--

ALTER SEQUENCE public.identitystore_identity_attribute_history _id_history_seq OWNED BY public.identitystore_identity_attribute_history .id_history;


--
-- Name: identitystore_identity; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.identitystore_identity (
    id_identity integer NOT NULL,
    connection_id character varying(100),
    customer_id character varying(50),
    date_create timestamp without time zone DEFAULT now() NOT NULL,
    last_update_date timestamp without time zone,
    is_deleted smallint DEFAULT 0,
    date_delete timestamp without time zone,
    is_merged smallint DEFAULT 0,
    date_merge timestamp without time zone,
    id_master_identity integer
);


ALTER TABLE public.identitystore_identity OWNER TO idstore;

--
-- Name: identitystore_identity_attribute; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.identitystore_identity_attribute (
    id_identity integer DEFAULT 0 NOT NULL,
    id_attribute integer DEFAULT 0 NOT NULL,
    attribute_value character varying,
    id_certification integer DEFAULT 0 NOT NULL,
    id_file integer DEFAULT 0,
    lastupdate_date timestamp without time zone DEFAULT now() NOT NULL,
    lastupdate_application character varying(100)
);


ALTER TABLE public.identitystore_identity_attribute OWNER TO idstore;

--
-- Name: identitystore_identity_id_identity_seq; Type: SEQUENCE; Schema: public; Owner: idstore
--

CREATE SEQUENCE public.identitystore_identity_id_identity_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.identitystore_identity_id_identity_seq OWNER TO idstore;

--
-- Name: identitystore_identity_id_identity_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: idstore
--

ALTER SEQUENCE public.identitystore_identity_id_identity_seq OWNED BY public.identitystore_identity.id_identity;


--
-- Name: identitystore_index_action; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.identitystore_index_action (
    id_index_action integer NOT NULL,
    customer_id character varying(50) NOT NULL,
    action_type character varying(50) NOT NULL,
    date_index timestamp without time zone NOT NULL
);


ALTER TABLE public.identitystore_index_action OWNER TO idstore;

--
-- Name: identitystore_index_action_id_index_action_seq; Type: SEQUENCE; Schema: public; Owner: idstore
--

CREATE SEQUENCE public.identitystore_index_action_id_index_action_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.identitystore_index_action_id_index_action_seq OWNER TO idstore;

--
-- Name: identitystore_index_action_id_index_action_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: idstore
--

ALTER SEQUENCE public.identitystore_index_action_id_index_action_seq OWNED BY public.identitystore_index_action.id_index_action;


--
-- Name: identitystore_ref_certification_processus; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.identitystore_ref_certification_processus (
    id_ref_attribute_certification_processus integer NOT NULL,
    label character varying(50) DEFAULT ''::character varying NOT NULL,
    code character varying(50) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.identitystore_ref_certification_processus OWNER TO idstore;

--
-- Name: identitystore_ref_attribute_c_id_ref_attribute_certificatio_seq; Type: SEQUENCE; Schema: public; Owner: idstore
--

CREATE SEQUENCE public.identitystore_ref_attribute_c_id_ref_attribute_certificatio_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.identitystore_ref_attribute_c_id_ref_attribute_certificatio_seq OWNER TO idstore;

--
-- Name: identitystore_ref_attribute_c_id_ref_attribute_certificatio_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: idstore
--

ALTER SEQUENCE public.identitystore_ref_attribute_c_id_ref_attribute_certificatio_seq OWNED BY public.identitystore_ref_certification_processus.id_ref_attribute_certification_processus;


--
-- Name: identitystore_ref_certification_attribute_level; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.identitystore_ref_certification_attribute_level (
    id_attribute integer NOT NULL,
    id_ref_certification_level integer NOT NULL,
    id_ref_attribute_certification_processus integer NOT NULL
);


ALTER TABLE public.identitystore_ref_certification_attribute_level OWNER TO idstore;

--
-- Name: identitystore_ref_certification_level; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.identitystore_ref_certification_level (
    id_ref_certification_level integer NOT NULL,
    name character varying(255) DEFAULT ''::character varying,
    description character varying(255) DEFAULT ''::character varying,
    level character varying(50) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.identitystore_ref_certification_level OWNER TO idstore;

--
-- Name: identitystore_ref_certification__id_ref_certification_level_seq; Type: SEQUENCE; Schema: public; Owner: idstore
--

CREATE SEQUENCE public.identitystore_ref_certification__id_ref_certification_level_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.identitystore_ref_certification__id_ref_certification_level_seq OWNER TO idstore;

--
-- Name: identitystore_ref_certification__id_ref_certification_level_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: idstore
--

ALTER SEQUENCE public.identitystore_ref_certification__id_ref_certification_level_seq OWNED BY public.identitystore_ref_certification_level.id_ref_certification_level;


--
-- Name: identitystore_service_contract; Type: TABLE; Schema: public; Owner: idstore
--

CREATE TABLE public.identitystore_service_contract (
    id_service_contract integer NOT NULL,
    id_client_app integer NOT NULL,
    name character varying(50) DEFAULT ''::character varying NOT NULL,
    organizational_entity character varying(50) DEFAULT ''::character varying NOT NULL,
    responsible_name character varying(50) DEFAULT ''::character varying NOT NULL,
    contact_name character varying(50) DEFAULT ''::character varying NOT NULL,
    service_type character varying(50) DEFAULT ''::character varying NOT NULL,
    starting_date date NOT NULL,
    ending_date date,
    authorized_read smallint DEFAULT 0 NOT NULL,
    authorized_deletion smallint DEFAULT 0 NOT NULL,
    authorized_search smallint DEFAULT 0 NOT NULL,
    authorized_import smallint DEFAULT 0 NOT NULL,
    authorized_export smallint DEFAULT 0 NOT NULL,
    authorized_merge smallint DEFAULT 0 NOT NULL,
    is_application_authorized_to_delete_value smallint DEFAULT 0 NOT NULL,
    is_application_authorized_to_delete_certificate smallint DEFAULT 0 NOT NULL,
    authorized_account_update smallint DEFAULT 0 NOT NULL
);


ALTER TABLE public.identitystore_service_contract OWNER TO idstore;

--
-- Name: identitystore_service_contract_id_service_contract_seq; Type: SEQUENCE; Schema: public; Owner: idstore
--

CREATE SEQUENCE public.identitystore_service_contract_id_service_contract_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.identitystore_service_contract_id_service_contract_seq OWNER TO idstore;

--
-- Name: identitystore_service_contract_id_service_contract_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: idstore
--

ALTER SEQUENCE public.identitystore_service_contract_id_service_contract_seq OWNED BY public.identitystore_service_contract.id_service_contract;


--
-- Name: core_admin_mailinglist id_mailinglist; Type: DEFAULT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_admin_mailinglist ALTER COLUMN id_mailinglist SET DEFAULT nextval('public.core_admin_mailinglist_id_mailinglist_seq'::regclass);


--
-- Name: core_admin_role_resource rbac_id; Type: DEFAULT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_admin_role_resource ALTER COLUMN rbac_id SET DEFAULT nextval('public.core_admin_role_resource_rbac_id_seq'::regclass);


--
-- Name: core_admin_user id_user; Type: DEFAULT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_admin_user ALTER COLUMN id_user SET DEFAULT nextval('public.core_admin_user_id_user_seq'::regclass);


--
-- Name: core_admin_user_field id_user_field; Type: DEFAULT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_admin_user_field ALTER COLUMN id_user_field SET DEFAULT nextval('public.core_admin_user_field_id_user_field_seq'::regclass);


--
-- Name: core_attribute id_attribute; Type: DEFAULT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_attribute ALTER COLUMN id_attribute SET DEFAULT nextval('public.core_attribute_id_attribute_seq'::regclass);


--
-- Name: core_attribute_field id_field; Type: DEFAULT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_attribute_field ALTER COLUMN id_field SET DEFAULT nextval('public.core_attribute_field_id_field_seq'::regclass);


--
-- Name: core_file id_file; Type: DEFAULT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_file ALTER COLUMN id_file SET DEFAULT nextval('public.core_file_id_file_seq'::regclass);


--
-- Name: core_indexer_action id_action; Type: DEFAULT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_indexer_action ALTER COLUMN id_action SET DEFAULT nextval('public.core_indexer_action_id_action_seq'::regclass);


--
-- Name: core_mail_queue id_mail_queue; Type: DEFAULT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_mail_queue ALTER COLUMN id_mail_queue SET DEFAULT nextval('public.core_mail_queue_id_mail_queue_seq'::regclass);


--
-- Name: core_page id_page; Type: DEFAULT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_page ALTER COLUMN id_page SET DEFAULT nextval('public.core_page_id_page_seq'::regclass);


--
-- Name: core_page_template id_template; Type: DEFAULT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_page_template ALTER COLUMN id_template SET DEFAULT nextval('public.core_page_template_id_template_seq'::regclass);


--
-- Name: core_physical_file id_physical_file; Type: DEFAULT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_physical_file ALTER COLUMN id_physical_file SET DEFAULT nextval('public.core_physical_file_id_physical_file_seq'::regclass);


--
-- Name: core_portlet id_portlet; Type: DEFAULT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_portlet ALTER COLUMN id_portlet SET DEFAULT nextval('public.core_portlet_id_portlet_seq'::regclass);


--
-- Name: core_stylesheet id_stylesheet; Type: DEFAULT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_stylesheet ALTER COLUMN id_stylesheet SET DEFAULT nextval('public.core_stylesheet_id_stylesheet_seq'::regclass);


--
-- Name: core_xsl_export id_xsl_export; Type: DEFAULT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_xsl_export ALTER COLUMN id_xsl_export SET DEFAULT nextval('public.core_xsl_export_id_xsl_export_seq'::regclass);

--
-- Name: identitystore_ref_attribute id_attribute; Type: DEFAULT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.identitystore_attribute ALTER COLUMN id_attribute SET DEFAULT nextval('public.identitystore_attribute_id_attribute_seq'::regclass);


--
-- Name: identitystore_identity_attribute_certificate id_attribute_certificate; Type: DEFAULT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.identitystore_identity_attribute_certificate ALTER COLUMN id_attribute_certificate SET DEFAULT nextval('public.identitystore_attribute_certificat_id_attribute_certificate_seq'::regclass);


--
-- Name: identitystore_client_application id_client_app; Type: DEFAULT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.identitystore_client_application ALTER COLUMN id_client_app SET DEFAULT nextval('public.identitystore_client_application_id_client_app_seq'::regclass);


--
-- Name: identitystore_identity_attribute_history  id_history; Type: DEFAULT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.identitystore_identity_attribute_history  ALTER COLUMN id_history SET DEFAULT nextval('public.identitystore_identity_attribute_history _id_history_seq'::regclass);


--
-- Name: identitystore_identity id_identity; Type: DEFAULT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.identitystore_identity ALTER COLUMN id_identity SET DEFAULT nextval('public.identitystore_identity_id_identity_seq'::regclass);


--
-- Name: identitystore_index_action id_index_action; Type: DEFAULT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.identitystore_index_action ALTER COLUMN id_index_action SET DEFAULT nextval('public.identitystore_index_action_id_index_action_seq'::regclass);


--
-- Name: identitystore_ref_certification_processus id_ref_attribute_certification_processus; Type: DEFAULT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.identitystore_ref_certification_processus ALTER COLUMN id_ref_attribute_certification_processus SET DEFAULT nextval('public.identitystore_ref_attribute_c_id_ref_attribute_certificatio_seq'::regclass);


--
-- Name: identitystore_ref_certification_level id_ref_certification_level; Type: DEFAULT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.identitystore_ref_certification_level ALTER COLUMN id_ref_certification_level SET DEFAULT nextval('public.identitystore_ref_certification__id_ref_certification_level_seq'::regclass);


--
-- Name: identitystore_service_contract id_service_contract; Type: DEFAULT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.identitystore_service_contract ALTER COLUMN id_service_contract SET DEFAULT nextval('public.identitystore_service_contract_id_service_contract_seq'::regclass);


--
-- Data for Name: core_admin_dashboard; Type: TABLE DATA; Schema: public; Owner: idstore
--

INSERT INTO public.core_admin_dashboard (dashboard_name, dashboard_column, dashboard_order) VALUES ('usersAdminDashboardComponent', 1, 1);
INSERT INTO public.core_admin_dashboard (dashboard_name, dashboard_column, dashboard_order) VALUES ('searchAdminDashboardComponent', 1, 2);
INSERT INTO public.core_admin_dashboard (dashboard_name, dashboard_column, dashboard_order) VALUES ('editorAdminDashboardComponent', 1, 3);
INSERT INTO public.core_admin_dashboard (dashboard_name, dashboard_column, dashboard_order) VALUES ('autoIncludesAdminDashboardComponent', 1, 4);
INSERT INTO public.core_admin_dashboard (dashboard_name, dashboard_column, dashboard_order) VALUES ('featuresAdminDashboardComponent', 1, 5);
INSERT INTO public.core_admin_dashboard (dashboard_name, dashboard_column, dashboard_order) VALUES ('xslExportAdminDashboardComponent', 1, 6);


--
-- Data for Name: core_admin_mailinglist; Type: TABLE DATA; Schema: public; Owner: idstore
--

INSERT INTO public.core_admin_mailinglist (id_mailinglist, name, description, workgroup) VALUES (1, 'admin', 'admin', 'all');


--
-- Data for Name: core_admin_mailinglist_filter; Type: TABLE DATA; Schema: public; Owner: idstore
--

INSERT INTO public.core_admin_mailinglist_filter (id_mailinglist, workgroup, role) VALUES (1, 'all', 'super_admin');


--
-- Data for Name: core_admin_right; Type: TABLE DATA; Schema: public; Owner: idstore
--

INSERT INTO public.core_admin_right (id_right, name, level_right, admin_url, description, is_updatable, plugin_name, id_feature_group, icon_url, documentation_url, id_order, is_external_feature) VALUES ('CORE_ADMIN_SITE', 'portal.site.adminFeature.admin_site.name', 2, 'jsp/admin/site/AdminSite.jsp', 'portal.site.adminFeature.admin_site.description', 1, NULL, 'SITE', 'images/admin/skin/features/admin_site.png', 'jsp/admin/documentation/AdminDocumentation.jsp?doc=admin-site', 1, 0);
INSERT INTO public.core_admin_right (id_right, name, level_right, admin_url, description, is_updatable, plugin_name, id_feature_group, icon_url, documentation_url, id_order, is_external_feature) VALUES ('CORE_CACHE_MANAGEMENT', 'portal.system.adminFeature.cache_management.name', 0, 'jsp/admin/system/ManageCaches.jsp', 'portal.system.adminFeature.cache_management.description', 1, NULL, 'SYSTEM', 'images/admin/skin/features/manage_caches.png', NULL, 1, 0);
INSERT INTO public.core_admin_right (id_right, name, level_right, admin_url, description, is_updatable, plugin_name, id_feature_group, icon_url, documentation_url, id_order, is_external_feature) VALUES ('CORE_SEARCH_INDEXATION', 'portal.search.adminFeature.indexer.name', 0, 'jsp/admin/search/ManageSearchIndexation.jsp', 'portal.search.adminFeature.indexer.description', 0, NULL, 'SYSTEM', NULL, NULL, 2, 0);
INSERT INTO public.core_admin_right (id_right, name, level_right, admin_url, description, is_updatable, plugin_name, id_feature_group, icon_url, documentation_url, id_order, is_external_feature) VALUES ('CORE_SEARCH_MANAGEMENT', 'portal.search.adminFeature.search_management.name', 0, NULL, 'portal.search.adminFeature.search_management.description', 0, NULL, 'SYSTEM', NULL, NULL, 3, 0);
INSERT INTO public.core_admin_right (id_right, name, level_right, admin_url, description, is_updatable, plugin_name, id_feature_group, icon_url, documentation_url, id_order, is_external_feature) VALUES ('CORE_LOGS_VISUALISATION', 'portal.system.adminFeature.logs_visualisation.name', 0, 'jsp/admin/system/ManageFilesSystem.jsp', 'portal.system.adminFeature.logs_visualisation.description', 1, NULL, 'SYSTEM', 'images/admin/skin/features/view_logs.png', NULL, 4, 0);
INSERT INTO public.core_admin_right (id_right, name, level_right, admin_url, description, is_updatable, plugin_name, id_feature_group, icon_url, documentation_url, id_order, is_external_feature) VALUES ('CORE_PAGE_TEMPLATE_MANAGEMENT', 'portal.style.adminFeature.page_template_management.name', 0, 'jsp/admin/style/ManagePageTemplates.jsp', 'portal.style.adminFeature.page_template_management.description', 0, NULL, 'STYLE', 'images/admin/skin/features/manage_page_templates.png', NULL, 2, 0);
INSERT INTO public.core_admin_right (id_right, name, level_right, admin_url, description, is_updatable, plugin_name, id_feature_group, icon_url, documentation_url, id_order, is_external_feature) VALUES ('CORE_PLUGINS_MANAGEMENT', 'portal.system.adminFeature.plugins_management.name', 0, 'jsp/admin/system/ManagePlugins.jsp', 'portal.system.adminFeature.plugins_management.description', 1, NULL, 'SYSTEM', 'images/admin/skin/features/manage_plugins.png', NULL, 5, 0);
INSERT INTO public.core_admin_right (id_right, name, level_right, admin_url, description, is_updatable, plugin_name, id_feature_group, icon_url, documentation_url, id_order, is_external_feature) VALUES ('CORE_PROPERTIES_MANAGEMENT', 'portal.site.adminFeature.properties_management.name', 2, 'jsp/admin/ManageProperties.jsp', 'portal.site.adminFeature.properties_management.description', 0, NULL, 'SITE', NULL, 'jsp/admin/documentation/AdminDocumentation.jsp?doc=admin-properties', 2, 0);
INSERT INTO public.core_admin_right (id_right, name, level_right, admin_url, description, is_updatable, plugin_name, id_feature_group, icon_url, documentation_url, id_order, is_external_feature) VALUES ('CORE_STYLESHEET_MANAGEMENT', 'portal.style.adminFeature.stylesheet_management.name', 0, 'jsp/admin/style/ManageStyleSheets.jsp', 'portal.style.adminFeature.stylesheet_management.description', 1, NULL, 'STYLE', 'images/admin/skin/features/manage_stylesheets.png', NULL, 3, 0);
INSERT INTO public.core_admin_right (id_right, name, level_right, admin_url, description, is_updatable, plugin_name, id_feature_group, icon_url, documentation_url, id_order, is_external_feature) VALUES ('CORE_STYLES_MANAGEMENT', 'portal.style.adminFeature.styles_management.name', 0, 'jsp/admin/style/ManageStyles.jsp', 'portal.style.adminFeature.styles_management.description', 1, NULL, 'STYLE', 'images/admin/skin/features/manage_styles.png', NULL, 4, 0);
INSERT INTO public.core_admin_right (id_right, name, level_right, admin_url, description, is_updatable, plugin_name, id_feature_group, icon_url, documentation_url, id_order, is_external_feature) VALUES ('CORE_USERS_MANAGEMENT', 'portal.users.adminFeature.users_management.name', 2, 'jsp/admin/user/ManageUsers.jsp', 'portal.users.adminFeature.users_management.description', 1, '', 'MANAGERS', 'images/admin/skin/features/manage_users.png', NULL, 1, 0);
INSERT INTO public.core_admin_right (id_right, name, level_right, admin_url, description, is_updatable, plugin_name, id_feature_group, icon_url, documentation_url, id_order, is_external_feature) VALUES ('CORE_FEATURES_MANAGEMENT', 'portal.admin.adminFeature.features_management.name', 0, NULL, 'portal.admin.adminFeature.features_management.description', 0, NULL, 'SYSTEM', 'images/admin/skin/features/manage_features.png', NULL, 6, 0);
INSERT INTO public.core_admin_right (id_right, name, level_right, admin_url, description, is_updatable, plugin_name, id_feature_group, icon_url, documentation_url, id_order, is_external_feature) VALUES ('CORE_RBAC_MANAGEMENT', 'portal.rbac.adminFeature.rbac_management.name', 0, 'jsp/admin/rbac/ManageRoles.jsp', 'portal.rbac.adminFeature.rbac_management.description', 0, '', 'MANAGERS', 'images/admin/skin/features/manage_rbac.png', NULL, 2, 0);
INSERT INTO public.core_admin_right (id_right, name, level_right, admin_url, description, is_updatable, plugin_name, id_feature_group, icon_url, documentation_url, id_order, is_external_feature) VALUES ('CORE_DAEMONS_MANAGEMENT', 'portal.system.adminFeature.daemons_management.name', 0, 'jsp/admin/system/ManageDaemons.jsp', 'portal.system.adminFeature.daemons_management.description', 0, NULL, 'SYSTEM', NULL, NULL, 7, 0);
INSERT INTO public.core_admin_right (id_right, name, level_right, admin_url, description, is_updatable, plugin_name, id_feature_group, icon_url, documentation_url, id_order, is_external_feature) VALUES ('CORE_WORKGROUPS_MANAGEMENT', 'portal.workgroup.adminFeature.workgroups_management.name', 2, 'jsp/admin/workgroup/ManageWorkgroups.jsp', 'portal.workgroup.adminFeature.workgroups_management.description', 0, NULL, 'MANAGERS', 'images/admin/skin/features/manage_workgroups.png', NULL, 3, 0);
INSERT INTO public.core_admin_right (id_right, name, level_right, admin_url, description, is_updatable, plugin_name, id_feature_group, icon_url, documentation_url, id_order, is_external_feature) VALUES ('CORE_ROLES_MANAGEMENT', 'portal.role.adminFeature.roles_management.name', 2, 'jsp/admin/role/ManagePageRole.jsp', 'portal.role.adminFeature.roles_management.description', 0, NULL, 'USERS', 'images/admin/skin/features/manage_roles.png', NULL, 1, 0);
INSERT INTO public.core_admin_right (id_right, name, level_right, admin_url, description, is_updatable, plugin_name, id_feature_group, icon_url, documentation_url, id_order, is_external_feature) VALUES ('CORE_MAILINGLISTS_MANAGEMENT', 'portal.mailinglist.adminFeature.mailinglists_management.name', 2, 'jsp/admin/mailinglist/ManageMailingLists.jsp', 'portal.mailinglist.adminFeature.mailinglists_management.description', 0, NULL, 'MANAGERS', 'images/admin/skin/features/manage_mailinglists.png', NULL, 4, 0);
INSERT INTO public.core_admin_right (id_right, name, level_right, admin_url, description, is_updatable, plugin_name, id_feature_group, icon_url, documentation_url, id_order, is_external_feature) VALUES ('CORE_LEVEL_RIGHT_MANAGEMENT', 'portal.users.adminFeature.level_right_management.name', 2, NULL, 'portal.users.adminFeature.level_right_management.description', 0, NULL, 'MANAGERS', 'images/admin/skin/features/manage_rights_levels.png', NULL, 5, 0);
INSERT INTO public.core_admin_right (id_right, name, level_right, admin_url, description, is_updatable, plugin_name, id_feature_group, icon_url, documentation_url, id_order, is_external_feature) VALUES ('CORE_LINK_SERVICE_MANAGEMENT', 'portal.insert.adminFeature.linkService_management.name', 2, NULL, 'portal.insert.adminFeature.linkService_management.description', 0, NULL, NULL, NULL, NULL, 1, 0);
INSERT INTO public.core_admin_right (id_right, name, level_right, admin_url, description, is_updatable, plugin_name, id_feature_group, icon_url, documentation_url, id_order, is_external_feature) VALUES ('CORE_RIGHT_MANAGEMENT', 'portal.users.adminFeature.right_management.name', 0, 'jsp/admin/features/ManageRights.jsp', 'portal.users.adminFeature.right_management.description', 0, NULL, 'MANAGERS', 'images/admin/skin/features/manage_rights_levels.png', NULL, 5, 0);
INSERT INTO public.core_admin_right (id_right, name, level_right, admin_url, description, is_updatable, plugin_name, id_feature_group, icon_url, documentation_url, id_order, is_external_feature) VALUES ('CORE_ADMINDASHBOARD_MANAGEMENT', 'portal.admindashboard.adminFeature.right_management.name', 0, NULL, 'portal.admindashboard.adminFeature.right_management.description', 0, NULL, 'SYSTEM', 'images/admin/skin/features/manage_admindashboards.png', NULL, 8, 0);
INSERT INTO public.core_admin_right (id_right, name, level_right, admin_url, description, is_updatable, plugin_name, id_feature_group, icon_url, documentation_url, id_order, is_external_feature) VALUES ('CORE_DASHBOARD_MANAGEMENT', 'portal.dashboard.adminFeature.dashboard_management.name', 0, NULL, 'portal.dashboard.adminFeature.dashboard_management.description', 0, NULL, 'SYSTEM', 'images/admin/skin/features/manage_dashboards.png', NULL, 9, 0);
INSERT INTO public.core_admin_right (id_right, name, level_right, admin_url, description, is_updatable, plugin_name, id_feature_group, icon_url, documentation_url, id_order, is_external_feature) VALUES ('CORE_XSL_EXPORT_MANAGEMENT', 'portal.xsl.adminFeature.xsl_export_management.name', 2, NULL, 'portal.xsl.adminFeature.xsl_export_management.description', 1, NULL, 'SYSTEM', NULL, NULL, 10, 0);
INSERT INTO public.core_admin_right (id_right, name, level_right, admin_url, description, is_updatable, plugin_name, id_feature_group, icon_url, documentation_url, id_order, is_external_feature) VALUES ('CORE_TEMPLATES_AUTO_INCLUDES_MANAGEMENT', 'portal.templates.adminFeature.ManageAutoIncludes.name', 1, NULL, 'portal.templates.adminFeature.ManageAutoIncludes.description', 1, NULL, 'STYLE', 'images/admin/skin/features/manage_templates.png', NULL, 4, 0);
INSERT INTO public.core_admin_right (id_right, name, level_right, admin_url, description, is_updatable, plugin_name, id_feature_group, icon_url, documentation_url, id_order, is_external_feature) VALUES ('CORE_EDITORS_MANAGEMENT', 'portal.admindashboard.editorManagement.right.name', 2, NULL, 'portal.admindashboard.editorManagement.right.description', 1, NULL, 'SYSTEM', NULL, NULL, 10, 0);
INSERT INTO public.core_admin_right (id_right, name, level_right, admin_url, description, is_updatable, plugin_name, id_feature_group, icon_url, documentation_url, id_order, is_external_feature) VALUES ('IDENTITYSTORE_MANAGEMENT', 'identitystore.adminFeature.ManageIdentities.name', 1, 'jsp/admin/plugins/identitystore/ManageIdentities.jsp', 'identitystore.adminFeature.ManageIdentities.description', 0, 'identitystore', NULL, NULL, NULL, 4, 0);
INSERT INTO public.core_admin_right (id_right, name, level_right, admin_url, description, is_updatable, plugin_name, id_feature_group, icon_url, documentation_url, id_order, is_external_feature) VALUES ('IDENTITYSTORE_ADMIN_MANAGEMENT', 'identitystore.adminFeature.AdminIdentities.name', 1, 'jsp/admin/plugins/identitystore/ManageClientApplications.jsp', 'identitystore.adminFeature.AdminIdentities.description', 0, 'identitystore', NULL, NULL, NULL, 4, 0);
INSERT INTO public.core_admin_right (id_right, name, level_right, admin_url, description, is_updatable, plugin_name, id_feature_group, icon_url, documentation_url, id_order, is_external_feature) VALUES ('IDENTITYSTORE_REF_MANAGEMENT', 'identitystore.adminFeature.ManageProcessusRef.name', 1, 'jsp/admin/plugins/identitystore/ManageRefAttributeCertificationProcessuss.jsp', 'identitystore.adminFeature.ManageProcessusRef.description', 0, 'identitystore', NULL, NULL, NULL, 4, 0);


--
-- Data for Name: core_admin_role; Type: TABLE DATA; Schema: public; Owner: idstore
--

INSERT INTO public.core_admin_role (role_key, role_description) VALUES ('all_site_manager', 'Site Manager');
INSERT INTO public.core_admin_role (role_key, role_description) VALUES ('super_admin', 'Super Administrateur');


--
-- Data for Name: core_admin_role_resource; Type: TABLE DATA; Schema: public; Owner: idstore
--

INSERT INTO public.core_admin_role_resource (rbac_id, role_key, resource_type, resource_id, permission) VALUES (57, 'all_site_manager', 'PAGE', '*', 'VIEW');
INSERT INTO public.core_admin_role_resource (rbac_id, role_key, resource_type, resource_id, permission) VALUES (58, 'all_site_manager', 'PAGE', '*', 'MANAGE');
INSERT INTO public.core_admin_role_resource (rbac_id, role_key, resource_type, resource_id, permission) VALUES (77, 'super_admin', 'INSERT_SERVICE', '*', '*');
INSERT INTO public.core_admin_role_resource (rbac_id, role_key, resource_type, resource_id, permission) VALUES (101, 'all_site_manager', 'PORTLET_TYPE', '*', '*');
INSERT INTO public.core_admin_role_resource (rbac_id, role_key, resource_type, resource_id, permission) VALUES (111, 'all_site_manager', 'ADMIN_USER', '*', '*');
INSERT INTO public.core_admin_role_resource (rbac_id, role_key, resource_type, resource_id, permission) VALUES (137, 'all_site_manager', 'SEARCH_SERVICE', '*', '*');
INSERT INTO public.core_admin_role_resource (rbac_id, role_key, resource_type, resource_id, permission) VALUES (164, 'all_site_manager', 'XSL_EXPORT', '*', '*');


--
-- Data for Name: core_admin_user; Type: TABLE DATA; Schema: public; Owner: idstore
--

INSERT INTO public.core_admin_user (id_user, access_code, last_name, first_name, email, status, password, locale, level_user, reset_password, accessibility_mode, password_max_valid_date, account_max_valid_date, nb_alerts_sent, last_login, workgroup_key) VALUES (3, 'redac', 'redac', 'redac', 'redac@lutece.fr', 1, 'PLAINTEXT:adminadmin', 'fr', 2, 0, 0, '1980-01-01 00:00:00', NULL, 0, '1980-01-01 00:00:00', 'all');
INSERT INTO public.core_admin_user (id_user, access_code, last_name, first_name, email, status, password, locale, level_user, reset_password, accessibility_mode, password_max_valid_date, account_max_valid_date, nb_alerts_sent, last_login, workgroup_key) VALUES (4, 'valid', 'valid', 'valid', 'valid@lutece.fr', 1, 'PLAINTEXT:adminadmin', 'fr', 3, 0, 0, '1980-01-01 00:00:00', NULL, 0, '1980-01-01 00:00:00', 'all');
INSERT INTO public.core_admin_user (id_user, access_code, last_name, first_name, email, status, password, locale, level_user, reset_password, accessibility_mode, password_max_valid_date, account_max_valid_date, nb_alerts_sent, last_login, workgroup_key) VALUES (2, 'lutece', 'Lutèce', 'lutece', 'lutece@lutece.fr', 1, 'PBKDF2WITHHMACSHA512:40000:cf949cf1df0e9a72d6584b892957ef16:e418d7324dd9cd71f73ca3b724d3b78ee7f0d957da4b9ce77d8f627065f0241bc092490fe696dbd95bd1aec93e2549b38577e25897ff625d1cbef0dad4f9df4c268711413ee03792d4b171bae79254625eab23b7ce2fb77611cf46d51896e756b11db748712b38a45c98bd2da31625b8077067591ddf14a53cde9d5b90e24dfb', 'fr', 1, 1, 0, '1980-01-01 00:00:00', 1705164788204, 0, '1980-01-01 00:00:00', 'all');
INSERT INTO public.core_admin_user (id_user, access_code, last_name, first_name, email, status, password, locale, level_user, reset_password, accessibility_mode, password_max_valid_date, account_max_valid_date, nb_alerts_sent, last_login, workgroup_key) VALUES (1, 'admin', 'Admin', 'admin', 'admin@lutece.fr', 0, 'PBKDF2WITHHMACSHA512:40000:0b064a0cb032199100cdcba177027eb4:1475491168321a0d795c2c9bc2d2280b2eed5408b3c1c5fbdd793bff8f31dfef7a12fb412926de24a60a166c963f340f1ee67171387430e25728c93601889e4d292637a71c4dcf7c1c57791a081095885061facb79f650321bc52645172f8860e368261e03de92812ed0bd4c9055ff0f9d46df18fac048cefa96fefeb6f1eef8', 'fr', 0, 0, 0, '2023-04-01 11:38:42.282', 1709470968072, 0, '2023-03-03 14:02:48.087', 'all');


--
-- Data for Name: core_admin_user_anonymize_field; Type: TABLE DATA; Schema: public; Owner: idstore
--

INSERT INTO public.core_admin_user_anonymize_field (field_name, anonymize) VALUES ('access_code', 1);
INSERT INTO public.core_admin_user_anonymize_field (field_name, anonymize) VALUES ('last_name', 1);
INSERT INTO public.core_admin_user_anonymize_field (field_name, anonymize) VALUES ('first_name', 1);
INSERT INTO public.core_admin_user_anonymize_field (field_name, anonymize) VALUES ('email', 1);


--
-- Data for Name: core_admin_user_field; Type: TABLE DATA; Schema: public; Owner: idstore
--



--
-- Data for Name: core_admin_user_preferences; Type: TABLE DATA; Schema: public; Owner: idstore
--



--
-- Data for Name: core_admin_workgroup; Type: TABLE DATA; Schema: public; Owner: idstore
--



--
-- Data for Name: core_admin_workgroup_user; Type: TABLE DATA; Schema: public; Owner: idstore
--



--
-- Data for Name: core_attribute; Type: TABLE DATA; Schema: public; Owner: idstore
--



--
-- Data for Name: core_attribute_field; Type: TABLE DATA; Schema: public; Owner: idstore
--



--
-- Data for Name: core_connections_log; Type: TABLE DATA; Schema: public; Owner: idstore
--

INSERT INTO public.core_connections_log (access_code, ip_address, date_login, login_status) VALUES ('admin', '127.0.0.1', '2023-01-22 15:06:04.923', 0);


--
-- Data for Name: core_dashboard; Type: TABLE DATA; Schema: public; Owner: idstore
--

INSERT INTO public.core_dashboard (dashboard_name, dashboard_column, dashboard_order) VALUES ('CORE_SYSTEM', 1, 2);
INSERT INTO public.core_dashboard (dashboard_name, dashboard_column, dashboard_order) VALUES ('CORE_USERS', 1, 1);
INSERT INTO public.core_dashboard (dashboard_name, dashboard_column, dashboard_order) VALUES ('CORE_USER', 4, 1);
INSERT INTO public.core_dashboard (dashboard_name, dashboard_column, dashboard_order) VALUES ('CORE_PAGES', 2, 1);


--
-- Data for Name: core_datastore; Type: TABLE DATA; Schema: public; Owner: idstore
--

INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.advanced_parameters.password_duration', '120');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.advanced_parameters.default_user_level', '0');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.advanced_parameters.default_user_notification', '1');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.advanced_parameters.default_user_language', 'fr');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.advanced_parameters.default_user_status', '0');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.advanced_parameters.email_pattern', '^[\w_.\-!\#\$\%\&''\*\+\/\=\?\^\`\}\{\|\~]+@[\w_.\-]+\.[\w]+$');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.advanced_parameters.email_pattern_verify_by', '');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.advanced_parameters.force_change_password_reinit', 'false');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.advanced_parameters.password_minimum_length', '8');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.advanced_parameters.password_format_upper_lower_case', 'false');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.advanced_parameters.password_format_numero', 'false');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.advanced_parameters.password_format_special_characters', 'false');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.advanced_parameters.password_history_size', '');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.advanced_parameters.maximum_number_password_change', '');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.advanced_parameters.tsw_size_password_change', '');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.advanced_parameters.use_advanced_security_parameters', '');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.advanced_parameters.account_life_time', '12');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.advanced_parameters.time_before_alert_account', '30');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.advanced_parameters.nb_alert_account', '2');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.advanced_parameters.time_between_alerts_account', '10');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.advanced_parameters.access_failures_max', '3');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.advanced_parameters.access_failures_interval', '10');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.advanced_parameters.expired_alert_mail_sender', 'lutece@nowhere.com');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.advanced_parameters.expired_alert_mail_subject', 'Votre compte a expiré');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.advanced_parameters.first_alert_mail_sender', 'lutece@nowhere.com');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.advanced_parameters.first_alert_mail_subject', 'Votre compte va bientôt expirer');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.advanced_parameters.other_alert_mail_sender', 'lutece@nowhere.com');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.advanced_parameters.other_alert_mail_subject', 'Votre compte va bientôt expirer');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.advanced_parameters.account_reactivated_mail_sender', 'lutece@nowhere.com');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.advanced_parameters.account_reactivated_mail_subject', 'Votre compte a bien été réactivé');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.advanced_parameters.access_failures_captcha', '1');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.advanced_parameters.notify_user_password_expired', '');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.advanced_parameters.password_expired_mail_sender', 'lutece@nowhere.com');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.advanced_parameters.password_expired_mail_subject', 'Votre mot de passe a expiré');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.advanced_parameters.reset_token_validity', '60');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.advanced_parameters.lock_reset_token_to_session', 'false');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.backOffice.defaultEditor', 'tinymce');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.frontOffice.defaultEditor', 'markitupbbcode');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core_banned_domain_names', 'yopmail.com');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('portal.site.site_property.name', 'LUTECE');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('portal.site.site_property.meta.author', '<author>');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('portal.site.site_property.meta.copyright', '<copyright>');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('portal.site.site_property.meta.description', '<description>');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('portal.site.site_property.meta.keywords', '<keywords>');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('portal.site.site_property.email', '<webmaster email>');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('portal.site.site_property.noreply_email', 'no-reply@mydomain.com');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('portal.site.site_property.home_url', 'jsp/site/Portal.jsp');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('portal.site.site_property.admin_home_url', 'jsp/admin/AdminMenu.jsp');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('portal.site.site_property.popup_credits.textblock', '&lt;credits text&gt;');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('portal.site.site_property.popup_legal_info.copyright.textblock', '&lt;copyright text&gt;');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('portal.site.site_property.popup_legal_info.privacy.textblock', '&lt;privacy text&gt;');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('portal.site.site_property.logo_url', 'images/logo-header-icon.png');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('portal.site.site_property.locale.default', 'fr');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('portal.site.site_property.avatar_default', 'images/admin/skin/unknown.png');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('portal.site.site_property.back_images', '''images/admin/skin/bg_login1.svg'' , ''images/admin/skin/bg_login2.svg'' , ''images/admin/skin/bg_login3.svg'' , ''images/admin/skin/bg_login4.svg''');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('portal.site.site_property.portlet.title.maxlength', '75');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.plugins.status.identitystore.installed', 'true');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.cache.status.PageCachingFilter.enabled', '0');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.cache.status.LuteceUserCacheService.enabled', '1');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.cache.status.MailAttachmentCacheService.overflowToDisk', 'true');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.cache.status.LuteceUserCacheService.maxElementsInMemory', '1000');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.cache.status.MailAttachmentCacheService.enabled', '1');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.cache.status.StaticFilesCachingFilter.timeToLiveSeconds', '604800');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.cache.status.MailAttachmentCacheService.diskPersistent', 'true');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.cache.status.BaseUserPreferencesCacheService.maxElementsInMemory', '1000');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.cache.status.MyPortalWidgetContentService.enabled', '1');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.cache.status.MailAttachmentCacheService.timeToLiveSeconds', '7200');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.cache.status.MailAttachmentCacheService.maxElementsInMemory', '10');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.cache.status.MyPortalWidgetService.enabled', '1');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.cache.status.SiteMapService.enabled', '1');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.plugins.status.swaggerui.installed', 'true');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.plugins.status.rest.installed', 'true');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.daemon.indexer.interval', '300');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.daemon.mailSender.interval', '86400');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.daemon.anonymizationDaemon.interval', '86400');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.daemon.anonymizationDaemon.onStartUp', 'false');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.daemon.accountLifeTimeDaemon.interval', '86400');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.daemon.threadLauncherDaemon.interval', '86400');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.daemon.indexDaemon.interval', '86400');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.plugins.status.swaggerui.pool', 'portal');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.cache.status.identitystore.activeServiceContractCache.enabled', '0');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.cache.status.identitystore.qualityBaseCache.enabled', '0');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.cache.status.identitystore.attributeKeyCache.enabled', '0');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.cache.status.identitystore.refAttributeCertificationDefinitionCache.enabled', '0');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.cache.status.identitystore.ActiveServiceContractCache.enabled', '0');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.cache.status.PageCachingFilter(CAUTION:NEVERUSEWITHUSERDYNAMICDATA).enabled', '0');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.cache.status.PortalMenuService.enabled', '1');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.cache.status.StaticFilesCachingFilter.enabled', '1');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.cache.status.LinksIncludeCacheService.enabled', '1');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.cache.status.PageCacheService.enabled', '1');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.cache.status.PortletCacheService.enabled', '0');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.cache.status.BaseUserPreferencesCacheService.enabled', '1');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.cache.status.ActiveServiceContractCache.enabled', '1');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.cache.status.AttributeKeyCache.enabled', '1');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.cache.status.RefAttributeCertificationDefinitionCache.enabled', '1');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.templates.currentCommonsInclude', 'Boostrap5Tabler');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.daemon.mailSender.onStartUp', 'true');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.daemon.threadLauncherDaemon.onStartUp', 'true');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.daemon.accountLifeTimeDaemon.onStartUp', 'true');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.daemon.indexer.onStartUp', 'true');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.daemon.indexDaemon.onStartUp', 'true');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.startup.time', '3 mars 2023 14:46:34');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.cache.status.pathCacheService.enabled', '1');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.cache.status.XMLTransformerCacheService(XSLT).enabled', '1');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.cache.status.DatastoreCacheService.enabled', '0');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.cache.status.identitystore.identityDtoCache.enabled', '0');
INSERT INTO public.core_datastore (entity_key, entity_value) VALUES ('core.cache.status.identitystore.identityAccountHistoryDtoCache.enabled', '0');


--
-- Data for Name: core_feature_group; Type: TABLE DATA; Schema: public; Owner: idstore
--

INSERT INTO public.core_feature_group (id_feature_group, feature_group_description, feature_group_label, feature_group_order) VALUES ('CONTENT', 'portal.features.group.content.description', 'portal.features.group.content.label', 1);
INSERT INTO public.core_feature_group (id_feature_group, feature_group_description, feature_group_label, feature_group_order) VALUES ('APPLICATIONS', 'portal.features.group.applications.description', 'portal.features.group.applications.label', 3);
INSERT INTO public.core_feature_group (id_feature_group, feature_group_description, feature_group_label, feature_group_order) VALUES ('SYSTEM', 'portal.features.group.system.description', 'portal.features.group.system.label', 7);
INSERT INTO public.core_feature_group (id_feature_group, feature_group_description, feature_group_label, feature_group_order) VALUES ('SITE', 'portal.features.group.site.description', 'portal.features.group.site.label', 2);
INSERT INTO public.core_feature_group (id_feature_group, feature_group_description, feature_group_label, feature_group_order) VALUES ('STYLE', 'portal.features.group.charter.description', 'portal.features.group.charter.label', 6);
INSERT INTO public.core_feature_group (id_feature_group, feature_group_description, feature_group_label, feature_group_order) VALUES ('USERS', 'portal.features.group.users.description', 'portal.features.group.users.label', 4);
INSERT INTO public.core_feature_group (id_feature_group, feature_group_description, feature_group_label, feature_group_order) VALUES ('MANAGERS', 'portal.features.group.managers.description', 'portal.features.group.managers.label', 5);


--
-- Data for Name: core_file; Type: TABLE DATA; Schema: public; Owner: idstore
--

INSERT INTO public.core_file (id_file, title, id_physical_file, file_size, mime_type, date_creation) VALUES (125, 'export_users_csv.xml', 125, 2523, 'application/xml', '2005-10-10 10:10:10');
INSERT INTO public.core_file (id_file, title, id_physical_file, file_size, mime_type, date_creation) VALUES (126, 'export_users_xml.xml', 126, 259, 'application/xml', '2005-10-10 10:10:10');


--
-- Data for Name: core_id_generator; Type: TABLE DATA; Schema: public; Owner: idstore
--



--
-- Data for Name: core_indexer_action; Type: TABLE DATA; Schema: public; Owner: idstore
--



--
-- Data for Name: core_level_right; Type: TABLE DATA; Schema: public; Owner: idstore
--

INSERT INTO public.core_level_right (id_level, name) VALUES (0, 'Level 0 - Technical administrator');
INSERT INTO public.core_level_right (id_level, name) VALUES (1, 'Level 1 - Fonctionnal administrator');
INSERT INTO public.core_level_right (id_level, name) VALUES (2, 'Level 2 - Site Manager - Webmaster');
INSERT INTO public.core_level_right (id_level, name) VALUES (3, 'Level 3 - Contributor');


--
-- Data for Name: core_mail_item; Type: TABLE DATA; Schema: public; Owner: idstore
--



--
-- Data for Name: core_mail_queue; Type: TABLE DATA; Schema: public; Owner: idstore
--



--
-- Data for Name: core_mode; Type: TABLE DATA; Schema: public; Owner: idstore
--

INSERT INTO public.core_mode (id_mode, description_mode, path, output_xsl_method, output_xsl_version, output_xsl_media_type, output_xsl_encoding, output_xsl_indent, output_xsl_omit_xml_dec, output_xsl_standalone) VALUES (0, 'Normal', 'normal/', 'xml', '1.0', 'text/xml', 'UTF-8', 'yes', 'yes', NULL);
INSERT INTO public.core_mode (id_mode, description_mode, path, output_xsl_method, output_xsl_version, output_xsl_media_type, output_xsl_encoding, output_xsl_indent, output_xsl_omit_xml_dec, output_xsl_standalone) VALUES (1, 'Administration', 'admin/', 'xml', '1.0', 'text/xml', 'UTF-8', 'yes', 'yes', NULL);
INSERT INTO public.core_mode (id_mode, description_mode, path, output_xsl_method, output_xsl_version, output_xsl_media_type, output_xsl_encoding, output_xsl_indent, output_xsl_omit_xml_dec, output_xsl_standalone) VALUES (2, 'Wap', 'wml/', 'xml', '1.0', 'text/xml', 'UTF-8', 'yes', 'yes', NULL);


--
-- Data for Name: core_page; Type: TABLE DATA; Schema: public; Owner: idstore
--

INSERT INTO public.core_page (id_page, id_parent, name, description, date_update, status, page_order, id_template, date_creation, role, code_theme, node_status, image_content, mime_type, meta_keywords, meta_description, id_authorization_node, display_date_update, is_manual_date_update) VALUES (1, 0, 'Home', 'Home Page', '2014-06-08 17:20:44', 1, 1, 4, '2003-09-09 00:38:01', 'none', 'default', 0, '\x', 'application/octet-stream', NULL, NULL, 1, 0, 0);
INSERT INTO public.core_page (id_page, id_parent, name, description, date_update, status, page_order, id_template, date_creation, role, code_theme, node_status, image_content, mime_type, meta_keywords, meta_description, id_authorization_node, display_date_update, is_manual_date_update) VALUES (2, 1, 'Page 1', 'A child page', '2014-06-08 18:23:42', 0, 1, 2, '2014-06-08 18:23:42', 'none', 'default', 1, NULL, 'application/octet-stream', NULL, NULL, 1, 0, 0);


--
-- Data for Name: core_page_template; Type: TABLE DATA; Schema: public; Owner: idstore
--

INSERT INTO public.core_page_template (id_template, description, file_name, picture) VALUES (1, 'One column', 'skin/site/page_template1.html', 'page_template1.gif');
INSERT INTO public.core_page_template (id_template, description, file_name, picture) VALUES (2, 'Two columns', 'skin/site/page_template2.html', 'page_template2.gif');
INSERT INTO public.core_page_template (id_template, description, file_name, picture) VALUES (3, 'Three columns', 'skin/site/page_template3.html', 'page_template3.gif');
INSERT INTO public.core_page_template (id_template, description, file_name, picture) VALUES (4, '1 + 2 columns', 'skin/site/page_template4.html', 'page_template4.gif');
INSERT INTO public.core_page_template (id_template, description, file_name, picture) VALUES (5, 'Two equal columns', 'skin/site/page_template5.html', 'page_template5.gif');
INSERT INTO public.core_page_template (id_template, description, file_name, picture) VALUES (6, 'Three unequal columns', 'skin/site/page_template6.html', 'page_template6.gif');


--
-- Data for Name: core_physical_file; Type: TABLE DATA; Schema: public; Owner: idstore
--

INSERT INTO public.core_physical_file (id_physical_file, file_value) VALUES (125, '\x3c3f786d6c2076657273696f6e3d22312e30223f3e0d0a3c78736c3a7374796c6573686565742076657273696f6e3d22312e302220786d6c6e733a78736c3d22687474703a2f2f7777772e77332e6f72672f313939392f58534c2f5472616e73666f726d223e0d0a093c78736c3a6f7574707574206d6574686f643d2274657874222f3e0d0a090d0a093c78736c3a74656d706c617465206d617463683d227573657273223e0d0a09093c78736c3a6170706c792d74656d706c617465732073656c6563743d227573657222202f3e0d0a093c2f78736c3a74656d706c6174653e0d0a090d0a093c78736c3a74656d706c617465206d617463683d2275736572223e0d0a09093c78736c3a746578743e223c2f78736c3a746578743e0d0a09093c78736c3a76616c75652d6f662073656c6563743d226163636573735f636f646522202f3e0d0a09093c78736c3a746578743e223b223c2f78736c3a746578743e0d0a09093c78736c3a76616c75652d6f662073656c6563743d226c6173745f6e616d6522202f3e0d0a09093c78736c3a746578743e223b223c2f78736c3a746578743e0d0a09093c78736c3a76616c75652d6f662073656c6563743d2266697273745f6e616d6522202f3e0d0a09093c78736c3a746578743e223b223c2f78736c3a746578743e0d0a09093c78736c3a76616c75652d6f662073656c6563743d22656d61696c22202f3e0d0a09093c78736c3a746578743e223b223c2f78736c3a746578743e0d0a09093c78736c3a76616c75652d6f662073656c6563743d2273746174757322202f3e0d0a09093c78736c3a746578743e223b223c2f78736c3a746578743e0d0a09093c78736c3a76616c75652d6f662073656c6563743d226c6f63616c6522202f3e0d0a09093c78736c3a746578743e223b223c2f78736c3a746578743e0d0a09093c78736c3a76616c75652d6f662073656c6563743d226c6576656c22202f3e0d0a09093c78736c3a746578743e223b223c2f78736c3a746578743e0d0a09093c78736c3a76616c75652d6f662073656c6563743d226d7573745f6368616e67655f70617373776f726422202f3e0d0a09093c78736c3a746578743e223b223c2f78736c3a746578743e0d0a09093c78736c3a76616c75652d6f662073656c6563743d226163636573736962696c6974795f6d6f646522202f3e0d0a09093c78736c3a746578743e223b223c2f78736c3a746578743e0d0a09093c78736c3a76616c75652d6f662073656c6563743d2270617373776f72645f6d61785f76616c69645f6461746522202f3e0d0a09093c78736c3a746578743e223b223c2f78736c3a746578743e0d0a09093c78736c3a76616c75652d6f662073656c6563743d226163636f756e745f6d61785f76616c69645f6461746522202f3e0d0a09093c78736c3a746578743e223b223c2f78736c3a746578743e0d0a09093c78736c3a76616c75652d6f662073656c6563743d22646174655f6c6173745f6c6f67696e22202f3e0d0a09093c78736c3a746578743e223c2f78736c3a746578743e0d0a09093c78736c3a6170706c792d74656d706c617465732073656c6563743d22726f6c657322202f3e0d0a09093c78736c3a6170706c792d74656d706c617465732073656c6563743d2272696768747322202f3e0d0a09093c78736c3a6170706c792d74656d706c617465732073656c6563743d22776f726b67726f75707322202f3e0d0a09093c78736c3a6170706c792d74656d706c617465732073656c6563743d226174747269627574657322202f3e0d0a09093c78736c3a746578743e262331303b3c2f78736c3a746578743e0d0a093c2f78736c3a74656d706c6174653e0d0a090d0a093c78736c3a74656d706c617465206d617463683d22726f6c6573223e0d0a09093c78736c3a6170706c792d74656d706c617465732073656c6563743d22726f6c6522202f3e0d0a093c2f78736c3a74656d706c6174653e0d0a090d0a093c78736c3a74656d706c617465206d617463683d22726f6c65223e0d0a09093c78736c3a746578743e3b22726f6c653a3c2f78736c3a746578743e0d0a09093c78736c3a76616c75652d6f662073656c6563743d2263757272656e74282922202f3e0d0a09093c78736c3a746578743e223c2f78736c3a746578743e0d0a093c2f78736c3a74656d706c6174653e0d0a090d0a093c78736c3a74656d706c617465206d617463683d22726967687473223e0d0a09093c78736c3a6170706c792d74656d706c617465732073656c6563743d22726967687422202f3e0d0a093c2f78736c3a74656d706c6174653e0d0a090d0a093c78736c3a74656d706c617465206d617463683d227269676874223e0d0a09093c78736c3a746578743e3b2272696768743a3c2f78736c3a746578743e0d0a09093c78736c3a76616c75652d6f662073656c6563743d2263757272656e74282922202f3e0d0a09093c78736c3a746578743e223c2f78736c3a746578743e0d0a093c2f78736c3a74656d706c6174653e0d0a090d0a093c78736c3a74656d706c617465206d617463683d22776f726b67726f757073223e0d0a09093c78736c3a6170706c792d74656d706c617465732073656c6563743d22776f726b67726f757022202f3e0d0a093c2f78736c3a74656d706c6174653e0d0a090d0a093c78736c3a74656d706c617465206d617463683d22776f726b67726f7570223e0d0a09093c78736c3a746578743e3b22776f726b67726f75703a3c2f78736c3a746578743e0d0a09093c78736c3a76616c75652d6f662073656c6563743d2263757272656e74282922202f3e0d0a09093c78736c3a746578743e223c2f78736c3a746578743e0d0a093c2f78736c3a74656d706c6174653e0d0a090d0a093c78736c3a74656d706c617465206d617463683d2261747472696275746573223e0d0a09093c78736c3a6170706c792d74656d706c617465732073656c6563743d2261747472696275746522202f3e0d0a093c2f78736c3a74656d706c6174653e0d0a090d0a093c78736c3a74656d706c617465206d617463683d22617474726962757465223e0d0a09093c78736c3a746578743e3b223c2f78736c3a746578743e0d0a09093c78736c3a76616c75652d6f662073656c6563743d226174747269627574652d696422202f3e0d0a09093c78736c3a746578743e3a3c2f78736c3a746578743e0d0a09093c78736c3a76616c75652d6f662073656c6563743d226174747269627574652d6669656c642d696422202f3e0d0a09093c78736c3a746578743e3a3c2f78736c3a746578743e0d0a09093c78736c3a76616c75652d6f662073656c6563743d226174747269627574652d76616c756522202f3e0d0a09093c78736c3a746578743e223c2f78736c3a746578743e0d0a093c2f78736c3a74656d706c6174653e0d0a090d0a3c2f78736c3a7374796c6573686565743e');
INSERT INTO public.core_physical_file (id_physical_file, file_value) VALUES (126, '\x3c3f786d6c2076657273696f6e3d22312e3022203f3e0d0a3c78736c3a7374796c6573686565742076657273696f6e3d22312e302220786d6c6e733a78736c3d22687474703a2f2f7777772e77332e6f72672f313939392f58534c2f5472616e73666f726d223e0d0a093c78736c3a74656d706c617465206d617463683d222f207c20402a207c206e6f64652829223e0d0a09093c78736c3a636f70793e0d0a0909093c78736c3a6170706c792d74656d706c617465732073656c6563743d22402a207c206e6f6465282922202f3e0d0a09093c2f78736c3a636f70793e0d0a093c2f78736c3a74656d706c6174653e0d0a3c2f78736c3a7374796c6573686565743e');


--
-- Data for Name: core_portal_component; Type: TABLE DATA; Schema: public; Owner: idstore
--

INSERT INTO public.core_portal_component (id_portal_component, name) VALUES (0, 'Porlet');
INSERT INTO public.core_portal_component (id_portal_component, name) VALUES (1, 'Article');
INSERT INTO public.core_portal_component (id_portal_component, name) VALUES (2, 'Article List Portlet');
INSERT INTO public.core_portal_component (id_portal_component, name) VALUES (3, 'Menu Init');
INSERT INTO public.core_portal_component (id_portal_component, name) VALUES (4, 'Main Menu');
INSERT INTO public.core_portal_component (id_portal_component, name) VALUES (5, 'Breadcrum');
INSERT INTO public.core_portal_component (id_portal_component, name) VALUES (6, 'Site Map');
INSERT INTO public.core_portal_component (id_portal_component, name) VALUES (7, 'Tree View');
INSERT INTO public.core_portal_component (id_portal_component, name) VALUES (8, 'Site Map (Admin mode)');


--
-- Data for Name: core_portlet; Type: TABLE DATA; Schema: public; Owner: idstore
--



--
-- Data for Name: core_portlet_alias; Type: TABLE DATA; Schema: public; Owner: idstore
--



--
-- Data for Name: core_portlet_type; Type: TABLE DATA; Schema: public; Owner: idstore
--

INSERT INTO public.core_portlet_type (id_portlet_type, name, url_creation, url_update, home_class, plugin_name, url_docreate, create_script, create_specific, create_specific_form, url_domodify, modify_script, modify_specific, modify_specific_form) VALUES ('ALIAS_PORTLET', 'portal.site.portletAlias.name', 'plugins/alias/CreatePortletAlias.jsp', 'plugins/alias/ModifyPortletAlias.jsp', 'fr.paris.lutece.portal.business.portlet.AliasPortletHome', 'alias', 'plugins/alias/DoCreatePortletAlias.jsp', '/admin/portlet/script_create_portlet.html', '/admin/portlet/alias/create_portlet_alias.html', '', 'plugins/alias/DoModifyPortletAlias.jsp', '/admin/portlet/script_modify_portlet.html', '/admin/portlet/alias/modify_portlet_alias.html', '');


--
-- Data for Name: core_role; Type: TABLE DATA; Schema: public; Owner: idstore
--



--
-- Data for Name: core_search_parameter; Type: TABLE DATA; Schema: public; Owner: idstore
--

INSERT INTO public.core_search_parameter (parameter_key, parameter_value) VALUES ('type_filter', 'none');
INSERT INTO public.core_search_parameter (parameter_key, parameter_value) VALUES ('default_operator', 'OR');
INSERT INTO public.core_search_parameter (parameter_key, parameter_value) VALUES ('help_message', 'Message d aide pour la recherche');
INSERT INTO public.core_search_parameter (parameter_key, parameter_value) VALUES ('date_filter', '0');
INSERT INTO public.core_search_parameter (parameter_key, parameter_value) VALUES ('tag_filter', '0');
INSERT INTO public.core_search_parameter (parameter_key, parameter_value) VALUES ('taglist', NULL);


--
-- Data for Name: core_style; Type: TABLE DATA; Schema: public; Owner: idstore
--

INSERT INTO public.core_style (id_style, description_style, id_portlet_type, id_portal_component) VALUES (3, 'Menu Init', '', 3);
INSERT INTO public.core_style (id_style, description_style, id_portlet_type, id_portal_component) VALUES (4, 'Main Menu', '', 4);
INSERT INTO public.core_style (id_style, description_style, id_portlet_type, id_portal_component) VALUES (5, 'Breadcrum', '', 5);
INSERT INTO public.core_style (id_style, description_style, id_portlet_type, id_portal_component) VALUES (6, 'Site Map', '', 6);
INSERT INTO public.core_style (id_style, description_style, id_portlet_type, id_portal_component) VALUES (7, 'Tree View', '', 7);
INSERT INTO public.core_style (id_style, description_style, id_portlet_type, id_portal_component) VALUES (8, 'Site Map (Admin mode)', NULL, 8);


--
-- Data for Name: core_style_mode_stylesheet; Type: TABLE DATA; Schema: public; Owner: idstore
--

INSERT INTO public.core_style_mode_stylesheet (id_style, id_mode, id_stylesheet) VALUES (3, 0, 211);
INSERT INTO public.core_style_mode_stylesheet (id_style, id_mode, id_stylesheet) VALUES (4, 0, 213);
INSERT INTO public.core_style_mode_stylesheet (id_style, id_mode, id_stylesheet) VALUES (5, 0, 215);
INSERT INTO public.core_style_mode_stylesheet (id_style, id_mode, id_stylesheet) VALUES (6, 0, 217);
INSERT INTO public.core_style_mode_stylesheet (id_style, id_mode, id_stylesheet) VALUES (7, 0, 253);
INSERT INTO public.core_style_mode_stylesheet (id_style, id_mode, id_stylesheet) VALUES (8, 1, 279);


--
-- Data for Name: core_stylesheet; Type: TABLE DATA; Schema: public; Owner: idstore
--

INSERT INTO public.core_stylesheet (id_stylesheet, description, file_name, source) VALUES (253, 'Child Pages - Tree View', 'menu_tree.xsl', '\x3c3f786d6c2076657273696f6e3d22312e30223f3e0d0a3c78736c3a7374796c6573686565742076657273696f6e3d22312e302220786d6c6e733a78736c3d22687474703a2f2f7777772e77332e6f72672f313939392f58534c2f5472616e73666f726d223e0d0a0d0a3c78736c3a706172616d206e616d653d22736974652d70617468222073656c6563743d22736974652d7061746822202f3e0d0a0d0a3c78736c3a74656d706c617465206d617463683d226d656e752d6c697374223e0d0a093c78736c3a7661726961626c65206e616d653d226d656e752d6c697374222073656c6563743d226d656e7522202f3e0d0a0d0a093c73637269707420747970653d22746578742f6a617661736372697074223e0d0a09092428646f63756d656e74292e72656164792866756e6374696f6e28297b0d0a090909242822237472656522292e7472656576696577287b0d0a09090909616e696d617465643a202266617374222c0d0a09090909636f6c6c61707365643a2066616c73652c0d0a09090909756e697175653a20747275652c0d0a09090909706572736973743a2022636f6f6b6965220d0a0909097d293b0d0a09090d0a09097d293b0d0a093c2f7363726970743e202020200d0a090d0a093c212d2d204d656e752054726565202d2d3e2020202020200d0a093c78736c3a696620746573743d226e6f7428737472696e67286d656e75293d272729223e0d0a09202020203c78736c3a746578742064697361626c652d6f75747075742d6573636170696e673d22796573223e0909202020200d0a2020202020202020202020203c64697620636c6173733d227472656534223e09090d0a0909093c68323e26233136303b3c2f68323e0d0a0909093c756c2069643d22747265652220636c6173733d227472656534223e0d0a202020202020202020202020202020203c78736c3a6170706c792d74656d706c617465732073656c6563743d226d656e7522202f3e20202020202020200d0a0909093c2f756c3e090d0a0909093c2f6469763e0d0a09092009203c6272202f3e0d0a09093c2f78736c3a746578743e200d0a093c2f78736c3a69663e0d0a3c2f78736c3a74656d706c6174653e0d0a0d0a0d0a3c78736c3a74656d706c617465206d617463683d226d656e75223e0d0a202020203c78736c3a7661726961626c65206e616d653d22696e646578223e0d0a20202020093c78736c3a6e756d626572206c6576656c3d2273696e676c65222076616c75653d22706f736974696f6e282922202f3e0d0a202020203c2f78736c3a7661726961626c653e0d0a09093c6c693e0d0a202020203c212d2d3c78736c3a696620746573743d2224696e64657820266c743b2037223e2d2d3e20202020202020200d0a202020202020202020203c6120687265663d227b24736974652d706174687d3f706167655f69643d7b706167652d69647d22207461726765743d225f746f7022203e0d0a2020202020202020202020202020203c78736c3a76616c75652d6f662073656c6563743d22706167652d6e616d6522202f3e0d0a20202020202020202020203c2f613e092020200d0a09092020203c6272202f3e0d0a09092020203c78736c3a76616c75652d6f662073656c6563743d22706167652d6465736372697074696f6e22202f3e0d0a09092020203c212d2d3c78736c3a76616c75652d6f662073656c6563743d22706167652d6465736372697074696f6e22202f3e3c6272202f3e2d2d3e09092020200909090d0a0909093c78736c3a6170706c792d74656d706c617465732073656c6563743d227375626c6576656c2d6d656e752d6c69737422202f3e200d0a0909090d0a09093c2f6c693e20090d0a202020203c212d2d3c2f78736c3a69663e2d2d3e0d0a09090d0a3c2f78736c3a74656d706c6174653e0d0a0d0a3c78736c3a74656d706c617465206d617463683d227375626c6576656c2d6d656e752d6c69737422203e200d0a090d0a093c78736c3a6170706c792d74656d706c617465732073656c6563743d227375626c6576656c2d6d656e7522202f3e200920202020090d0a0d0a3c2f78736c3a74656d706c6174653e0d0a0d0a0d0a3c78736c3a74656d706c617465206d617463683d227375626c6576656c2d6d656e75223e0d0a2020203c78736c3a7661726961626c65206e616d653d22696e6465785f736f75735f6d656e75223e0d0a2020202020202020203c78736c3a6e756d626572206c6576656c3d2273696e676c65222076616c75653d22706f736974696f6e282922202f3e0d0a2020203c2f78736c3a7661726961626c653e0d0a0909203c756c203e0d0a0909093c6c693e0d0a3c212d2d093c7370616e3e202d2d3e0d0a090909093c6120687265663d227b24736974652d706174687d3f706167655f69643d7b706167652d69647d22207461726765743d225f746f70223e0d0a09090909093c78736c3a76616c75652d6f662073656c6563743d22706167652d6e616d6522202f3e0d0a090909093c2f613e0d0a0909093c2f6c693e0909090d0a09093c2f756c3e0d0a093c212d2d3c2f7370616e3e092d2d3e0d0a09090d0a2020200d0a3c2f78736c3a74656d706c6174653e0d0a0d0a3c2f78736c3a7374796c6573686565743e0d0a');
INSERT INTO public.core_stylesheet (id_stylesheet, description, file_name, source) VALUES (215, 'Breadcrum', 'page_path.xsl', '\x3c3f786d6c2076657273696f6e3d22312e30223f3e0d0a3c78736c3a7374796c6573686565742076657273696f6e3d22312e302220786d6c6e733a78736c3d22687474703a2f2f7777772e77332e6f72672f313939392f58534c2f5472616e73666f726d223e0d0a0d0a3c78736c3a706172616d206e616d653d22736974652d70617468222073656c6563743d22736974652d7061746822202f3e0d0a0d0a0d0a3c78736c3a74656d706c617465206d617463683d2270616765223e0d0a09093c78736c3a696620746573743d22706f736974696f6e2829213d6c61737428292d31223e0d0a0909093c6120687265663d227b24736974652d706174687d3f706167655f69643d7b706167652d69647d22207461726765743d225f746f70223e3c78736c3a76616c75652d6f662073656c6563743d22706167652d6e616d6522202f3e3c2f613e203e0d0a09093c2f78736c3a69663e0d0a09093c78736c3a696620746573743d22706f736974696f6e28293d6c61737428292d31223e0d0a0909093c78736c3a76616c75652d6f662073656c6563743d22706167652d6e616d6522202f3e0d0a09093c2f78736c3a69663e0d0a3c2f78736c3a74656d706c6174653e0d0a0d0a0d0a3c78736c3a74656d706c617465206d617463683d22706167655f6c696e6b223e0d0a09093c78736c3a696620746573743d22706f736974696f6e2829213d6c61737428292d31223e0d0a0909093c6120687265663d227b24736974652d706174687d3f7b706167652d75726c7d22207461726765743d225f746f70223e3c78736c3a76616c75652d6f662073656c6563743d22706167652d6e616d6522202f3e3c2f613e203e0d0a09093c2f78736c3a69663e0d0a09093c78736c3a696620746573743d22706f736974696f6e28293d6c61737428292d31223e0d0a0909093c78736c3a76616c75652d6f662073656c6563743d22706167652d6e616d6522202f3e0d0a09093c2f78736c3a69663e0d0a3c2f78736c3a74656d706c6174653e0d0a0d0a0d0a3c2f78736c3a7374796c6573686565743e');
INSERT INTO public.core_stylesheet (id_stylesheet, description, file_name, source) VALUES (213, 'Main Menu', 'menu_main.xsl', '\x3c3f786d6c2076657273696f6e3d22312e30223f3e0d0a3c78736c3a7374796c6573686565742076657273696f6e3d22312e30220d0a09786d6c6e733a78736c3d22687474703a2f2f7777772e77332e6f72672f313939392f58534c2f5472616e73666f726d223e0d0a0d0a093c78736c3a706172616d206e616d653d22736974652d70617468222073656c6563743d22736974652d7061746822202f3e0d0a0d0a093c78736c3a74656d706c617465206d617463683d226d656e752d6c697374223e0d0a09093c78736c3a6170706c792d74656d706c617465732073656c6563743d226d656e7522202f3e0d0a093c2f78736c3a74656d706c6174653e0d0a0d0a093c78736c3a74656d706c617465206d617463683d226d656e75223e0d0a09093c6c693e0d0a0909093c6120687265663d227b24736974652d706174687d3f706167655f69643d7b706167652d69647d2220636c6173733d2266697273742d6c6576656c22207461726765743d225f746f70223e0d0a09090909093c78736c3a76616c75652d6f662073656c6563743d22706167652d6e616d6522202f3e0d0a0909093c2f613e0d0a09093c2f6c693e0d0a093c2f78736c3a74656d706c6174653e0d0a0d0a3c2f78736c3a7374796c6573686565743e0d0a0d0a');
INSERT INTO public.core_stylesheet (id_stylesheet, description, file_name, source) VALUES (211, 'Menu Init', 'menu_init.xsl', '\x3c3f786d6c2076657273696f6e3d22312e30223f3e0d0a3c78736c3a7374796c6573686565742076657273696f6e3d22312e302220786d6c6e733a78736c3d22687474703a2f2f7777772e77332e6f72672f313939392f58534c2f5472616e73666f726d223e0d0a0d0a3c78736c3a706172616d206e616d653d22736974652d70617468222073656c6563743d22736974652d7061746822202f3e0d0a0d0a3c78736c3a74656d706c617465206d617463683d226d656e752d6c697374223e0d0a3c6272202f3e3c6272202f3e0d0a093c6469762069643d226d656e752d696e6974223e0d0a09093c6469762069643d226d656e752d696e69742d636f6e74656e74223e0d0a2020202020202020202020203c756c2069643d226d656e752d7665727469223e0d0a202020202020202020202020202020203c78736c3a6170706c792d74656d706c617465732073656c6563743d226d656e7522202f3e0d0a2020202020202020202020203c2f756c3e0d0a20202020202020203c2f6469763e0d0a20202020203c2f6469763e0d0a3c2f78736c3a74656d706c6174653e0d0a0d0a0d0a3c78736c3a74656d706c617465206d617463683d226d656e75223e0d0a202020203c78736c3a7661726961626c65206e616d653d22696e646578223e0d0a20202020093c78736c3a6e756d626572206c6576656c3d2273696e676c65222076616c75653d22706f736974696f6e282922202f3e0d0a202020203c2f78736c3a7661726961626c653e0d0a0d0a202020203c78736c3a696620746573743d2224696e646578202667743b2037223e0d0a20202020202020203c6c6920636c6173733d2266697273742d7665727469223e0d0a2020202020202020093c6120687265663d227b24736974652d706174687d3f706167655f69643d7b706167652d69647d22207461726765743d225f746f70223e0d0a2020202020202020202009093c78736c3a76616c75652d6f662073656c6563743d22706167652d6e616d6522202f3e0d0a0920202020202020203c2f613e0d0a2020202009202020203c78736c3a6170706c792d74656d706c617465732073656c6563743d227375626c6576656c2d6d656e752d6c69737422202f3e0d0a20202020202020203c2f6c693e0d0a2020203c2f78736c3a69663e0d0a3c2f78736c3a74656d706c6174653e0d0a0d0a3c78736c3a74656d706c617465206d617463683d227375626c6576656c2d6d656e752d6c69737422203e0d0a093c756c3e0d0a20202020093c6c6920636c6173733d226c6173742d7665727469223e0d0a090920093c78736c3a6170706c792d74656d706c617465732073656c6563743d227375626c6576656c2d6d656e7522202f3e0d0a2009202020203c2f6c693e0d0a202020203c2f756c3e0d0a3c2f78736c3a74656d706c6174653e0d0a0d0a3c78736c3a74656d706c617465206d617463683d227375626c6576656c2d6d656e75223e0d0a2020203c78736c3a7661726961626c65206e616d653d22696e6465785f736f75735f6d656e75223e0d0a2020202020202020203c78736c3a6e756d626572206c6576656c3d2273696e676c65222076616c75653d22706f736974696f6e282922202f3e0d0a2020203c2f78736c3a7661726961626c653e0d0a0d0a2020203c6120687265663d227b24736974652d706174687d3f706167655f69643d7b706167652d69647d22207461726765743d225f746f70223e0d0a09093c7370616e3e3c78736c3a76616c75652d6f662073656c6563743d22706167652d6e616d6522202f3e3c2f7370616e3e0d0a2020203c2f613e0d0a3c2f78736c3a74656d706c6174653e0d0a0d0a3c2f78736c3a7374796c6573686565743e0d0a');
INSERT INTO public.core_stylesheet (id_stylesheet, description, file_name, source) VALUES (217, 'Site Map', 'site_map.xsl', '\x3c3f786d6c2076657273696f6e3d22312e302220656e636f64696e673d2249534f2d383835392d31223f3e0d0a3c78736c3a7374796c6573686565742076657273696f6e3d22312e302220786d6c6e733a78736c3d22687474703a2f2f7777772e77332e6f72672f313939392f58534c2f5472616e73666f726d223e0d0a0d0a3c78736c3a706172616d206e616d653d22736974652d70617468222073656c6563743d22736974652d7061746822202f3e0d0a0d0a0d0a3c78736c3a74656d706c617465206d617463683d22706167655b706167652d6c6576656c3d305d223e0d0a093c64697620636c6173733d227370616e2d31352070726570656e642d3120617070656e642d3120617070656e642d626f74746f6d223e0d0a09093c64697620636c6173733d22706f72746c6574202d6c75746563652d626f726465722d726164697573223e0d0a0909093c78736c3a6170706c792d74656d706c617465732073656c6563743d226368696c642d70616765732d6c69737422202f3e0d0a09093c2f6469763e0d0a093c2f6469763e0d0a3c2f78736c3a74656d706c6174653e0d0a0d0a0d0a3c78736c3a74656d706c617465206d617463683d22706167655b706167652d6c6576656c3d315d22203e0d0a3c756c20636c6173733d22736974652d6d61702d6c6576656c2d6f6e65223e0d0a093c6c693e0d0a09093c6120687265663d227b24736974652d706174687d3f706167655f69643d7b706167652d69647d22207461726765743d225f746f70223e0d0a0909093c78736c3a76616c75652d6f662073656c6563743d22706167652d6e616d6522202f3e0d0a09093c2f613e0d0a09093c78736c3a6170706c792d74656d706c617465732073656c6563743d22706167652d6465736372697074696f6e22202f3e0d0a09093c78736c3a6170706c792d74656d706c617465732073656c6563743d22706167652d696d61676522202f3e0d0a09093c78736c3a6170706c792d74656d706c617465732073656c6563743d226368696c642d70616765732d6c69737422202f3e0d0a09202020203c78736c3a746578742064697361626c652d6f75747075742d6573636170696e673d22796573223e0d0a0909202020203c215b43444154415b3c64697620636c6173733d22636c656172223e26233136303b3c2f6469763e5d5d3e0d0a09202020203c2f78736c3a746578743e0d0a093c2f6c693e0d0a3c2f756c3e0d0a3c2f78736c3a74656d706c6174653e0d0a0d0a0d0a3c78736c3a74656d706c617465206d617463683d22706167655b706167652d6c6576656c3d325d22203e0d0a3c756c20636c6173733d22736974652d6d61702d6c6576656c2d74776f223e0d0a093c6c693e0d0a09093c6120687265663d227b24736974652d706174687d3f706167655f69643d7b706167652d69647d22207461726765743d225f746f70223e0d0a0909093c78736c3a76616c75652d6f662073656c6563743d22706167652d6e616d6522202f3e0d0a09093c2f613e0d0a09093c78736c3a6170706c792d74656d706c617465732073656c6563743d22706167652d6465736372697074696f6e22202f3e0d0a09093c78736c3a6170706c792d74656d706c617465732073656c6563743d226368696c642d70616765732d6c69737422202f3e0d0a093c2f6c693e0d0a3c2f756c3e0d0a3c2f78736c3a74656d706c6174653e0d0a0d0a0d0a3c78736c3a74656d706c617465206d617463683d22706167655b706167652d6c6576656c3e325d22203e0d0a3c756c20636c6173733d22736974652d6d61702d6c6576656c2d68696768657374223e0d0a093c6c693e0d0a09093c6120687265663d227b24736974652d706174687d3f706167655f69643d7b706167652d69647d22207461726765743d225f746f70223e0d0a0909093c78736c3a76616c75652d6f662073656c6563743d22706167652d6e616d6522202f3e0d0a09093c2f613e0d0a09093c78736c3a6170706c792d74656d706c617465732073656c6563743d22706167652d6465736372697074696f6e22202f3e0d0a09093c78736c3a6170706c792d74656d706c617465732073656c6563743d226368696c642d70616765732d6c69737422202f3e0d0a093c2f6c693e0d0a3c2f756c3e0d0a3c2f78736c3a74656d706c6174653e0d0a0d0a0d0a3c78736c3a74656d706c617465206d617463683d22706167652d6465736372697074696f6e223e0d0a093c6272202f3e3c78736c3a76616c75652d6f662073656c6563743d222e22202f3e0d0a3c2f78736c3a74656d706c6174653e0d0a0d0a0d0a3c78736c3a74656d706c617465206d617463683d226368696c642d70616765732d6c6973745b706167652d6c6576656c3d305d223e0d0a093c78736c3a696620746573743d22636f756e742870616765293e3022203e0d0a09093c78736c3a6170706c792d74656d706c617465732073656c6563743d227061676522202f3e0d0a202020203c2f78736c3a69663e0d0a3c2f78736c3a74656d706c6174653e0d0a0d0a0d0a3c78736c3a74656d706c617465206d617463683d226368696c642d70616765732d6c6973745b706167652d6c6576656c3d315d223e0d0a093c78736c3a696620746573743d22636f756e742870616765293e3022203e0d0a09093c78736c3a6170706c792d74656d706c617465732073656c6563743d227061676522202f3e0d0a202020203c2f78736c3a69663e0d0a3c2f78736c3a74656d706c6174653e0d0a0d0a0d0a3c78736c3a74656d706c617465206d617463683d226368696c642d70616765732d6c6973745b706167652d6c6576656c3d325d223e0d0a093c78736c3a696620746573743d22636f756e742870616765293e3022203e0d0a09093c78736c3a6170706c792d74656d706c617465732073656c6563743d227061676522202f3e0d0a202020203c2f78736c3a69663e0d0a3c2f78736c3a74656d706c6174653e0d0a0d0a3c78736c3a74656d706c617465206d617463683d226368696c642d70616765732d6c6973745b706167652d6c6576656c3e325d223e0d0a093c78736c3a696620746573743d22636f756e742870616765293e3022203e0d0a09093c78736c3a6170706c792d74656d706c617465732073656c6563743d227061676522202f3e0d0a202020203c2f78736c3a69663e0d0a3c2f78736c3a74656d706c6174653e0d0a0d0a0d0a3c78736c3a74656d706c617465206d617463683d22706167652d696d616765223e0d0a093c64697620636c6173733d226c6576656c2d6f6e652d696d616765223e0d0a20202020093c64697620636c6173733d22706f6c61726f6964223e0d0a09093c696d672020626f726465723d2230222077696474683d22383022206865696768743d22383022207372633d22696d616765732f6c6f63616c2f646174612f70616765732f7b2e7d2220616c743d2222202f3e0d0a2020202020202020203c2f6469763e0d0a093c2f646976203e0d0a3c2f78736c3a74656d706c6174653e0d0a0d0a0d0a3c2f78736c3a7374796c6573686565743e0d0a');
INSERT INTO public.core_stylesheet (id_stylesheet, description, file_name, source) VALUES (279, 'Site Map (Admin mode)', 'admin_site_map_admin.xsl', '\x3c3f786d6c2076657273696f6e3d22312e30223f3e0d0a3c78736c3a7374796c6573686565742076657273696f6e3d22312e302220786d6c6e733a78736c3d22687474703a2f2f7777772e77332e6f72672f313939392f58534c2f5472616e73666f726d223e0d0a3c78736c3a706172616d206e616d653d22736974652d70617468222073656c6563743d22736974652d7061746822202f3e0d0a3c78736c3a7661726961626c65206e616d653d2263757272656e742d706167652d6964222073656c6563743d2263757272656e742d706167652d696422202f3e0d0a0d0a3c78736c3a74656d706c617465206d617463683d22706167655b706167652d6c6576656c3d305d223e200d0a093c6469762069643d22747265652220636c6173733d226a73747265652d64656661756c74223e0d0a09093c6120687265663d227b24736974652d706174687d3f706167655f69643d7b706167652d69647d22207469746c653d227b706167652d6465736372697074696f6e7d22203e0d0a0909093c78736c3a76616c75652d6f662073656c6563743d22706167652d6e616d6522202f3e0d0a0909093c78736c3a696620746573743d226e6f7428737472696e6728706167652d726f6c65293d276e6f6e652729223e200d0a090909093c7374726f6e673e3c78736c3a746578742064697361626c652d6f75747075742d6573636170696e673d22796573223e2d20236931386e7b706f7274616c2e736974652e61646d696e5f706167652e74616241646d696e4d6170526f6c6552657365727665647d3c2f78736c3a746578743e0d0a090909093c78736c3a76616c75652d6f662073656c6563743d22706167652d726f6c6522202f3e3c2f7374726f6e673e0d0a0909093c2f78736c3a69663e2020202020202020202020200d0a09093c2f613e0d0a09093c756c3e0d0a0909093c78736c3a6170706c792d74656d706c617465732073656c6563743d226368696c642d70616765732d6c69737422202f3e0d0a09093c2f756c3e0d0a093c2f6469763e0d0a3c2f78736c3a74656d706c6174653e0d0a202020200d0a3c78736c3a74656d706c617465206d617463683d22706167655b706167652d6c6576656c3e305d22203e0d0a093c78736c3a7661726961626c65206e616d653d22696e646578222073656c6563743d22706167652d696422202f3e0d0a093c78736c3a7661726961626c65206e616d653d226465736372697074696f6e222073656c6563743d22706167652d6465736372697074696f6e22202f3e0d0a090d0a093c6c692069643d226e6f64652d7b24696e6465787d223e0d0a09093c6120687265663d227b24736974652d706174687d3f706167655f69643d7b706167652d69647d22207469746c653d227b246465736372697074696f6e7d223e0d0a09093c78736c3a76616c75652d6f662073656c6563743d22706167652d6e616d6522202f3e0d0a0909093c78736c3a696620746573743d226e6f7428737472696e6728706167652d726f6c65293d276e6f6e652729223e0d0a090909093c7374726f6e673e0d0a0909090920203c78736c3a746578742064697361626c652d6f75747075742d6573636170696e673d22796573223e236931386e7b706f7274616c2e736974652e61646d696e5f706167652e74616241646d696e4d6170526f6c6552657365727665647d3c2f78736c3a746578743e3c78736c3a76616c75652d6f662073656c6563743d22706167652d726f6c6522202f3e0d0a090909093c2f7374726f6e673e0d0a0909093c2f78736c3a69663e0d0a09093c2f613e0d0a09093c78736c3a63686f6f73653e0d0a0909093c78736c3a7768656e20746573743d22636f756e74286368696c642d70616765732d6c6973742f2a293e30223e0d0a090909093c756c3e0d0a090909092020203c78736c3a6170706c792d74656d706c617465732073656c6563743d226368696c642d70616765732d6c69737422202f3e0d0a090909093c2f756c3e0d0a0909093c2f78736c3a7768656e3e0d0a09092020203c78736c3a6f74686572776973653e0d0a090909093c78736c3a6170706c792d74656d706c617465732073656c6563743d226368696c642d70616765732d6c69737422202f3e0d0a09092020203c2f78736c3a6f74686572776973653e0d0a09093c2f78736c3a63686f6f73653e0d0a093c2f6c693e0d0a3c2f78736c3a74656d706c6174653e0d0a202020200d0a3c78736c3a74656d706c617465206d617463683d226368696c642d70616765732d6c697374223e0d0a093c78736c3a6170706c792d74656d706c617465732073656c6563743d227061676522202f3e0d0a3c2f78736c3a74656d706c6174653e0d0a202020200d0a3c2f78736c3a7374796c6573686565743e0d0a');


--
-- Data for Name: core_template; Type: TABLE DATA; Schema: public; Owner: idstore
--

INSERT INTO public.core_template (template_name, template_value) VALUES ('core_first_alert_mail', 'Bonjour ${first_name} ! Votre compte utilisateur arrive à expiration. Pour prolonger sa validité, veuillez <a href="${url}">cliquer ici</a>.</br>Si vous ne le faites pas avant le ${date_valid}, il sera désactivé.');
INSERT INTO public.core_template (template_name, template_value) VALUES ('core_expiration_mail', 'Bonjour ${first_name} ! Votre compte a expiré. Vous ne pourrez plus vous connecter avec, et les données vous concernant ont été anonymisées');
INSERT INTO public.core_template (template_name, template_value) VALUES ('core_other_alert_mail', 'Bonjour ${first_name} ! Votre compte utilisateur arrive à expiration. Pour prolonger sa validité, veuillez <a href="${url}">cliquer ici</a>.</br>Si vous ne le faites pas avant le ${date_valid}, il sera désactivé.');
INSERT INTO public.core_template (template_name, template_value) VALUES ('core_account_reactivated_mail', 'Bonjour ${first_name} ! Votre compte utilisateur a bien été réactivé. Il est désormais valable jusqu''au ${date_valid}.');
INSERT INTO public.core_template (template_name, template_value) VALUES ('core_password_expired', 'Bonjour ! Votre mot de passe a expiré. Lors de votre prochaine connexion, vous pourrez le changer.');


--
-- Data for Name: core_text_editor; Type: TABLE DATA; Schema: public; Owner: idstore
--

INSERT INTO public.core_text_editor (editor_name, editor_description, backoffice) VALUES ('tinymce', 'portal.admindashboard.editors.labelBackTinyMCE', 1);
INSERT INTO public.core_text_editor (editor_name, editor_description, backoffice) VALUES ('', 'portal.admindashboard.editors.labelBackNoEditor', 1);
INSERT INTO public.core_text_editor (editor_name, editor_description, backoffice) VALUES ('', 'portal.admindashboard.editors.labelFrontNoEditor', 0);
INSERT INTO public.core_text_editor (editor_name, editor_description, backoffice) VALUES ('markitupbbcode', 'portal.admindashboard.editors.labelFrontMarkitupBBCode', 0);


--
-- Data for Name: core_user_password_history; Type: TABLE DATA; Schema: public; Owner: idstore
--

INSERT INTO public.core_user_password_history (id_user, password, date_password_change) VALUES (1, 'PBKDF2WITHHMACSHA512:40000:0b064a0cb032199100cdcba177027eb4:1475491168321a0d795c2c9bc2d2280b2eed5408b3c1c5fbdd793bff8f31dfef7a12fb412926de24a60a166c963f340f1ee67171387430e25728c93601889e4d292637a71c4dcf7c1c57791a081095885061facb79f650321bc52645172f8860e368261e03de92812ed0bd4c9055ff0f9d46df18fac048cefa96fefeb6f1eef8', '2022-12-02 10:38:42.291788');


--
-- Data for Name: core_user_preferences; Type: TABLE DATA; Schema: public; Owner: idstore
--



--
-- Data for Name: core_user_right; Type: TABLE DATA; Schema: public; Owner: idstore
--

INSERT INTO public.core_user_right (id_right, id_user) VALUES ('CORE_ADMIN_SITE', 1);
INSERT INTO public.core_user_right (id_right, id_user) VALUES ('CORE_ADMIN_SITE', 2);
INSERT INTO public.core_user_right (id_right, id_user) VALUES ('CORE_LINK_SERVICE_MANAGEMENT', 1);
INSERT INTO public.core_user_right (id_right, id_user) VALUES ('CORE_LINK_SERVICE_MANAGEMENT', 2);
INSERT INTO public.core_user_right (id_right, id_user) VALUES ('CORE_CACHE_MANAGEMENT', 1);
INSERT INTO public.core_user_right (id_right, id_user) VALUES ('CORE_DAEMONS_MANAGEMENT', 1);
INSERT INTO public.core_user_right (id_right, id_user) VALUES ('CORE_FEATURES_MANAGEMENT', 1);
INSERT INTO public.core_user_right (id_right, id_user) VALUES ('CORE_LEVEL_RIGHT_MANAGEMENT', 1);
INSERT INTO public.core_user_right (id_right, id_user) VALUES ('CORE_LOGS_VISUALISATION', 1);
INSERT INTO public.core_user_right (id_right, id_user) VALUES ('CORE_MAILINGLISTS_MANAGEMENT', 1);
INSERT INTO public.core_user_right (id_right, id_user) VALUES ('CORE_MODES_MANAGEMENT', 1);
INSERT INTO public.core_user_right (id_right, id_user) VALUES ('CORE_PAGE_TEMPLATE_MANAGEMENT', 1);
INSERT INTO public.core_user_right (id_right, id_user) VALUES ('CORE_PAGE_TEMPLATE_MANAGEMENT', 2);
INSERT INTO public.core_user_right (id_right, id_user) VALUES ('CORE_PLUGINS_MANAGEMENT', 1);
INSERT INTO public.core_user_right (id_right, id_user) VALUES ('CORE_PROPERTIES_MANAGEMENT', 1);
INSERT INTO public.core_user_right (id_right, id_user) VALUES ('CORE_PROPERTIES_MANAGEMENT', 2);
INSERT INTO public.core_user_right (id_right, id_user) VALUES ('CORE_RBAC_MANAGEMENT', 1);
INSERT INTO public.core_user_right (id_right, id_user) VALUES ('CORE_ROLES_MANAGEMENT', 1);
INSERT INTO public.core_user_right (id_right, id_user) VALUES ('CORE_ROLES_MANAGEMENT', 2);
INSERT INTO public.core_user_right (id_right, id_user) VALUES ('CORE_SEARCH_INDEXATION', 1);
INSERT INTO public.core_user_right (id_right, id_user) VALUES ('CORE_SEARCH_INDEXATION', 2);
INSERT INTO public.core_user_right (id_right, id_user) VALUES ('CORE_SEARCH_MANAGEMENT', 1);
INSERT INTO public.core_user_right (id_right, id_user) VALUES ('CORE_SEARCH_MANAGEMENT', 2);
INSERT INTO public.core_user_right (id_right, id_user) VALUES ('CORE_STYLES_MANAGEMENT', 1);
INSERT INTO public.core_user_right (id_right, id_user) VALUES ('CORE_STYLESHEET_MANAGEMENT', 1);
INSERT INTO public.core_user_right (id_right, id_user) VALUES ('CORE_USERS_MANAGEMENT', 1);
INSERT INTO public.core_user_right (id_right, id_user) VALUES ('CORE_USERS_MANAGEMENT', 2);
INSERT INTO public.core_user_right (id_right, id_user) VALUES ('CORE_WORKGROUPS_MANAGEMENT', 1);
INSERT INTO public.core_user_right (id_right, id_user) VALUES ('CORE_WORKGROUPS_MANAGEMENT', 2);
INSERT INTO public.core_user_right (id_right, id_user) VALUES ('CORE_RIGHT_MANAGEMENT', 1);
INSERT INTO public.core_user_right (id_right, id_user) VALUES ('CORE_ADMINDASHBOARD_MANAGEMENT', 1);
INSERT INTO public.core_user_right (id_right, id_user) VALUES ('CORE_DASHBOARD_MANAGEMENT', 1);
INSERT INTO public.core_user_right (id_right, id_user) VALUES ('CORE_XSL_EXPORT_MANAGEMENT', 1);
INSERT INTO public.core_user_right (id_right, id_user) VALUES ('CORE_TEMPLATES_AUTO_INCLUDES_MANAGEMENT', 1);
INSERT INTO public.core_user_right (id_right, id_user) VALUES ('CORE_EDITORS_MANAGEMENT', 1);
INSERT INTO public.core_user_right (id_right, id_user) VALUES ('IDENTITYSTORE_MANAGEMENT', 1);
INSERT INTO public.core_user_right (id_right, id_user) VALUES ('IDENTITYSTORE_ADMIN_MANAGEMENT', 1);
INSERT INTO public.core_user_right (id_right, id_user) VALUES ('IDENTITYSTORE_REF_MANAGEMENT', 1);
INSERT INTO public.core_user_right (id_right, id_user) VALUES ('VIEW_IDENTITY', 1);
INSERT INTO public.core_user_right (id_right, id_user) VALUES ('INDEX_IDENTITY', 1);

--
-- Data for Name: core_user_role; Type: TABLE DATA; Schema: public; Owner: idstore
--

INSERT INTO public.core_user_role (role_key, id_user) VALUES ('all_site_manager', 1);
INSERT INTO public.core_user_role (role_key, id_user) VALUES ('super_admin', 1);
INSERT INTO public.core_user_role (role_key, id_user) VALUES ('all_site_manager', 2);
INSERT INTO public.core_user_role (role_key, id_user) VALUES ('super_admin', 2);

--
-- Data for Name: core_xsl_export; Type: TABLE DATA; Schema: public; Owner: idstore
--

INSERT INTO public.core_xsl_export (id_xsl_export, title, description, extension, id_file, plugin) VALUES (125, 'Core - Export users to a CSV file', 'Export back office users to a CSV file', 'csv', 125, 'core');
INSERT INTO public.core_xsl_export (id_xsl_export, title, description, extension, id_file, plugin) VALUES (126, 'Core - Export users to a XML file', 'Export back office users to a XML file', 'xml', 126, 'core');

--
-- Data for Name: identitystore_attribute; Type: TABLE DATA; Schema: public; Owner: idstore
--

INSERT INTO public.identitystore_attribute (id_attribute, name, key_name, description, key_type, certifiable, pivot, key_weight) VALUES (12, 'Téléphone portable', 'mobile_phone', 'Réservé pour l''envoi de SMS', 0, 1, 0, 0);
INSERT INTO public.identitystore_attribute (id_attribute, name, key_name, description, key_type, certifiable, pivot, key_weight) VALUES (13, 'Téléphone fixe', 'fixed_phone', '', 0, 0, 0, 0);
INSERT INTO public.identitystore_attribute (id_attribute, name, key_name, description, key_type, certifiable, pivot, key_weight) VALUES (14, 'Adresse', 'address', '', 0, 1, 0, 0);
INSERT INTO public.identitystore_attribute (id_attribute, name, key_name, description, key_type, certifiable, pivot, key_weight) VALUES (15, 'Complément d''adresse', 'address_complement', '', 0, 1, 0, 0);
INSERT INTO public.identitystore_attribute (id_attribute, name, key_name, description, key_type, certifiable, pivot, key_weight) VALUES (16, 'Code postal', 'address_postal_code', 'Champ d''adresse : code postal', 0, 1, 0, 0);
INSERT INTO public.identitystore_attribute (id_attribute, name, key_name, description, key_type, certifiable, pivot, key_weight) VALUES (17, 'Ville', 'address_city', 'Champ d''adresse : ville', 0, 1, 0, 0);
INSERT INTO public.identitystore_attribute (id_attribute, name, key_name, description, key_type, certifiable, pivot, key_weight) VALUES (18, 'Moyen de contact préféré ', 'preferred_contact', '', 0, 0, 0, 0);
INSERT INTO public.identitystore_attribute (id_attribute, name, key_name, description, key_type, certifiable, pivot, key_weight) VALUES (19, 'Acceptation des CGU', 'accepted_cgu', '', 0, 0, 0, 0);
INSERT INTO public.identitystore_attribute (id_attribute, name, key_name, description, key_type, certifiable, pivot, key_weight) VALUES (20, 'ID Store Key', 'ids_key', '', 0, 1, 0, 0);
INSERT INTO public.identitystore_attribute (id_attribute, name, key_name, description, key_type, certifiable, pivot, key_weight) VALUES (21, 'Adresse de facturation', 'address_billing', '', 0, 0, 0, 0);
INSERT INTO public.identitystore_attribute (id_attribute, name, key_name, description, key_type, certifiable, pivot, key_weight) VALUES (22, 'Complément d''adresse de facturation', 'address_billing_complement', '', 0, 0, 0, 0);
INSERT INTO public.identitystore_attribute (id_attribute, name, key_name, description, key_type, certifiable, pivot, key_weight) VALUES (23, 'Code postal d''adresse de facturation', 'address_billing_postal_code', '', 0, 0, 0, 0);
INSERT INTO public.identitystore_attribute (id_attribute, name, key_name, description, key_type, certifiable, pivot, key_weight) VALUES (24, 'Ville d''adresse de facturation', 'address_billing_city', '', 0, 0, 0, 0);
INSERT INTO public.identitystore_attribute (id_attribute, name, key_name, description, key_type, certifiable, pivot, key_weight) VALUES (25, 'Accepte les informations de la MDP', 'info_accepted', '', 0, 0, 0, 0);
INSERT INTO public.identitystore_attribute (id_attribute, name, key_name, description, key_type, certifiable, pivot, key_weight) VALUES (26, 'Accepte les enquetes de satisfaction ', 'survey_accepted', '', 0, 0, 0, 0);
INSERT INTO public.identitystore_attribute (id_attribute, name, key_name, description, key_type, certifiable, pivot, key_weight) VALUES (27, '(FC) Prénoms', 'fc_given_name', 'Format Pivot FranceConnect - Liste des prénoms', 0, 0, 0, 0);
INSERT INTO public.identitystore_attribute (id_attribute, name, key_name, description, key_type, certifiable, pivot, key_weight) VALUES (28, '(FC) Nom de naissance', 'fc_family_name', 'Format Pivot FranceConnect', 0, 0, 0, 0);
INSERT INTO public.identitystore_attribute (id_attribute, name, key_name, description, key_type, certifiable, pivot, key_weight) VALUES (29, '(FC) Date de naissance', 'fc_birthdate', 'Format Pivot FranceConnect - format YYYY-MM-DD', 0, 0, 0, 0);
INSERT INTO public.identitystore_attribute (id_attribute, name, key_name, description, key_type, certifiable, pivot, key_weight) VALUES (30, '(FC) Genre', 'fc_gender', 'Format Pivot FranceConnect - male / female', 0, 0, 0, 0);
INSERT INTO public.identitystore_attribute (id_attribute, name, key_name, description, key_type, certifiable, pivot, key_weight) VALUES (31, '(FC) Lieu de naissance', 'fc_birthplace', 'Format Pivot FranceConnect - Code INSEE du lieu de naissance (ou une chaîne vide si la personne est née à l''étranger)', 0, 0, 0, 0);
INSERT INTO public.identitystore_attribute (id_attribute, name, key_name, description, key_type, certifiable, pivot, key_weight) VALUES (32, '(FC) Pays de naissance', 'fc_birthcountry', 'Format Pivot FranceConnect - Code INSEE du pays de naissance', 0, 0, 0, 0);
INSERT INTO public.identitystore_attribute (id_attribute, name, key_name, description, key_type, certifiable, pivot, key_weight) VALUES (33, '(FC) Key', 'fc_key', 'Format Pivot FranceConnect - Key', 0, 0, 0, 0);
INSERT INTO public.identitystore_attribute (id_attribute, name, key_name, description, key_type, certifiable, pivot, key_weight) VALUES (34, '(VOTE) Prénoms', 'vote_given_name', 'Format VOTE - Liste des prénoms', 0, 0, 0, 0);
INSERT INTO public.identitystore_attribute (id_attribute, name, key_name, description, key_type, certifiable, pivot, key_weight) VALUES (35, '(VOTE) Nom de naissance', 'vote_family_name', '', 0, 0, 0, 0);
INSERT INTO public.identitystore_attribute (id_attribute, name, key_name, description, key_type, certifiable, pivot, key_weight) VALUES (36, '(VOTE) Ville de naissance', 'vote_birthplace', '', 0, 0, 0, 0);
INSERT INTO public.identitystore_attribute (id_attribute, name, key_name, description, key_type, certifiable, pivot, key_weight) VALUES (37, '(VOTE) Pays de naissance', 'vote_birthcountry', '', 0, 0, 0, 0);
INSERT INTO public.identitystore_attribute (id_attribute, name, key_name, description, key_type, certifiable, pivot, key_weight) VALUES (38, '(VOTE) Date de naissance', 'vote_birthdate', '', 0, 0, 0, 0);
INSERT INTO public.identitystore_attribute (id_attribute, name, key_name, description, key_type, certifiable, pivot, key_weight) VALUES (39, '(VOTE) Key', 'vote_key', 'Format Pivot FranceConnect - Key', 0, 0, 0, 0);
INSERT INTO public.identitystore_attribute (id_attribute, name, key_name, description, key_type, certifiable, pivot, key_weight) VALUES (8, 'Libellé INSEE pays de naissance', 'insee_birthcountry_label', '', 0, 1, 0, 3);
INSERT INTO public.identitystore_attribute (id_attribute, name, key_name, description, key_type, certifiable, pivot, key_weight) VALUES (1, 'Nom de famille de naissance', 'family_name', '', 0, 1, 1, 18);
INSERT INTO public.identitystore_attribute (id_attribute, name, key_name, description, key_type, certifiable, pivot, key_weight) VALUES (2, 'Nom usuel', 'preferred_username', '', 0, 0, 0, 15);
INSERT INTO public.identitystore_attribute (id_attribute, name, key_name, description, key_type, certifiable, pivot, key_weight) VALUES (10, 'Email de connexion', 'email_login', '', 0, 1, 0, 20);
INSERT INTO public.identitystore_attribute (id_attribute, name, key_name, description, key_type, certifiable, pivot, key_weight) VALUES (4, 'Date de naissance', 'birthdate', 'au format DD/MM/YYYY', 0, 1, 1, 17);
INSERT INTO public.identitystore_attribute (id_attribute, name, key_name, description, key_type, certifiable, pivot, key_weight) VALUES (7, 'Libellé INSEE commune de naissance', 'insee_birthplace_label', '', 0, 1, 0, 5);
INSERT INTO public.identitystore_attribute (id_attribute, name, key_name, description, key_type, certifiable, pivot, key_weight) VALUES (3, 'Prénoms', 'first_name', 'Prénoms usuels', 0, 1, 1, 10);
INSERT INTO public.identitystore_attribute (id_attribute, name, key_name, description, key_type, certifiable, pivot, key_weight) VALUES (5, 'Code INSEE commune de naissance', 'insee_birthplace_code', '', 0, 1, 1, 5);
INSERT INTO public.identitystore_attribute (id_attribute, name, key_name, description, key_type, certifiable, pivot, key_weight) VALUES (9, 'Email', 'email', '', 0, 1, 0, 20);
INSERT INTO public.identitystore_attribute (id_attribute, name, key_name, description, key_type, certifiable, pivot, key_weight) VALUES (11, 'Genre', 'gender', '0:Non défini /  1:Homme / 2:Femme', 0, 1, 1, 3);
INSERT INTO public.identitystore_attribute (id_attribute, name, key_name, description, key_type, certifiable, pivot, key_weight) VALUES (6, 'Code INSEE pays de naissance', 'insee_birthcountry_code', '', 0, 1, 1, 3);


--
-- Data for Name: identitystore_identity_attribute_certificate; Type: TABLE DATA; Schema: public; Owner: idstore
--



--
-- Data for Name: identitystore_service_contract_attribute_certification; Type: TABLE DATA; Schema: public; Owner: idstore
--

INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (1, 11, 1);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (1, 11, 2);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (1, 11, 3);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (1, 11, 7);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (1, 11, 8);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (1, 1, 1);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (1, 1, 2);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (1, 1, 3);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (1, 1, 8);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (1, 2, 8);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (1, 3, 1);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (2, 11, 1);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (2, 11, 2);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (2, 11, 3);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (2, 11, 7);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (2, 11, 8);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (2, 1, 1);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 11, 3);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 11, 7);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 11, 8);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 11, 1);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 11, 2);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 12, 6);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 13, 1);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 14, 3);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 14, 4);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 14, 1);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 14, 2);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 15, 3);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 15, 4);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 15, 1);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 15, 2);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 16, 3);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 16, 4);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 16, 1);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 16, 2);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 17, 3);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 17, 4);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 17, 2);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 1, 3);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 1, 7);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 1, 8);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 1, 1);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 1, 2);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 2, 8);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 3, 3);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 3, 7);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 3, 8);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 3, 1);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 3, 2);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 4, 3);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 4, 7);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 4, 8);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 4, 1);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 4, 2);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 5, 3);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 5, 7);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 5, 8);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 5, 2);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 6, 3);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 6, 7);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 6, 8);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 6, 2);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 7, 3);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 7, 7);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 7, 8);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 7, 2);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 8, 3);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 8, 7);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 8, 8);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 8, 1);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 8, 2);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 9, 5);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 9, 8);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 20, 3);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 20, 8);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 20, 2);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 10, 5);
INSERT INTO public.identitystore_service_contract_attribute_certification (id_service_contract, id_attribute, id_ref_attribute_certification_processus) VALUES (3, 10, 1);


--
-- Data for Name: identitystore_service_contract_attribute_requirement; Type: TABLE DATA; Schema: public; Owner: idstore
--

INSERT INTO public.identitystore_service_contract_attribute_requirement (id_service_contract, id_attribute, id_ref_certification_level) VALUES (1, 11, 1);
INSERT INTO public.identitystore_service_contract_attribute_requirement (id_service_contract, id_attribute, id_ref_certification_level) VALUES (1, 2, 1);
INSERT INTO public.identitystore_service_contract_attribute_requirement (id_service_contract, id_attribute, id_ref_certification_level) VALUES (1, 3, 1);
INSERT INTO public.identitystore_service_contract_attribute_requirement (id_service_contract, id_attribute, id_ref_certification_level) VALUES (1, 1, 4);
INSERT INTO public.identitystore_service_contract_attribute_requirement (id_service_contract, id_attribute, id_ref_certification_level) VALUES (2, 1, 3);
INSERT INTO public.identitystore_service_contract_attribute_requirement (id_service_contract, id_attribute, id_ref_certification_level) VALUES (2, 2, 4);
INSERT INTO public.identitystore_service_contract_attribute_requirement (id_service_contract, id_attribute, id_ref_certification_level) VALUES (2, 3, 4);
INSERT INTO public.identitystore_service_contract_attribute_requirement (id_service_contract, id_attribute, id_ref_certification_level) VALUES (2, 11, 5);
INSERT INTO public.identitystore_service_contract_attribute_requirement (id_service_contract, id_attribute, id_ref_certification_level) VALUES (3, 1, 1);
INSERT INTO public.identitystore_service_contract_attribute_requirement (id_service_contract, id_attribute, id_ref_certification_level) VALUES (3, 3, 1);
INSERT INTO public.identitystore_service_contract_attribute_requirement (id_service_contract, id_attribute, id_ref_certification_level) VALUES (3, 4, 1);


--
-- Data for Name: identitystore_service_contract_attribute_right; Type: TABLE DATA; Schema: public; Owner: idstore
--

INSERT INTO public.identitystore_service_contract_attribute_right (id_service_contract, id_attribute, searchable, readable, writable) VALUES (1, 11, 1, 1, 1);
INSERT INTO public.identitystore_service_contract_attribute_right (id_service_contract, id_attribute, searchable, readable, writable) VALUES (1, 1, 1, 1, 1);
INSERT INTO public.identitystore_service_contract_attribute_right (id_service_contract, id_attribute, searchable, readable, writable) VALUES (1, 2, 1, 1, 1);
INSERT INTO public.identitystore_service_contract_attribute_right (id_service_contract, id_attribute, searchable, readable, writable) VALUES (1, 3, 1, 1, 1);
INSERT INTO public.identitystore_service_contract_attribute_right (id_service_contract, id_attribute, searchable, readable, writable) VALUES (2, 11, 1, 1, 1);
INSERT INTO public.identitystore_service_contract_attribute_right (id_service_contract, id_attribute, searchable, readable, writable) VALUES (2, 1, 1, 1, 1);
INSERT INTO public.identitystore_service_contract_attribute_right (id_service_contract, id_attribute, searchable, readable, writable) VALUES (2, 2, 0, 1, 1);
INSERT INTO public.identitystore_service_contract_attribute_right (id_service_contract, id_attribute, searchable, readable, writable) VALUES (2, 3, 1, 1, 1);
INSERT INTO public.identitystore_service_contract_attribute_right (id_service_contract, id_attribute, searchable, readable, writable) VALUES (3, 22, 1, 1, 0);
INSERT INTO public.identitystore_service_contract_attribute_right (id_service_contract, id_attribute, searchable, readable, writable) VALUES (3, 23, 1, 1, 0);
INSERT INTO public.identitystore_service_contract_attribute_right (id_service_contract, id_attribute, searchable, readable, writable) VALUES (3, 24, 1, 1, 0);
INSERT INTO public.identitystore_service_contract_attribute_right (id_service_contract, id_attribute, searchable, readable, writable) VALUES (3, 25, 1, 1, 0);
INSERT INTO public.identitystore_service_contract_attribute_right (id_service_contract, id_attribute, searchable, readable, writable) VALUES (3, 10, 1, 1, 1);
INSERT INTO public.identitystore_service_contract_attribute_right (id_service_contract, id_attribute, searchable, readable, writable) VALUES (3, 11, 1, 1, 1);
INSERT INTO public.identitystore_service_contract_attribute_right (id_service_contract, id_attribute, searchable, readable, writable) VALUES (3, 12, 1, 1, 1);
INSERT INTO public.identitystore_service_contract_attribute_right (id_service_contract, id_attribute, searchable, readable, writable) VALUES (3, 13, 1, 1, 1);
INSERT INTO public.identitystore_service_contract_attribute_right (id_service_contract, id_attribute, searchable, readable, writable) VALUES (3, 14, 1, 1, 1);
INSERT INTO public.identitystore_service_contract_attribute_right (id_service_contract, id_attribute, searchable, readable, writable) VALUES (3, 15, 1, 1, 1);
INSERT INTO public.identitystore_service_contract_attribute_right (id_service_contract, id_attribute, searchable, readable, writable) VALUES (3, 16, 1, 1, 1);
INSERT INTO public.identitystore_service_contract_attribute_right (id_service_contract, id_attribute, searchable, readable, writable) VALUES (3, 17, 1, 1, 1);
INSERT INTO public.identitystore_service_contract_attribute_right (id_service_contract, id_attribute, searchable, readable, writable) VALUES (3, 18, 1, 1, 0);
INSERT INTO public.identitystore_service_contract_attribute_right (id_service_contract, id_attribute, searchable, readable, writable) VALUES (3, 19, 1, 1, 0);
INSERT INTO public.identitystore_service_contract_attribute_right (id_service_contract, id_attribute, searchable, readable, writable) VALUES (3, 1, 1, 1, 1);
INSERT INTO public.identitystore_service_contract_attribute_right (id_service_contract, id_attribute, searchable, readable, writable) VALUES (3, 2, 1, 1, 1);
INSERT INTO public.identitystore_service_contract_attribute_right (id_service_contract, id_attribute, searchable, readable, writable) VALUES (3, 3, 1, 1, 1);
INSERT INTO public.identitystore_service_contract_attribute_right (id_service_contract, id_attribute, searchable, readable, writable) VALUES (3, 4, 1, 1, 1);
INSERT INTO public.identitystore_service_contract_attribute_right (id_service_contract, id_attribute, searchable, readable, writable) VALUES (3, 5, 1, 1, 1);
INSERT INTO public.identitystore_service_contract_attribute_right (id_service_contract, id_attribute, searchable, readable, writable) VALUES (3, 6, 1, 1, 1);
INSERT INTO public.identitystore_service_contract_attribute_right (id_service_contract, id_attribute, searchable, readable, writable) VALUES (3, 7, 1, 1, 1);
INSERT INTO public.identitystore_service_contract_attribute_right (id_service_contract, id_attribute, searchable, readable, writable) VALUES (3, 8, 1, 1, 1);
INSERT INTO public.identitystore_service_contract_attribute_right (id_service_contract, id_attribute, searchable, readable, writable) VALUES (3, 9, 1, 1, 1);
INSERT INTO public.identitystore_service_contract_attribute_right (id_service_contract, id_attribute, searchable, readable, writable) VALUES (3, 20, 1, 1, 1);
INSERT INTO public.identitystore_service_contract_attribute_right (id_service_contract, id_attribute, searchable, readable, writable) VALUES (3, 21, 1, 1, 0);


--
-- Data for Name: identitystore_client_application; Type: TABLE DATA; Schema: public; Owner: idstore
--

INSERT INTO public.identitystore_client_application (id_client_app, name, code) VALUES (2, 'Test Application 2', 'APP2');
INSERT INTO public.identitystore_client_application (id_client_app, name, code) VALUES (1, 'Test Application 1', 'APP1');
INSERT INTO public.identitystore_client_application (id_client_app, name, code) VALUES (3, 'Application de test', 'TEST');


--
-- Data for Name: identitystore_client_application_certifiers; Type: TABLE DATA; Schema: public; Owner: idstore
--



--
-- Data for Name: identitystore_identity_attribute_history ; Type: TABLE DATA; Schema: public; Owner: idstore
--



--
-- Data for Name: identitystore_identity; Type: TABLE DATA; Schema: public; Owner: idstore
--



--
-- Data for Name: identitystore_identity_attribute; Type: TABLE DATA; Schema: public; Owner: idstore
--



--
-- Data for Name: identitystore_index_action; Type: TABLE DATA; Schema: public; Owner: idstore
--



--
-- Data for Name: identitystore_ref_certification_attribute_level; Type: TABLE DATA; Schema: public; Owner: idstore
--

INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (1, 5, 3);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (3, 5, 3);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (4, 5, 3);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (5, 5, 3);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (6, 5, 3);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (7, 5, 3);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (8, 5, 3);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (11, 5, 3);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (14, 5, 3);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (15, 5, 3);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (16, 5, 3);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (17, 5, 3);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (20, 5, 3);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (14, 6, 4);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (15, 6, 4);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (16, 6, 4);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (17, 6, 4);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (9, 6, 5);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (10, 6, 5);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (12, 6, 6);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (1, 7, 7);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (3, 7, 7);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (4, 7, 7);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (5, 7, 7);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (6, 7, 7);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (7, 7, 7);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (8, 7, 7);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (11, 7, 7);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (1, 7, 8);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (2, 1, 8);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (3, 7, 8);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (4, 7, 8);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (5, 7, 8);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (6, 7, 8);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (7, 7, 8);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (8, 7, 8);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (9, 6, 8);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (11, 7, 8);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (20, 7, 8);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (10, 3, 1);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (11, 3, 1);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (1, 3, 1);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (3, 3, 1);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (4, 3, 1);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (16, 3, 1);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (15, 3, 1);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (14, 3, 1);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (13, 3, 1);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (8, 3, 1);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (7, 5, 2);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (8, 5, 2);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (20, 5, 2);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (17, 5, 2);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (1, 4, 2);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (16, 5, 2);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (15, 5, 2);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (14, 5, 2);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (3, 5, 2);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (4, 5, 2);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (5, 5, 2);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (11, 5, 2);
INSERT INTO public.identitystore_ref_certification_attribute_level (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus) VALUES (6, 5, 2);


--
-- Data for Name: identitystore_ref_certification_processus; Type: TABLE DATA; Schema: public; Owner: idstore
--

INSERT INTO public.identitystore_ref_certification_processus (id_ref_attribute_certification_processus, label, code) VALUES (3, 'Certifiable Agent pièce originales', 'agent');
INSERT INTO public.identitystore_ref_certification_processus (id_ref_attribute_certification_processus, label, code) VALUES (4, 'Certifiable Courrier', 'courrier');
INSERT INTO public.identitystore_ref_certification_processus (id_ref_attribute_certification_processus, label, code) VALUES (5, 'Certifiable Mail', 'mail');
INSERT INTO public.identitystore_ref_certification_processus (id_ref_attribute_certification_processus, label, code) VALUES (6, 'Certifiable SMS', 'sms');
INSERT INTO public.identitystore_ref_certification_processus (id_ref_attribute_certification_processus, label, code) VALUES (7, 'Certifiable R2P', 'r2p');
INSERT INTO public.identitystore_ref_certification_processus (id_ref_attribute_certification_processus, label, code) VALUES (8, 'Certifiable FC', 'fc');
INSERT INTO public.identitystore_ref_certification_processus (id_ref_attribute_certification_processus, label, code) VALUES (1, 'Mon Paris', 'mon_paris');
INSERT INTO public.identitystore_ref_certification_processus (id_ref_attribute_certification_processus, label, code) VALUES (2, 'Certifiable PJ', 'pj');


--
-- Data for Name: identitystore_ref_certification_level; Type: TABLE DATA; Schema: public; Owner: idstore
--

INSERT INTO public.identitystore_ref_certification_level (id_ref_certification_level, name, description, level) VALUES (1, 'Aucune certification - auto déclaratif', 'Juste une identité sans compte', '100');
INSERT INTO public.identitystore_ref_certification_level (id_ref_certification_level, name, description, level) VALUES (2, 'Données saisies dans les référentiels métier sans justificatifs', 'Une identité issu d''une appli métier dont on ne connait pas la qualité', '200');
INSERT INTO public.identitystore_ref_certification_level (id_ref_certification_level, name, description, level) VALUES (3, 'Données saisies par utilisateur connecté', 'On a un compte associé', '300');
INSERT INTO public.identitystore_ref_certification_level (id_ref_certification_level, name, description, level) VALUES (4, 'Certifiable Agent pièce reproduite (copie de pièce originale)', 'Pièce certifiante copiée sans rencontre de l''usager (à valider par MOA)', '400');
INSERT INTO public.identitystore_ref_certification_level (id_ref_certification_level, name, description, level) VALUES (5, 'Certifiable Agent pièce originale', 'Pièce originale certifiée par l''agent', '500');
INSERT INTO public.identitystore_ref_certification_level (id_ref_certification_level, name, description, level) VALUES (6, 'Données validées par circuit de validation', 'Mail, SMS', '600');
INSERT INTO public.identitystore_ref_certification_level (id_ref_certification_level, name, description, level) VALUES (7, 'Données validées par référentiel de confiance', 'FC, R2P (Tout processus INSEE)', '700');


--
-- Data for Name: identitystore_service_contract; Type: TABLE DATA; Schema: public; Owner: idstore
--

INSERT INTO public.identitystore_service_contract (id_service_contract, id_client_app, name, organizational_entity, responsible_name, contact_name, service_type, starting_date, ending_date, authorized_read, authorized_deletion, authorized_search, authorized_import, authorized_export, authorized_merge, is_application_authorized_to_delete_value, is_application_authorized_to_delete_certificate, authorized_account_update) VALUES (1, 1, 'Test Application 1 Contract 1', 'Fictive SA', 'My Application Responsible', 'My Application Contact', 'BO Lutèce', '2000-08-10', NULL, 1, 1, 1, 1, 1, 1, 1, 1, 0);
INSERT INTO public.identitystore_service_contract (id_service_contract, id_client_app, name, organizational_entity, responsible_name, contact_name, service_type, starting_date, ending_date, authorized_read, authorized_deletion, authorized_search, authorized_import, authorized_export, authorized_merge, is_application_authorized_to_delete_value, is_application_authorized_to_delete_certificate, authorized_account_update) VALUES (2, 2, 'Test Application 2 Contract 1', 'Fictive SA', 'My Application Responsible', 'My Application Contact', 'FO Lutèce', '2000-08-10', NULL, 1, 1, 1, 1, 1, 0, 1, 1, 0);
INSERT INTO public.identitystore_service_contract (id_service_contract, id_client_app, name, organizational_entity, responsible_name, contact_name, service_type, starting_date, ending_date, authorized_read, authorized_deletion, authorized_search, authorized_import, authorized_export, authorized_merge, is_application_authorized_to_delete_value, is_application_authorized_to_delete_certificate, authorized_account_update) VALUES (3, 3, 'Contract de service pour l''application de test', 'Yupiik', 'Loris Boiteux', 'Loris Boiteux', 'FO Lutèce', '2022-06-28', NULL, 0, 1, 0, 1, 1, 1, 0, 0, 1);


--
-- Name: core_admin_mailinglist_id_mailinglist_seq; Type: SEQUENCE SET; Schema: public; Owner: idstore
--

SELECT pg_catalog.setval('public.core_admin_mailinglist_id_mailinglist_seq', 1, true);


--
-- Name: core_admin_role_resource_rbac_id_seq; Type: SEQUENCE SET; Schema: public; Owner: idstore
--

SELECT pg_catalog.setval('public.core_admin_role_resource_rbac_id_seq', 1, false);


--
-- Name: core_admin_user_field_id_user_field_seq; Type: SEQUENCE SET; Schema: public; Owner: idstore
--

SELECT pg_catalog.setval('public.core_admin_user_field_id_user_field_seq', 1, false);


--
-- Name: core_admin_user_id_user_seq; Type: SEQUENCE SET; Schema: public; Owner: idstore
--

SELECT pg_catalog.setval('public.core_admin_user_id_user_seq', 4, true);


--
-- Name: core_attribute_field_id_field_seq; Type: SEQUENCE SET; Schema: public; Owner: idstore
--

SELECT pg_catalog.setval('public.core_attribute_field_id_field_seq', 1, false);


--
-- Name: core_attribute_id_attribute_seq; Type: SEQUENCE SET; Schema: public; Owner: idstore
--

SELECT pg_catalog.setval('public.core_attribute_id_attribute_seq', 1, false);


--
-- Name: core_file_id_file_seq; Type: SEQUENCE SET; Schema: public; Owner: idstore
--

SELECT pg_catalog.setval('public.core_file_id_file_seq', 1, false);


--
-- Name: core_indexer_action_id_action_seq; Type: SEQUENCE SET; Schema: public; Owner: idstore
--

SELECT pg_catalog.setval('public.core_indexer_action_id_action_seq', 1, false);


--
-- Name: core_mail_queue_id_mail_queue_seq; Type: SEQUENCE SET; Schema: public; Owner: idstore
--

SELECT pg_catalog.setval('public.core_mail_queue_id_mail_queue_seq', 1, false);


--
-- Name: core_page_id_page_seq; Type: SEQUENCE SET; Schema: public; Owner: idstore
--

SELECT pg_catalog.setval('public.core_page_id_page_seq', 2, true);


--
-- Name: core_page_template_id_template_seq; Type: SEQUENCE SET; Schema: public; Owner: idstore
--

SELECT pg_catalog.setval('public.core_page_template_id_template_seq', 6, true);


--
-- Name: core_physical_file_id_physical_file_seq; Type: SEQUENCE SET; Schema: public; Owner: idstore
--

SELECT pg_catalog.setval('public.core_physical_file_id_physical_file_seq', 1, false);


--
-- Name: core_portlet_id_portlet_seq; Type: SEQUENCE SET; Schema: public; Owner: idstore
--

SELECT pg_catalog.setval('public.core_portlet_id_portlet_seq', 1, false);


--
-- Name: core_stylesheet_id_stylesheet_seq; Type: SEQUENCE SET; Schema: public; Owner: idstore
--

SELECT pg_catalog.setval('public.core_stylesheet_id_stylesheet_seq', 1, false);


--
-- Name: core_xsl_export_id_xsl_export_seq; Type: SEQUENCE SET; Schema: public; Owner: idstore
--

SELECT pg_catalog.setval('public.core_xsl_export_id_xsl_export_seq', 1, false);


--
-- Name: identitystore_attribute_certificat_id_attribute_certificate_seq; Type: SEQUENCE SET; Schema: public; Owner: idstore
--

SELECT pg_catalog.setval('public.identitystore_attribute_certificat_id_attribute_certificate_seq', 8276183, true);


--
-- Name: identitystore_attribute_id_attribute_seq; Type: SEQUENCE SET; Schema: public; Owner: idstore
--

SELECT pg_catalog.setval('public.identitystore_attribute_id_attribute_seq', 39, true);


--
-- Name: identitystore_client_application_id_client_app_seq; Type: SEQUENCE SET; Schema: public; Owner: idstore
--

SELECT pg_catalog.setval('public.identitystore_client_application_id_client_app_seq', 2, true);


--
-- Name: identitystore_identity_attribute_history _id_history_seq; Type: SEQUENCE SET; Schema: public; Owner: idstore
--

SELECT pg_catalog.setval('public.identitystore_identity_attribute_history _id_history_seq', 8242462, true);


--
-- Name: identitystore_identity_id_identity_seq; Type: SEQUENCE SET; Schema: public; Owner: idstore
--

SELECT pg_catalog.setval('public.identitystore_identity_id_identity_seq', 639113, true);


--
-- Name: identitystore_index_action_id_index_action_seq; Type: SEQUENCE SET; Schema: public; Owner: idstore
--

SELECT pg_catalog.setval('public.identitystore_index_action_id_index_action_seq', 1, false);


--
-- Name: identitystore_ref_attribute_c_id_ref_attribute_certificatio_seq; Type: SEQUENCE SET; Schema: public; Owner: idstore
--

SELECT pg_catalog.setval('public.identitystore_ref_attribute_c_id_ref_attribute_certificatio_seq', 12, true);


--
-- Name: identitystore_ref_certification__id_ref_certification_level_seq; Type: SEQUENCE SET; Schema: public; Owner: idstore
--

SELECT pg_catalog.setval('public.identitystore_ref_certification__id_ref_certification_level_seq', 9, true);


--
-- Name: identitystore_service_contract_id_service_contract_seq; Type: SEQUENCE SET; Schema: public; Owner: idstore
--

SELECT pg_catalog.setval('public.identitystore_service_contract_id_service_contract_seq', 3, true);


--
-- Name: core_admin_dashboard core_admin_dashboard_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_admin_dashboard
    ADD CONSTRAINT core_admin_dashboard_pkey PRIMARY KEY (dashboard_name);


--
-- Name: core_admin_mailinglist_filter core_admin_mailinglist_filter_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_admin_mailinglist_filter
    ADD CONSTRAINT core_admin_mailinglist_filter_pkey PRIMARY KEY (id_mailinglist, workgroup, role);


--
-- Name: core_admin_mailinglist core_admin_mailinglist_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_admin_mailinglist
    ADD CONSTRAINT core_admin_mailinglist_pkey PRIMARY KEY (id_mailinglist);


--
-- Name: core_admin_right core_admin_right_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_admin_right
    ADD CONSTRAINT core_admin_right_pkey PRIMARY KEY (id_right);


--
-- Name: core_admin_role core_admin_role_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_admin_role
    ADD CONSTRAINT core_admin_role_pkey PRIMARY KEY (role_key);


--
-- Name: core_admin_role_resource core_admin_role_resource_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_admin_role_resource
    ADD CONSTRAINT core_admin_role_resource_pkey PRIMARY KEY (rbac_id);


--
-- Name: core_admin_user_anonymize_field core_admin_user_anonymize_field_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_admin_user_anonymize_field
    ADD CONSTRAINT core_admin_user_anonymize_field_pkey PRIMARY KEY (field_name);


--
-- Name: core_admin_user_field core_admin_user_field_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_admin_user_field
    ADD CONSTRAINT core_admin_user_field_pkey PRIMARY KEY (id_user_field);


--
-- Name: core_admin_user core_admin_user_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_admin_user
    ADD CONSTRAINT core_admin_user_pkey PRIMARY KEY (id_user);


--
-- Name: core_admin_user_preferences core_admin_user_preferences_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_admin_user_preferences
    ADD CONSTRAINT core_admin_user_preferences_pkey PRIMARY KEY (id_user, pref_key);


--
-- Name: core_admin_workgroup core_admin_workgroup_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_admin_workgroup
    ADD CONSTRAINT core_admin_workgroup_pkey PRIMARY KEY (workgroup_key);


--
-- Name: core_admin_workgroup_user core_admin_workgroup_user_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_admin_workgroup_user
    ADD CONSTRAINT core_admin_workgroup_user_pkey PRIMARY KEY (workgroup_key, id_user);


--
-- Name: core_attribute_field core_attribute_field_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_attribute_field
    ADD CONSTRAINT core_attribute_field_pkey PRIMARY KEY (id_field);


--
-- Name: core_attribute core_attribute_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_attribute
    ADD CONSTRAINT core_attribute_pkey PRIMARY KEY (id_attribute);


--
-- Name: core_dashboard core_dashboard_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_dashboard
    ADD CONSTRAINT core_dashboard_pkey PRIMARY KEY (dashboard_name);


--
-- Name: core_datastore core_datastore_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_datastore
    ADD CONSTRAINT core_datastore_pkey PRIMARY KEY (entity_key);


--
-- Name: core_feature_group core_feature_group_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_feature_group
    ADD CONSTRAINT core_feature_group_pkey PRIMARY KEY (id_feature_group);


--
-- Name: core_file core_file_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_file
    ADD CONSTRAINT core_file_pkey PRIMARY KEY (id_file);


--
-- Name: core_id_generator core_id_generator_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_id_generator
    ADD CONSTRAINT core_id_generator_pkey PRIMARY KEY (class_name);


--
-- Name: core_indexer_action core_indexer_action_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_indexer_action
    ADD CONSTRAINT core_indexer_action_pkey PRIMARY KEY (id_action);


--
-- Name: core_level_right core_level_right_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_level_right
    ADD CONSTRAINT core_level_right_pkey PRIMARY KEY (id_level);


--
-- Name: core_mail_item core_mail_item_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_mail_item
    ADD CONSTRAINT core_mail_item_pkey PRIMARY KEY (id_mail_queue);


--
-- Name: core_mail_queue core_mail_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_mail_queue
    ADD CONSTRAINT core_mail_queue_pkey PRIMARY KEY (id_mail_queue);


--
-- Name: core_mode core_mode_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_mode
    ADD CONSTRAINT core_mode_pkey PRIMARY KEY (id_mode);


--
-- Name: core_page core_page_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_page
    ADD CONSTRAINT core_page_pkey PRIMARY KEY (id_page);


--
-- Name: core_page_template core_page_template_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_page_template
    ADD CONSTRAINT core_page_template_pkey PRIMARY KEY (id_template);


--
-- Name: core_physical_file core_physical_file_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_physical_file
    ADD CONSTRAINT core_physical_file_pkey PRIMARY KEY (id_physical_file);


--
-- Name: core_portal_component core_portal_component_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_portal_component
    ADD CONSTRAINT core_portal_component_pkey PRIMARY KEY (id_portal_component);


--
-- Name: core_portlet_alias core_portlet_alias_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_portlet_alias
    ADD CONSTRAINT core_portlet_alias_pkey PRIMARY KEY (id_portlet, id_alias);


--
-- Name: core_portlet core_portlet_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_portlet
    ADD CONSTRAINT core_portlet_pkey PRIMARY KEY (id_portlet);


--
-- Name: core_portlet_type core_portlet_type_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_portlet_type
    ADD CONSTRAINT core_portlet_type_pkey PRIMARY KEY (id_portlet_type);


--
-- Name: core_role core_role_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_role
    ADD CONSTRAINT core_role_pkey PRIMARY KEY (role);


--
-- Name: core_search_parameter core_search_parameter_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_search_parameter
    ADD CONSTRAINT core_search_parameter_pkey PRIMARY KEY (parameter_key);


--
-- Name: core_style_mode_stylesheet core_style_mode_stylesheet_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_style_mode_stylesheet
    ADD CONSTRAINT core_style_mode_stylesheet_pkey PRIMARY KEY (id_style, id_mode, id_stylesheet);


--
-- Name: core_style core_style_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_style
    ADD CONSTRAINT core_style_pkey PRIMARY KEY (id_style);


--
-- Name: core_stylesheet core_stylesheet_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_stylesheet
    ADD CONSTRAINT core_stylesheet_pkey PRIMARY KEY (id_stylesheet);


--
-- Name: core_template core_template_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_template
    ADD CONSTRAINT core_template_pkey PRIMARY KEY (template_name);


--
-- Name: core_text_editor core_text_editor_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_text_editor
    ADD CONSTRAINT core_text_editor_pkey PRIMARY KEY (editor_name, backoffice);


--
-- Name: core_user_password_history core_user_password_history_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_user_password_history
    ADD CONSTRAINT core_user_password_history_pkey PRIMARY KEY (id_user, date_password_change);


--
-- Name: core_user_preferences core_user_preferences_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_user_preferences
    ADD CONSTRAINT core_user_preferences_pkey PRIMARY KEY (id_user, pref_key);


--
-- Name: core_user_right core_user_right_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_user_right
    ADD CONSTRAINT core_user_right_pkey PRIMARY KEY (id_right, id_user);


--
-- Name: core_user_role core_user_role_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_user_role
    ADD CONSTRAINT core_user_role_pkey PRIMARY KEY (role_key, id_user);


--
-- Name: core_xsl_export core_xsl_export_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.core_xsl_export
    ADD CONSTRAINT core_xsl_export_pkey PRIMARY KEY (id_xsl_export);


--
-- Name: identitystore_identity_attribute_certificate identitystore_identity_attribute_certificate_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.identitystore_identity_attribute_certificate
    ADD CONSTRAINT identitystore_identity_attribute_certificate_pkey PRIMARY KEY (id_attribute_certificate);


--
-- Name: identitystore_service_contract_attribute_certification identitystore_service_contract_attribute_certification_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.identitystore_service_contract_attribute_certification
    ADD CONSTRAINT identitystore_service_contract_attribute_certification_pkey PRIMARY KEY (id_attribute, id_ref_attribute_certification_processus, id_service_contract);


--
-- Name: identitystore_ref_attribute identitystore_attribute_key_name_key; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.identitystore_attribute
    ADD CONSTRAINT identitystore_attribute_key_name_key UNIQUE (key_name);


--
-- Name: identitystore_ref_attribute identitystore_attribute_name_key; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.identitystore_attribute
    ADD CONSTRAINT identitystore_attribute_name_key UNIQUE (name);


--
-- Name: identitystore_ref_attribute identitystore_attribute_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.identitystore_attribute
    ADD CONSTRAINT identitystore_attribute_pkey PRIMARY KEY (id_attribute);


--
-- Name: identitystore_service_contract_attribute_requirement identitystore_service_contract_attribute_requirement_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.identitystore_service_contract_attribute_requirement
    ADD CONSTRAINT identitystore_service_contract_attribute_requirement_pkey PRIMARY KEY (id_attribute, id_service_contract, id_ref_certification_level);


--
-- Name: identitystore_service_contract_attribute_right identitystore_service_contract_attribute_right_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.identitystore_service_contract_attribute_right
    ADD CONSTRAINT identitystore_service_contract_attribute_right_pkey PRIMARY KEY (id_service_contract, id_attribute);


--
-- Name: identitystore_client_application_certifiers identitystore_client_application_certifiers_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.identitystore_client_application_certifiers
    ADD CONSTRAINT identitystore_client_application_certifiers_pkey PRIMARY KEY (id_client_app, certifier_code);


--
-- Name: identitystore_client_application identitystore_client_application_code_key; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.identitystore_client_application
    ADD CONSTRAINT identitystore_client_application_code_key UNIQUE (code);


--
-- Name: identitystore_client_application identitystore_client_application_name_key; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.identitystore_client_application
    ADD CONSTRAINT identitystore_client_application_name_key UNIQUE (name);


--
-- Name: identitystore_client_application identitystore_client_application_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.identitystore_client_application
    ADD CONSTRAINT identitystore_client_application_pkey PRIMARY KEY (id_client_app);


--
-- Name: identitystore_identity_attribute_history  identitystore_identity_attribute_history _pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.identitystore_identity_attribute_history 
    ADD CONSTRAINT identitystore_identity_attribute_history _pkey PRIMARY KEY (id_history);


--
-- Name: identitystore_identity_attribute identitystore_identity_attribute_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.identitystore_identity_attribute
    ADD CONSTRAINT identitystore_identity_attribute_pkey PRIMARY KEY (id_identity, id_attribute);


--
-- Name: identitystore_identity identitystore_identity_connection_id_key; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.identitystore_identity
    ADD CONSTRAINT identitystore_identity_connection_id_key UNIQUE (connection_id);


--
-- Name: identitystore_identity identitystore_identity_customer_id_key; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.identitystore_identity
    ADD CONSTRAINT identitystore_identity_customer_id_key UNIQUE (customer_id);


--
-- Name: identitystore_identity identitystore_identity_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.identitystore_identity
    ADD CONSTRAINT identitystore_identity_pkey PRIMARY KEY (id_identity);


--
-- Name: identitystore_index_action identitystore_index_action_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.identitystore_index_action
    ADD CONSTRAINT identitystore_index_action_pkey PRIMARY KEY (id_index_action);


--
-- Name: identitystore_ref_certification_attribute_level identitystore_ref_certification_attribute_level_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.identitystore_ref_certification_attribute_level
    ADD CONSTRAINT identitystore_ref_certification_attribute_level_pkey PRIMARY KEY (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus);


--
-- Name: identitystore_ref_certification_processus identitystore_ref_certification_processus_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.identitystore_ref_certification_processus
    ADD CONSTRAINT identitystore_ref_certification_processus_pkey PRIMARY KEY (id_ref_attribute_certification_processus);


--
-- Name: identitystore_ref_certification_level identitystore_ref_certification_level_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.identitystore_ref_certification_level
    ADD CONSTRAINT identitystore_ref_certification_level_pkey PRIMARY KEY (id_ref_certification_level);


--
-- Name: identitystore_service_contract identitystore_service_contract_pkey; Type: CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.identitystore_service_contract
    ADD CONSTRAINT identitystore_service_contract_pkey PRIMARY KEY (id_service_contract);


--
-- Name: core_admin_user_field_idx_file; Type: INDEX; Schema: public; Owner: idstore
--

CREATE INDEX core_admin_user_field_idx_file ON public.core_admin_user_field USING btree (id_file);


--
-- Name: identitystore_client_application_certifiers_id_client_app_idx; Type: INDEX; Schema: public; Owner: idstore
--

CREATE INDEX identitystore_client_application_certifiers_id_client_app_idx ON public.identitystore_client_application_certifiers USING btree (id_client_app);


--
-- Name: identitystore_identity_connection_id_idx; Type: INDEX; Schema: public; Owner: idstore
--

CREATE INDEX identitystore_identity_connection_id_idx ON public.identitystore_identity USING btree (connection_id);


--
-- Name: identitystore_identity_customer_id_idx; Type: INDEX; Schema: public; Owner: idstore
--

CREATE INDEX identitystore_identity_customer_id_idx ON public.identitystore_identity USING btree (customer_id);


--
-- Name: index_admin_user_preferences; Type: INDEX; Schema: public; Owner: idstore
--

CREATE INDEX index_admin_user_preferences ON public.core_admin_user_preferences USING btree (id_user);


--
-- Name: index_childpage; Type: INDEX; Schema: public; Owner: idstore
--

CREATE INDEX index_childpage ON public.core_page USING btree (id_parent, page_order);


--
-- Name: index_connections_log; Type: INDEX; Schema: public; Owner: idstore
--

CREATE INDEX index_connections_log ON public.core_connections_log USING btree (ip_address, date_login);


--
-- Name: index_page; Type: INDEX; Schema: public; Owner: idstore
--

CREATE INDEX index_page ON public.core_page USING btree (id_template, id_parent);


--
-- Name: index_portlet; Type: INDEX; Schema: public; Owner: idstore
--

CREATE INDEX index_portlet ON public.core_portlet USING btree (id_page, id_portlet_type, id_style);


--
-- Name: index_right; Type: INDEX; Schema: public; Owner: idstore
--

CREATE INDEX index_right ON public.core_admin_right USING btree (level_right, admin_url);


--
-- Name: index_style; Type: INDEX; Schema: public; Owner: idstore
--

CREATE INDEX index_style ON public.core_style USING btree (id_portlet_type);


--
-- Name: index_style_mode_stylesheet; Type: INDEX; Schema: public; Owner: idstore
--

CREATE INDEX index_style_mode_stylesheet ON public.core_style_mode_stylesheet USING btree (id_stylesheet, id_mode);


--
-- Name: index_user_preferences; Type: INDEX; Schema: public; Owner: idstore
--

CREATE INDEX index_user_preferences ON public.core_user_preferences USING btree (id_user);


--
-- Name: index_user_right; Type: INDEX; Schema: public; Owner: idstore
--

CREATE INDEX index_user_right ON public.core_user_right USING btree (id_user);


--
-- Name: is_locked_core_mail_queue; Type: INDEX; Schema: public; Owner: idstore
--

CREATE INDEX is_locked_core_mail_queue ON public.core_mail_queue USING btree (is_locked);


--
-- Name: ix_attribute_value; Type: INDEX; Schema: public; Owner: idstore
--

CREATE INDEX ix_attribute_value ON public.identitystore_identity_attribute USING btree (attribute_value);


--
-- Name: identitystore_service_contract_attribute_certification fk_attribute_certification_certification_processus; Type: FK CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.identitystore_service_contract_attribute_certification
    ADD CONSTRAINT fk_attribute_certification_certification_processus FOREIGN KEY (id_ref_attribute_certification_processus) REFERENCES public.identitystore_ref_certification_processus(id_ref_attribute_certification_processus);


--
-- Name: identitystore_service_contract_attribute_certification fk_attribute_certification_id_attribute; Type: FK CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.identitystore_service_contract_attribute_certification
    ADD CONSTRAINT fk_attribute_certification_id_attribute FOREIGN KEY (id_attribute) REFERENCES public.identitystore_attribute(id_attribute);


--
-- Name: identitystore_service_contract_attribute_certification fk_attribute_certification_id_service_contract; Type: FK CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.identitystore_service_contract_attribute_certification
    ADD CONSTRAINT fk_attribute_certification_id_service_contract FOREIGN KEY (id_service_contract) REFERENCES public.identitystore_service_contract(id_service_contract);


--
-- Name: identitystore_ref_certification_attribute_level fk_attribute_ref_certification_level_certification_level; Type: FK CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.identitystore_ref_certification_attribute_level
    ADD CONSTRAINT fk_attribute_ref_certification_level_certification_level FOREIGN KEY (id_ref_certification_level) REFERENCES public.identitystore_ref_certification_level(id_ref_certification_level);


--
-- Name: identitystore_ref_certification_attribute_level fk_attribute_ref_certification_level_certification_processus; Type: FK CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.identitystore_ref_certification_attribute_level
    ADD CONSTRAINT fk_attribute_ref_certification_level_certification_processus FOREIGN KEY (id_ref_attribute_certification_processus) REFERENCES public.identitystore_ref_certification_processus(id_ref_attribute_certification_processus);


--
-- Name: identitystore_ref_certification_attribute_level fk_attribute_ref_certification_level_id_attribute; Type: FK CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.identitystore_ref_certification_attribute_level
    ADD CONSTRAINT fk_attribute_ref_certification_level_id_attribute FOREIGN KEY (id_attribute) REFERENCES public.identitystore_attribute(id_attribute);


--
-- Name: identitystore_service_contract_attribute_requirement fk_attribute_requirement_certification_level; Type: FK CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.identitystore_service_contract_attribute_requirement
    ADD CONSTRAINT fk_attribute_requirement_certification_level FOREIGN KEY (id_ref_certification_level) REFERENCES public.identitystore_ref_certification_level(id_ref_certification_level);


--
-- Name: identitystore_service_contract_attribute_requirement fk_attribute_requirement_id_attribute; Type: FK CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.identitystore_service_contract_attribute_requirement
    ADD CONSTRAINT fk_attribute_requirement_id_attribute FOREIGN KEY (id_attribute) REFERENCES public.identitystore_attribute(id_attribute);


--
-- Name: identitystore_service_contract_attribute_requirement fk_attribute_requirement_id_service_contract; Type: FK CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.identitystore_service_contract_attribute_requirement
    ADD CONSTRAINT fk_attribute_requirement_id_service_contract FOREIGN KEY (id_service_contract) REFERENCES public.identitystore_service_contract(id_service_contract);


--
-- Name: identitystore_service_contract_attribute_right fk_attribute_right_id_attribute; Type: FK CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.identitystore_service_contract_attribute_right
    ADD CONSTRAINT fk_attribute_right_id_attribute FOREIGN KEY (id_attribute) REFERENCES public.identitystore_attribute(id_attribute);


--
-- Name: identitystore_service_contract_attribute_right fk_attribute_right_id_service_contract; Type: FK CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.identitystore_service_contract_attribute_right
    ADD CONSTRAINT fk_attribute_right_id_service_contract FOREIGN KEY (id_service_contract) REFERENCES public.identitystore_service_contract(id_service_contract);


--
-- Name: identitystore_identity_attribute fk_identity_attribute_id_attribute; Type: FK CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.identitystore_identity_attribute
    ADD CONSTRAINT fk_identity_attribute_id_attribute FOREIGN KEY (id_attribute) REFERENCES public.identitystore_attribute(id_attribute);


--
-- Name: identitystore_identity_attribute fk_identity_attribute_id_identity; Type: FK CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.identitystore_identity_attribute
    ADD CONSTRAINT fk_identity_attribute_id_identity FOREIGN KEY (id_identity) REFERENCES public.identitystore_identity(id_identity);


--
-- Name: identitystore_service_contract fk_service_contract_id_client_app; Type: FK CONSTRAINT; Schema: public; Owner: idstore
--

ALTER TABLE ONLY public.identitystore_service_contract
    ADD CONSTRAINT fk_service_contract_id_client_app FOREIGN KEY (id_client_app) REFERENCES public.identitystore_client_application(id_client_app);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: idstore
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM idstore;
GRANT ALL ON SCHEMA public TO idstore;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

