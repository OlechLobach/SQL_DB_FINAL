USE AnimeGameDB;
GO

-- ������ ��� ����
SELECT * FROM Games;

-- ������ ��� ���������
SELECT * FROM Characters;

-- ������ ��� �����
SELECT * FROM Studios;

-- ������ ��� ��������
SELECT * FROM Platforms;

-- ������ ��� ������������
SELECT * FROM Users;

-- ������ ��� ������
SELECT * FROM Reviews;

-- ������ ��� ������� ���������
SELECT * FROM CharacterSkills;

-- ������ ��� ��������� ���� ������������
SELECT * FROM UserFavorites;

-- ������ ��� ���� �� ��������� �������� (���������, 'PC')
SELECT g.Title, p.PlatformName
FROM Games g
JOIN GamePlatforms gp ON g.GameID = gp.GameID
JOIN Platforms p ON gp.PlatformID = p.PlatformID
WHERE p.PlatformName = 'PC';

-- ������ ��� ��������� � ����� ��� (���������, 'Spirited Away')
SELECT c.Name, c.Role, g.Title
FROM Characters c
JOIN Games g ON c.GameID = g.GameID
WHERE g.Title = 'Spirited Away';

-- ������ ������ ����������� (���������, 'JohnDoe')
SELECT u.UserName, r.ReviewText, r.Rating, g.Title
FROM Reviews r
JOIN Users u ON r.UserID = u.UserID
JOIN Games g ON r.GameID = g.GameID
WHERE u.UserName = 'JohnDoe';

-- ������ ��� ���� �� ���� ����������
SELECT g.Title, s.StudioName
FROM Games g
JOIN Studios s ON g.StudioID = s.StudioID;