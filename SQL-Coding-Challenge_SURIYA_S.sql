--1. Provide a SQL script that initializes the database for the Pet Adoption Platform ”PetPals”. 
create database Petpals_database;

use database Petpals_database;

--2. Create tables for pets, shelters, donations, adoption events, and participants and define appropriate primary keys, foreign keys, and constraints
-- Table: Pets
CREATE TABLE Pets (
Pet_ID INT PRIMARY KEY IDENTITY(1,1),  
Name VARCHAR(100) NOT NULL,          
Age INT NOT NULL,               
Breed VARCHAR(100),                
Type VARCHAR(50) NOT NULL,           
AvailableForAdoption BIT NOT NULL   
);

--inputs: pets table
INSERT INTO Pets (Name, Age, Breed, Type, AvailableForAdoption)
VALUES
('Max', 3, 'Labrador', 'Dog', 1),
('Bella', 2, 'Persian', 'Cat', 1),
('Charlie', 5, 'Beagle', 'Dog', 0),
('Daisy', 1, 'Shih Tzu', 'Dog', 1),
('Luna', 4, 'Siberian', 'Cat', 1),
('Rocky', 6, 'German Shepherd', 'Dog', 0),
('Simba', 3, 'Bengal', 'Cat', 1),
('Milo', 2, 'Golden Retriever', 'Dog', 1),
('Coco', 7, 'Poodle', 'Dog', 0),
('Oreo', 1, 'Sphynx', 'Cat', 1);


-- Table: Shelters
CREATE TABLE Shelters (
Shelter_ID INT PRIMARY KEY IDENTITY(1,1), 
Name VARCHAR(100) NOT NULL,             
Location VARCHAR(255)                 
);

--inputs: shelters
INSERT INTO Shelters (Name, Location)
VALUES
('Chennai Pet Shelter', 'Chennai'),
('Coimbatore Animal Care', 'Coimbatore'),
('Madurai Animal Home', 'Madurai'),
('Salem Stray Aid', 'Salem'),
('Tirunelveli Pet Haven', 'Tirunelveli'),
('Trichy Pet Protection', 'Tiruchirappalli'),
('Vellore Animal Welfare', 'Vellore'),
('Erode Rescue Center', 'Erode'),
('Nagercoil Stray Support', 'Nagercoil'),
('Thoothukudi Pet Home', 'Thoothukudi');


-- Table: Donations
CREATE TABLE Donations (
Donation_ID INT PRIMARY KEY IDENTITY(1,1), 
Donor_Name VARCHAR(100) NOT NULL,    
Donation_Type VARCHAR(50) NOT NULL,   
Donation_Amount DECIMAL(10, 2),    
Donation_Item VARCHAR(100),          
Donation_Date DATETIME NOT NULL   
);

--inputs: donation
INSERT INTO Donations (Donor_Name, Donation_Type, Donation_Amount, Donation_Item, Donation_Date)
VALUES
('Vijay', 'Cash', 5000.00, NULL, '2024-01-10'),
('Priya', 'Item', NULL, 'Dog Food', '2024-02-15'),
('Ravi', 'Cash', 3000.00, NULL, '2024-03-20'),
('Deepa', 'Item', NULL, 'Cat Toys', '2024-03-25'),
('Suresh', 'Cash', 2000.00, NULL, '2024-04-10'),
('Anitha', 'Item', NULL, 'Leashes', '2024-05-05'),
('Karthik', 'Cash', 1500.00, NULL, '2024-06-20'),
('Rekha', 'Item', NULL, 'Blankets', '2024-07-25'),
('Ramesh', 'Cash', 2500.00, NULL, '2024-08-10'),
('Bala', 'Item', NULL, 'Dog Beds', '2024-09-12');


-- Table: AdoptionEvents
CREATE TABLE AdoptionEvents (
Event_ID INT PRIMARY KEY IDENTITY(1,1), 
Event_Name VARCHAR(100) NOT NULL,
Event_Date DATETIME NOT NULL,   
Location VARCHAR(255) NOT NULL
);

--inputs: Adoption events
INSERT INTO AdoptionEvents (Event_Name, Event_Date, Location)
VALUES
('Chennai Adoption Drive', '2024-01-20', 'Chennai'),
('Summer Pet Rescue', '2024-06-15', 'Coimbatore'),
('Madurai Pet Fest', '2024-09-25', 'Madurai'),
('Salem Winter Adoption', '2024-12-10', 'Salem'),
('Tirunelveli Pet Fair', '2024-11-05', 'Tirunelveli'),
('Chennai Mega Adoption', '2024-03-15', 'Chennai'),
('Trichy Stray Help', '2024-05-25', 'Tiruchirappalli'),
('Vellore Special Event', '2024-07-05', 'Vellore'),
('Thoothukudi Pet Fest', '2024-10-10', 'Thoothukudi'),
('Erode Rescue Fair', '2024-08-25', 'Erode');


-- Table: Participants
CREATE TABLE Participants (
    Participant_ID INT PRIMARY KEY IDENTITY(1,1),
    Participant_Name VARCHAR(100) NOT NULL, 
    Participant_Type VARCHAR(50) NOT NULL, 
    EventID INT,
    CONSTRAINT FK_Participant_Event FOREIGN KEY (EventID) REFERENCES AdoptionEvents(Event_ID)
);

--inputs: Participants
INSERT INTO Participants (Participant_Name, Participant_Type, EventID)
VALUES
('Chennai Pet Shelter', 'Shelter', 1),
('Coimbatore Animal Care', 'Shelter', 2),
('Madurai Animal Home', 'Shelter', 3),
('Salem Stray Aid', 'Shelter', 4),
('Tirunelveli Pet Haven', 'Shelter', 5),
('Karthik', 'Adopter', 1),
('Priya', 'Adopter', 2),
('Ravi', 'Adopter', 3),
('Deepa', 'Adopter', 4),
('Suresh', 'Adopter', 5);



--5. Retrival of available pets for adoption
select Name, Age, Breed, Type
from Pets
where AvailableForAdoption=1;

--6 retrieve participant names and types for a specific adoption event


SELECT P.Participant_Name,
P.Participant_Type,
AE.Event_Name,
AE.Event_Date,
AE.Location
FROM Participants P
INNER JOIN AdoptionEvents AE ON P.EventID = AE.Event_ID
WHERE P.EventID = 2;


--7. Stored procedure to update shelter information in MS SQL
CREATE PROCEDURE UpdateShelterInfo
    @ShelterID INT,
    @NewName VARCHAR(100),
    @NewLocation VARCHAR(255)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Shelters WHERE Shelter_ID = @ShelterID)
    BEGIN
        UPDATE Shelters
        SET Name = @NewName, Location = @NewLocation
        WHERE Shelter_ID = @ShelterID;
    END
    ELSE
    BEGIN
        PRINT 'Shelter ID not found.';
    END
END;
GO


--8. Total donation ammount for each shelter
SELECT 
S.Name AS ShelterName,                              
ISNULL(SUM(D.Donation_Amount), 0) AS TotalDonations 
FROM Shelters S  
LEFT JOIN Donations D ON S.Shelter_ID = D.Donation_ID  
GROUP BY S.Name         
ORDER BY TotalDonations DESC;          

--9. pets without owners
--(since there is no owner column in pets table, i am adding new column named "Owner_ID" in Pets table.
alter table Pets add Owner_ID int;
--(updating sample datas)
UPDATE Pets
SET Owner_ID = CASE 
    WHEN Name = 'Max' THEN 1  -- Rajesh Kumar
    WHEN Name = 'Bella' THEN 2 -- Anita Rao
    WHEN Name = 'Daisy' THEN 1 -- Rajesh Kumar
    WHEN Name = 'Luna' THEN 3  -- Vikram Singh
    WHEN Name = 'Simba' THEN 4  -- Priya Menon
    WHEN Name = 'Milo' THEN 5   -- Suresh Babu
    ELSE NULL -- Keep the others as NULL
END;

--query to retrive pets without owners
-- SQL query to retrieve pets without owners
SELECT Name, Age, Breed, Type               
FROM Pets
WHERE Owner_ID IS NULL;     

--10.
-- Create a CTE for the months
WITH MonthYear AS (
SELECT DATEADD(MONTH, number, '2024-01-01') AS MonthDate
FROM master.dbo.spt_values 
WHERE type = 'P' AND number < DATEDIFF(MONTH, '2024-01-01', GETDATE()) + 1
)
-- Query to get total donations with month-year
SELECT 
FORMAT(M.MonthDate, 'MMMM yyyy') AS MonthYear,
ISNULL(SUM(D.Donation_Amount), 0) AS Total_Donation
FROM MonthYear M
LEFT JOIN Donations D ON FORMAT(D.Donation_Date, 'yyyy-MM') = FORMAT(M.MonthDate, 'yyyy-MM')
GROUP BY M.MonthDate
ORDER BY M.MonthDate;

--11. distinct breeds of pets aged 1-3 or older than 5
SELECT DISTINCT Breed
FROM Pets
WHERE (Age BETWEEN 1 AND 3) OR (Age > 5);

--12. pets and their shelters available for adoption
	--altering the pets table with shelter id
	ALTER TABLE Pets
	ADD Shelter_ID INT
	CONSTRAINT FK_Pets_Shelter
	FOREIGN KEY (Shelter_ID) REFERENCES Shelters(Shelter_ID);


	--updating sample values for shelter id
	UPDATE Pets SET Shelter_ID = 1 WHERE Name IN ('Max', 'Daisy');  
	UPDATE Pets SET Shelter_ID = 2 WHERE Name IN ('Bella', 'Milo');  
	UPDATE Pets SET Shelter_ID = 3 WHERE Name = 'Luna';        
	UPDATE Pets SET Shelter_ID = 4 WHERE Name = 'Simba'; 
	UPDATE Pets SET Shelter_ID = 5 WHERE Name = 'Oreo'; 

	--query for pets and their shelters available for adoption
	SELECT 
	P.Name AS Pet_Name,
	P.Age,
	P.Breed,
	P.Type,
	S.Name AS Shelter_Name,
	S.Location
	FROM Pets P
	JOIN Shelters S ON P.Shelter_ID = S.Shelter_ID
	WHERE P.AvailableForAdoption = 1;  

--13. Total number of participants in events organized by shelters located in specific city
SELECT COUNT(P.Participant_ID) AS Total_Participants
FROM Participants P
JOIN AdoptionEvents AE ON P.EventID = AE.Event_ID
JOIN Shelters S ON AE.Location = S.Location
WHERE S.Location = 'Chennai';

--14.  list of unique breeds for pets with ages between 1 and 5 years. 
SELECT DISTINCT Breed, Age
FROM Pets
WHERE Age BETWEEN 1 AND 5;


--15.  pets that have not been adopted by selecting their information from the 'Pet' table.
SELECT *
FROM Pets
WHERE AvailableForAdoption = 1;

--16. names of all adopted pets along with the adopter's name 
SELECT p.Name AS PetName, par.Participant_Name AS AdopterName
FROM Pets p
JOIN Participants par ON p.Pet_ID = par.EventID
WHERE par.Participant_Type = 'Adopter';

--17. list of all shelters along with the count of pets currently available for adoption
SELECT s.Shelter_ID, s.Name AS ShelterName, COUNT(p.Pet_ID) AS AvailablePetsCount
FROM Shelters s
LEFT JOIN Pets p ON s.Shelter_ID = p.Shelter_ID AND p.AvailableForAdoption = 1
GROUP BY s.Shelter_ID, s.Name;

--18. 
SELECT 
p1.Pet_ID AS Pet1_ID,
p1.Name AS Pet1_Name,
p2.Pet_ID AS Pet2_ID,
p2.Name AS Pet2_Name,
p1.Breed,
s.Name AS Shelter_Name
FROM Pets p1
JOIN Pets p2 ON p1.Breed = p2.Breed AND p1.Pet_ID < p2.Pet_ID 
JOIN Shelters s ON p1.Shelter_ID = s.Shelter_ID
ORDER BY Shelter_Name, Breed;

-- Update Pets to create unique pairs with the same breed in the same shelter
UPDATE Pets
SET 
    Shelter_ID = CASE 
        WHEN Name IN ('Max', 'Bella') THEN 1 
        WHEN Name IN ('Daisy', 'Charlie') THEN 2 
        WHEN Name IN ('Luna', 'Rocky') THEN 3 
        WHEN Name IN ('Simba', 'Milo') THEN 4 
        WHEN Name IN ('Coco', 'Oreo') THEN 5  
        ELSE Shelter_ID  
    END,
    Breed = CASE 
        WHEN Name IN ('Max', 'Bella') THEN 'Labrador' 
        WHEN Name IN ('Daisy', 'Charlie') THEN 'Beagle' 
        WHEN Name IN ('Luna', 'Rocky') THEN 'Siberian'  
        WHEN Name IN ('Simba', 'Milo') THEN 'Bengal'
        WHEN Name IN ('Coco', 'Oreo') THEN 'Poodle'  
        ELSE Breed  
    END,
    AvailableForAdoption = CASE 
        WHEN Name IN ('Max', 'Bella', 'Daisy', 'Charlie', 'Luna', 'Rocky', 'Simba', 'Milo', 'Coco', 'Oreo') THEN 1 
        ELSE 0 
    END 
		WHERE Name IN ('Max', 'Bella', 'Daisy', 'Charlie', 'Luna', 'Rocky', 'Simba', 'Milo', 'Coco', 'Oreo');

--19. List all possible combinations of shelters and adoption events. 

SELECT 
s.Shelter_ID,
s.Name AS Shelter_Name,
ae.Event_ID,
ae.Event_Name,
ae.Event_Date,
ae.Location
FROM Shelters s
CROSS JOIN AdoptionEvents ae
ORDER BY s.Name, ae.Event_Date;

--20.  the shelter that has the highest number of adopted pets. 
SELECT 
s.Shelter_ID,
s.Name AS Shelter_Name,
COUNT(p.Pet_ID) AS Adopted_Pets_Count
FROM Shelters s
LEFT JOIN Pets p ON s.Shelter_ID = p.Shelter_ID
WHERE p.Owner_ID IS NOT NULL
GROUP BY s.Shelter_ID, s.Name
ORDER BY Adopted_Pets_Count DESC
OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY; 
