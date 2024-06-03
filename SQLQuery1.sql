USE AnimeGameDB;
GO

-- Вибірка всіх ігор
SELECT * FROM Games;

-- Вибірка всіх персонажів
SELECT * FROM Characters;

-- Вибірка всіх студій
SELECT * FROM Studios;

-- Вибірка всіх платформ
SELECT * FROM Platforms;

-- Вибірка всіх користувачів
SELECT * FROM Users;

-- Вибірка всіх відгуків
SELECT * FROM Reviews;

-- Вибірка всіх навичок персонажів
SELECT * FROM CharacterSkills;

-- Вибірка всіх улюблених ігор користувачів
SELECT * FROM UserFavorites;

-- Вибірка всіх ігор на конкретній платформі (наприклад, 'PC')
SELECT g.Title, p.PlatformName
FROM Games g
JOIN GamePlatforms gp ON g.GameID = gp.GameID
JOIN Platforms p ON gp.PlatformID = p.PlatformID
WHERE p.PlatformName = 'PC';

-- Вибірка всіх персонажів з певної гри (наприклад, 'Spirited Away')
SELECT c.Name, c.Role, g.Title
FROM Characters c
JOIN Games g ON c.GameID = g.GameID
WHERE g.Title = 'Spirited Away';

-- Вибірка відгуків користувача (наприклад, 'JohnDoe')
SELECT u.UserName, r.ReviewText, r.Rating, g.Title
FROM Reviews r
JOIN Users u ON r.UserID = u.UserID
JOIN Games g ON r.GameID = g.GameID
WHERE u.UserName = 'JohnDoe';

-- Вибірка всіх ігор та їхніх розробників
SELECT g.Title, s.StudioName
FROM Games g
JOIN Studios s ON g.StudioID = s.StudioID;