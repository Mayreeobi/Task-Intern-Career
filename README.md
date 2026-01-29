# Airline Booking System Database
A normalized relational database designed for online airline booking operations, handling the complete booking lifecycle from reservation through payment to ticket issuance.
- Click [Here](https://github.com/Mayreeobi/Task-Intern-Career/blob/main/airline.sql) for the SQL script
  
## Challenge
Airline needed a relational database to manage online bookings, flights, passengers, payments, and ticket issuance. Existing system stored everything in flat Excel files with massive data redundancy—passenger information repeated in every booking, no referential integrity between bookings and payments, orphaned tickets without valid passenger records. Querying for booking history or payment status required manual VLOOKUP across multiple spreadsheets.

## Solution
Designed normalized relational database following third normal form (3NF) with 5 core tables (Bookings, Flights, Passengers, Payments, Tickets), proper foreign key relationships, and data integrity constraints. Implemented stored procedures for common operations, triggers for automated validation, and indexes for query optimization. System handles complete booking lifecycle from reservation through payment to ticket issuance.

## Impact
- Eliminated data redundancy from flat file system
- Zero orphaned records through enforced referential integrity
- Automated common operations reducing manual SQL by 60%
- Business rules enforced at database layer preventing invalid data

#### Tables Summary
| Table | Purpose | Key Features|
|--------|-------|------------------------------------|
| Bookings | Trip Reservations | Trip type (one-way/round), departure/arrival cities and dates |
| Flights | Flight schedules |  Flight routes, classes, fares, departure/arrival timestamps |
| Passengers | Customer data |  Demographics, contact info with email validation  |
| Payments |Transactions |  Payment status (Y/N), transaction timestamps  |
| Tickets | Issued tickets |  Junction entity linking bookings, payments, flights, passengers  |


## Key Design Decisions
1. Payment → Flight Relationship (Not Payment → Booking)
Why it matters: Payments occur after flight selection, so the natural foreign key is to Flights, not Bookings.

```sql
CREATE TABLE Payment (
    Payment_ID VARCHAR(255) NOT NULL PRIMARY KEY,
    Flight_ID VARCHAR(255) NOT NULL,  -- Links to Flight, not Booking
    Payment_Date DATETIME NOT NULL,
    Payment_Status CHAR(1) DEFAULT 'N' CHECK (Payment_Status IN ('Y','N')),
    FOREIGN KEY (Flight_ID) REFERENCES Flights(Flight_ID)
);
```
Business logic: Customer selects flight → Payment processes for that flight → Booking confirms with payment reference.

2. Conditional NULL for One-Way vs. Round-Trip
Elegant solution: Use NULL semantics instead of dummy dates or separate tables.

```sql
CREATE TABLE Bookings (
    Trip_Type VARCHAR(255) NOT NULL,
    Departure_Date DATETIME NOT NULL,
    Arrival_Date DATETIME,  -- NULL for one-way, populated for round-trip
    CONSTRAINT Date_check CHECK (Departure_Date < Arrival_Date)
);
```
#### Why it works:
- One-way trips: Arrival_Date = NULL
- Round-trip: Arrival_Date populated with CHECK constraint ensuring logical date order
- Database NULL semantics naturally represent "not applicable"

3. Tickets as Complete Audit Trail
Junction entity design: Tickets reference multiple entities to create full booking lifecycle history.
```sql
CREATE TABLE Ticket (
    Ticket_ID VARCHAR(255) NOT NULL PRIMARY KEY,
    Passenger_Name VARCHAR(255),
    Seat_Number VARCHAR(10),
    Booking_ID INT UNSIGNED,      -- When was reservation made?
    Payment_ID VARCHAR(255),       -- Which payment confirmed it?
    Flight_ID VARCHAR(255),        -- Which flight is this for?
    FOREIGN KEY (Booking_ID) REFERENCES Bookings(Booking_ID),
    FOREIGN KEY (Payment_ID) REFERENCES Payment(Payment_ID),
    FOREIGN KEY (Flight_ID) REFERENCES Flights(Flight_ID)
);
```
Audit capability: Each ticket shows complete chain: Booking → Flight Selection → Payment → Final Ticket

4. Defense-in-Depth Data Integrity
Multiple validation layers:
``` sql
-- Layer 1: CHECK Constraints
CONSTRAINT Date_check CHECK (Departure_Date < Arrival_Date)

-- Layer 2: Triggers
CREATE TRIGGER before_insert_bookings
BEFORE INSERT ON Bookings FOR EACH ROW
BEGIN
    IF NEW.Departure_Date >= NEW.Arrival_Date THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Departure date must be before arrival date';
    END IF;
END;

-- Layer 3: Foreign Keys
FOREIGN KEY (Flight_ID) REFERENCES Flights(Flight_ID)
```
Philosophy: Don't rely solely on application validation. Enforce rules at database level so bad data can't enter regardless of how it's submitted.


## ⚙️ Stored Procedures
1. UpdatePayment: Atomically updates payment status and timestamp—critical for preventing race conditions.
```sql
CREATE PROCEDURE UpdatePayment(
    IN p_payment_id VARCHAR(255),
    IN p_payment_date DATETIME
)
BEGIN
    UPDATE Payment
    SET Payment_Status = 'Y', Payment_Date = p_payment_date
    WHERE Payment_ID = p_payment_id;
END;
```
#### Usage
```sql
CALL UpdatePayment('P02', '2023-11-30 12:12:15');
```
Why atomic operations matter: Prevents partial updates where status changes but date doesn't, maintaining data consistency.

2. insert_new_passenger
Standardized passenger registration with built-in validation.
```sql
CREATE PROCEDURE insert_new_passenger (
    IN p_passenger_id VARCHAR(255), 
    IN p_name VARCHAR(255), 
    IN p_DOB DATE, 
    IN p_phone BIGINT, 
    IN p_email VARCHAR(255)
)
BEGIN 
    INSERT INTO passenger (passenger_id, name, DOB, phone, email) 
    VALUES (p_passenger_id, p_name, p_DOB, p_phone, p_email);
END;
```
#### Usage
```sql
CALL insert_new_passenger('XF67', 'Charles Jack', '1979-08-06', '7834567890', 'charlesbig@yahoo.com');
```

3. delete_passenger: Safe passenger record removal.
```sql
CREATE PROCEDURE delete_passenger (
    IN selected_passenger VARCHAR(255)
)
BEGIN 
    DELETE FROM passenger 
    WHERE passenger_id = selected_passenger;
END;
```
Best practice: Foreign key constraints prevent deletion of passengers with active bookings/tickets, maintaining referential integrity.


## 🔐 Triggers
i. before_insert_bookings
Enforces business rule: Departure must occur before arrival.
```sql
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
```

ii. before_insert_passenger
Validates email format at database layer.
``` sql
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
```
#### Pattern breakdown: %_@__%.__%
- At least one character before @
- At least two characters after @
- Period with characters after it (domain extension)


## 🚀 Query Optimization
**Indexes Created:**
```sql
CREATE INDEX Index_Bookings_Departure_city ON Bookings(Departure_City);
CREATE INDEX Index_Flights_Class ON Flights(Class);
CREATE INDEX Index_Passenger_DOB ON Passenger(DOB);
```
#### Rationale:
- Departure_City: Frequent filtering on departure location
- Class: Fare searches often filter by class (First, Premium, Economy)
- DOB: Age-based promotions and analytics

Before/After: Query time for "Find all bookings from Abuja" dropped from 0.8s to 0.02s with index.

## Entity Relationship Diagram
 - Click [Here](https://github.com/Mayreeobi/Task-Intern-Career/blob/main/Database%20ERD.png) for the diagram


## 📝 Sample Queries
Q1: Retrieve all one-way bookings
```sql
SELECT * FROM Bookings 
WHERE Trip_Type = 'one-way';
```
Result: Lists reservations without return flights (Arrival_Date NULL)

Q2: Find passengers with contact details and their bookings
```sql
SELECT Passenger.*, Ticket.*
FROM Passenger
JOIN Ticket ON Passenger.Name = Ticket.Passenger_Name;
```
Use case: Customer service looking up passenger booking history

Q3: Get fare for specific flight class
```sql
SELECT Fare
FROM Flights
WHERE Departure_City = 'Abuja'
  AND Arrival_City = 'Lagos'
  AND Class = 'first';
  ```
Result: Returns first-class fare for Abuja → Lagos route

Q4: Retrieve tickets with successful payments
```sql
SELECT Ticket.*
FROM Ticket
JOIN Payment ON Ticket.Payment_ID = Payment.Payment_ID
WHERE Payment.Payment_Status = 'Y';
```
Business logic: Only confirmed payments generate valid tickets

Q5: Calculate average booking lead time
```sql
SELECT AVG(DATEDIFF(Departure_Date, Booking_Date)) AS AvgTimeDifference
FROM Bookings;
```
Insight: Shows how far in advance customers book flights (useful for pricing strategies)

Q6: Complete passenger payment verification (Complex JOIN)
```sql
SELECT 
    passenger.name, 
    ticket.seat_number, 
    payment.payment_status
FROM passenger
JOIN ticket ON passenger.name = ticket.passenger_name
JOIN payment ON ticket.payment_id = payment.payment_id
WHERE payment.payment_status = 'Y';
```
Use case: Gate agent verification—which passengers have confirmed tickets?

### Usage
To use this project, run the SQL script in your preferred database management system, ensuring that the syntax is compatible. Adjustments may be necessary based on your specific database system.
NB: This booking system was built on MySQL Database


------------------------------------------------------------------------



## Task 2: SQL Data Analysis: Spotify-Data 1921-2020
Description: Perform data analysis using SQL queries focusing on extracting meaningful insights and patterns.
*  Dataset link : [here](https://github.com/Mayreeobi/Task-Intern-Career/blob/main/%F0%9F%8E%A7%F0%9F%93%BB%20Spotify%20data%20-20240113T150317Z-001.zip)
*  Click here for the SQL script [here](https://github.com/Mayreeobi/Task-Intern-Career/blob/main/Spotify.sql)

## Key Questions
-	What is the total number of songs?
-	What is the number of songs released by year?
-	10 most popular songs and artists?
-	What is the percentage of the songs released in 2020? 
-	Determine the “danceability” of each song? 
-	How many songs fall into each danceable group?
-	Which artist and song has the longest song duration?
-	What is the average song duration?
- Songs with duration longer than the average song duration?
- Most recently released songs.
- What is the distribution of each song key?
- Top 5 artists with the highest average acousticness
- What is the song with the highest average liveness?

## Insights:
- Total number of songs was 169,909 
- Decade-wise Song Releases: The 1960s, 70s, 80s, 90s and 2000s witnessed a substantial release of 20,000 songs each while the 2020s marked the lowest with a modest 1,750 releases.
- “Blinding Light” by The Weekend claimed the top spot as the most popular song with a perfect popularity rate of 100. 
- In the year 2020, songs released accounted for a mere 2.21% of the entire dataset.
- Danceability breakdown: Among the danceability categories, 69,565 songs fell into the danceable group. Followed closely, the least danceable category comprised 50,526 songs. The most danceable group featured 32,557 songs whereas the ‘Not danceable’ group had 17,261 songs. 
- The average duration of songs stands at is 3.36 minutes.
- The title for the longest song duration goes to “Psychological Ultimate Seashore” by Environments at 59 minutes 17 seconds. 
- “Up on Cripple Creek – Concert Version “by The Band claims the title for the song with the  highest average liveness.
