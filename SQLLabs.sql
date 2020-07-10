------------------------------------------------------------------
--EXERCISE 1. CREATE DATABASE
------------------------------------------------------------------
--EXERCISE 2. Create Tables

CREATE TABLE Clients(
	Id INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(50) NOT NULL,
	LastName NVARCHAR(50) NOT NULL
)

CREATE TABLE AccountType(
id INT PRIMARY KEY IDENTITY(1,1),
[NAME] NVARCHAR(50) NOT NULL

)

CREATE TABLE Accounts(
id INT PRIMARY KEY IDENTITY(1,1),
AccountTypeId INT FOREIGN KEY REFERENCES AccountType(id),
Balance DECIMAL(15,2) NOT NULL DEFAULT(0),
Clientsid INT FOREIGN KEY REFERENCES Clients(id),
)
----------------------------------------------------------------------
--EXERCISE 3 .Insert Example Data into our Database

  INSERT INTO Clients(FIRSTNAME,LASTNAME) VALUES
 ('Greata','Andersson'),
 ('Peter','Pettersson'),
 ('Mel','Gibson'),
 ('Maria','Danielsson')
 
 INSERT INTO AccountType(NAME) VALUES
 ('Checking'),
 ('Savings')

 INSERT INTO Accounts(Clientsid,AccountTypeId,Balance) VALUES	
 (1,1,175),
 (2,1,275.56),
 (3,1,138.01),
 (4,1,40.30),
 (4,2,375.50)

  --SELECT * FROM AccountType
------------------------------------------------------------------------
--EXERCISE 4 Create a simple View
 
 CREATE VIEW v_ClientBalances AS
 SELECT(FIRSTNAME +' '+LASTNAME) AS [NAME],
 (AccountType.NAME) AS [AccountType],Balance
 FROM Clients
 JOIN Accounts ON Clients.id = Accounts.Clientsid
 JOIN Accounts ON AccountType.id=Accounts.AccountTypeId

 SELECT * FROM v_ClientBalance
 -------------------------------------------------------------------------
 --EXERCISE 5 Create a Function

 CREATE FUNCTION f_CalculateTotalBalance(@ClientID INT)
RETURNS DECIMAL(15,2)
BEGIN
    DECLARE @result AS DECIMAL(15,2)=(
	SELECT SUM (Balance)
	FROM Accounts WHERE ClientsId=@ClientID
	)
	RETURN @result
END

SELECT dbo.f_CalculateTotalBalance(2) AS Balance
---------------------------------------------------------------------------
 --EXERCISE 6 Create procedure

 CREATE PROC p_AddAccount @ClientsID INT, @AccountTypeId INT AS
INSERT INTO Accounts(ClientsId,AccountTypeId)
VALUES(@ClientsID,@AccountTypeId)

p_AddAccount 4,1

SELECT * FROM Accounts

--Deposit procedure

CREATE PROC p_Deposit @AccountId INT, @Amount DECIMAL(15, 2) AS
UPDATE Accounts
SET Balance += @Amount
WHERE Id = @AccountId


--p_Deposit 7,100

--Withdarw procedure

CREATE PROC p_Withdraw @AccountId INT, @Amount DECIMAL(15, 2)AS
BEGIN
	DECLARE @OldBalance DECIMAL(15, 2)
	SELECT @OldBalance = Balance FROM Accounts WHERE Id = @AccountId
	IF (@OldBalance - @Amount >= 0)
	BEGIN
		UPDATE Accounts
		SET Balance -= @Amount
		WHERE Id = @AccountId

	END
	ELSE
	BEGIN
		RAISERROR('Insufficient funds', 10, 1)
	END
END


--p_Withdraw 7,10
---------------------------------------------------------------------------
--Exercise 7 Create TransactionsTableand a Trigger

CREATE TABLE Transactions(
	Id INT PRIMARY KEY IDENTITY,
	AccountId INT FOREIGN KEY REFERENCES Accounts(Id),
	Oldbalance DECIMAL (15,2) NOT NULL,
	Newbalance DECIMAL (15,2) NOT NULL,
	Amount AS Newbalance - Oldbalance,
	[DATETIME] DATETIME2

)

CREATE TRIGGER tr_Transaction ON Accounts
AFTER UPDATE
AS
	INSERT INTO Transactions(AccountId, Oldbalance, Newbalance, [DateTime])
	SELECT inserted.Id, deleted.Balance, inserted.Balance,GETDATE()FROM inserted
	JOIN deleted ON inserted.Id = deleted.Id

p_Deposit 1,25.00
GO

p_Deposit 1,40.00
GO

p_Withdraw 2,200.00
GO

p_Deposit 4,180.00
GO


SELECT * FROM Transactions



