--
-- Drop tables if exists
--


DROP TABLE IF EXISTS identitystore_service_contract_attribute_certification CASCADE;
DROP TABLE IF EXISTS identitystore_identity_account_history CASCADE;
DROP TABLE IF EXISTS identitystore_identity CASCADE;
DROP TABLE IF EXISTS identitystore_service_contract_attribute_requirement CASCADE;
DROP TABLE IF EXISTS identitystore_service_contract_attribute_right CASCADE;
DROP TABLE IF EXISTS identitystore_service_contract CASCADE;
DROP TABLE IF EXISTS identitystore_identity_attribute_history  CASCADE;
DROP TABLE IF EXISTS identitystore_identity_history  CASCADE;
DROP TABLE IF EXISTS identitystore_client_application CASCADE;
DROP TABLE IF EXISTS identitystore_client_application_certifiers CASCADE;
DROP TABLE IF EXISTS identitystore_identity_attribute_certificate CASCADE;
DROP TABLE IF EXISTS identitystore_identity_attribute CASCADE;
DROP TABLE IF EXISTS identitystore_ref_certification_processus CASCADE;
DROP TABLE IF EXISTS identitystore_ref_certification_attribute_level CASCADE;
DROP TABLE IF EXISTS identitystore_ref_certification_level CASCADE;
DROP TABLE IF EXISTS identitystore_ref_attribute CASCADE;
DROP TABLE IF EXISTS identitystore_index_action CASCADE;
--
-- Structure for table identitystore_identity
--

CREATE TABLE identitystore_identity
(
    id_identity        int AUTO_INCREMENT,
    connection_id      varchar(100) NULL UNIQUE,
    customer_id        varchar(50)  NOT NULL UNIQUE,
    date_create        timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL ,
    last_update_date   timestamp(3) DEFAULT CURRENT_TIMESTAMP,
    is_deleted         smallint     default 0,
    date_delete        timestamp(3) NULL,
    is_merged          smallint     default 0,
    date_merge         timestamp(3) NULL,
    id_master_identity int          NULL,
    is_mon_paris_active smallint DEFAULT 0 NOT NULL ,
    expiration_date timestamp(3) NOT NULL,
    unicity_hash_code VARCHAR(36) NOT NULL UNIQUE DEFAULT gen_random_uuid(),
    PRIMARY KEY (id_identity)
);

CREATE INDEX identitystore_identity_connection_id ON identitystore_identity (lower(connection_id::text));
CREATE INDEX identitystore_identity_customer_id ON identitystore_identity (customer_id);
CREATE INDEX identitystore_identity_master_id ON identitystore_identity (id_master_identity);
CREATE INDEX identitystore_identity_expiration_date ON identitystore_identity (expiration_date);

--
-- Structure for table identitystore_attribute
--

CREATE TABLE identitystore_ref_attribute
(
    id_attribute int AUTO_INCREMENT,
    name         varchar(100) default '' UNIQUE NOT NULL ,
    key_name     varchar(100) default '' UNIQUE NOT NULL ,
    description  varchar(255) NULL,
    key_type     int          default '0' NOT NULL ,
    key_weight   int          default '0' NOT NULL ,
    certifiable  smallint              default 0,
    pivot        smallint              default 0,
    alternative_pivot smallint           default 0,
    mandatory_for_creation smallint DEFAULT 0 NOT NULL ,
    common_search_key VARCHAR(100) NULL, 
    validation_regex varchar(510) DEFAULT '^[A-Za-zÀ-Üà-ü\d\s''-]+$',
    validation_error_message varchar(255) DEFAULT 'uniquement caractères alphanumériques, apostrophe, espace et tirets.',
    validation_error_message_key varchar(128) DEFAULT 'identitystore.attribute.status.validation.error.only.alphanum.apostrophe.space.dash' NOT NULL ,
    creation_date  TIMESTAMP(3)  DEFAULT CURRENT_TIMESTAMP NOT NULL, 
    last_update_date TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP NOT NULL, 
    author_name VARCHAR(255),
    PRIMARY KEY (id_attribute)
);

-- Matrice de configuration des processus

CREATE TABLE identitystore_ref_certification_level
(
    id_ref_certification_level int AUTO_INCREMENT,
    name                       varchar(255) default '',
    description                varchar(255) default '',
    level                      varchar(50)  default '' NOT NULL,
    PRIMARY KEY (id_ref_certification_level)
);

CREATE TABLE identitystore_ref_certification_processus
(
    id_ref_attribute_certification_processus int AUTO_INCREMENT,
    label                                    varchar(50) default '' NOT NULL,
    code                                     varchar(50) default '' NOT NULL,
    PRIMARY KEY (id_ref_attribute_certification_processus)
);

CREATE TABLE identitystore_ref_certification_attribute_level
(
    id_attribute                             int NOT NULL,
    id_ref_certification_level               int NOT NULL,
    id_ref_attribute_certification_processus int NOT NULL,
    PRIMARY KEY (id_attribute, id_ref_certification_level, id_ref_attribute_certification_processus)
);
ALTER TABLE identitystore_ref_certification_attribute_level
    ADD CONSTRAINT fk_attribute_ref_certification_level_certification_level FOREIGN KEY (id_ref_certification_level) REFERENCES identitystore_ref_certification_level (id_ref_certification_level);
ALTER TABLE identitystore_ref_certification_attribute_level
    ADD CONSTRAINT fk_attribute_ref_certification_level_certification_processus FOREIGN KEY (id_ref_attribute_certification_processus) REFERENCES identitystore_ref_certification_processus (id_ref_attribute_certification_processus);
ALTER TABLE identitystore_ref_certification_attribute_level
    ADD CONSTRAINT fk_attribute_ref_certification_level_id_attribute FOREIGN KEY (id_attribute) REFERENCES identitystore_ref_attribute (id_attribute);

--
-- Structure for table identitystore_identity_attribute
--

CREATE TABLE identitystore_identity_attribute
(
    id_identity            int          default '0' NOT NULL ,
    id_attribute           int          default '0' NOT NULL ,
    attribute_value        LONG VARCHAR NULL,
    id_certification       int          default '0' NOT NULL ,
    id_file                int                   default '0',
    lastupdate_date        timestamp(3)    default CURRENT_TIMESTAMP NOT NULL ,
    lastupdate_application VARCHAR(100) NULL,
    PRIMARY KEY (id_identity, id_attribute)
);
ALTER TABLE identitystore_identity_attribute
    ADD CONSTRAINT fk_identity_attribute_id_identity FOREIGN KEY (id_identity) REFERENCES identitystore_identity (id_identity);
ALTER TABLE identitystore_identity_attribute
    ADD CONSTRAINT fk_identity_attribute_id_attribute FOREIGN KEY (id_attribute) REFERENCES identitystore_ref_attribute (id_attribute);
CREATE INDEX ix_attribute_value ON identitystore_identity_attribute (attribute_value ASC);

--
-- Structure for table identitystore_identity_attribute_certificate
--

CREATE TABLE identitystore_identity_attribute_certificate
(
    id_attribute_certificate int AUTO_INCREMENT,
    certifier_code           varchar(255) default '' NOT NULL ,
    certificate_date         timestamp(3)    NOT NULL,
    certificate_level        int           default '0' NOT NULL,
    expiration_date          timestamp(3)     default NULL,
    PRIMARY KEY (id_attribute_certificate)
);

--
-- Structure for table identitystore_client_application_certifiers
--

CREATE TABLE identitystore_client_application_certifiers
(
    id_client_app  int          NOT NULL,
    certifier_code varchar(255)  default '' NOT NULL,
    PRIMARY KEY (id_client_app, certifier_code)
);
CREATE INDEX identitystore_client_application_certifiers_id_client_app ON identitystore_client_application_certifiers (id_client_app);


--
-- Structure for table identitystore_client_application
--

CREATE TABLE identitystore_client_application
(
    id_client_app int AUTO_INCREMENT,
    name                 varchar(255)  UNIQUE NOT NULL,
    client_code          varchar(255) NOT NULL ,
    application_code     varchar(255) NOT NULL ,
	creation_date  TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP NOT NULL ,
	last_update_date TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP NOT NULL ,
	author_name VARCHAR(255),
    PRIMARY KEY (id_client_app)
);

--
-- Structure for table identitystore_identity_attribute_history
--

CREATE TABLE identitystore_identity_attribute_history
(
    id_history            int AUTO_INCREMENT,
    change_type           int          NOT NULL,
    change_satus          varchar(255) NOT NULL,
    change_message        varchar(255)          default null,
    author_type           varchar(255) NOT NULL,
    author_name           varchar(255)          default null,
    client_code           varchar(255)          default null,
    id_identity           int          NOT NULL,
    attribute_key         varchar(50)  NOT NULL,
    attribute_value       varchar(255)          default null,
    certification_process varchar(255)          default null,
    certification_date    timestamp(3)             default null,
    modification_date     timestamp(3)   default CURRENT_TIMESTAMP  NOT NULL ,
    metadata              json         DEFAULT NULL,
    PRIMARY KEY (id_history)
);

CREATE  INDEX IDX_ID_IDENTITY_ATTRIBUTE_HISTORY ON identitystore_identity_attribute_history (id_identity);

--
-- Structure for table identitystore_service_contract
--
CREATE TABLE identitystore_service_contract (
    id_service_contract int AUTO_INCREMENT,
    id_client_app integer NOT NULL,
    name varchar(255) DEFAULT '',
    organizational_entity varchar(255) DEFAULT '',   
    moa_entity_name varchar(255) DEFAULT '',
    moa_responsible_name varchar(255) DEFAULT '',
    moa_contact_name varchar(255) DEFAULT '',    
    moe_entity_name varchar(255) DEFAULT '',
    moe_responsible_name varchar(255) DEFAULT '',    
    contact_name varchar(255) DEFAULT '',
    service_type varchar(255) DEFAULT '',
    starting_date date NOT NULL,
    ending_date date,
    data_retention_period_in_months integer NOT NULL,
    authorized_creation smallint DEFAULT 0 NOT NULL,
    authorized_update smallint DEFAULT 0 NOT NULL,
    authorized_deletion smallint DEFAULT 0 NOT NULL,
    authorized_search smallint DEFAULT 0 NOT NULL,
    authorized_import smallint DEFAULT 0 NOT NULL,
    authorized_export smallint DEFAULT 0 NOT NULL,
    authorized_merge smallint DEFAULT 0 NOT NULL,
    authorized_account_update smallint DEFAULT 0 NOT NULL,
    authorized_decertification smallint DEFAULT 0 NOT NULL,
    authorized_agent_history_read smallint DEFAULT 0 NOT NULL,
    authorized_attachment_certification SMALLINT DEFAULT 0 NOT NULL,
    creation_date  TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update_date TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
    author_name VARCHAR(255),
    PRIMARY KEY (id_service_contract)
);

ALTER TABLE identitystore_service_contract
    ADD CONSTRAINT fk_service_contract_id_client_app FOREIGN KEY (id_client_app) REFERENCES identitystore_client_application (id_client_app);

--
-- Structure for table identitystore_client_access_control_list
--

CREATE TABLE identitystore_service_contract_attribute_right
(
    id_service_contract int      NOT NULL,
    id_attribute        int      NOT NULL,
    searchable          smallint  default 0 NOT NULL,
    readable            smallint  default 0 NOT NULL,
    writable            smallint  default 0 NOT NULL,
    mandatory           smallint  default 0 NOT NULL,
    PRIMARY KEY (id_service_contract, id_attribute)
);
ALTER TABLE identitystore_service_contract_attribute_right
    ADD CONSTRAINT fk_attribute_right_id_attribute FOREIGN KEY (id_attribute) REFERENCES identitystore_ref_attribute (id_attribute);
ALTER TABLE identitystore_service_contract_attribute_right
    ADD CONSTRAINT fk_attribute_right_id_service_contract FOREIGN KEY (id_service_contract) REFERENCES identitystore_service_contract (id_service_contract);


--
-- Structure for table identitystore_service_contract_attribute_requirement
--
CREATE TABLE identitystore_service_contract_attribute_requirement
(
    id_service_contract        int NOT NULL,
    id_attribute               int NOT NULL,
    id_ref_certification_level int NOT NULL,
    PRIMARY KEY (id_attribute, id_service_contract, id_ref_certification_level)
);
ALTER TABLE identitystore_service_contract_attribute_requirement
    ADD CONSTRAINT fk_attribute_requirement_id_service_contract FOREIGN KEY (id_service_contract) REFERENCES identitystore_service_contract (id_service_contract);
ALTER TABLE identitystore_service_contract_attribute_requirement
    ADD CONSTRAINT fk_attribute_requirement_id_attribute FOREIGN KEY (id_attribute) REFERENCES identitystore_ref_attribute (id_attribute);
ALTER TABLE identitystore_service_contract_attribute_requirement
    ADD CONSTRAINT fk_attribute_requirement_certification_level FOREIGN KEY (id_ref_certification_level) REFERENCES identitystore_ref_certification_level (id_ref_certification_level);

--
-- Structure for table identitystore_service_contract_attribute_certification
--

CREATE TABLE identitystore_service_contract_attribute_certification
(
    id_service_contract                      int NOT NULL,
    id_attribute                             int NOT NULL,
    id_ref_attribute_certification_processus int NOT NULL,
    PRIMARY KEY (id_attribute, id_ref_attribute_certification_processus, id_service_contract)
);
ALTER TABLE identitystore_service_contract_attribute_certification
    ADD CONSTRAINT fk_attribute_certification_id_service_contract FOREIGN KEY (id_service_contract) REFERENCES identitystore_service_contract (id_service_contract);
ALTER TABLE identitystore_service_contract_attribute_certification
    ADD CONSTRAINT fk_attribute_certification_id_attribute FOREIGN KEY (id_attribute) REFERENCES identitystore_ref_attribute (id_attribute);
ALTER TABLE identitystore_service_contract_attribute_certification
    ADD CONSTRAINT fk_attribute_certification_certification_processus FOREIGN KEY (id_ref_attribute_certification_processus) REFERENCES identitystore_ref_certification_processus (id_ref_attribute_certification_processus);

--
-- Structure for table identitystore_attribute
--

CREATE TABLE identitystore_index_action
(
    id_index_action int AUTO_INCREMENT,
    customer_id     varchar(50) NOT NULL,
    action_type     varchar(50) NOT NULL,
    date_index      timestamp(3)   NOT NULL,
    PRIMARY KEY (id_index_action)
);



DROP TABLE IF EXISTS identitystore_identity_search_rule;
CREATE TABLE identitystore_identity_search_rule (
    id_rule      int AUTO_INCREMENT,
    type         varchar(8)      NOT NULL,
    PRIMARY KEY (id_rule)
);

DROP TABLE IF EXISTS identitystore_identity_search_rule_attribute;
CREATE TABLE identitystore_identity_search_rule_attribute (
    id_rule        int     NOT NULL,
    id_attribute   int     NOT NULL
);
ALTER TABLE identitystore_identity_search_rule_attribute
    ADD CONSTRAINT fk_identity_search_rule_attribute_id_rule FOREIGN KEY (id_rule) REFERENCES identitystore_identity_search_rule (id_rule) ON DELETE CASCADE;
ALTER TABLE identitystore_identity_search_rule_attribute
    ADD CONSTRAINT fk_identity_search_rule_attribute_id_attribute FOREIGN KEY (id_attribute) REFERENCES identitystore_ref_attribute (id_attribute);



--
-- Structure for table identitystore_identity_history
--
CREATE TABLE  identitystore_identity_history
(
    id_history            int AUTO_INCREMENT,
    change_type           int not null,
    change_status         varchar(255),
    change_message        varchar(255),
    author_type           varchar(255),
    author_name           varchar(255),
    client_code           varchar(255),
    customer_id           varchar(50) NOT NULL,
    modification_date     timestamp(3)    default CURRENT_TIMESTAMP,
    metadata              json default NULL,
    PRIMARY KEY (id_history)
    );

CREATE INDEX identitystore_identity_history_cuid ON identitystore_identity_history (customer_id);


--
-- Structure for table identitystore_duplicate_rule
--
CREATE TABLE identitystore_duplicate_rule (
    id_rule                 int AUTO_INCREMENT,
    code                    varchar(100)  UNIQUE NOT NULL,
    name                    varchar(100) NOT NULL,
    description             varchar(255),
    nb_filled_attributes    int,
    nb_equal_attributes     int,
    nb_missing_attributes   int,
    priority INT  DEFAULT 100 NOT NULL,
    active smallint  DEFAULT 0 NOT NULL,
    daemon smallint  DEFAULT 0 NOT NULL,
    daemon_last_exec_date TIMESTAMP(3) DEFAULT NULL,
    detection_limit         int default -1,
    creation_date  TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP NOT NULL ,
	last_update_date TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP NOT NULL ,
	author_name VARCHAR(255),
    PRIMARY KEY (id_rule)
);

--
-- Structure for table identitystore_quality_suspicious_identity
--


DROP TABLE IF EXISTS identitystore_quality_suspicious_identity;
CREATE TABLE identitystore_quality_suspicious_identity (
    id_suspicious_identity int AUTO_INCREMENT,
    customer_id varchar(50) default '' NOT NULL,
    id_duplicate_rule INT DEFAULT 0 NOT NULL ,
    date_create timestamp(3) default CURRENT_TIMESTAMP NOT NULL ,
    last_update_date timestamp(3),
    date_delete timestamp(3),
    is_deleted smallint default 0,
    PRIMARY KEY (id_suspicious_identity)
);
CREATE INDEX identitystore_quality_suspicious_identity_cuid ON identitystore_quality_suspicious_identity (customer_id);

--
-- Structure for table identitystore_quality_suspicious_identity_lock
--
DROP TABLE IF EXISTS identitystore_quality_suspicious_identity_lock;
CREATE TABLE identitystore_quality_suspicious_identity_lock (
    customer_id varchar(50) default '' NOT NULL,
    date_lock_end timestamp(3),
    is_locked smallint default 0,
    author_type varchar(255),
    author_name varchar(255)
);

--
-- Structure for table identitystore_quality_suspicious_identity
--

DROP TABLE IF EXISTS identitystore_quality_suspicious_identity_excluded;
CREATE TABLE identitystore_quality_suspicious_identity_excluded
(
    first_customer_id  VARCHAR(50)  NOT NULL,
    second_customer_id VARCHAR(50)  NOT NULL,
    date_create        TIMESTAMP(3)    NOT NULL,
    author_type        VARCHAR(255) NOT NULL,
    author_name        VARCHAR(255) NOT NULL
);

--
-- Structure for table identitystore_ref_attribute_values
--
DROP TABLE IF EXISTS identitystore_ref_attribute_values;
CREATE TABLE identitystore_ref_attribute_values
(
    id_attribute INTEGER,
    value        VARCHAR(50),
    label        VARCHAR(255)
);
ALTER TABLE identitystore_ref_attribute_values
    ADD CONSTRAINT fk_id_attribute FOREIGN KEY (id_attribute) REFERENCES identitystore_ref_attribute (id_attribute);

--
-- Structure for table identitystore_identity_account_history
--
CREATE TABLE identitystore_identity_account_history (
    connection_id varchar(100) NOT NULL,
    id_identity   int NOT NULL REFERENCES identitystore_identity(id_identity),
    creation_date timestamp(3) default CURRENT_TIMESTAMP NOT NULL,
    deletion_date timestamp(3) default CURRENT_TIMESTAMP NOT NULL,
    PRIMARY KEY (connection_id, id_identity, creation_date)
);
CREATE INDEX identitystore_identity_account_history_connection_id ON identitystore_identity_account_history (lower(connection_id::text));
CREATE INDEX identitystore_identity_account_history_id_identity ON identitystore_identity_account_history (id_identity);
