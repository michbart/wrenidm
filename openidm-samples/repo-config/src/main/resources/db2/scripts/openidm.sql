CONNECT TO DOPENIDM;
QUIESCE DATABASE IMMEDIATE FORCE CONNECTIONS;
UNQUIESCE DATABASE;
CONNECT RESET;
DEACTIVATE DATABASE DOPENIDM;
DROP DATABASE DOPENIDM;
-- DROP STOGROUP GOPENIDM;
-- COMMIT;
-- CREATE STOGROUP GOPENIDM
--       VOLUMES ('*')
--       VCAT     VSDB2T
--;
CREATE DATABASE   DOPENIDM
--       STOGROUP   GOPENIDM
--       BUFFERPOOL BP2
    -- Increase default page size for Activiti
    PAGESIZE 32 K
;
CONNECT TO DOPENIDM;

-- http://db2-vignettes.blogspot.com/2013/07/a-temporary-table-could-not-be-created.html
CREATE BUFFERPOOL BPOIDMTEMPPOOL SIZE 500 PAGESIZE 32K;

CREATE TEMPORARY TABLESPACE TEMPSPACE2 pagesize 32k
       MANAGED BY AUTOMATIC STORAGE
       BUFFERPOOL BPOIDMTEMPPOOL;

CREATE SCHEMA SOPENIDM;

-- -----------------------------------------------------
-- Table openidm.objecttypes
-- -----------------------------------------------------
CREATE TABLESPACE SOIDM00 MANAGED BY AUTOMATIC STORAGE;

CREATE TABLE SOPENIDM.OBJECTTYPES (
    ID                         INTEGER GENERATED BY DEFAULT AS IDENTITY ( CYCLE ),
    OBJECTTYPE                 VARCHAR(255)   NOT NULL,
    PRIMARY KEY (ID) )
IN DOPENIDM.SOIDM00;
COMMENT ON TABLE SOPENIDM.OBJECTTYPES IS 'OPENIDM - Dictionary table for object types';
CREATE UNIQUE INDEX SOPENIDM.IDX_OBJECTTYPES_OBJECTTYPE ON SOPENIDM.OBJECTTYPES (OBJECTTYPE ASC);


-- -----------------------------------------------------
-- Table openidm.genericobjects
-- -----------------------------------------------------

CREATE TABLESPACE SOIDM01 MANAGED BY AUTOMATIC STORAGE;
CREATE TABLE SOPENIDM.GENERICOBJECTS (
    id                         INTEGER GENERATED BY DEFAULT AS IDENTITY ( CYCLE ),
    objecttypes_id             INTEGER        NOT NULL,
    objectid                   VARCHAR(255)   NOT NULL,
    rev                        VARCHAR(38)    NOT NULL,
    fullobject                 CLOB(2M),
    PRIMARY KEY (ID),
    CONSTRAINT FK_GENERICOBJECTS_OBJECTTYPES
        FOREIGN KEY (OBJECTTYPES_ID ) REFERENCES SOPENIDM.OBJECTTYPES (ID ) ON DELETE CASCADE) IN DOPENIDM.SOIDM01;
COMMENT ON TABLE SOPENIDM.GENERICOBJECTS IS 'OPENIDM - Generic table For Any Kind Of Objects';
CREATE INDEX SOPENIDM.FK_GENERICOBJECTS_OBJECTTYPES ON SOPENIDM.GENERICOBJECTS (OBJECTTYPES_ID ASC);
CREATE UNIQUE INDEX SOPENIDM.IDX_GENERICOBJECTS_OBJECT ON SOPENIDM.GENERICOBJECTS (OBJECTID ASC, OBJECTTYPES_ID ASC);

-- -----------------------------------------------------
-- Table openidm.genericobjectproperties
-- -----------------------------------------------------

CREATE TABLESPACE SOIDM02 MANAGED BY AUTOMATIC STORAGE;
CREATE TABLE SOPENIDM.GENERICOBJECTPROPERTIES (
    genericobjects_id          INTEGER        NOT NULL,
    propkey                    VARCHAR(255)   NOT NULL,
    proptype                   VARCHAR(255),
    propvalue                  VARCHAR(2000),
    PRIMARY KEY (genericobjects_id, propkey),
    CONSTRAINT FK_GENERICOBJECTPROPERTIES_GENERICOBJECTS
        FOREIGN KEY (GENERICOBJECTS_ID ) REFERENCES SOPENIDM.GENERICOBJECTS (ID)
        ON DELETE CASCADE
) IN DOPENIDM.SOIDM02;
COMMENT ON TABLE SOPENIDM.GENERICOBJECTPROPERTIES IS 'OPENIDM - Properties of Generic Objects';
CREATE INDEX SOPENIDM.IDX_GENERICOBJECTPROPERTIES_GENERICOBJECTS ON SOPENIDM.GENERICOBJECTPROPERTIES (GENERICOBJECTS_ID ASC);
CREATE INDEX SOPENIDM.IDX_GENERICOBJECTPROPERTIES_PROPKEY ON SOPENIDM.GENERICOBJECTPROPERTIES (PROPKEY ASC);
CREATE INDEX SOPENIDM.IDX_GENERICOBJECTPROPERTIES_PROPVALUE ON SOPENIDM.GENERICOBJECTPROPERTIES (PROPVALUE ASC);

-- -----------------------------------------------------
-- Table openidm.managedobjects
-- -----------------------------------------------------

CREATE TABLESPACE SOIDM03 MANAGED BY AUTOMATIC STORAGE;
CREATE TABLE SOPENIDM.MANAGEDOBJECTS (
    id                         INTEGER GENERATED BY DEFAULT AS IDENTITY ( CYCLE ),
    objecttypes_id             INTEGER        NOT NULL,
    objectid                   VARCHAR(255)   NOT NULL,
    rev                        VARCHAR(38)    NOT NULL,
    fullobject                 CLOB(2M),
    PRIMARY KEY (ID),
    CONSTRAINT FK_MANAGEDOBJECTS_OBJECTTYPES
        FOREIGN KEY (OBJECTTYPES_ID ) REFERENCES SOPENIDM.OBJECTTYPES (ID )
        ON DELETE CASCADE
) IN DOPENIDM.SOIDM03;
COMMENT ON TABLE SOPENIDM.MANAGEDOBJECTS IS 'OPENIDM - Generic Table For Managed Objects';
CREATE UNIQUE INDEX SOPENIDM.IDX_MANAGEDOBJECTS_OBJECT
    ON SOPENIDM.MANAGEDOBJECTS (objecttypes_id ASC, objectid ASC);
CREATE INDEX SOPENIDM.FK_MANAGEDOBJECTS_OBJECTTYPES ON SOPENIDM.MANAGEDOBJECTS (OBJECTTYPES_ID ASC);

-- -----------------------------------------------------
-- Table openidm.managedobjectproperties
-- -----------------------------------------------------

CREATE TABLESPACE SOIDM04 MANAGED BY AUTOMATIC STORAGE ;
CREATE TABLE SOPENIDM.MANAGEDOBJECTPROPERTIES (
    MANAGEDOBJECTS_ID          INTEGER        NOT NULL,
    PROPKEY                    VARCHAR(255)   NOT NULL,
    PROPTYPE                   VARCHAR(255),
    PROPVALUE                  VARCHAR(2000),
    PRIMARY KEY (MANAGEDOBJECTS_ID, PROPKEY),
    CONSTRAINT FK_MANAGEDOBJECTPROPERTIES_MANAGEDOBJECTS
        FOREIGN KEY (MANAGEDOBJECTS_ID )
        REFERENCES SOPENIDM.MANAGEDOBJECTS (ID )
        ON DELETE CASCADE
) IN DOPENIDM.SOIDM04;
COMMENT ON TABLE SOPENIDM.MANAGEDOBJECTPROPERTIES IS 'OPENIDM - Properties of Managed Objects';
CREATE INDEX SOPENIDM.IDX_MANAGEDOBJECTPROPERTIES_MANAGEDOBJECTS ON SOPENIDM.MANAGEDOBJECTPROPERTIES (MANAGEDOBJECTS_ID ASC);
CREATE INDEX SOPENIDM.IDX_MANAGEDOBJECTPROPERTIES_PROPKEY ON SOPENIDM.MANAGEDOBJECTPROPERTIES (PROPKEY ASC);
CREATE INDEX SOPENIDM.IDX_MANAGEDOBJECTPROPERTIES_PROPVALUE ON SOPENIDM.MANAGEDOBJECTPROPERTIES (PROPVALUE ASC);

-- -----------------------------------------------------
-- Table openidm.configobjects
-- -----------------------------------------------------

CREATE TABLESPACE SOIDM05 MANAGED BY AUTOMATIC STORAGE ;
CREATE TABLE SOPENIDM.CONFIGOBJECTS (
    id                         INTEGER GENERATED BY DEFAULT AS IDENTITY ( CYCLE ),
    objecttypes_id             INTEGER        NOT NULL,
    objectid                   VARCHAR(255)   NOT NULL,
    rev                        VARCHAR(38)    NOT NULL,
    fullobject                 CLOB(2M),
    PRIMARY KEY (ID),
    CONSTRAINT FK_CONFIGOBJECTS_OBJECTTYPES
        FOREIGN KEY (OBJECTTYPES_ID )
        REFERENCES SOPENIDM.OBJECTTYPES (ID )
        ON DELETE CASCADE
) IN DOPENIDM.SOIDM05;
COMMENT ON TABLE SOPENIDM.CONFIGOBJECTS IS 'OPENIDM - Generic Table For Config Objects';
CREATE INDEX SOPENIDM.FK_CONFIGOBJECTS_OBJECTTYPES ON SOPENIDM.CONFIGOBJECTS (OBJECTTYPES_ID ASC);
CREATE UNIQUE INDEX SOPENIDM.IDX_CONFIGOBJECTS_OBJECT ON SOPENIDM.CONFIGOBJECTS (OBJECTID ASC, OBJECTTYPES_ID ASC);

-- -----------------------------------------------------
-- Table openidm.configobjectproperties
-- -----------------------------------------------------

CREATE TABLESPACE SOIDM06 MANAGED BY AUTOMATIC STORAGE;
CREATE TABLE SOPENIDM.CONFIGOBJECTPROPERTIES (
    CONFIGOBJECTS_ID           INTEGER        NOT NULL,
    PROPKEY                    VARCHAR(255)   NOT NULL,
    PROPTYPE                   VARCHAR(255),
    PROPVALUE                  VARCHAR(2000),
    PRIMARY KEY (CONFIGOBJECTS_ID, PROPKEY),
    CONSTRAINT FK_CONFIGOBJECTPROPERTIES_CONFIGOBJECTS
        FOREIGN KEY (CONFIGOBJECTS_ID )
        REFERENCES SOPENIDM.CONFIGOBJECTS (ID )
        ON DELETE CASCADE
) IN DOPENIDM.SOIDM06;
COMMENT ON TABLE SOPENIDM.CONFIGOBJECTPROPERTIES IS 'OPENIDM - Properties of Config Objects';
CREATE INDEX SOPENIDM.IDX_CONFIGOBJECTPROPERTIES_CONFIGOBJECTS ON SOPENIDM.CONFIGOBJECTPROPERTIES (CONFIGOBJECTS_ID ASC);
CREATE INDEX SOPENIDM.IDX_CONFIGOBJECTPROPERTIES_PROPKEY ON SOPENIDM.CONFIGOBJECTPROPERTIES (PROPKEY ASC);
CREATE INDEX SOPENIDM.IDX_CONFIGOBJECTPROPERTIES_PROPVALUE ON SOPENIDM.CONFIGOBJECTPROPERTIES (PROPVALUE ASC);

-- -----------------------------------------------------
-- Table openidm.relationships
-- -----------------------------------------------------

CREATE TABLESPACE SOIDM22 MANAGED BY AUTOMATIC STORAGE ;
CREATE TABLE SOPENIDM.RELATIONSHIPS (
    id                         INTEGER GENERATED BY DEFAULT AS IDENTITY ( CYCLE ),
    objecttypes_id             INTEGER        NOT NULL,
    objectid                   VARCHAR(255)   NOT NULL,
    rev                        VARCHAR(38)    NOT NULL,
    fullobject                 CLOB(2M),
    PRIMARY KEY (id),
    CONSTRAINT fk_relationships_objecttypes
        FOREIGN KEY (objecttypes_id)
        REFERENCES sopenidm.objecttypes (id)
        ON DELETE CASCADE
) IN DOPENIDM.SOIDM22;
COMMENT ON TABLE sopenidm.relationships IS 'OPENIDM - Generic Table For Relationships';
CREATE INDEX sopenidm.fk_relationships_objecttypes ON sopenidm.relationships (objecttypes_id ASC);
CREATE UNIQUE INDEX sopenidm.idx_relaitonships_object ON sopenidm.relationships (objectid ASC, objecttypes_id ASC);

-- -----------------------------------------------------
-- Table openidm.relationshiproperties
-- -----------------------------------------------------

CREATE TABLESPACE SOIDM23 MANAGED BY AUTOMATIC STORAGE;
CREATE TABLE SOPENIDM.RELATIONSHIPPROPERTIES (
    relationships_id           INTEGER        NOT NULL,
    propkey                    VARCHAR(255)   NOT NULL,
    proptype                   VARCHAR(255),
    propvalue                  VARCHAR(2000),
    PRIMARY KEY (relationships_id, propkey),
    CONSTRAINT fk_relationshipproperties_relationships
        FOREIGN KEY (relationships_id)
        REFERENCES sopenidm.relationships (id)
        ON DELETE CASCADE
) IN DOPENIDM.SOIDM23;
COMMENT ON TABLE SOPENIDM.RELATIONSHIPPROPERTIES IS 'OPENIDM - Properties of Relationships';
CREATE INDEX SOPENIDM.IDX_RELATIONSHIPPROPERTIES_RELATIONSHIPS ON SOPENIDM.RELATIONSHIPPROPERTIES (RELATIONSHIPS_ID ASC);
CREATE INDEX SOPENIDM.IDX_RELATIONSHIPPROPERTIES_PROPKEY ON SOPENIDM.RELATIONSHIPPROPERTIES (PROPKEY ASC);
CREATE INDEX SOPENIDM.IDX_RELATIONSHIPPROPERTIES_PROPVALUE ON SOPENIDM.RELATIONSHIPPROPERTIES (PROPVALUE ASC);

-- -----------------------------------------------------
-- Table openidm.links
-- -----------------------------------------------------

CREATE TABLESPACE SOIDM07 MANAGED BY AUTOMATIC STORAGE;
CREATE TABLE SOPENIDM.LINKS (
    objectid                   VARCHAR(38)    NOT NULL,
    rev                        VARCHAR(38)    NOT NULL,
    linktype                   VARCHAR(50)   NOT NULL,
    linkqualifier              VARCHAR(50)   NOT NULL,
    firstid                    VARCHAR(255)   NOT NULL,
    secondid                   VARCHAR(255)   NOT NULL,
    PRIMARY KEY (OBJECTID)
) IN DOPENIDM.SOIDM07;
COMMENT ON TABLE SOPENIDM.LINKS IS 'OPENIDM - Object Links For Mappings And Synchronization';

CREATE UNIQUE INDEX SOPENIDM.IDX_LINKS_FIRST ON SOPENIDM.LINKS (LINKTYPE ASC, LINKQUALIFIER ASC, FIRSTID ASC);
CREATE UNIQUE INDEX SOPENIDM.IDX_LINKS_SECOND ON SOPENIDM.LINKS (LINKTYPE ASC, LINKQUALIFIER ASC, SECONDID ASC);

-- -----------------------------------------------------
-- Table openidm.securitykeys
-- -----------------------------------------------------

CREATE TABLESPACE SOIDM12 MANAGED BY AUTOMATIC STORAGE;
CREATE TABLE SOPENIDM.SECURITYKEYS (
    objectid                   VARCHAR(38)     NOT NULL,
    rev                        VARCHAR(38)     NOT NULL,
    keypair                    CLOB(2M)        NOT NULL
) IN DOPENIDM.SOIDM12;
COMMENT ON TABLE SOPENIDM.SECURITYKEYS IS 'OPENIDM - Security keys';

-- -----------------------------------------------------
-- Table `openidm`.`auditauthentication`
-- -----------------------------------------------------
CREATE TABLESPACE SOIDM20 MANAGED BY AUTOMATIC STORAGE;
CREATE TABLE sopenidm.auditauthentication (
  objectid VARCHAR(56) NOT NULL,
  transactionid VARCHAR(255) NOT NULL,
  activitydate VARCHAR(29) NOT NULL,
  userid VARCHAR(255) NULL,
  eventname VARCHAR(50) NULL,
  result VARCHAR(255) NULL,
  principals CLOB(2M),
  context CLOB(2M),
  entries CLOB(2M),
  trackingids CLOB(2M),
  PRIMARY KEY (objectid)
) IN DOPENIDM.SOIDM20;


-- -----------------------------------------------------
-- Table openidm.auditrecon
-- -----------------------------------------------------

CREATE TABLESPACE SOIDM08 MANAGED BY AUTOMATIC STORAGE;
CREATE TABLE SOPENIDM.AUDITRECON (
    objectid VARCHAR(56) NOT NULL ,
    transactionid VARCHAR(255) NOT NULL ,
    activitydate VARCHAR(29) NOT NULL ,
    eventname VARCHAR(50) NULL ,
    userid VARCHAR(255) NULL ,
    trackingids CLOB(2M),
    activity VARCHAR(24) NULL ,
    exceptiondetail CLOB(2M) NULL ,
    linkqualifier VARCHAR(255) NULL ,
    mapping VARCHAR(511) NULL ,
    message CLOB(2M) NULL ,
    messagedetail CLOB(2M) NULL ,
    situation VARCHAR(24) NULL ,
    sourceobjectid VARCHAR(511) NULL ,
    status VARCHAR(20) NULL ,
    targetobjectid VARCHAR(511) NULL ,
    reconciling VARCHAR(12) NULL ,
    ambiguoustargetobjectids CLOB(2M) NULL ,
    reconaction VARCHAR(36) NULL ,
    entrytype VARCHAR(7) NULL ,
    reconid VARCHAR(56) NULL ,
    PRIMARY KEY (OBJECTID)
) IN DOPENIDM.SOIDM08;
COMMENT ON TABLE SOPENIDM.AUDITRECON IS 'OPENIDM - Reconciliation Audit Log';

CREATE INDEX sopenidm.idx_auditrecon_reconid ON sopenidm.auditrecon (reconid ASC);
CREATE INDEX sopenidm.idx_auditrecon_entrytype ON sopenidm.auditrecon (entrytype ASC);

-- -----------------------------------------------------
-- Table openidm.auditsync
-- -----------------------------------------------------

CREATE TABLESPACE SOIDM13 MANAGED BY AUTOMATIC STORAGE;
CREATE TABLE sopenidm.auditsync (
    objectid                VARCHAR(56) NOT NULL ,
    transactionid           VARCHAR(255) NOT NULL ,
    activitydate            VARCHAR(29) NOT NULL ,
    eventname               VARCHAR(50) NULL ,
    userid VARCHAR(255) NULL ,
    trackingids CLOB(2M),
    activity                VARCHAR(24) NULL ,
    exceptiondetail         CLOB(2M) NULL ,
    linkqualifier           VARCHAR(255) NULL ,
    mapping                 VARCHAR(511) NULL ,
    message                 CLOB(2M) NULL ,
    messagedetail           CLOB(2M) NULL ,
    situation               VARCHAR(24) NULL ,
    sourceobjectid          VARCHAR(511) NULL ,
    status                  VARCHAR(20) NULL ,
    targetobjectid          VARCHAR(511) NULL ,
    PRIMARY KEY (objectid) )
IN DOPENIDM.SOIDM13;
COMMENT ON TABLE SOPENIDM.AUDITSYNC IS 'OPENIDM - Sync Audit Log';

-- -----------------------------------------------------
-- Table `openidm`.`auditconfig`
-- -----------------------------------------------------
CREATE TABLESPACE SOIDM21 MANAGED BY AUTOMATIC STORAGE;
CREATE  TABLE sopenidm.auditconfig (
  objectid VARCHAR(56) NOT NULL ,
  activitydate VARCHAR(29) NOT NULL,
  eventname VARCHAR(255) NULL ,
  transactionid VARCHAR(255) NOT NULL ,
  userid VARCHAR(255) NULL ,
  trackingids CLOB(2M),
  runas VARCHAR(255) NULL ,
  configobjectid VARCHAR(255) NULL ,
  operation VARCHAR(255) NULL ,
  beforeObject CLOB(2M) NULL ,
  afterObject CLOB(2M) NULL ,
  changedfields CLOB(2M) NULL ,
  rev VARCHAR(255) NULL,
  PRIMARY KEY (objectid)
) IN DOPENIDM.SOIDM21;


-- -----------------------------------------------------
-- Table openidm.auditactivity
-- -----------------------------------------------------

CREATE TABLESPACE SOIDM09 MANAGED BY AUTOMATIC STORAGE;
CREATE TABLE SOPENIDM.AUDITACTIVITY (
    objectid VARCHAR(56) NOT NULL ,
    activitydate VARCHAR(29) NOT NULL,
    eventname VARCHAR(255) NULL ,
    transactionid VARCHAR(255) NOT NULL ,
    userid VARCHAR(255) NULL ,
    trackingids CLOB(2M),
    runas VARCHAR(255) NULL ,
    activityobjectid VARCHAR(255) NULL ,
    operation VARCHAR(255) NULL ,
    subjectbefore CLOB(2M) NULL ,
    subjectafter CLOB(2M) NULL ,
    changedfields CLOB(2M) NULL ,
    subjectrev VARCHAR(255) NULL ,
    passwordchanged VARCHAR(5) NULL ,
    message CLOB(2M) NULL,
    status VARCHAR(20) ,
    PRIMARY KEY (objectid)
) IN DOPENIDM.SOIDM09;
COMMENT ON TABLE SOPENIDM.AUDITACTIVITY IS 'OPENIDM - Activity Audit Logs';
CREATE INDEX SOPENIDM.idx_auditactivity_transactionid ON SOPENIDM.AUDITACTIVITY (transactionid ASC);

-- -----------------------------------------------------
-- Table openidm.auditaccess
-- -----------------------------------------------------

CREATE TABLESPACE SOIDM10 MANAGED BY AUTOMATIC STORAGE;
CREATE TABLE SOPENIDM.AUDITACCESS (
    objectid VARCHAR(56) NOT NULL ,
    activitydate VARCHAR(29) NOT NULL,
    eventname VARCHAR(255) ,
    transactionid VARCHAR(255) NOT NULL ,
    userid VARCHAR(255) ,
    trackingids CLOB(2M),
    server_ip VARCHAR(40) ,
    server_port VARCHAR(5) ,
    client_ip VARCHAR(40) ,
    client_port VARCHAR(5) ,
    request_protocol VARCHAR(255) NULL ,
    request_operation VARCHAR(255) NULL ,
    request_detail CLOB(2M) NULL ,
    http_request_secure VARCHAR(255) NULL ,
    http_request_method VARCHAR(255) NULL ,
    http_request_path VARCHAR(255) NULL ,
    http_request_queryparameters CLOB(2M) NULL ,
    http_request_headers CLOB(2M) NULL ,
    http_request_cookies CLOB(2M) NULL ,
    http_response_headers CLOB(2M) NULL ,
    response_status VARCHAR(255) NULL ,
    response_statuscode VARCHAR(255) NULL ,
    response_elapsedtime VARCHAR(255) NULL ,
    response_elapsedtimeunits VARCHAR(255) NULL ,
    response_detail CLOB(2M) NULL ,
    roles CLOB(2M) NULL ,
    PRIMARY KEY (OBJECTID)
) IN DOPENIDM.SOIDM10;
COMMENT ON TABLE SOPENIDM.AUDITACCESS IS 'OPENIDM - Audit Access';

-- -----------------------------------------------------
-- Table openidm.internaluser
-- -----------------------------------------------------

CREATE TABLESPACE SOIDM14 MANAGED BY AUTOMATIC STORAGE;
CREATE TABLE SOPENIDM.INTERNALUSER (
    objectid                   VARCHAR(254)    NOT NULL,
    rev                        VARCHAR(38),
    pwd                        VARCHAR(510),
    roles                      VARCHAR(1024),
    PRIMARY KEY (objectid)
) IN DOPENIDM.SOIDM14;
COMMENT ON TABLE SOPENIDM.INTERNALUSER IS 'OPENIDM - Internal User';

-- -----------------------------------------------------
-- Table openidm.internaluser
-- -----------------------------------------------------

CREATE TABLESPACE SOIDM26 MANAGED BY AUTOMATIC STORAGE;
CREATE TABLE SOPENIDM.INTERNALROLE (
    objectid                   VARCHAR(254)    NOT NULL,
    rev                        VARCHAR(38),
    description                VARCHAR(1024),
    PRIMARY KEY (objectid)
) IN DOPENIDM.SOIDM26;
COMMENT ON TABLE SOPENIDM.INTERNALROLE IS 'OPENIDM - Internal Role';

-- -----------------------------------------------------
-- Table openidm.schedulerobjects
-- -----------------------------------------------------

CREATE TABLESPACE SOIDM15 MANAGED BY AUTOMATIC STORAGE;
CREATE TABLE SOPENIDM.SCHEDULEROBJECTS (
    ID                         INTEGER GENERATED BY DEFAULT AS IDENTITY ( CYCLE ),
    OBJECTTYPES_ID             INTEGER        NOT NULL,
    OBJECTID                   VARCHAR(255)   NOT NULL,
    REV                        VARCHAR(38)    NOT NULL,
    FULLOBJECT                 CLOB(2M),
    PRIMARY KEY (ID),
    CONSTRAINT FK_SCHEDULEROBJECTS_OBJECTTYPES
        FOREIGN KEY (OBJECTTYPES_ID )
        REFERENCES SOPENIDM.OBJECTTYPES (ID )
        ON DELETE CASCADE
) IN DOPENIDM.SOIDM15;
COMMENT ON TABLE SOPENIDM.SCHEDULEROBJECTS IS 'OPENIDM - Generic table for scheduler objects';

CREATE INDEX SOPENIDM.FK_SCHEDULEROBJECTS_OBJECTTYPES ON SOPENIDM.SCHEDULEROBJECTS (OBJECTTYPES_ID ASC) ;
CREATE UNIQUE INDEX SOPENIDM.IDX_SCHEDULEROBJECTS_OBJECT ON SOPENIDM.SCHEDULEROBJECTS (OBJECTID ASC, OBJECTTYPES_ID ASC);

-- -----------------------------------------------------
-- Table openidm.schedulerobjectproperties
-- -----------------------------------------------------

CREATE TABLESPACE SOIDM16 MANAGED BY AUTOMATIC STORAGE;
CREATE TABLE SOPENIDM.SCHEDULEROBJECTPROPERTIES (
    SCHEDULEROBJECTS_ID        INTEGER        NOT NULL,
    PROPKEY                    VARCHAR(255)   NOT NULL,
    PROPTYPE                   VARCHAR(255),
    PROPVALUE                  VARCHAR(2000),
    PRIMARY KEY (SCHEDULEROBJECTS_ID, PROPKEY),
    CONSTRAINT FK_SCHEDULEROBJECTPROPERTIES_SCHEDULEROBJECTS
        FOREIGN KEY (SCHEDULEROBJECTS_ID )
        REFERENCES SOPENIDM.SCHEDULEROBJECTS (ID )
        ON DELETE CASCADE
) IN DOPENIDM.SOIDM16;
COMMENT ON TABLE SOPENIDM.SCHEDULEROBJECTPROPERTIES IS 'OPENIDM - Properties of Generic Objects';
CREATE INDEX SOPENIDM.IDX_SCHEDULEROBJECTPROPERTIES_SCHEDULEROBJECTS ON SOPENIDM.SCHEDULEROBJECTPROPERTIES (SCHEDULEROBJECTS_ID ASC) ;
CREATE INDEX SOPENIDM.IDX_SCHEDULEROBJECTPROPERTIES_PROPKEY ON SOPENIDM.SCHEDULEROBJECTPROPERTIES (PROPKEY ASC) ;
CREATE INDEX SOPENIDM.IDX_SCHEDULEROBJECTPROPERTIES_PROPVALUE ON SOPENIDM.SCHEDULEROBJECTPROPERTIES (PROPVALUE ASC) ;

-- -----------------------------------------------------
-- Table openidm.uinotification
-- -----------------------------------------------------

CREATE TABLESPACE SOIDM19 MANAGED BY AUTOMATIC STORAGE;
CREATE TABLE SOPENIDM.UINOTIFICATION (
    OBJECTID                   VARCHAR(38)    NOT NULL,
    REV                        VARCHAR(38)    NOT NULL,
    NOTIFICATIONTYPE           VARCHAR(255)   NOT NULL,
    CREATEDATE                 VARCHAR(255)   NOT NULL,
    MESSAGE                    CLOB(2M)       NOT NULL,
    REQUESTER                  VARCHAR(255)       NULL,
    RECEIVERID                 VARCHAR(38)    NOT NULL,
    REQUESTERID                VARCHAR(38)        NULL,
    NOTIFICATIONSUBTYPE        VARCHAR(255)       NULL,
    PRIMARY KEY (OBJECTID)
) IN DOPENIDM.SOIDM19;
COMMENT ON TABLE SOPENIDM.UINOTIFICATION IS 'OPENIDM - Generic table for ui notifications';

-- -----------------------------------------------------
-- Table openidm.clusterobjects
-- -----------------------------------------------------

CREATE TABLESPACE SOIDM17 MANAGED BY AUTOMATIC STORAGE;
CREATE TABLE SOPENIDM.CLUSTEROBJECTS (
    ID                         INTEGER GENERATED BY DEFAULT AS IDENTITY ( CYCLE ),
    OBJECTTYPES_ID             INTEGER        NOT NULL,
    OBJECTID                   VARCHAR(255)   NOT NULL,
    REV                        VARCHAR(38)    NOT NULL,
    FULLOBJECT                 CLOB(2M),
    PRIMARY KEY (ID),
    CONSTRAINT FK_CLUSTEROBJECTS_OBJECTTYPES
        FOREIGN KEY (OBJECTTYPES_ID )
        REFERENCES SOPENIDM.OBJECTTYPES (ID )
        ON DELETE CASCADE
) IN DOPENIDM.SOIDM17;
COMMENT ON TABLE SOPENIDM.CLUSTEROBJECTS IS 'OPENIDM - Generic table for cluster objects';
CREATE INDEX SOPENIDM.FK_CLUSTEROBJECTS_OBJECTTYPES ON SOPENIDM.CLUSTEROBJECTS (OBJECTTYPES_ID ASC);
CREATE UNIQUE INDEX SOPENIDM.IDX_CLUSTEROBJECTS_OBJECT ON SOPENIDM.CLUSTEROBJECTS (OBJECTID ASC, OBJECTTYPES_ID ASC);

-- -----------------------------------------------------
-- Table openidm.clusterobjectproperties
-- -----------------------------------------------------

CREATE TABLESPACE SOIDM18 MANAGED BY AUTOMATIC STORAGE;
CREATE TABLE SOPENIDM.CLUSTEROBJECTPROPERTIES (
    CLUSTEROBJECTS_ID          INTEGER        NOT NULL,
    PROPKEY                    VARCHAR(255)   NOT NULL,
    PROPTYPE                   VARCHAR(255),
    PROPVALUE                  VARCHAR(2000),
    PRIMARY KEY (CLUSTEROBJECTS_ID, PROPKEY),
    CONSTRAINT FK_CLUSTEROBJECTPROPERTIES_CLUSTEROBJECTS
        FOREIGN KEY (CLUSTEROBJECTS_ID )
        REFERENCES SOPENIDM.CLUSTEROBJECTS (ID )
        ON DELETE CASCADE
) IN DOPENIDM.SOIDM18;
COMMENT ON TABLE SOPENIDM.CLUSTEROBJECTPROPERTIES IS 'OPENIDM - Properties of Generic Objects';
CREATE INDEX SOPENIDM.IDX_CLUSTEROBJECTPROPERTIES_CLUSTEROBJECTS ON SOPENIDM.CLUSTEROBJECTPROPERTIES (CLUSTEROBJECTS_ID ASC);
CREATE INDEX SOPENIDM.IDX_CLUSTEROBJECTPROPERTIES_PROPKEY ON SOPENIDM.CLUSTEROBJECTPROPERTIES (PROPKEY ASC);
CREATE INDEX SOPENIDM.IDX_CLUSTEROBJECTPROPERTIES_PROPVALUE ON SOPENIDM.CLUSTEROBJECTPROPERTIES (PROPVALUE ASC);

-- -----------------------------------------------------
-- Table `openidm`.`updateobjects`
-- -----------------------------------------------------

CREATE TABLESPACE SOIDM24 MANAGED BY AUTOMATIC STORAGE;
CREATE  TABLE SOPENIDM.UPDATEOBJECTS (
    ID                        INTEGER GENERATED BY DEFAULT AS IDENTITY ( CYCLE ),
  OBJECTTYPES_ID             INTEGER        NOT NULL,
  OBJECTID                   VARCHAR(255)   NOT NULL,
  REV                        VARCHAR(38)    NOT NULL,
  FULLOBJECT                 CLOB(2M),
  PRIMARY KEY (ID),
  CONSTRAINT FK_UPDATEOBJECTS_OBJECTTYPES
  FOREIGN KEY (OBJECTTYPES_ID )
  REFERENCES SOPENIDM.OBJECTTYPES (ID )
  ON DELETE CASCADE
) IN DOPENIDM.SOIDM24;

-- -----------------------------------------------------
-- Table `openidm`.`updateobjectproperties`
-- -----------------------------------------------------

CREATE TABLESPACE SOIDM25 MANAGED BY AUTOMATIC STORAGE;
CREATE TABLE SOPENIDM.UPDATEOBJECTPROPERTIES (
  UPDATEOBJECTS_ID           INTEGER        NOT NULL,
  PROPKEY                    VARCHAR(255)   NOT NULL,
  PROPTYPE                   VARCHAR(255),
  PROPVALUE                  VARCHAR(2000),
  PRIMARY KEY (UPDATEOBJECTS_ID, PROPKEY),
  CONSTRAINT FK_UPDATEOBJECTPROPERTIES_UPDATEOBJECTS
  FOREIGN KEY (UPDATEOBJECTS_ID )
  REFERENCES SOPENIDM.UPDATEOBJECTS (ID )
  ON DELETE CASCADE
) IN DOPENIDM.SOIDM25;
COMMENT ON TABLE SOPENIDM.UPDATEOBJECTPROPERTIES IS 'OPENIDM - Properties of Update Objects';
CREATE INDEX SOPENIDM.IDX_UPDATEOBJECTPROPERTIES_UPDATEOBJECTS ON SOPENIDM.UPDATEOBJECTPROPERTIES (UPDATEOBJECTS_ID ASC);
CREATE INDEX SOPENIDM.IDX_UPDATEOBJECTPROPERTIES_PROPKEY ON SOPENIDM.UPDATEOBJECTPROPERTIES (PROPKEY ASC);
CREATE INDEX SOPENIDM.IDX_UPDATEOBJECTPROPERTIES_PROPVALUE ON SOPENIDM.UPDATEOBJECTPROPERTIES (PROPVALUE ASC);

-- -----------------------------------------------------
-- Data for table openidm.internaluser
-- -----------------------------------------------------

INSERT INTO sopenidm.internaluser (objectid, rev, pwd, roles) VALUES ('openidm-admin', '0', 'openidm-admin', '[ { "_ref" : "repo/internal/role/openidm-admin" }, { "_ref" : "repo/internal/role/openidm-authorized" } ]');
INSERT INTO sopenidm.internaluser (objectid, rev, pwd, roles) VALUES ('anonymous', '0', 'anonymous', '[ { "_ref" : "repo/internal/role/openidm-reg" } ]');

INSERT INTO sopenidm.internalrole (objectid, rev, description)
VALUES
('openidm-authorized', '0', 'Basic minimum user'),
('openidm-admin', '0', 'Administrative access'),
('openidm-cert', '0', 'Authenticated via certificate'),
('openidm-tasks-manager', '0', 'Allowed to reassign workflow tasks'),
('openidm-reg', '0', 'Anonymous access');


COMMIT;
