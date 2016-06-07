CREATE TABLE Proposal
(
    ID BIGINT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    ADDEDAT TIMESTAMP,
    DESCRIPTION CLOB,
    FEEDBACK BOOLEAN  NOT NULL,
    VALID BOOLEAN NOT NULL,
    FORMAT VARCHAR(255),
    CATEGORY VARCHAR(255),
    GUEST BOOLEAN  NOT NULL,
    IDEAFORNOW CLOB,
    LANG VARCHAR(2),
    LEVEL VARCHAR(255),
    MAXATTENDEES INTEGER,
    MESSAGEFORSTAFF CLOB,
    STATUS VARCHAR(15) NOT NULL,
    SUMMARY VARCHAR(300),
    TITLE VARCHAR(100),
    EVENT_ID BIGINT
);
CREATE TABLE ProposalComment
(
    ID BIGINT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    CONTENT CLOB NOT NULL,
    POSTEDAT TIMESTAMP NOT NULL,
    PRIVATE BOOLEAN,
    MEMBER_ID BIGINT NOT NULL,
    PROPOSAL_ID BIGINT NOT NULL
);
CREATE TABLE Proposal_Interest
(
    PROPOSAL_ID BIGINT NOT NULL,
    INTERESTS_ID BIGINT NOT NULL,
    PRIMARY KEY (PROPOSAL_ID, INTERESTS_ID)
);
CREATE TABLE Proposal_Member
(
    PROPOSALS_ID BIGINT NOT NULL,
    SPEAKERS_ID BIGINT NOT NULL,
    PRIMARY KEY (PROPOSALS_ID, SPEAKERS_ID)
);

ALTER TABLE Proposal ADD FOREIGN KEY (EVENT_ID) REFERENCES Event (ID);
CREATE INDEX FK_57X1HYKABJNYXHBTPROPOSAL ON Proposal (EVENT_ID);
ALTER TABLE ProposalComment ADD FOREIGN KEY (MEMBER_ID) REFERENCES Member (ID);
ALTER TABLE ProposalComment ADD FOREIGN KEY (PROPOSAL_ID) REFERENCES Proposal (ID);
CREATE INDEX FK_DO57TL76PROPOSAL ON ProposalComment (PROPOSAL_ID);
CREATE INDEX FK_FE7JMD8XPVHCPROPOSAL ON ProposalComment (MEMBER_ID);
ALTER TABLE Proposal_Interest ADD FOREIGN KEY (INTERESTS_ID) REFERENCES Interest (ID);
ALTER TABLE Proposal_Interest ADD FOREIGN KEY (PROPOSAL_ID) REFERENCES Proposal (ID);
CREATE INDEX FK_SFT1JGIN7E4O0XPROPOSAL ON Proposal_Interest (INTERESTS_ID);
ALTER TABLE Proposal_Member ADD FOREIGN KEY (SPEAKERS_ID) REFERENCES Member (ID);
ALTER TABLE Proposal_Member ADD FOREIGN KEY (PROPOSALS_ID) REFERENCES Proposal (ID);
CREATE INDEX FK_1HW59BB9NJR35MPROPOSAL ON Proposal_Member (SPEAKERS_ID);
