-- ============================================
-- Airline Booking System Database Schema
-- Author: Chinyere Obi
-- Date: January 2024
-- Description: Normalized (3NF) database for 
--              online airline booking operations
-- ============================================


-- DATABASE CREATION
DROP DATABASE IF EXISTS airline_booking;
CREATE DATABASE airline_booking
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

-- Check if the database was created
SHOW DATABASES;

-- Makes the database active
USE airline_booking;
 
 -- TABLES CREATIONS
 -- Create Passengers Table 
DROP TABLE IF EXISTS passengers;

CREATE TABLE passengers (
    passenger_id VARCHAR(50) PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    date_of_birth DATE NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(255) NOT NULL UNIQUE,

    CONSTRAINT chk_passenger_email
        CHECK (email LIKE '%_@__%.__%')
);

-- Create Flights Table
DROP TABLE IF EXISTS flights;

CREATE TABLE flights (
    flight_id VARCHAR(50) PRIMARY KEY,
    departure_city VARCHAR(100) NOT NULL,
    arrival_city VARCHAR(100) NOT NULL,
    departure_datetime DATETIME NOT NULL,
    arrival_datetime DATETIME,
    travel_class ENUM ('Economy','Premium','Business','First') NOT NULL,
    base_fare DECIMAL(10,2) NOT NULL,
    #created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_flight_dates
        CHECK (departure_datetime < arrival_datetime),

    CONSTRAINT chk_city_difference
        CHECK (departure_city <> arrival_city)
);

-- Create Bookings Table
DROP TABLE IF EXISTS bookings;
CREATE TABLE bookings (
    booking_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    passenger_id VARCHAR(50) NOT NULL,
    trip_type ENUM ('One_Way','Round_Trip') NOT NULL,
    booking_date DATETIME NOT NULL,
    booking_status ENUM ('Confirmed','Cancelled','Pending') DEFAULT 'Confirmed',

    CONSTRAINT fk_booking_passenger
        FOREIGN KEY (passenger_id)
        REFERENCES passengers(passenger_id)
        ON DELETE CASCADE
);

-- Create BOOKING_FLIGHTS (Supports Round Trips & Multi-Leg Trips)
DROP TABLE IF EXISTS booking_flights;

CREATE TABLE booking_flights (
    booking_flight_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    booking_id INT UNSIGNED NOT NULL,
    flight_id VARCHAR(50) NOT NULL,
    segment_order INT NOT NULL,

    CONSTRAINT uq_booking_segment
        UNIQUE (booking_id, segment_order),

    CONSTRAINT fk_bf_booking
        FOREIGN KEY (booking_id)
        REFERENCES bookings(booking_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_bf_flight
        FOREIGN KEY (flight_id)
        REFERENCES flights(flight_id)
);

-- Create Payments Table
DROP TABLE IF EXISTS payments; 

CREATE TABLE payments (
    payment_id VARCHAR(50) PRIMARY KEY,
    booking_id INT UNSIGNED NOT NULL,
    payment_date DATETIME NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_status ENUM ('Success','Failed') NOT NULL,
    payment_method ENUM ('Card','Transfer','Wallet') DEFAULT 'Card',

    CONSTRAINT fk_payment_booking
        FOREIGN KEY (booking_id)
        REFERENCES bookings(booking_id)
        ON DELETE CASCADE
);

-- Create Tickets Table
DROP TABLE IF EXISTS tickets;

CREATE TABLE tickets (
    ticket_id VARCHAR(50) PRIMARY KEY,
    booking_flight_id INT UNSIGNED NOT NULL,
    seat_number VARCHAR(10),
    #issued_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_ticket_booking_flight
        FOREIGN KEY (booking_flight_id)
        REFERENCES booking_flights(booking_flight_id)
        ON DELETE CASCADE
);

-- Check if all tables were created
SELECT *
FROM information_schema.columns
WHERE TABLE_SCHEMA = "airline_booking";

-- To check if the tables were created and constraints are properly placed
DESCRIBE passengers;
DESCRIBE flights;
DESCRIBE bookings;
DESCRIBE booking_flights;
DESCRIBE payments;
DESCRIBE tickets;

/* INSERT DATA INTO THE TABLES
 The tables are ready and the next step is to insert values into the table with the data for 
 the airline online booking. 
 */
-- Insert data into passengers table
INSERT INTO passengers (passenger_id, full_name, date_of_birth, phone, email)
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

--  Insert data into flights table 
INSERT INTO flights (flight_id, departure_city, arrival_city,
    departure_datetime, arrival_datetime, travel_class, base_fare)     
VALUES
('ABJ051','Abuja','Lagos','2023-12-20 08:15:10',NULL,'First',250500),
('ENU040','Enugu','Port Harcourt','2023-12-23 12:04:40','2024-01-04 14:00:10','Premium',360010),
('CAL022','Calabar','Abuja','2023-12-27 16:30:32','2024-01-03 15:50:25','Economy',259800),
('LOS167','Lagos','Owerri','2023-12-27 20:18:55',NULL,'Economy',88900),
('LOS159','Lagos','Enugu','2023-12-28 12:00:10','2024-01-05 18:40:04','Economy',313200),
('ABJ014','Abuja','Owerri','2023-12-28 14:00:00',NULL,'Economy',181400),
('ABJ010','Abuja','Kano','2023-12-29 11:54:13','2024-01-06 12:37:05','First',300200),
('LOS108','Lagos','Uyo','2023-12-29 17:39:47',NULL,'First',201000),
('ABJ034','Abuja','Owerri','2023-12-29 13:39:08',NULL,'Premium',170600),
('PH050','Port Harcourt','Lagos','2023-12-29 19:50:52','2024-01-09 16:09:48','Economy',161500);

-- Insert data into bookings table
INSERT INTO bookings (booking_id, passenger_id, trip_type, booking_date)
VALUES
(1,'A01','ONE_WAY','2023-11-30 12:00:03'),
(2,'BT11','ROUND_TRIP','2023-12-06 16:40:25'),
(3,'AEP2','ROUND_TRIP','2023-11-20 05:26:30'),
(4,'B23','ONE_WAY','2023-12-01 21:10:10'),
(5,'KPG24','ROUND_TRIP','2023-12-30 17:20:12'),
(6,'V90','ONE_WAY','2023-12-09 02:20:39'),
(7,'TGC92','ROUND_TRIP','2023-11-20 17:30:39'),
(8,'O78','ONE_WAY','2023-12-16 22:49:36'),
(9,'T08','ONE_WAY','2023-12-01 10:02:50'),
(10,'RST2','ROUND_TRIP','2023-12-18 16:18:55');

 -- Insert data into booking_flights table
INSERT INTO booking_flights (booking_id, flight_id, segment_order)
VALUES
(1,'ABJ051',1),
(2,'ENU040',1),
(3,'CAL022',1),
(4,'LOS167',1),
(5,'LOS159',1),
(6,'ABJ014',1),
(7,'ABJ010',1),
(8,'LOS108',1),
(9,'ABJ034',1),
(10,'PH050',1);

 -- Insert data into payments table
INSERT INTO payments (payment_id, booking_id, payment_date, amount, payment_status)
VALUES
('P02',1,'2023-11-30 12:10:13',250500,'SUCCESS'),
('F005',2,'2023-12-06 16:48:43',360010,'SUCCESS'),
('F033',3,'2023-11-20 05:36:50',259800,'SUCCESS'),
('F02',4,'2023-12-01 21:12:11',88900,'SUCCESS'),
('F087',5,'2023-12-30 17:30:22',313200,'SUCCESS'),
('P10',6,'2023-12-09 02:30:49',181400,'SUCCESS'),
('F400',7,'2023-11-20 17:36:49',300200,'SUCCESS'),
('F70',8,'2023-12-16 22:59:46',201000,'SUCCESS'),
('P06',9,'2023-12-01 10:10:40',170600,'SUCCESS'),
('F104',10,'2023-12-18 16:28:35',161500,'SUCCESS');
    
 -- Insert data into tickets table 
INSERT INTO tickets (ticket_id, booking_flight_id, seat_number)
VALUES
('TXA11',1,'1A'),
('PY180',2,'3B'),
('BPY02',3,'8C'),
('KUT01',4,'25F'),
('ECU05',5,'10D'),
('VTR04',6,'12E'),
('QTX01',7,'2A'),
('ZGY11',8,'1B'),
('DWT07',9,'5D'),
('GFJ08',10,'21A');
    
-- TO BE SURE THE DATA WAS SUCCESSFULLY INSERTED INTO THE TABLES
SELECT * FROM passengers;
SELECT * FROM flights;
SELECT * FROM booking_flights;
SELECT * FROM bookings;
SELECT * FROM payments;
SELECT * FROM tickets;
  
# QUERY OPTIMIZATION #
-- Creating indexes for performance optimization
CREATE INDEX idx_booking_passenger ON bookings(passenger_id);
CREATE INDEX idx_flight_route ON flights(departure_city, arrival_city);
CREATE INDEX idx_flight_departure ON flights(departure_datetime);
CREATE INDEX idx_payment_status ON payments(payment_status);

-- To show all indexes in the database
SELECT DISTINCT TABLE_NAME,
  INDEX_NAME
FROM INFORMATION_SCHEMA.STATISTICS
WHERE TABLE_SCHEMA = 'airline_booking';

-- Shows the created index
SHOW INDEX FROM bookings;

-- STORED PROCEDURE 
/* Stored Procedure 1: Update payment 
 This will update the Payment table, setting the Payment_Status to 'Y' and updating 
the Payment_Date based on the provided values. 
*/
DROP PROCEDURE IF EXISTS UpdatePayment;
-- To create the procedure
DELIMITER //

CREATE PROCEDURE UpdatePayment (
    IN p_payment_id VARCHAR(50),
    IN p_status ENUM('Success','Failed','Refunded')
)
BEGIN
    UPDATE payments
    SET payment_status = p_status,
        payment_date = CURRENT_TIMESTAMP
    WHERE payment_id = p_payment_id;
END //

DELIMITER ;

-- To test  the stored procedure
-- UpdatePayment Stored Procedure
CALL UpdatePayment ('P02', '2023-11-30 12:12:15');

-- Check if the new passenger was inserted
SELECT * FROM payments;

-- Stored Procedure 2: 
DROP PROCEDURE IF EXISTS insert_new_passenger;

DELIMITER //

CREATE PROCEDURE insert_new_passenger (
    IN p_passenger_id VARCHAR(50),
    IN p_full_name VARCHAR(255),
    IN p_dob DATE,
    IN p_phone VARCHAR(20),
    IN p_email VARCHAR(255)
)
BEGIN
    INSERT INTO passengers
    (passenger_id, full_name, date_of_birth, phone, email)
    VALUES
    (p_passenger_id, p_full_name, p_dob, p_phone, p_email);
END //

DELIMITER ;

-- To test  the stored procedure
-- To test insert_new_passenger procedure: first is to insert Charles using the procedure
CALL insert_new_passenger ('XF67', 'Charles Jack', '1979-08-06', '7834567890','charlesbig@yahoo.com');

-- Check if the new passenger was inserted
SELECT * FROM passengers;

-- STORED PROCEDURE 3: Stored Procedure to delete existing passengers
-- To create the procedure
DROP PROCEDURE IF EXISTS delete_passenger;
DELIMITER //

CREATE PROCEDURE delete_passenger (
    IN p_passenger_id VARCHAR(50)
)
BEGIN
    DELETE FROM passengers
    WHERE passenger_id = p_passenger_id;
END //

DELIMITER ;

-- To delete the new passenger and test the delete passenger procedure
DELETE FROM passengers
WHERE full_name = 'Charles Jack';

-- To check if it worked
SELECT * FROM passengers;

-- TRIGGERS 
/* Trigger 1:  Enforce Departure Date Before Arrival Date
This trigger ensures that the departure date is before the arrival date 
when inserting into the Bookings table.
 */
 
DELIMITER //
CREATE TRIGGER before_insert_flights
BEFORE INSERT ON flights FOR EACH ROW
BEGIN
    IF NEW.departure_datetime >= NEW.arrival_datetime THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Departure date must be before arrival date';
    END IF;
END //
DELIMITER ;

/* Trigger 2: Enforce Email Format 
This trigger ensures that the email format is valid when inserting into 
the Passengers table.
 */
 DELIMITER //

CREATE TRIGGER trg_validate_email
BEFORE INSERT ON passengers
FOR EACH ROW
BEGIN
    IF NEW.email NOT LIKE '%_@__%.__%' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid email format';
    END IF;
END //

DELIMITER ;



# QUESTION #
-- Q1: What are the details of the bookings made for one-way trips?
SELECT *
FROM bookings
WHERE trip_type = 'ONE_WAY';

-- Q2: What is the fare for a first-class flight from Abuja to Lagos?
SELECT ROUND(base_fare,0)
FROM flights
WHERE departure_city = 'Abuja'
  AND arrival_city = 'Lagos'
  AND travel_class = 'First';

-- Q3: Retrieve ticket details for passengers who paid successfully.
SELECT t.*
FROM tickets t
JOIN booking_flights bf ON t.booking_flight_id = bf.booking_flight_id
JOIN bookings b ON bf.booking_id = b.booking_id
JOIN payments p ON b.booking_id = p.booking_id
WHERE p.payment_status = 'SUCCESS';

-- Q4: Retrieve the list of passengers who have successfully paid for their tickets, include their names and seat numbers?
SELECT 
    p.full_name,
    p.email,
    t.ticket_id,
    t.seat_number
FROM passengers p
JOIN bookings b ON p.passenger_id = b.passenger_id
JOIN booking_flights bf ON b.booking_id = bf.booking_id
JOIN tickets t ON bf.booking_flight_id = t.booking_flight_id;


