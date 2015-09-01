CREATE TABLE ARTICLE
(
    ID BIGINT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    CONTENT CLOB,
    HEADLINE VARCHAR(255),
    NBCONSULTS BIGINT NOT NULL,
    POSTEDAT BINARY(255),
    TITLE VARCHAR(100),
    VALID BOOLEAN NOT NULL,
    AUTHOR_ID BIGINT NOT NULL
);
CREATE TABLE ARTICLECOMMENT
(
    ID BIGINT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    CONTENT CLOB NOT NULL,
    POSTEDAT BINARY(255) NOT NULL,
    ARTICLE_ID BIGINT,
    MEMBER_ID BIGINT NOT NULL
);
CREATE TABLE EVENT
(
    ID BIGINT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    CURRENT BOOLEAN NOT NULL,
    YEAR INTEGER NOT NULL
);
CREATE TABLE INTEREST
(
    NAME VARCHAR(50) PRIMARY KEY NOT NULL
);
CREATE TABLE MEMBER
(
    DTYPE VARCHAR(31) NOT NULL,
    ID BIGINT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    COMPANY VARCHAR(100),
    EMAIL VARCHAR(250),
    FIRSTNAME VARCHAR(100),
    LASTNAME VARCHAR(100),
    LOGIN VARCHAR(100) NOT NULL,
    LONGDESCRIPTION CLOB,
    NBCONSULTS BIGINT NOT NULL,
    PUBLICPROFILE BOOLEAN NOT NULL,
    REGISTEREDAT BINARY(255),
    SHORTDESCRIPTION VARCHAR(300),
    TICKETINGREGISTERED BOOLEAN,
    LEVEL VARCHAR(255),
    LOGOURL VARCHAR(250),
    SESSIONTYPE VARCHAR(255)
);
CREATE TABLE MEMBER_EVENT
(
    MEMBER_ID BIGINT NOT NULL,
    EVENTS_ID BIGINT NOT NULL,
    PRIMARY KEY (MEMBER_ID, EVENTS_ID)
);
CREATE TABLE MEMBER_INTEREST
(
    MEMBER_ID BIGINT NOT NULL,
    INTERESTS_NAME VARCHAR(50) NOT NULL,
    PRIMARY KEY (MEMBER_ID, INTERESTS_NAME)
);
CREATE TABLE SESSION
(
    DTYPE VARCHAR(31) NOT NULL,
    ID BIGINT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    ADDEDAT BINARY(255),
    DESCRIPTION CLOB NOT NULL,
    FEEDBACK BOOLEAN NOT NULL,
    FORMAT VARCHAR(255),
    GUEST BOOLEAN NOT NULL,
    IDEAFORNOW CLOB,
    LANG VARCHAR(255) NOT NULL,
    LEVEL VARCHAR(255),
    MAXATTENDEES INTEGER,
    MESSAGEFORSTAFF CLOB,
    NBCONSULTS BIGINT NOT NULL,
    SESSIONACCEPTED BOOLEAN,
    SUMMARY VARCHAR(300),
    TITLE VARCHAR(100) NOT NULL,
    VALID BOOLEAN NOT NULL,
    EVENT_ID BIGINT NOT NULL
);
CREATE TABLE SESSIONCOMMENT
(
    ID BIGINT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    CONTENT CLOB NOT NULL,
    POSTEDAT BINARY(255) NOT NULL,
    PRIVATE BOOLEAN,
    MEMBER_ID BIGINT NOT NULL,
    SESSION_ID BIGINT NOT NULL
);
CREATE TABLE SESSION_INTEREST
(
    SESSION_ID BIGINT NOT NULL,
    INTERESTS_NAME VARCHAR(50) NOT NULL,
    PRIMARY KEY (SESSION_ID, INTERESTS_NAME)
);
CREATE TABLE SESSION_MEMBER
(
    SESSIONS_ID BIGINT NOT NULL,
    SPEAKERS_ID BIGINT NOT NULL,
    PRIMARY KEY (SESSIONS_ID, SPEAKERS_ID)
);
CREATE TABLE SHAREDLINK
(
    ID BIGINT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    URL VARCHAR(250) NOT NULL,
    NAME VARCHAR(50) NOT NULL,
    ORDERNUM INTEGER NOT NULL,
    MEMBER_ID BIGINT NOT NULL
);
CREATE TABLE VOTE
(
    ID BIGINT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    VALUE BOOLEAN NOT NULL,
    MEMBER_ID BIGINT,
    SESSION_ID BIGINT
);
ALTER TABLE ARTICLE ADD FOREIGN KEY (AUTHOR_ID) REFERENCES MEMBER (ID);
CREATE INDEX FK_I83UTKPQPTS0YRSY4YDQOCRJ1_INDEX_F ON ARTICLE (AUTHOR_ID);
ALTER TABLE ARTICLECOMMENT ADD FOREIGN KEY (ARTICLE_ID) REFERENCES ARTICLE (ID);
ALTER TABLE ARTICLECOMMENT ADD FOREIGN KEY (MEMBER_ID) REFERENCES MEMBER (ID);
CREATE INDEX FK_ATSU0CSTQXORIS7YCDG34FSWN_INDEX_1 ON ARTICLECOMMENT (MEMBER_ID);
CREATE INDEX FK_AVS081D85MIEX4N67V7C5S8CW_INDEX_1 ON ARTICLECOMMENT (ARTICLE_ID);
ALTER TABLE MEMBER_EVENT ADD FOREIGN KEY (EVENTS_ID) REFERENCES EVENT (ID);
ALTER TABLE MEMBER_EVENT ADD FOREIGN KEY (MEMBER_ID) REFERENCES MEMBER (ID);
CREATE INDEX FK_JRP4A4XBP5F1104QCU4RU7WHL_INDEX_B ON MEMBER_EVENT (EVENTS_ID);
ALTER TABLE MEMBER_INTEREST ADD FOREIGN KEY (INTERESTS_NAME) REFERENCES INTEREST (NAME);
ALTER TABLE MEMBER_INTEREST ADD FOREIGN KEY (MEMBER_ID) REFERENCES MEMBER (ID);
CREATE INDEX FK_S1VKU5CHUXOD57D3X700OASQV_INDEX_5 ON MEMBER_INTEREST (INTERESTS_NAME);
ALTER TABLE SESSION ADD FOREIGN KEY (EVENT_ID) REFERENCES EVENT (ID);
CREATE INDEX FK_57X1HYKABJNYXHBTRXBUD3SFY_INDEX_A ON SESSION (EVENT_ID);
ALTER TABLE SESSIONCOMMENT ADD FOREIGN KEY (MEMBER_ID) REFERENCES MEMBER (ID);
ALTER TABLE SESSIONCOMMENT ADD FOREIGN KEY (SESSION_ID) REFERENCES SESSION (ID);
CREATE INDEX FK_DO57TL76PDOYNECXJ0KT1LRG6_INDEX_B ON SESSIONCOMMENT (SESSION_ID);
CREATE INDEX FK_FE7JMD8XPVHCQWGJ9JY5IT15N_INDEX_B ON SESSIONCOMMENT (MEMBER_ID);
ALTER TABLE SESSION_INTEREST ADD FOREIGN KEY (INTERESTS_NAME) REFERENCES INTEREST (NAME);
ALTER TABLE SESSION_INTEREST ADD FOREIGN KEY (SESSION_ID) REFERENCES SESSION (ID);
CREATE INDEX FK_SFT1JGIN7E4O0X558JPYUR1MA_INDEX_D ON SESSION_INTEREST (INTERESTS_NAME);
ALTER TABLE SESSION_MEMBER ADD FOREIGN KEY (SPEAKERS_ID) REFERENCES MEMBER (ID);
ALTER TABLE SESSION_MEMBER ADD FOREIGN KEY (SESSIONS_ID) REFERENCES SESSION (ID);
CREATE INDEX FK_1HW59BB9NJR35MBFY8HNSL4P9_INDEX_8 ON SESSION_MEMBER (SPEAKERS_ID);
ALTER TABLE SHAREDLINK ADD FOREIGN KEY (MEMBER_ID) REFERENCES MEMBER (ID);
CREATE INDEX FK_JMWRLMEQKS9K6YLWM3L9OS4OW_INDEX_B ON SHAREDLINK (MEMBER_ID);
ALTER TABLE VOTE ADD FOREIGN KEY (MEMBER_ID) REFERENCES MEMBER (ID);
ALTER TABLE VOTE ADD FOREIGN KEY (SESSION_ID) REFERENCES SESSION (ID);
CREATE INDEX FK_2C2FFF78WIGPLG6SSA2JVCVPA_INDEX_2 ON VOTE (MEMBER_ID);
CREATE INDEX FK_J9FXUBHACYP33YOVI4RJ6QF8O_INDEX_2 ON VOTE (SESSION_ID);
