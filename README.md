# TASK INTERN CAREER 
This repository contains the tasks that I completed while working as a SQL Intern at Intern Career

    Internship Category – SQL 
    Internship Duration - 1 Month (January 2024)
    Internship Type – Virtual Internship
 

## Task 1: SQL Data Analysis: Spotify-Data 1921-2020
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


## TASK 2: SQL Database Design and Optimization.
Description: Design a database schema, optimize queries, and explore performance tuning techniques.
- Click [Here](https://github.com/Mayreeobi/Task-Intern-Career/blob/main/airline.sql) for the SQL script

NB: This booking system was built on MySQL Database

### Task Structure
The task is structured into the following components:
-	Task Overview
-	Introduction
-	Database Creation, tables creation, constraints and inserting of data into the tables.
-	Query optimization
-	Stored procedures
-	Triggers creation
-	Entity Relationship Diagram
-	SQL Questions.

### Introduction
The Airline Booking System Database is designed to manage information related to the online booking of an airline. The database is made up of 5 tables, and each table holds crucial information for tracking and managing different aspects of the airline's operations.

### Database Creation
Database Creation: Defines the database schema, inserting of data into the tables and constraints.

#### Database Tables
#### Bookings Table: Bookings Table contains information on the passenger’s booking.
-	Booking_ID: Integer Unsigned Primary Key
-	Trip_Type: Varchar, Maximum 255 characters
-	Booking_date: Datetime Not Null
-	Departure_city: Varchar, Maximum 255 characters
-	Arrival_city: Varchar, Maximum 255 characters
-	Departure_date: Datetime Not Null
-	Arrival_date: Datetime
-	LastName: Varchar, Maximum 50 characters
-	DOB: Date, Not Null
-	Email: Varchar, Maximum 100 characters, Unique

#### Constraints on Bookings Table
-	Trip_type cannot be NULL.
-	Departure_Date < Arrival_Date

#### Flights Table: Flight table contains information about the specific flights offered by the airline
-	Flight_ID: Varchar, Maximum 255 characters, Primary Key
-	Departure_city: Varchar, Maximum 255 characters, Not Null
-	Arrival_city: Varchar, Maximum 255 characters, Not Null
-	Departure_date: Datetime Not Null
-	Arrival_date: Datetime
-	Class: Varchar, Maximum 255 characters, Not Null
-	Fare: Double, Not Null

#### Constraint on Flights Table
-	Departure_city cannot be NULL.

#### Passenger Table: Passenger table contains information about the passengers of the airline.
-   Passenger_ID: Varchar, Maximum 255 characters, Primary Key
-   Name: Varchar, Maximum 255 characters.
-   DOB: Date Not Null
-   Phone: Bigint Not Null
-   Email: Varchar, Maximum 255 characters, check (Email LIKE '%_@__%.__%’)

#### Payment Table: Payment table  contains information regarding payment of the flight.
-	Payment_ID: Varchar, Maximum 255 characters, Primary Key
-	Flight_ID: Varchar, Maximum 255 characters, Foreign Key referencing Flights
-	Payment_date: Datetime, Not Null
-	Payment_status: Char Maimum 1 charcter, Check(Payment_status IN (‘Y’,’N’))

#### Constraint on Payment Table
-	Foreign key constraints established on Flight tables.

#### Ticket Table: Ticket table contains information about the tickets purchased by the passenger.
-	Ticket_ID: Varchar, Maximum 255 characters, Primary Key
-	Name: Varchar, Maximum 255 characters.
-	Seat_number: Varchar, Maximum 10 characters.
-	Booking_ID: Integer Unsigned, Foreign Key referencing Bookings
-	Payment_ID: Varchar, Maximum 255 characters, Foreign Key referencing Payment
-	Flight_ID: Varchar, Maximum 255 characters, Foreign Key referencing Flights

#### Constraint on Ticket Table
-	Foreign key constraints established between Bookings, Payment, and Flights tables.

### Query Optimization
Creating indexes for performance optimization
-   CREATE INDEX Index_Bookings_Departure_city ON Bookings(Departure_City);
-   CREATE INDEX Index_Flights_Class ON Flights(Class);
-   CREATE INDEX Index_Passenger_DOB ON Passenger(DOB);


### Stored Procedures
-   Stored Procedure 1: : To update the Payment table.
-   Stored Procedure 2: To insert a new passenger into the passenger table and update.
-   Stored Procedure 3: To delete existing passenger table.

### Triggers
-   Trigger 1: Enforce Departure Date Before Arrival Date
-   Trigger 2: Enforce Email Format 

### Entity Relationship Diagram
 - Click [Here](https://github.com/Mayreeobi/Task-Intern-Career/blob/main/Database%20ERD.png) for the diagram
 
### Usage
To use this project, run the SQL script in your preferred database management system, ensuring that the syntax is compatible. Adjustments may be necessary based on your specific database system.

