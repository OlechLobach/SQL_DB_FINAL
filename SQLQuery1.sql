USE AnimeGameDB;
GO

-- ������� ����� � ������� �����
INSERT INTO Studios (StudioName, FoundedDate) VALUES ('Studio Ghibli', '1985-06-15');
INSERT INTO Studios (StudioName, FoundedDate) VALUES ('Square Enix', '1986-09-22');

-- ������� ����� � ������� ��������
INSERT INTO Platforms (PlatformName) VALUES ('PC');
INSERT INTO Platforms (PlatformName) VALUES ('PlayStation 4');
INSERT INTO Platforms (PlatformName) VALUES ('Xbox One');

-- ������� ����� � ������� ������������
INSERT INTO Users (UserName, Email, RegistrationDate) VALUES ('JohnDoe', 'john@example.com', '2020-01-01');
INSERT INTO Users (UserName, Email, RegistrationDate) VALUES ('JaneSmith', 'jane@example.com', '2021-05-15');

-- ������� ����� � ������� ����
INSERT INTO Games (Title, StudioID, ReleaseDate, Genre, Price) VALUES ('Final Fantasy VII', 2, '1997-01-31', 'RPG', 59.99);
INSERT INTO Games (Title, StudioID, ReleaseDate, Genre, Price) VALUES ('Spirited Away', 1, '2001-07-20', 'Adventure', 49.99);

-- ������� ����� � ������� ���������
INSERT INTO Characters (Name, Role, GameID) VALUES ('Cloud Strife', 'Hero', 1);
INSERT INTO Characters (Name, Role, GameID) VALUES ('Chihiro Ogino', 'Protagonist', 2);

-- ������� ����� � ������� ������
INSERT INTO Reviews (UserID, GameID, ReviewText, Rating, ReviewDate) VALUES (1, 1, 'Amazing game!', 10, '2021-06-01');
INSERT INTO Reviews (UserID, GameID, ReviewText, Rating, ReviewDate) VALUES (2, 2, 'A beautiful story.', 9, '2021-07-15');

-- ������� ����� � ������� ������� ���������
INSERT INTO CharacterSkills (CharacterID, SkillName, SkillLevel) VALUES (1, 'Sword Fighting', 95);
INSERT INTO CharacterSkills (CharacterID, SkillName, SkillLevel) VALUES (2, 'Magic', 80);

-- ������� ����� � ������� ��������� ���� ������������
INSERT INTO UserFavorites (UserID, GameID) VALUES (1, 1);
INSERT INTO UserFavorites (UserID, GameID) VALUES (2, 2);

-- ��'���� �� ������ �� �����������
INSERT INTO GamePlatforms (GameID, PlatformID) VALUES (1, 1);
INSERT INTO GamePlatforms (GameID, PlatformID) VALUES (2, 2);

-- ��'���� �� ������ �� �����������
INSERT INTO GameCharacters (GameID, CharacterID) VALUES (1, 1);
INSERT INTO GameCharacters (GameID, CharacterID) VALUES (2, 2);