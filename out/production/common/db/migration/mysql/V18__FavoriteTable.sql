CREATE TABLE Favorite
(
    ID BIGINT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    SESSION_ID BIGINT NOT NULL,
    MEMBER_ID BIGINT NOT NULL
);

ALTER TABLE Favorite ADD FOREIGN KEY (SESSION_ID) REFERENCES Session (ID);
ALTER TABLE Favorite ADD FOREIGN KEY (MEMBER_ID) REFERENCES Member (ID);