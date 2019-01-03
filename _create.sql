SPOOL project.out 
SET ECHO ON
/**************************************** 
CIS 353 - Database Design Project 
Team 4
Tyler Anson
Pierce Ortlieb
Ryan Korteway
Charles Dodge
****************************************/
CREATE TABLE Computer 
(
serialNum		INTEGER NOT NULL,
manufacturer	CHAR(15) NOT NULL,
model			CHAR(15) NOT NULL,
processorBrand  CHAR(15) NOT NULL,
osNum			INTEGER NOT NULL,
RAM		     	INTEGER NOT NULL,
MSRP			INTEGER    NOT NULL,
--
-- compIC1: Every computer has and is recognized by its serial number. (KEY)
CONSTRAINT compIC1 PRIMARY KEY (serialNum),
-- compIC2: No computer can be sold for less than $300 when it has 4 GB or more of RAM.
CONSTRAINT compIC2 check( not( RAM >= 4 AND MSRP <= 300)),
-- compIC3: No computer can have less than 2 GB of RAM.
CONSTRAINT compIC3 check (RAM >= 2)
-- compIC4: All computers must have an Operating System from our Operating System Table. Which is added to our table with an alter command after the operating table is created.
-- compIC5: All computers must have a Manufacturer from our Manufacturer Table. Another foreign key added after the creation of the other table.
--
);
---------------------------------------------------------------------------------------------------------------------------
CREATE TABLE  Operating_System
(
osID		INTEGER,		
name 		CHAR(15)  NOT NULL,
versionNum	INTEGER NOT NULL,
bitCount	INTEGER,
--
-- osIC1: Every operating system has to have an assigned OS number for its key.
CONSTRAINT osIC1 PRIMARY KEY (osID)
);
-- Adding the Foreign key constraint to computer for operating system.
ALTER TABLE COMPUTER ADD CONSTRAINT compIC4 FOREIGN KEY (osNum) REFERENCES Operating_System(osID);
---------------------------------------------------------------------------------------------------------------------------
CREATE TABLE  Manufacturer
(
name			CHAR(15),
email			CHAR(18),
customerRating	INTEGER NOT NULL,
phoneNum		INTEGER NOT NULL,
--
-- mIC1: Each manufacturer must have a unique name that it is identified by. 
CONSTRAINT mIC1 PRIMARY KEY (name)
);
-- ADDING THE Foreign key constraint to Computer for manufacturer.
ALTER TABLE COMPUTER ADD CONSTRAINT compIC5 FOREIGN KEY (manufacturer) REFERENCES Manufacturer(name);
---------------------------------------------------------------------------------------------------------------------------
CREATE TABLE  Peripheral
(
modelNum 	INTEGER,
name		CHAR(15) NOT NULL,
type 		CHAR(15) NOT NULL,
--
-- perIC1: Every piece of hardware is identified by its unique model number
CONSTRAINT perIC1 PRIMARY KEY (modelNum)
);
-----------------------------------------------------------------------
CREATE TABLE Customer
(
customerID	INTEGER NOT NULL,
name		CHAR(15),
address 	CHAR(18),
region		CHAR(15) NOT NULL,
phoneNumber	INTEGER,
type		CHAR(15),
--
-- customerIC1: Every customer is identified by their Customer ID
CONSTRAINT customerIC1 PRIMARY KEY (customerID)
); 
-----------------------------------------------------------------------
CREATE TABLE Purchased
(
serialNum	INTEGER NOT NULL,
customerID	INTEGER,
dateSold	DATE,
pmtMethod	CHAR(15),
amount		INTEGER,
--
-- All peripherals are packaged with computers so they have a composite key of their own model -- number and the computer numbers 
CONSTRAINT PurchasedIC1 PRIMARY KEY (serialNum,customerID,dateSold),
-- All computers that have been sold must have been in stock at one point.
CONSTRAINT PurchasedIC2 FOREIGN KEY (serialNum) references Computer(serialNum),
--All computers must be sold to our customers.
CONSTRAINT PurchasedIC3 FOREIGN KEY (CustomerID) references Customer(customerID)
);
------------------------------------------------------------------------
CREATE TABLE Manufacturer_Region
(
name	CHAR(15),
region  CHAR(15),
-- mrC1:The composite key is a composite of a manufacturer's name and a region served.
CONSTRAINT mrIC1 Primary Key (name, region),
--mrIC2: Each region is going to be identified by its manufacturer and its location.
CONSTRAINT locIC2 FOREIGN KEY (name) REFERENCES Manufacturer(name)
				ON DELETE CASCADE
				DEFERRABLE INITIALLY DEFERRED
);
---------------------------------------------------------------------------
CREATE TABLE Computer_Peripherals
(
serialNum               INTEGER,
peripheralModelNumber	INTEGER NOT NULL,
--
--Each computer peripheral in this table must be in the overall table of peripherals.
CONSTRAINT cpIC1 FOREIGN KEY (peripheralModelNumber) REFERENCES PeripheralTable(modelNum),
--Each computer a peripheral is tied with must be in our overall table of computers.
CONSTRAINT cpIC2 FOREIGN KEY (serialNum) REFERENCES Computer(serialNum)
);
----------------------------------------------------------------------------
SET FEEDBACK OFF 
-- --------------------------------------------------------------------
-- POPULATING THE DATABASE INSTANCE
-- --------------------------------------------------------------------
INSERT INTO Computer VALUES (1234, ‘Lenovo’, ‘Think Pad’, ‘Intel’, 0132 , 8, 1400);
INSERT INTO Computer VALUES (1235, ‘Lenovo’, ‘Think Pad’, ‘Intel’, 0732, 4, 900);
INSERT INTO Computer VALUES (1236, ‘Apple’, ‘MacBook Pro’, ‘Intel’, 1010, 8, 2000);
INSERT INTO Computer VALUES (1237, ‘Apple’, ‘MacBook’, ‘Intel’, 1008, 4, 1500);

                
-- --------------------------------------------------------------------
INSERT INTO Operating_System VALUES (0164, ‘Windows’, 64);
INSERT INTO Operating_System VALUES (0132, ‘Windows’, 32);
INSERT INTO Operating_System VALUES (0864, ‘Windows’, 64);
INSERT INTO Operating_System VALUES (0832, ‘Windows’, 32);
INSERT INTO Operating_System VALUES (0764, ‘Windows’, 64);
INSERT INTO Operating_System VALUES (0732, ‘Windows’, 32);
INSERT INTO Operating_System VALUES (1010, ‘El Capitan’, 64);
INSERT INTO Operating_System VALUES (1009, ‘Mavericks’, 64);
INSERT INTO Operating_System VALUES (1008, ‘Mountain Lion’, 64);
INSERT INTO Operating_System VALUES (1007, ‘Lion’, 64);
INSERT INTO Operating_System VALUES (1006, ‘Snow Leopard’, 64);
INSERT INTO Operating_System VALUES (140404, ‘Ubuntu’, 64);
INSERT INTO Operating_System VALUES (140405, ‘Ubuntu’, 32);
-- --------------------------------------------------------------------
INSERT INTO Manufacturer VALUES (‘Apple’, ‘support@apple.com’, 95, 8006927753);
INSERT INTO Manufacturer VALUES (‘Samsung’, ‘support@samsung.com’, 88, 8006927753);
INSERT INTO Manufacturer VALUES (‘Lenovo’, ‘support@lenovo.com’, 92, 8006927753);
INSERT INTO Manufacturer VALUES (‘Dell’, ‘support@dell.com’, 90, 8006927753);
INSERT INTO Manufacturer VALUES (‘HP’, ‘support@hp.com’, 85, 8006927753);
INSERT INTO Manufacturer VALUES (‘Asus’, ‘support@asus.com’, 89, 8006927753);
INSERT INTO Manufacturer VALUES (‘Acer’, ‘support@acer.com’, 83, 8006927753);
INSERT INTO Manufacturer VALUES (‘MSI’, ‘support@msi.com’, 97, 8006927753);
-- --------------------------------------------------------------------
INSERT INTO Peripheral VALUES (9928384, ‘Logitech’, ‘Keyboard’);
INSERT INTO Peripheral VALUES (9928385, ‘Logitech’, ‘Mouse’);
INSERT INTO Peripheral VALUES (9928386, ‘Logitech’, ‘TrackPad’);
INSERT INTO Peripheral VALUES (8847584, ‘Apple’, ‘MagicKeyboard’);
INSERT INTO Peripheral VALUES (8847585, ‘Apple’, ‘MightyMouse’);
INSERT INTO Peripheral VALUES (8847586, ‘Apple’, ‘MagicTrackPad’);

-- --------------------------------------------------------------------
INSERT INTO Customer VALUES (1, ‘Dodge’, ‘1340 Eastern Ave’, 6163086378, ‘Home’);
INSERT INTO Customer VALUES (2, ‘Anson’, ‘847 Cherry Ave’, 2692035582, ‘Other’);
INSERT INTO Customer VALUES (3, ‘Korteway’, ‘2740 Pine Ridge Dr’, 2695322163, ‘Home’);
INSERT INTO Customer VALUES (4, ‘Ortlieb’, ‘137 Manzana Ct’, 2693692940, ‘Home’);
INSERT INTO Customer VALUES (5, ‘Best Buy’, ‘2875 E. Beltline , 8002378289, ‘Business’);
INSERT INTO Customer VALUES (6, ‘Sawyer’, ‘249 Cherry Ave’, 6162035582, ‘Home’);
INSERT INTO Customer VALUES (7, ‘Picard’, ‘8592 Enterprise Dr’, 4400044999, ‘Other’);
INSERT INTO Customer VALUES (8, ‘GVSU’, ‘1 Campus Dr’, 6163315000, ‘School’);

-- --------------------------------------------------------------------
INSERT INTO Purchased VALUES (436213, 1, ‘11/11/2015’, ‘MasterCard’, 1000);
INSERT INTO Purchased VALUES (436214, 1, ‘11/29/2015’, ‘MasterCard’, 800);
INSERT INTO Purchased VALUES (436215, 1, ‘12/04/2015’, ‘MasterCard’, 1300);
INSERT INTO Purchased VALUES (436216, 2, ‘1/11/2016’, ‘AMEX’, 500);
INSERT INTO Purchased VALUES (436217, 3, ‘2/11/2016’, ‘Visa’, 250);
INSERT INTO Purchased VALUES (436218, 3, ‘2/29/2016’, ‘Visa’, 1800);
INSERT INTO Purchased VALUES (436219, 4, ‘3/29/2016’, ‘Discover’, 600);
INSERT INTO Purchased VALUES (436220, 4, ‘4/01/2016’, ‘Discover’, 2000);
-- --------------------------------------------------------------------
-- --------------------------------------------------------------------
SET FEEDBACK ON 
COMMIT
-- next up below this is the queries
-- then the insert, update, delete tests of the IC’s.
-- Now, if no violations were detected, COMMIT all the commands in this file
COMMIT
SPOOL OFF
POOL project.out 
SET ECHO ON
/**************************************** 
CIS 353 - Database Design Project 
Team 4
Tyler Anson
Pierce Ortlieb
Ryan Korteway
Charles Dodge
****************************************/
CREATE TABLE Computer 
(
serialNum		INTEGER NOT NULL,
manufacturer	CHAR(15) NOT NULL,
model			CHAR(15) NOT NULL,
processorBrand  CHAR(15) NOT NULL,
osNun			INTEGER NOT NULL,
RAM		     	INTEGER NOT NULL,
MSRP			INTEGER    NOT NULL,
--
-- compIC1: Every computer has and is recognized by its serial number. (KEY)
CONSTRAINT compIC1 PRIMARY KEY (serialNum),
-- compIC2: No computer can be sold for less than $300 when it has 4 GB or more of RAM.
CONSTRAINT compIC2 check( not( RAM >= 4 AND MSRP <= 300)),
-- compIC3: No computer can have less than 2 GB of RAM.
CONSTRAINT compIC3 check (RAM >= 2),
-- compIC4: All computers must have an Operating System from our Operating System Table.
CONSTRAINT compIC4 FOREIGN KEY (osNum) REFERENCES Operating_System(osID),
-- compIC5: All computers must have a Manufacturer from our Manufacturer Table.
CONSTRAINT compIC5 FOREIGN KEY (manufacturer) REFERENCES Manufacturer(name)
);
---------------------------------------------------------------------------------------------------------------------------
CREATE TABLE  Operating_System
(
osID		INTEGER		
name 		CHAR(15)  NOT NULL,
versionNum	INTEGER NOT NULL,
bitCount	INTEGER,
--
-- osIC1: Every operating system has to have an assigned OS number for its key.
CONSTRAINT osIC1 PRIMARY KEY (osID)
);
---------------------------------------------------------------------------------------------------------------------------
CREATE TABLE  Manufacturer
(
name			CHAR(15),
e-mail			CHAR(18),
customerRating	INTEGER NOT NULL,
phoneNum		INTEGER NOT NULL,
--
-- mIC1: Each manufacturer must have a unique name that it is identified by. 
CONSTRAINT mIC1 PRIMARY KEY (name)
);
---------------------------------------------------------------------------------------------------------------------------
CREATE TABLE  Peripheral
(
modelNum 	INTEGER,
name		CHAR(15) NOT NULL,
type 		CHAR(15) NOT NULL,
--
-- perIC1: Every piece of hardware is identified by its unique model number
CONSTRAINT perIC1 PRIMARY KEY (modelNum)
);
-----------------------------------------------------------------------
CREATE TABLE Customer
(
customerID	INTEGER NOT NULL,
name		CHAR(15),
address 	CHAR(18),
region		CHAR(15) NOT NULL,
phoneNumber	INTEGER,
type		CHAR(15),
--
-- cIC1: Every customer is identified by their Customer ID
CONSTRAINT cIC1 PRIMARY KEY (customerID)
); 
-----------------------------------------------------------------------
CREATE TABLE Purchased
(
serialNum	INTEGER NOT NULL,
CustomerID	INTEGER,
date		DATE,
pmtMethod	CHAR(15),
amount		INTEGER,
--
-- All peripherals are packaged with computers so they have a composite key of their own model -- number and the computer numbers 
CONSTRAINT purIC1 PRIMARY KEY (serialNum,CustomerID,date),
-- All computers that have been sold must have been in stock at one point.
CONSTRAINT purIC2 FOREIGN KEY (serialNum) references Computer(serialNum),
--All computers must be sold to our customers.
CONSTRAINT purIC3 FOREIGN KEY (CustomerID) references Customer(customerID)
);
------------------------------------------------------------------------
CREATE TABLE Manufacturer_Region
(
name	CHAR(15),
region  CHAR(15),
-- mrC1:The composite key is a composite of a manufacturer's name and a region served.
CONSTRAINT mrIC1 Primary Key (name, region),
--mrIC2: Each region is going to be identified by its manufacturer and its location.
CONSTRAINT locIC2 FOREIGN KEY (name) REFERENCES Manufacturer(name)
				ON DELETE CASCADE
				DEFERRABLE INITIALLY DEFERRED
);
---------------------------------------------------------------------------
CREATE TABLE Computer_Peripherals
(
serialNum               INTEGER,
peripheralModelNumber	INTEGER NOT NULL,
--
--Each computer peripheral in this table must be in the overall table of peripherals.
CONSTRAINT cpIC1 FOREIGN KEY (peripheralModelNumber) REFERENCES Peripheral(modelNum),
--Each computer a peripheral is tied with must be in our overall table of computers.
CONSTRAINT cpIC2 FOREIGN KEY (serialNum) REFERENCES Computer(serialNum)
);
----------------------------------------------------------------------------
SET FEEDBACK OFF 
-- --------------------------------------------------------------------
-- POPULATING THE DATABASE INSTANCE
-- --------------------------------------------------------------------
INSERT INTO Computer VALUES (1234, 'Lenovo', 'Think Pad', 'Intel', 0132 , 8, 1400);
INSERT INTO Computer VALUES (1235, 'Lenovo', 'Think Pad', 'Intel', 0732, 4, 900);
INSERT INTO Computer VALUES (1236, 'Apple', 'MacBook Pro', 'Intel', 1010, 8, 2000);
INSERT INTO Computer VALUES (1237, 'Apple', 'MacBook', 'Intel', 1008, 4, 1500);

                
-- --------------------------------------------------------------------
INSERT INTO Operating_System VALUES (0164, 'Windows', 64);
INSERT INTO Operating_System VALUES (0132, 'Windows', 32);
INSERT INTO Operating_System VALUES (0864, 'Windows', 64);
INSERT INTO Operating_System VALUES (0832, 'Windows', 32);
INSERT INTO Operating_System VALUES (0764, 'Windows', 64);
INSERT INTO Operating_System VALUES (0732, 'Windows', 32);
INSERT INTO Operating_System VALUES (1010, 'El Capitan', 64);
INSERT INTO Operating_System VALUES (1009, 'Mavericks', 64);
INSERT INTO Operating_System VALUES (1008, 'Mountain Lion', 64);
INSERT INTO Operating_System VALUES (1007, 'Lion', 64);
INSERT INTO Operating_System VALUES (1006, 'Snow Leopard', 64);
INSERT INTO Operating_System VALUES (140404, 'Ubuntu', 64);
INSERT INTO Operating_System VALUES (140405, 'Ubuntu', 32);
-- --------------------------------------------------------------------
INSERT INTO Manufacturer VALUES ('Apple', 'support@apple.com', 92, 8006927753);
INSERT INTO Manufacturer VALUES ('Samsung', 'support@apple.com', 92, 8006927753);
INSERT INTO Manufacturer VALUES ('Lenovo', 'support@apple.com', 92, 8006927753);
INSERT INTO Manufacturer VALUES ('Dell', 'support@apple.com', 92, 8006927753);
INSERT INTO Manufacturer VALUES ('HP', 'support@apple.com', 92, 8006927753);
INSERT INTO Manufacturer VALUES ('Asus', 'support@apple.com', 92, 8006927753);
INSERT INTO Manufacturer VALUES ('Acer', 'support@apple.com', 92, 8006927753);
INSERT INTO Manufacturer VALUES ('MSI', 'support@apple.com', 92, 8006927753);
-- --------------------------------------------------------------------
INSERT INTO Peripheral VALUES (9928384, 'Logitech', 'Keyboard');
INSERT INTO Peripheral VALUES (9928385, 'Logitech', 'Mouse');
INSERT INTO Peripheral VALUES (9928386, 'Logitech', 'Track Pad');
INSERT INTO Peripheral VALUES (8847584, 'Apple', 'MagicKeyboard');
INSERT INTO Peripheral VALUES (8847585, 'Apple', 'MightyMouse');
INSERT INTO Peripheral VALUES (8847586, 'Apple', 'MagicTrackPad');

-- --------------------------------------------------------------------
INSERT INTO Customer VALUES (1, 'Dodge', '1340 Eastern Ave', 6163086378, 'Home');
INSERT INTO Customer VALUES (2, 'Anson', '847 Cherry Ave', 2692035582, 'Other');
INSERT INTO Customer VALUES (3, 'Korteway', '2740 Pine Ridge Dr', 2695322163, 'Home');
INSERT INTO Customer VALUES (4, 'Ortlieb', '137 Manzana Ct, 2693692940', 'Home');
INSERT INTO Customer VALUES (5, 'Best Buy', '2875 E. Beltline', 8002378289, 'Business');
INSERT INTO Customer VALUES (6, 'Sawyer', '249 Cherry Ave', 6162035582, 'Home');
INSERT INTO Customer VALUES (7, 'Picard', '8592 Enterprise Dr', 4400044999, 'Other');
INSERT INTO Customer VALUES (8, 'GVSU', '1 Campus Dr', 6163315000, 'School');

-- --------------------------------------------------------------------
INSERT INTO Purchased VALUES (436213, 1, '11/11/2015', 'MasterCard', 1000);
INSERT INTO Purchased VALUES (436214, 1, '11/29/2015', 'MasterCard', 800);
INSERT INTO Purchased VALUES (436215, 1, '12/04/2015', 'MasterCard', 1300);
INSERT INTO Purchased VALUES (436216, 2, '11/11/2015', 'AMEX', 500);
INSERT INTO Purchased VALUES (436217, 3, '11/11/2015', 'Visa', 250);
INSERT INTO Purchased VALUES (436218, 3, '11/11/2015', 'Visa', 1800);
INSERT INTO Purchased VALUES (436219, 4, '11/11/2015', 'Discover', 600);
INSERT INTO Purchased VALUES (436220, 4, '11/11/2015', 'Discover', 2000);
-- --------------------------------------------------------------------
-- --------------------------------------------------------------------
SET FEEDBACK ON 
COMMIT
-- next up below this is the queries
-- then the insert, update, delete tests of the IC’s.
-- Now, if no violations were detected, COMMIT all the commands in this file
COMMIT
SPOOL OFF

