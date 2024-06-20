# SQL Queries

###### Table Setup (DDL)
``` sql
CREATE SCHEMA cd;
CREATE TABLE cd.members (
  memid integer NOT NULL,
  surname character varying(200) NOT NULL,
  firstname character varying(200) NOT NULL,
  address character varying(300) NOT NULL,
  zipcode integer NOT NULL,
  telephone character varying(20) NOT NULL,
  recommendedby integer,
  joindate timestamp NOT NULL,
  CONSTRAINT members_pk PRIMARY KEY (memid),
  CONSTRAINT fk_members_recommendedby FOREIGN KEY (recommendedby) REFERENCES 
      cd.members(memid) ON DELETE
  SET
    NULL
);
CREATE TABLE cd.facilities (
  facid integer NOT NULL,
  name character varying(100) NOT NULL,
  membercost numeric NOT NULL,
  guestcost numeric NOT NULL,
  initialoutlay numeric NOT NULL,
  monthlymaintenance numeric NOT NULL,
  CONSTRAINT facilities_pk PRIMARY KEY (facid)
);
CREATE TABLE cd.bookings (
  bookid integer NOT NULL,
  facid integer NOT NULL,
  memid integer NOT NULL,
  starttime timestamp NOT NULL,
  slots integer NOT NULL,
  CONSTRAINT bookings_pk PRIMARY KEY (bookid),
  CONSTRAINT fk_bookings_facid FOREIGN KEY (facid) REFERENCES cd.facilities
      (facid),
  CONSTRAINT fk_bookings_memid FOREIGN KEY (memid) REFERENCES cd.members
      (memid)
);
```

###### Question 1: Show all members 

```sql
SELECT *
FROM cd.members
```

### Question 2: The club is adding a new facility - a spa. We need to add it into the facilities table. Use the following values:
- facid: 9
- Name: 'Spa'
- membercost: 20
- guestcost: 30
- initialoutlay: 100000
- monthlymaintenance: 800

```sql
INSERT INTO cd.facilities (facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
VALUES (9, 'Spa', 20, 30, 100000, 800);
```





EOF


