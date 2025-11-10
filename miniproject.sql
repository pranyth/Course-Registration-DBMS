-- DBMS Mini Project 
-- Project: College Course Registration System - PRANITH K PES2UG23CS434, PRANAV NEGI PES2UG23CS429

DROP DATABASE IF EXISTS miniproject;
-- Create the new database
CREATE DATABASE miniproject;
USE miniproject;

--
-- DDL (Data Definition Language) - Creating Tables
--

CREATE TABLE Department (
    Department_ID VARCHAR(10) PRIMARY KEY,
    Dept_Name VARCHAR(100) NOT NULL UNIQUE,
    Location VARCHAR(100)
);

CREATE TABLE Classroom (
    Classroom_ID VARCHAR(10) PRIMARY KEY,
    Building VARCHAR(50) NOT NULL,
    Room_no INT NOT NULL,
    Capacity INT,
    CONSTRAINT chk_capacity CHECK (Capacity >= 0)
);

CREATE TABLE Semester (
    Semester_ID VARCHAR(10) PRIMARY KEY,
    Semester_Name VARCHAR(20) NOT NULL,
    Year INT NOT NULL,
    Start_Date DATE,
    End_Date DATE
);

CREATE TABLE Student (
    Student_ID VARCHAR(15) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(15),
    Department_ID VARCHAR(10),
    FOREIGN KEY (Department_ID) REFERENCES Department(Department_ID) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Faculty (
    Faculty_ID VARCHAR(10) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Department_ID VARCHAR(10),
    FOREIGN KEY (Department_ID) REFERENCES Department(Department_ID) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Course (
    Course_ID VARCHAR(10) PRIMARY KEY,
    Course_Name VARCHAR(100) NOT NULL,
    Credits INT,
    Department_ID VARCHAR(10),
    Faculty_ID VARCHAR(10),
    CONSTRAINT chk_credits CHECK (Credits > 0),
    FOREIGN KEY (Department_ID) REFERENCES Department(Department_ID) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (Faculty_ID) REFERENCES Faculty(Faculty_ID) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE Registration (
    Reg_ID INT PRIMARY KEY AUTO_INCREMENT,
    Student_ID VARCHAR(15),
    Course_ID VARCHAR(10),
    Reg_Date DATE NOT NULL,
    Grade VARCHAR(2),
    FOREIGN KEY (Student_ID) REFERENCES Student(Student_ID) ON DELETE CASCADE,
    FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID) ON DELETE RESTRICT
);

CREATE TABLE Schedule (
    Schedule_ID INT PRIMARY KEY AUTO_INCREMENT,
    Course_ID VARCHAR(10),
    Semester_ID VARCHAR(10),
    Classroom_ID VARCHAR(10),
    Day VARCHAR(15),
    Time_Slot VARCHAR(20),
    FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID) ON DELETE CASCADE,
    FOREIGN KEY (Semester_ID) REFERENCES Semester(Semester_ID) ON DELETE RESTRICT,
    FOREIGN KEY (Classroom_ID) REFERENCES Classroom(Classroom_ID) ON DELETE SET NULL
);

--
-- DML (Data Manipulation Language) - Inserting Data
--

-- Insert data into Department table
INSERT INTO Department (Department_ID, Dept_Name, Location) VALUES
('CS', 'Computer Science', 'Block 5, 2nd Floor'),
('EC', 'Electronics & Communication', 'Block 3, 1st Floor'),
('ME', 'Mechanical Engineering', 'Block 2, Ground Floor'),
('CV', 'Civil Engineering', 'Block 4, 3rd Floor'),
('BT', 'Biotechnology', 'Block 1, 4th Floor'),
('PHY', 'Physics Department', 'Block 6, 1st Floor');

-- Insert data into Classroom table
INSERT INTO Classroom (Classroom_ID, Building, Room_no, Capacity) VALUES
('C5201', 'Block 5', 201, 75),
('C3105', 'Block 3', 105, 60),
('C2G02', 'Block 2', 2, 80),
('C4301', 'Block 4', 301, 70),
('C1404', 'Block 1', 404, 50),
('C6110', 'Block 6', 110, 65);

-- Insert data into Semester table
INSERT INTO Semester (Semester_ID, Semester_Name, Year, Start_Date, End_Date) VALUES
('FALL24', 'Fall 2024', 2024, '2024-08-20', '2024-12-15'),
('SPR25', 'Spring 2025', 2025, '2025-01-10', '2025-05-05'),
('FALL25', 'Fall 2025', 2025, '2025-08-21', '2025-12-16'),
('SPR26', 'Spring 2026', 2026, '2026-01-12', '2026-05-08'),
('FALL26', 'Fall 2026', 2026, '2026-08-22', '2026-12-18'),
('SPR27', 'Spring 2027', 2027, '2027-01-11', '2027-05-07');

-- Insert data into Faculty table
INSERT INTO Faculty (Faculty_ID, Name, Email, Department_ID) VALUES
('FCS01', 'Dr. Evelyn Reed', 'e.reed@university.edu', 'CS'),
('FEC01', 'Dr. Samuel Chen', 's.chen@university.edu', 'EC'),
('FME01', 'Prof. Priya Sharma', 'p.sharma@university.edu', 'ME'),
('FCV01', 'Dr. Ben Carter', 'b.carter@university.edu', 'CV'),
('FBT01', 'Dr. Olivia Kim', 'o.kim@university.edu', 'BT'),
('FCS02', 'Dr. Raj Patel', 'r.patel@university.edu', 'CS');

-- Insert data into Student table
INSERT INTO Student (Student_ID, Name, Email, Phone, Department_ID) VALUES
('STU001', 'Alice Johnson', 'alice.j@student.edu', '9876543210', 'CS'),
('STU002', 'Bob Williams', 'bob.w@student.edu', '9876543211', 'EC'),
('STU003', 'Charlie Brown', 'charlie.b@student.edu', '9876543212', 'ME'),
('STU004', 'Diana Miller', 'diana.m@student.edu', '9876543213', 'CS'),
('STU005', 'Ethan Davis', 'ethan.d@student.edu', '9876543214', 'CV'),
('STU006', 'Fiona Garcia', 'fiona.g@student.edu', '9876543215', 'BT');

-- Insert data into Course table
INSERT INTO Course (Course_ID, Course_Name, Credits, Department_ID, Faculty_ID) VALUES
('CS101', 'Intro to Python', 4, 'CS', 'FCS01'),
('EC202', 'Digital Circuits', 4, 'EC', 'FEC01'),
('ME301', 'Thermodynamics', 3, 'ME', 'FME01'),
('CS351A', 'Database Management', 4, 'CS', 'FCS02'),
('CV210', 'Surveying', 3, 'CV', 'FCV01'),
('BT150', 'Cell Biology', 4, 'BT', 'FBT01');

-- Insert data into Registration table
INSERT INTO Registration (Student_ID, Course_ID, Reg_Date) VALUES
('STU001', 'CS101', '2025-08-15'),
('STU001', 'CS351A', '2025-08-15'),
('STU002', 'EC202', '2025-08-16'),
('STU003', 'ME301', '2025-08-16'),
('STU004', 'CS351A', '2025-08-17'),
('STU005', 'CV210', '2025-08-17'),
('STU006', 'BT150', '2025-08-18');

-- Insert data into Schedule table
INSERT INTO Schedule (Course_ID, Semester_ID, Classroom_ID, Day, Time_Slot) VALUES
('CS101', 'FALL25', 'C5201', 'Monday', '09:00-10:00'),
('CS101', 'FALL25', 'C5201', 'Wednesday', '09:00-10:00'),
('EC202', 'FALL25', 'C3105', 'Tuesday', '11:00-12:00'),
('ME301', 'FALL25', 'C2G02', 'Thursday', '14:00-15:00'),
('CS351A', 'FALL25', 'C5201', 'Tuesday', '10:00-11:00'),
('CV210', 'FALL25', 'C4301', 'Friday', '09:00-10:00'),
('BT150', 'FALL25', 'C1404', 'Monday', '13:00-14:00');

--
-- Advanced Database Objects
--

-- Change the delimiter for multi-line objects
DELIMITER $$

-- 1. Stored Procedure: Get a student's registered courses
CREATE PROCEDURE sp_GetStudentRegistrations(IN p_Student_ID VARCHAR(15))
BEGIN
    SELECT 
        S.Name AS Student_Name,
        C.Course_ID,
        C.Course_Name,
        R.Reg_Date,
        R.Grade,
        R.Reg_ID
    FROM Registration R
    JOIN Course C ON R.Course_ID = C.Course_ID
    JOIN Student S ON R.Student_ID = S.Student_ID
    WHERE R.Student_ID = p_Student_ID;
END$$

-- 2. Stored Function: Get current enrollment count for a course
CREATE FUNCTION fn_GetCourseEnrollmentCount(p_Course_ID VARCHAR(10))
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_count INT;
    
    SELECT COUNT(*) INTO v_count
    FROM Registration
    WHERE Course_ID = p_Course_ID;
    
    RETURN v_count;
END$$

-- 3. Trigger: Check classroom capacity BEFORE inserting a new registration
CREATE TRIGGER trg_CheckCapacity
BEFORE INSERT ON Registration
FOR EACH ROW
BEGIN
    DECLARE v_capacity INT;
    DECLARE v_current_enrollment INT;
    DECLARE v_classroom_id VARCHAR(10);

    -- 1. Find the classroom for this course
    SELECT Classroom_ID INTO v_classroom_id
    FROM Schedule
    WHERE Course_ID = NEW.Course_ID
    LIMIT 1;
    
    -- 2. If a classroom is assigned, get its capacity
    IF v_classroom_id IS NOT NULL THEN
        SELECT Capacity INTO v_capacity
        FROM Classroom
        WHERE Classroom_ID = v_classroom_id;
        
        -- 3. Get the current number of students registered
        SET v_current_enrollment = fn_GetCourseEnrollmentCount(NEW.Course_ID);
        
        -- 4. Check if the class is full
        IF v_current_enrollment >= v_capacity THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: Cannot register. The class is full.';
        END IF;
    END IF;
END$$

-- Reset delimiter back to normal
DELIMITER ;