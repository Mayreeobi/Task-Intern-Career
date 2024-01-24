-- DATABASE CREATION

-- Drop Database if exists
DROP DATABASE IF EXISTS airlinebooking;

-- Create Database For Airline Online Booking
CREATE DATABASE Airlinebooking
DEFAULT CHARACTER SET utf8mb4;

-- Check if the database was created
SHOW DATABASES;

-- Makes the database active
USE AirlineBooking;
 
 -- TABLES CREATIONS
-- Create Bookings Table
DROP TABLE IF EXISTS Bookings;

CREATE TABLE Bookings (
    Booking_ID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    Trip_Type VARCHAR(255) NOT NULL,
    Booking_Date DATETIME NOT NULL,
    Departure_City VARCHAR(255) NOT NULL,
    Arrival_City VARCHAR(255) NOT NULL,
    Departure_Date DATETIME NOT NULL,
    Arrival_Date DATETIME,
    CONSTRAINT CK_Trip_Type CHECK (Trip_Type IS NOT NULL),
    CONSTRAINT Date_check CHECK (Departure_Date < Arrival_Date) 
);

-- Create Flights Table
DROP TABLE IF EXISTS Flights;

CREATE TABLE Flights (
    Flight_ID VARCHAR(255) NOT NULL PRIMARY KEY,
    Departure_City VARCHAR(255) NOT NULL,
    Arrival_City VARCHAR(255) NOT NULL,
    Departure_Date DATETIME NOT NULL,
    Arrival_Date DATETIME,
    Class VARCHAR(255) NOT NULL,
    Fare DOUBLE NOT NULL,
    CONSTRAINT CK_Departure_City CHECK (Departure_City IS NOT NULL)
);

-- Create Passenger Table 
DROP TABLE IF EXISTS Passenger;

CREATE TABLE Passenger (
	Passenger_ID VARCHAR(255) NOT NULL PRIMARY KEY,
	Name VARCHAR(255) NOT NULL,
    DOB DATE NOT NULL,
    Phone BIGINT NOT NULL,
    Email VARCHAR(255) CHECK (Email LIKE '%_@__%.__%')
);

-- Create Payment Table
DROP TABLE IF EXISTS Payment; 

CREATE TABLE Payment (
    Payment_ID VARCHAR(255) NOT NULL,
    Flight_ID VARCHAR(255) NOT NULL,
    Payment_Date DATETIME NOT NULL,
    Payment_Status CHAR(1) DEFAULT 'N' CHECK (Payment_Status IN ('Y','N')),
    CONSTRAINT Payment_ID_PK PRIMARY KEY (Payment_ID),
    CONSTRAINT Flight_ID_FK FOREIGN KEY (Flight_ID) REFERENCES Flights (Flight_ID)
);

-- Create Ticket Table
DROP TABLE IF EXISTS Ticket;

CREATE TABLE Ticket (
    Ticket_ID VARCHAR(255) NOT NULL PRIMARY KEY,
	Passenger_Name VARCHAR(255),
	Seat_Number VARCHAR(10),
    Booking_ID INT UNSIGNED,
    Payment_ID VARCHAR(255),
	Flight_ID VARCHAR(255),
    CONSTRAINT Booking_ID_FK FOREIGN KEY (Booking_ID) REFERENCES Bookings(Booking_ID),
	CONSTRAINT Payment_ID_FK2 FOREIGN KEY (Payment_ID) REFERENCES Payment(Payment_ID),
    CONSTRAINT Flight_ID_FK3 FOREIGN KEY (Flight_ID) REFERENCES Flights(Flight_ID)
);

-- Check if all tables were created
SELECT *
FROM information_schema.columns
WHERE TABLE_SCHEMA = "airlinebooking";

-- To check if the tables were created and constraints are properly placed
DESCRIBE Bookings;
DESCRIBE Flights;
DESCRIBE Passenger;
DESCRIBE Payment;
DESCRIBE Ticket;
  
  -- INSERTING DATA INTO THE TABLES
 /* 
 The tables are ready and the next step is to insert values into the table with the data for 
 the airline online booking. 
 */
-- INSERTING DATA INTO THE BOOKINGS TABLE
INSERT INTO bookings (booking_id, trip_type, booking_date, departure_city, arrival_city, departure_date, arrival_date) 
 VALUES 
	(1, 'one-way', '2023-11-30 12:00:03', 'Abuja', 'Lagos', '2023-12-20 08:15:10', NULL),
	(2, 'round', '2023-12-06 16:40:25', 'Enugu', 'Port Harcourt', '2023-12-23 12:04:40', '2024-01-04 14:00:10'),
	(3, 'round', '2023-11-20 05:26:30', 'Calabar', 'Abuja', '2023-12-27 16:30:32', '2024-01-03 15:50:25'),
	(4, 'one-way', '2023-12-01 21:10:10', 'Lagos', 'Owerri', '2023-12-27 20:18:55', NULL),
	(5, 'round', '2023-12-30 17:20:12', 'Lagos', 'Enugu', '2023-12-28 12:00:10', '2024-01-05 18:40:04'),
	(6, 'one-way', '2023-12-09 02:20:39', 'Abuja', 'Owerri', '2023-12-28 14:00:00', NULL),
	(7, 'round', '2023-11-20 17:30:39', 'Abuja', 'Kano', '2023-12-29 11:54:13', '2024-01-06 12:37:05'),
	(8, 'one-way', '2023-12-16 22:49:36', 'Lagos', 'Uyo', '2023-12-29 17:39:47', NULL),
	(9, 'one-way', '2023-12-01 10:02:50', 'Abuja', 'Owerri', '2023-12-29 13:39:08',  NULL),
	(10, 'round', '2023-12-18 16:18:55', 'Port Harcourt', 'Lagos', '2023-12-29 19:50:52', '2024-01-09 16:09:48');
	

-- INSERTING DATA INTO THE FLIGHTS TABLE 
INSERT INTO flights (flight_id, departure_city, arrival_city, departure_date, arrival_date, class, fare)
VALUES
	('ABJ051', 'Abuja', 'Lagos', '2023-12-20 08:15:10', NULL,'first', '250500'),
	('ENU040', 'Enugu', 'Port Harcourt', '2023-12-23 12:04:40', '2024-01-04 14:00:10', 'Premium', '360010'),
	('CAL022', 'Calabar', 'Abuja','2023-12-27 16:30:32', '2024-01-03 15:50:25', 'Economy', '259800'),
	('LOS167', 'Lagos', 'Owerri','2023-12-27 20:18:55', NULL, 'Economy Saver', '88900'),
	('LOS159', 'Lagos', 'Enugu', '2023-12-28 12:00:10', '2024-01-05 18:40:04', 'Economy', '313200'),
	('ABJ014', 'Abuja', 'Owerri','2023-12-28 14:00:00', NULL, 'Economy', '181400'),
	('ABJ010', 'Abuja', 'Kano', '2023-12-29 11:54:13', '2024-01-06 12:37:05', 'First', '300200'),
	('LOS108', 'Lagos', 'Uyo','2023-12-29 17:39:47', NULL, 'First', '201000'),
	('ABJ034', 'Abuja', 'Owerri','2023-12-29 13:39:08', NULL, 'Premium', '170600'),
	('PH050', 'Port Harcourt', 'Lagos', '2023-12-29 19:50:52', '2024-01-09 16:09:48', 'Economy Saver', '161500');
    
    
 -- INSERTING DATA INTO THE PASSENGER TABLE 
INSERT INTO passenger (passenger_id, name, DOB, phone, email) 
VALUES 
	('A01', 'Bayo Ade', '1989-10-29', '1234567890','bayoade0@hotmail.com'),
	('BT11', 'Ofure Woji', '1970-05-05', '2745903937', 'woji909@yahoo.com'), 
	('AEP2', 'Akpan Obong', '1984-06-28', '8834567890', 'obongakpan@hotmail.com'), 
	('B23', 'Claire Oko', '1986-02-15', '6677890435', 'claireoko@hotmail.com'), 
    ('KPG24', 'Victor Ibe', '1970-07-05', '4356789024', 'victor007ibe@yahoo.com'), 
	('V90', 'Cami Nelson', '1980-04-20', '9876543210', 'nelsoncami@hotmail.com'), 
	('TGC92', 'Abubakar Musa', '1986-11-18', '5558889911', 'abu.musa@gmail.com'),
	('O78', 'Yetunde Mfon', '1983-03-31', '3710784800', 'yetundemfon@yahoo.com'), 
	('T08', 'Ike Izu', '1986-01-13', '1231231234', 'izuike@hotmail.com'), 
	('RST2', 'Collins Idris', '1988-08-25', '7045789645', 'collinsidris@yahoo.com');

    
 -- INSERTING DATA INTO THE PAYMENT TABLE 
INSERT INTO payment (payment_id, flight_id, payment_date, payment_status) 
VALUES
	('P02', 'ABJ051', '2023-11-30 12:10:13', 'Y'),
	('F005',  'ENU040', '2023-12-06 16:48:43', 'Y'),
	('F033', 'CAL022', '2023-11-20 05:36:50', 'Y'),
	('F02', 'LOS167', '2023-12-01 21:12:11', 'Y'),
	('F087', 'LOS159', '2023-12-30 17:30:22', 'Y'),
	('P10', 'ABJ014', '2023-12-09 02:30:49', 'Y'),
	('F400', 'ABJ010','2023-11-20 17:36:49', 'Y'),
	('F70', 'LOS108', '2023-12-16 22:59:46', 'Y'),
	('P06', 'ABJ034', '2023-12-01 10:10:40', 'Y'),
	('F104','PH050','2023-12-18 16:28:35', 'Y');
    

 -- INSERTING DATA INTO THE TICKET TABLE 
INSERT INTO ticket (ticket_id, passenger_name, seat_number, booking_id, payment_id, flight_id)
VALUES
	('TXA11', 'Bayo Ade', '1A', 1, 'P02', 'ABJ051'),
	('PY180', 'Ofure Woji', '3B', 2,  'F005', 'ENU040'),
	('BPY02', 'Akpan Obong', '8C', 3,  'F033', 'CAL022'),
	('KUT01', 'Claire Oko', '25F', 4, 'F02', 'LOS167'),
	('ECU05', 'Victor Ibe', '10D', 5, 'F087', 'LOS159'),
	('VTR04', 'Cami Nelson', '12E', 6, 'P10', 'ABJ014'),
	('QTX01', 'Abubukar Musa', '2A', 7, 'F400', 'ABJ010'),
	('ZGY11', 'Yetunde Mfon', '1B', 8, 'F70', 'LOS108'),
	('DWT07', 'Ike Izu', '5D', 9, 'P06', 'ABJ034'),
	('GFJ08', 'Collins Idris', '21A', 10,'F104', 'PH050');
    
-- TO BE SURE THE DATA WAS SUCCESSFULLY INSERTED INTO THE TABLES
SELECT * FROM bookings;
SELECT * FROM passenger;
SELECT * FROM flights;
SELECT * FROM payment;
SELECT * FROM ticket;
  

# QUERY OPTIMIZATION #
-- Creating indexes for performance optimization
CREATE INDEX Index_Bookings_Departure_city ON Bookings(Departure_City);
CREATE INDEX Index_Flights_Class ON Flights(Class);
CREATE INDEX Index_Passenger_DOB ON Passenger(DOB);

-- To show all indexes in the database
SELECT DISTINCT TABLE_NAME,
  INDEX_NAME
FROM INFORMATION_SCHEMA.STATISTICS
WHERE TABLE_SCHEMA = 'AirlineBooking';

-- Shows the created index
SHOW INDEX FROM Bookings;

-- STORED PROCEDURE 
-- Stored Procedure 1: Update payment 
/* This will update the Payment table, setting the Payment_Status to 'Y' and updating 
the Payment_Date based on the provided values. 
*/
DROP PROCEDURE IF EXISTS UpdatePayment;

DELIMITER //

CREATE PROCEDURE UpdatePayment(
    IN p_payment_id VARCHAR(255),
    IN p_payment_date DATETIME
)
BEGIN
    UPDATE Payment
    SET Payment_Status = 'Y', Payment_Date = p_payment_date
    WHERE Payment_ID = p_payment_id;
END //

DELIMITER ;


-- To test  the stored procedure
-- UpdatePayment Stored Procedure
CALL UpdatePayment('P02', '2023-11-30 12:12:15');

-- Check if the new passenger was inserted
SELECT * FROM payment;

-- Stored Procedure 2: 
DROP PROCEDURE IF EXISTS insert_new_passenger;

-- To create the procedure
DELIMITER //

CREATE PROCEDURE insert_new_passenger (
        IN p_passenger_id VARCHAR(255), 
        IN p_name VARCHAR(255), 
		IN p_DOB DATE, 
        IN p_phone BIGINT, 
        IN p_email VARCHAR(255)
        )
BEGIN 
      INSERT INTO passenger (passenger_id, name, DOB, phone, email) 
VALUES 
	(p_passenger_id, p_name, p_DOB, p_phone, p_email);
END //

DELIMITER ;  

-- To test  the stored procedure
-- To test insert_new_passenger procedure: first is to insert Charles using the procedure
CALL insert_new_passenger ('XF67', 'Charles Jack', '1979-08-06', '7834567890','charlesbig@yahoo.com');

-- Check if the new passenger was inserted
SELECT * FROM passenger;

-- STORED PROCEDURE 3: Stored Procedure to delete existing passengers
-- To create the procedure
DROP PROCEDURE IF EXISTS delete_passenger;

DELIMITER //
CREATE PROCEDURE delete_passenger (
        IN selected_passenger VARCHAR(255)
	)
BEGIN 
      DELETE FROM passenger 
    WHERE passenger_id = selected_passenger;
END //
DELIMITER ;  


-- To delete the new passenger and test the delete passenger procedure
DELETE FROM Passenger
WHERE name = 'Charles Jack';

-- To check if it worked
SELECT * FROM passenger;


-- TRIGGERS 
--Trigger 1:  Enforce Departure Date Before Arrival Date
/* 
This trigger ensures that the departure date is before the arrival date 
when inserting into the Bookings table.
 */
 
DELIMITER //
CREATE TRIGGER before_insert_bookings
BEFORE INSERT ON Bookings FOR EACH ROW
BEGIN
    IF NEW.Departure_Date >= NEW.Arrival_Date THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Departure date must be before arrival date';
    END IF;
END //
DELIMITER ;

- Trigger 2: Enforce Email Format 
/* 
This trigger ensures that the email format is valid when inserting into 
the Passengers table.
 */
 
DELIMITER //
CREATE TRIGGER before_insert_passenger
BEFORE INSERT ON Passenger FOR EACH ROW
BEGIN
    IF NEW.Email NOT LIKE '%_@__%.__%' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Invalid email format';
    END IF;
END //
DELIMITER ;

# QUESTION #
-- Q1: What are the details of the bookings made for one-way trips?
SELECT * FROM Bookings WHERE Trip_Type = 'one-way';

-- Q2: Who are the passengers with bookings, and what are their contact details?
SELECT Passenger.*, Ticket.*
FROM Passenger
JOIN Ticket ON Passenger.Name = Ticket.Passenger_Name;

-- Q3: What is the fare for a first-class flight from Abuja to Lagos?
SELECT 
    Fare
FROM
    Flights
WHERE
    Departure_City = 'Abuja'
        AND Arrival_City = 'Lagos'
        AND Class = 'first';

-- Q4: Retrieve ticket details for passengers who paid successfully.
SELECT Ticket.*
FROM Ticket
JOIN Payment ON Ticket.Payment_ID = Payment.Payment_ID
WHERE Payment.Payment_Status = 'Y';

-- Q5: Determine the average time difference between booking and departure dates.
SELECT AVG(DATEDIFF(Departure_Date, Booking_Date)) AS AvgTimeDifference
FROM Bookings;

-- Q6: Retrieve the list of passengers who have successfully paid for their tickets, include their names and seat numbers?
SELECT 
    passenger.name, ticket.seat_number, payment_status
FROM
    passenger
        JOIN
    ticket ON passenger.name = ticket.passenger_name
        JOIN
    payment ON ticket.payment_id = payment.payment_id
WHERE
    payment_status = 'Y';