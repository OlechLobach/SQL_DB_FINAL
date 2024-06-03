CREATE DATABASE AnimeGameDB;
GO

USE AnimeGameDB;
GO

-- Таблиця для студій-розробників
CREATE TABLE Studios (
    StudioID INT PRIMARY KEY IDENTITY,
    StudioName NVARCHAR(100) NOT NULL CHECK (StudioName != ''),
    FoundedDate DATE NOT NULL CHECK (FoundedDate >= '1900-01-01')
);
GO

-- Таблиця для ігор
CREATE TABLE Games (
    GameID INT PRIMARY KEY IDENTITY,
    Title NVARCHAR(100) NOT NULL CHECK (Title != ''),
    StudioID INT NOT NULL,
    ReleaseDate DATE NOT NULL CHECK (ReleaseDate >= '1980-01-01'),
    Genre NVARCHAR(50) NOT NULL CHECK (Genre != ''),
    Price DECIMAL(10, 2) NOT NULL CHECK (Price >= 0)
);
GO

-- Таблиця для платформ
CREATE TABLE Platforms (
    PlatformID INT PRIMARY KEY IDENTITY,
    PlatformName NVARCHAR(100) NOT NULL CHECK (PlatformName != '')
);
GO

-- Таблиця для користувачів
CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY,
    UserName NVARCHAR(100) NOT NULL CHECK (UserName != ''),
    Email NVARCHAR(100) NOT NULL CHECK (Email LIKE '%@%'),
    RegistrationDate DATE NOT NULL CHECK (RegistrationDate >= '2000-01-01')
);
GO

-- Таблиця для персонажів
CREATE TABLE Characters (
    CharacterID INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(100) NOT NULL CHECK (Name != ''),
    Role NVARCHAR(50) NOT NULL CHECK (Role != ''),
    GameID INT NOT NULL
);
GO

-- Таблиця для відгуків
CREATE TABLE Reviews (
    ReviewID INT PRIMARY KEY IDENTITY,
    UserID INT NOT NULL,
    GameID INT NOT NULL,
    ReviewText NVARCHAR(MAX) NOT NULL CHECK (LEN(ReviewText) > 10),
    Rating INT NOT NULL CHECK (Rating BETWEEN 1 AND 10),
    ReviewDate DATE NOT NULL CHECK (ReviewDate >= '2000-01-01')
);
GO

-- Зв'язок між іграми та платформами
CREATE TABLE GamePlatforms (
    GameID INT NOT NULL,
    PlatformID INT NOT NULL,
    PRIMARY KEY (GameID, PlatformID)
);
GO

-- Зв'язок між іграми та персонажами
CREATE TABLE GameCharacters (
    GameID INT NOT NULL,
    CharacterID INT NOT NULL,
    PRIMARY KEY (GameID, CharacterID)
);
GO

-- Таблиця для навичок персонажів
CREATE TABLE CharacterSkills (
    SkillID INT PRIMARY KEY IDENTITY,
    CharacterID INT NOT NULL,
    SkillName NVARCHAR(100) NOT NULL CHECK (SkillName != ''),
    SkillLevel INT NOT NULL CHECK (SkillLevel BETWEEN 1 AND 100)
);
GO

-- Таблиця для улюблених ігор користувачів
CREATE TABLE UserFavorites (
    UserID INT NOT NULL,
    GameID INT NOT NULL,
    PRIMARY KEY (UserID, GameID)
);
GO

-- Таблиця для архівування видалених ігор
CREATE TABLE ArchiveGames (
    ArchiveGameID INT PRIMARY KEY IDENTITY,
    GameID INT,
    Title NVARCHAR(100),
    StudioID INT,
    ReleaseDate DATE,
    Genre NVARCHAR(50),
    Price DECIMAL(10, 2)
);
GO

-- Додавання зовнішніх ключів

ALTER TABLE Games
ADD CONSTRAINT FK_Games_Studios FOREIGN KEY (StudioID) REFERENCES Studios(StudioID);
GO

ALTER TABLE Characters
ADD CONSTRAINT FK_Characters_Games FOREIGN KEY (GameID) REFERENCES Games(GameID);
GO

ALTER TABLE Reviews
ADD CONSTRAINT FK_Reviews_Users FOREIGN KEY (UserID) REFERENCES Users(UserID),
    CONSTRAINT FK_Reviews_Games FOREIGN KEY (GameID) REFERENCES Games(GameID);
GO

ALTER TABLE GamePlatforms
ADD CONSTRAINT FK_GamePlatforms_Games FOREIGN KEY (GameID) REFERENCES Games(GameID),
    CONSTRAINT FK_GamePlatforms_Platforms FOREIGN KEY (PlatformID) REFERENCES Platforms(PlatformID);
GO

ALTER TABLE GameCharacters
ADD CONSTRAINT FK_GameCharacters_Games FOREIGN KEY (GameID) REFERENCES Games(GameID),
    CONSTRAINT FK_GameCharacters_Characters FOREIGN KEY (CharacterID) REFERENCES Characters(CharacterID);
GO

ALTER TABLE CharacterSkills
ADD CONSTRAINT FK_CharacterSkills_Characters FOREIGN KEY (CharacterID) REFERENCES Characters(CharacterID);
GO

ALTER TABLE UserFavorites
ADD CONSTRAINT FK_UserFavorites_Users FOREIGN KEY (UserID) REFERENCES Users(UserID),
    CONSTRAINT FK_UserFavorites_Games FOREIGN KEY (GameID) REFERENCES Games(GameID);
GO

-- Тригери

-- Тригер на вставку нової гри для логування
CREATE TRIGGER trg_InsertGame
ON Games
AFTER INSERT
AS
BEGIN
    PRINT 'New game has been added.';
END;
GO

-- Тригер на видалення гри для архівації
CREATE TRIGGER trg_DeleteGame
ON Games
INSTEAD OF DELETE
AS
BEGIN
    INSERT INTO ArchiveGames (GameID, Title, StudioID, ReleaseDate, Genre, Price)
    SELECT GameID, Title, StudioID, ReleaseDate, Genre, Price
    FROM deleted;
    DELETE FROM Games WHERE GameID IN (SELECT GameID FROM deleted);
END;
GO

-- Тригер на оновлення ціни гри для логування
CREATE TRIGGER trg_UpdateGamePrice
ON Games
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Price)
    BEGIN
        PRINT 'Game price has been updated.';
    END;
END;
GO

-- Тригер на вставку нового відгуку для логування
CREATE TRIGGER trg_InsertReview
ON Reviews
AFTER INSERT
AS
BEGIN
    PRINT 'New review has been added.';
END;
GO

-- Тригер на оновлення рейтингу відгуку для логування
CREATE TRIGGER trg_UpdateReviewRating
ON Reviews
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Rating)
    BEGIN
        PRINT 'Review rating has been updated.';
    END;
END;
GO

-- Тригер на видалення користувача для логування
CREATE TRIGGER trg_DeleteUser
ON Users
INSTEAD OF DELETE
AS
BEGIN
    PRINT 'User deletion attempted.';
END;
GO

-- Тригер на вставку нової платформи для логування
CREATE TRIGGER trg_InsertPlatform
ON Platforms
AFTER INSERT
AS
BEGIN
    PRINT 'New platform has been added.';
END;
GO

-- Тригер на оновлення навичок персонажа для логування
CREATE TRIGGER trg_UpdateCharacterSkill
ON CharacterSkills
AFTER UPDATE
AS
BEGIN
    PRINT 'Character skill has been updated.';
END;
GO

-- Тригер на видалення персонажа для логування
CREATE TRIGGER trg_DeleteCharacter
ON Characters
INSTEAD OF DELETE
AS
BEGIN
    PRINT 'Character deletion attempted.';
END;
GO

-- Тригер на оновлення інформації про користувача для логування
CREATE TRIGGER trg_UpdateUserInfo
ON Users
AFTER UPDATE
AS
BEGIN
    PRINT 'User information has been updated.';
END;
GO

-- Процедури

-- Процедура додавання нової гри
CREATE PROCEDURE AddNewGame
    @Title NVARCHAR(100),
    @StudioID INT,
    @ReleaseDate DATE,
    @Genre NVARCHAR(50),
    @Price DECIMAL(10, 2)
AS
BEGIN
    INSERT INTO Games (Title, StudioID, ReleaseDate, Genre, Price)
    VALUES (@Title, @StudioID, @ReleaseDate, @Genre, @Price);
END;
GO

-- Процедура додавання нового користувача
CREATE PROCEDURE AddNewUser
    @UserName NVARCHAR(100),
    @Email NVARCHAR(100),
    @RegistrationDate DATE
AS
BEGIN
    INSERT INTO Users (UserName, Email, RegistrationDate)
    VALUES (@UserName, @Email, @RegistrationDate);
END;
GO

-- Процедура додавання нового персонажа
CREATE PROCEDURE AddNewCharacter
    @Name NVARCHAR(100),
    @Role NVARCHAR(50),
    @GameID INT
AS
BEGIN
    INSERT INTO Characters (Name, Role, GameID)
    VALUES (@Name, @Role, @GameID);
END;
GO

-- Процедура додавання нової платформи
CREATE PROCEDURE AddNewPlatform
    @PlatformName NVARCHAR(100)
AS
BEGIN
    INSERT INTO Platforms (PlatformName)
    VALUES (@PlatformName);
END;
GO

-- Процедура додавання нового відгуку
CREATE PROCEDURE AddNewReview
    @UserID INT,
    @GameID INT,
    @ReviewText NVARCHAR(MAX),
    @Rating INT,
    @ReviewDate DATE
AS
BEGIN
    INSERT INTO Reviews (UserID, GameID, ReviewText, Rating, ReviewDate)
    VALUES (@UserID, @GameID, @ReviewText, @Rating, @ReviewDate);
END;
GO

-- Процедура оновлення ціни гри
CREATE PROCEDURE UpdateGamePrice
    @GameID INT,
    @NewPrice DECIMAL(10, 2)
AS
BEGIN
    UPDATE Games
    SET Price = @NewPrice
    WHERE GameID = @GameID;
END;
GO

-- Процедура оновлення рейтингу відгуку
CREATE PROCEDURE UpdateReviewRating
    @ReviewID INT,
    @NewRating INT
AS
BEGIN
    UPDATE Reviews
    SET Rating = @NewRating
    WHERE ReviewID = @ReviewID;
END;
GO

-- Процедура видалення гри
CREATE PROCEDURE DeleteGame
    @GameID INT
AS
BEGIN
    DELETE FROM Games
    WHERE GameID = @GameID;
END;
GO

-- Процедура отримання всіх ігор
CREATE PROCEDURE GetAllGames
AS
BEGIN
    SELECT * FROM Games;
END;
GO

-- Процедура отримання всіх персонажів
CREATE PROCEDURE GetAllCharacters
AS
BEGIN
    SELECT * FROM Characters;
END;
GO

-- Процедура отримання всіх студій
CREATE PROCEDURE GetAllStudios
AS
BEGIN
    SELECT * FROM Studios;
END;
GO

-- Процедура отримання всіх платформ
CREATE PROCEDURE GetAllPlatforms
AS
BEGIN
    SELECT * FROM Platforms;
END;
GO

-- Процедура отримання всіх користувачів
CREATE PROCEDURE GetAllUsers
AS
BEGIN
    SELECT * FROM Users;
END;
GO

-- Процедура отримання всіх відгуків
CREATE PROCEDURE GetAllReviews
AS
BEGIN
    SELECT * FROM Reviews;
END;
GO

-- Процедура отримання всіх навичок персонажів
CREATE PROCEDURE GetAllCharacterSkills
AS
BEGIN
    SELECT * FROM CharacterSkills;
END;
GO

-- Процедура отримання улюблених ігор користувачів
CREATE PROCEDURE GetAllUserFavorites
AS
BEGIN
    SELECT * FROM UserFavorites;
END;