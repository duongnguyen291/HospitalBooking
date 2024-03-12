-- Create the Hospital database
CREATE DATABASE Hospital;
GO

USE Hospital;
GO

-- Create the Specialization table
CREATE TABLE Specialization (
    Specialization_ID INT PRIMARY KEY,
    Specialization_Name VARCHAR(255),
    Department VARCHAR(255)
);

-- Create the staff table
CREATE TABLE staff (
    Staff_ID INT PRIMARY KEY IDENTITY,
    Name VARCHAR(255),
    Specialization_ID INT,
    Salary FLOAT,
    Phone INT,
    Address VARCHAR(255),
    DOB DATE,
    Gender CHAR(1),
    FOREIGN KEY (Specialization_ID) REFERENCES Specialization(Specialization_ID) ON DELETE CASCADE
);


-- Create the Service table
CREATE TABLE Service (
    Service_ID INT PRIMARY KEY,
    Name VARCHAR(255),
    Value INT,
    Specialization_ID INT,
    FOREIGN KEY (Specialization_ID) REFERENCES Specialization(Specialization_ID)
);

-- Create the Patient table
CREATE TABLE Patient (
    Patient_ID INT PRIMARY KEY IDENTITY,
    Name VARCHAR(255),
    Phone VARCHAR(255),
    Address VARCHAR(255),
    DOB DATE,
    Health_Insurance VARCHAR(255),
    Gender CHAR(1),
);

-- Create the Account table
CREATE TABLE Account (
    Account_ID INT PRIMARY KEY IDENTITY,
    Email VARCHAR(100) UNIQUE,
    Password VARCHAR(50) NOT NULL,
    Staff_ID INT,
    Patient_ID INT,
    Type_Of_Account INT NOT NULL,
    FOREIGN KEY (Staff_ID) REFERENCES staff(Staff_ID),
    FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID)
);

-- Create the Room table
CREATE TABLE Room (
    Room_ID INT PRIMARY KEY,
    Name VARCHAR(255),
    Type VARCHAR(255),
    Value INT
);

-- Create the Appointment table
CREATE TABLE Appointment (
    Appointment_ID INT PRIMARY KEY IDENTITY,
    Patient_ID INT NOT NULL,
    Staff_ID INT NOT NULL,
    Service_ID INT NOT NULL,
    Date DATE NOT NULL,
    Start_Hour Time NOT NULL,
    End_Hour Time NOT NULL,
    Room_ID INT NOT NULL,
    Payment VARCHAR(255),
    Status VARCHAR(255) NOT NULL,
	Created_At Time Default GETDATE(),
    FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID),
    FOREIGN KEY (Staff_ID) REFERENCES staff(Staff_ID),
    FOREIGN KEY (Service_ID) REFERENCES Service(Service_ID),
    FOREIGN KEY (Room_ID) REFERENCES Room(Room_ID)
);



Create View DocAppInfo as
Select staff.Staff_ID as ID , staff.Name as Name , count(Distinct Appointment.Appointment_ID) as SoLuong , Appointment.Start_Hour as TGBD, Appointment.End_Hour as TGKT from staff
join Appointment on staff.Staff_ID=Appointment.Staff_ID
Group By staff.Staff_ID,staff.Name,Appointment.Start_Hour,Appointment.End_Hour



create view PatAppInfo as
Select Patient.Patient_ID, Patient.Name , Count(Distinct Appointment.Appointment_ID) as SoCuocHen, Appointment.Start_Hour , Appointment.End_Hour  from Patient
Join Appointment on Patient.Patient_ID=Appointment.Patient_ID
Group by Patient.Patient_ID, Patient.Name,Appointment.Start_Hour, Appointment.End_Hour



Create Trigger CheckAPPStartTime
On Appointment
for Insert
as 
	declare @starttime Time, @staffid INT ,@appday DATE, @created TIME
	select @created = created_at From inserted
	select @starttime= Start_Hour From inserted
	select @staffid=Staff_ID from inserted
	Select @appday = Date from inserted
if(Exists(select Appointment.Start_Hour From Appointment 
			where Appointment.Staff_ID=@staffid
			and Appointment.Date = @appday
			And Appointment.Start_Hour <= @starttime
			and Appointment.End_Hour > @starttime
			and Appointment.Status NOT LIKE 'Cancel'
			and Appointment.Created_At != @created  )
)
begin
print 'CheckAPPStartTime FAIL'
rollback
end
else
print 'CheckAPPStartTime  Accepted'

Create Trigger CheckAppRoom
On Appointment
for Insert
as
	declare @starttime1 Time, @RoomID INT, @appday1 DATE, @created TIME
	select @starttime1 = Start_Hour from inserted
	select @appday1 = Date from inserted
	select @RoomID = Room_ID from inserted
if(Exists(select Appointment.Start_Hour From Appointment
			where Appointment.Room_ID=@RoomID
			and Appointment.Date = @appday1
			and Appointment.Start_Hour <= @starttime1
			and Appointment.End_Hour > @starttime1
			and Appointment.Status NOT LIKE 'Cancel'
            and Appointment.Created_At != @created)
)
begin 
print 'CheckAppRoom FAIL' 
rollback
end
else
print 'CheckAppRoom Accepted'

Create Index ix_staff_name
on staff(name);

create index ix_service_name
on service(name);

create index ix_patient_info
on patient(Name , DOB);

create unique index ix_patient_hi
on patient(Health_Insurance);

Create unique index ix_account_login
on account(email,password);

create index ix_room_name
on room(name);

create index ix_appointment_info
on appointment(Date,Start_Hour,End_Hour,status);

-- Specialization Table
INSERT INTO Specialization (Specialization_ID, Specialization_Name, Department)
VALUES
(1, 'Cardiology', 'Medicine'),
(2, 'Orthopedics', 'Surgery'),
(3, 'Dentistry', 'Dental'),
(4, 'Neurology', 'Medicine'),
(5, 'Ophthalmology', 'Surgery'),
(6, 'Pediatrics', 'Medicine'),
(7, 'Dermatology', 'Medicine'),
(8, 'Gastroenterology', 'Medicine'),
(9, 'Obstetrics and Gynecology', 'Surgery'),
(10, 'Urology', 'Surgery'),
(11, 'Otolaryngology', 'Surgery'),
(12, 'Psychiatry', 'Medicine'),
(13, 'Endocrinology', 'Medicine'),
(14, 'Radiology', 'Diagnostic'),
(15, 'Oncology', 'Medicine'),
(16, 'Emergency Medicine', 'Emergency'),
(17, 'Nephrology', 'Medicine'),
(18, 'Rheumatology', 'Medicine'),
(19, 'Hematology', 'Medicine'),
(20, 'Allergy and Immunology', 'Medicine');

-- Staff Table
INSERT INTO staff (Name, Specialization_ID, Salary, Phone, Address, DOB, Gender)
VALUES
('Dr. Smith', 1, 80000, 12367890, '123 Main St', '1980-05-15', 'M'),
('Dr. Johnson', 2, 75000, 1876510, '456 Oak St', '1975-08-20', 'F'),
('Dr. Davis', 4, 90000,1551567, '789 Pine St', '1982-03-10', 'M'),
('Dr. Miller', 6, 85000, 19876543, '234 Birch St', '1978-09-25', 'F'),
('Dr. Anderson', 7, 90000, 1123567, '789 Oak St', '1983-02-14', 'M'),
('Dr. Wilson', 8, 85000, 12347890, '567 Oak St', '1976-06-20', 'M'),
('Dr. Martinez', 9, 90000, 18543210, '789 Pine St', '1980-02-15', 'F'),
('Dr. Harris', 11, 95000, 1513567, '234 Birch St', '1972-09-10', 'M'),
('Dr. Taylor', 13, 88000, 15576543, '678 Maple St', '1985-03-25', 'F'),
('Dr. King', 14, 92000, 1634567, '890 Elm St', '1979-11-14', 'M'),
('Dr. Young', 15, 87000, 17725678, '345 Cedar St', '1987-08-30', 'F'),
('Dr. Lee', 16, 89000, 18834789, '456 Birch St', '1982-05-18', 'M'),
('Dr. White', 17, 86000, 19947890, '567 Pine St', '1988-12-01', 'F'),
('Dr. Turner', 18, 93000, 20078901, '678 Oak St', '1983-07-10', 'M'),
('Dr. Allen', 19, 91000, 2189012, '789 Cedar St', '1986-04-05', 'F'),
('Dr. Scott', 20, 92000, 22290123, '890 Elm St', '1981-01-20', 'M'),
('Dr. Hughes', 8, 94000, 2301234, '123 Maple St', '1974-10-15', 'F'),
('Dr. Wright', 9, 96000, 2442345, '234 Cedar St', '1970-07-30', 'M'),
('Dr. Robinson', 11, 89000, 2523456, '345 Pine St', '1984-04-25', 'F'),
('Dr. Evans', 13, 88000, 26614567, '456 Oak St', '1977-01-10', 'M'),
('Dr. Foster', 14, 90000, 27345678, '567 Elm St', '1989-09-05', 'F'),
('Dr. Reed', 15, 87000, 2886789, '678 Birch St', '1980-06-20', 'M'),
('Dr. Baker', 16, 91000, 29967890, '789 Cedar St', '1983-03-15', 'F'),
('Dr. Murphy', 17, 94000, 30056781, '890 Pine St', '1975-12-01', 'M'),
('Dr. Rivera', 18, 95000, 31167890, '123 Elm St', '1988-08-10', 'F'),
('Dr. NGUYEN HONG PHUONG', 18, 1000, 03365623, '1 DAI CO VIET', '1988-08-10', 'M');

-- Service Table
INSERT INTO Service (Service_ID, Name, Value, Specialization_ID)
VALUES
(101, 'Cardiac Checkup', 150, 1),
(102, 'Orthopedic Consultation', 120, 2),
(103, 'MRI Scan', 200, 4),
(104, 'Dental Cleaning', 80, 3),
(105, 'Pediatric Checkup', 130, 6),
(106, 'Dermatological Consultation', 110, 7),
(107, 'Gastrointestinal Endoscopy', 180, 8),
(108, 'Prenatal Care', 160, 9),
(109, 'Urinary Tract Surgery', 250, 10),
(110, 'ENT Consultation', 120, 11),
(111, 'Psychiatric Evaluation', 200, 12),
(112, 'Thyroid Function Test', 90, 13),
(113, 'CT Scan', 220, 14),
(114, 'Chemotherapy', 280, 15),
(115, 'Emergency Room Visit', 150, 16),
(116, 'Kidney Biopsy', 200, 17),
(117, 'Rheumatoid Arthritis Treatment', 170, 18),
(118, 'Bone Marrow Biopsy', 230, 19),
(119, 'Allergy Testing', 110, 20);
SELECT * FROM Patient
-- Patient Table
INSERT INTO Patient (Name, Phone, Address, DOB, Health_Insurance, Gender)
VALUES
('John Doe', '157891234', '567 Elm St', '1990-12-05', '1234233245678', 'M'),
('Jane Smith', '14567890', '789 Maple St', '1985-07-18', '8765433242321', 'F'),
('Emily Johnson', '14567890', '456 Cedar St', '1995-04-30', '23423453456789', 'F'),
('Michael Brown', '8889876543', '678 Pine St', '2000-11-12', '9873465432', 'M'),
('Sophia Turner', '9991234567', '890 Oak St', '1998-09-20', '34567364890', 'F'),
('David Johnson', '3334567890', '123 Birch St', '1982-03-15', '81787654321', 'M'),
('Amanda Miller', '7775551234', '234 Pine St', '1993-08-27', '2345662789', 'F'),
('Christopher White', '4443336789', '345 Cedar St', '1980-01-10', '3445-67890', 'M'),
('Olivia Harris', '5557890123', '456 Oak St', '1992-05-22', '1234506748', 'F'),
('Daniel Wilson', '6669876543', '567 Elm St', '1987-09-08', '98760951432', 'M'),
('Isabella Davis', '1112223344', '678 Maple St', '1997-12-03', '8748654321', 'F'),
('Andrew Taylor', '9998887777', '789 Cedar St', '1984-04-17', '2347156789', 'M'),
('Sophie Moore', '7776665555', '890 Pine St', '1996-06-25', '987654332', 'F'),
('Matthew Hall', '4445556666', '123 Oak St', '1989-11-05', '34567334890', 'M'),
('Ella Brown', '3334445555', '234 Birch St', '1991-02-14', '1234535678', 'F'),
('Nathan Clark', '1119998888', '345 Maple St', '1986-07-01', '8765345321', 'M'),
('Scarlett Evans', '6661112222', '456 Cedar St', '1994-10-12', '2333456789', 'F'),
('Logan Turner', '2223334444', '567 Pine St', '1983-12-20', '98736542332', 'M'),
('Grace King', '5552221111', '678 Elm St', '1999-04-08', '87635432421', 'F'),
('Ryan Allen', '8887776666', '789 Maple St', '1981-06-18', '234531212336789', 'M'),
('Ava Phillips', '7778889999', '890 Cedar St', '1990-09-30', '343561237890', 'F'),
('Carter Martin', '5554443333', '123 Pine St', '1998-03-07', '126341235678', 'M'),
('Lily Harris', '3332221111', '234 Elm St', '1988-08-14', '987654125332', 'F'),
('Dylan Thompson', '1115559999', '345 Maple St', '1995-01-26', '876531234321', 'M'),
('Chloe Walker', '6664442222', '456 Cedar St', '1985-04-04', '234513236789', 'F');

-- Account Table
INSERT INTO Account (Email, Password, Staff_ID, Patient_ID, Type_Of_Account)
VALUES
('admin@gmail.com','1',NULL,NULL,0),
('john.doe@example.com', 'password123', 1, NULL, 2),
('jane.smith@example.com', 'pass456', NULL, 1, 1),
('dr.smith@example.com', 'drpass789', 1, NULL, 2),
('emily.johnson@example.com', 'pass789', NULL, 3, 1),
('michael.brown@example.com', 'mikepass123', 5, NULL, 2),
('olivia.jones@example.com', 'oliviapass456', 2, NULL, 2),
('liam.white@example.com', 'liampass789', NULL, 4, 1),
('dr.anderson@example.com', 'drpass987', 5, NULL, 2),
('david.taylor@example.com', 'davidpass123', 1, NULL, 2),
('olivia.martinez@example.com', 'oliviapass456', NULL, 2, 1),
('liam.harris@example.com', 'liampass789', 3, NULL, 2),
('ella.taylor@example.com', 'ellapass987', NULL, 4, 1),
('mason.king@example.com', 'masonpass123', 5, NULL, 2),
('sophie.young@example.com', 'sophiepass456', NULL, 6, 1),
('logan.lee@example.com', 'loganpass789', 7, NULL, 2),
('ava.white@example.com', 'avapass123', NULL, 8, 1),
('noah.turner@example.com', 'noahpass456', 9, NULL, 2),
('emma.allen@example.com', 'emmapass789', NULL, 10, 1),
('mia.scott@example.com', 'miapass123', 11, NULL, 2),
('jackson.hughes@example.com', 'jacksonpass456', NULL, 12, 1),
('chloe.wright@example.com', 'chloepass789', 13, NULL, 2),
('lucas.robinson@example.com', 'lucaspass123', NULL, 14, 1),
('lily.evans@example.com', 'lilypass456', 15, NULL, 2),
('benjamin.foster@example.com', 'benjaminpass789', NULL, 16, 1),
('zoe.reed@example.com', 'zoepass123', 17, NULL, 2),
('elijah.baker@example.com', 'elijahpass456', NULL, 18, 1),
('aria.murphy@example.com', 'ariapass789', 19, NULL, 2),
('grayson.rivera@example.com', 'graysonpass123', NULL, 20, 1),
('langcochiquy@gmail.com', '1', 24, NULL, 2);

-- Room Table
INSERT INTO Room (Room_ID, Name, Type, Value)
VALUES
(201, 'Room-01', 'Standard', 100),
(202, 'Room-02', ' Standard', 200), 
(203, 'Room-03', 'Specialized', 150),
(204, 'Room-04', 'Deluxe', 250),
(205, 'Room-05', 'Standard', 120),
(206, 'Room-06', 'Specialized', 180),
(207, 'Room-07', 'Deluxe', 300),
(208, 'Room-08', ' Standard', 220),
(209, 'Room-09', 'Specialized', 170),
(210, 'Room-10', 'Deluxe', 270),
(211, 'Room-11', ' Standard', 190),
(212, 'Room-12', 'Specialized', 160),
(213, 'Room-13', 'Deluxe', 280),
(214, 'Room-14', ' Standard', 210),
(215, 'Room-15', 'Specialized', 140),
(216, 'Room-16', 'Deluxe', 260),
(217, 'Room-17', ' Standard', 230),
(218, 'Room-18', 'Specialized', 200),
(219, 'Room-19', 'Deluxe', 290),
(220, 'Room-20', ' Standard', 240),
(221, 'Room-21', 'Specialized', 170),
(222, 'Room-22', 'Deluxe', 310),
(223, 'Room-23', ' Standard', 250),
(224, 'Room-24', 'Specialized', 180),
(225, 'Room-25', 'Deluxe', 330),
(226, 'Room-26', ' Standard', 270);
-- Appointment Table
INSERT INTO Appointment (Patient_ID, Staff_ID, Service_ID, Date, Start_Hour, End_Hour, Room_ID, Payment, Status)
VALUES
(1, 1, 101, '2024-02-10', '09:00:00', '10:30:00', 201, 'Cash', 'Completed'),
(2, 2, 102, '2024-02-15', '14:30:00', '16:00:00', 202, 'Cash', 'Completed'),
(2, 1, 101, '2024-02-20', '11:00:00', '12:30:00', 201, 'Credit Card', 'Completed'),
(3, 5, 105, '2024-03-05', '10:30:00', '11:45:00', 204, 'Credit Card', 'Completed'),
(1, 5, 106, '2024-03-10', '15:00:00', '16:30:00', 205, 'Credit Card', 'Completed'),
(4, 4, 105, '2024-03-15', '13:45:00', '15:00:00', 204, 'Credit Card', 'Completed'),
(5, 2, 102, '2024-04-05', '11:30:00', '13:00:00', 202, 'Insurance', 'Completed'),
(3, 1, 106, '2024-04-10', '14:00:00', '15:30:00', 205, 'Insurance', 'Completed'),
(5, 4, 103, '2024-04-15', '09:45:00', '11:15:00', 203, 'Insurance', 'Completed'),
(13, 9, 110, '2024-10-01', '10:30:00', '12:00:00', 210, 'Credit Card', 'Completed'),
(14, 10, 111, '2024-10-05', '14:00:00', '15:30:00', 211, 'Insurance', 'Completed'),
(15, 11, 112, '2024-10-10', '11:30:00', '13:00:00', 212, 'Cash', 'Completed'),
(16, 12, 113, '2024-10-15', '09:00:00', '10:15:00', 213, 'Credit Card', 'Completed'),
(17, 13, 114, '2024-11-01', '15:00:00', '16:30:00', 214, 'Cash', 'Completed'),
(18, 14, 115, '2024-11-05', '13:30:00', '15:00:00', 215, 'Credit Card', 'Completed'),
(19, 15, 116, '2024-11-10', '10:30:00', '12:00:00', 216, 'Cash', 'Completed'),
(20, 16, 117, '2024-11-15', '14:15:00', '15:30:00', 217, 'Credit Card', 'Completed'),
(21, 17, 118, '2024-12-01', '11:00:00', '12:30:00', 218, 'Cash', 'Completed'),
(22, 18, 119, '2024-12-05', '09:45:00', '11:00:00', 219, 'Credit Card', 'Completed'),
(6, 3, 104, '2024-04-20', '12:00:00', '13:30:00', 203, 'Cash', 'Completed'),
(7, 6, 107, '2024-05-05', '09:30:00', '11:00:00', 206, 'Credit Card', 'Completed'),
(8, 7, 108, '2024-05-10', '14:45:00', '16:00:00', 207, 'Cash', 'Completed'),
(9, 8, 109, '2024-05-15', '10:15:00', '11:30:00', 208, 'Credit Card', 'Completed'),
(10, 9, 110, '2024-06-01', '15:30:00', '17:00:00', 209, 'Insurance', 'Completed'),
(11, 10, 111, '2024-06-05', '11:45:00', '13:15:00', 210, 'Insurance', 'Completed'),
(12, 11, 112, '2024-06-10', '09:15:00', '10:30:00', 211, 'Cash', 'Completed'),
(13, 12, 113, '2024-06-15', '14:30:00', '16:00:00', 212, 'Credit Card', 'Completed'),
(14, 13, 114, '2024-07-01', '10:00:00', '11:15:00', 213, 'Cash', 'Completed'),
(15, 14, 115, '2024-07-05', '13:45:00', '15:15:00', 214, 'Credit Card', 'Completed'),
(16, 15, 116, '2024-07-10', '11:30:00', '12:45:00', 215, 'Cash', 'Completed'),
(17, 16, 117, '2024-07-15', '14:15:00', '15:30:00', 216, 'Credit Card', 'Completed'),
(18, 17, 118, '2024-08-01', '10:45:00', '12:15:00', 217, 'Cash', 'Completed'),
(19, 18, 119, '2024-08-05', '09:30:00', '10:45:00', 218, 'Credit Card', 'Completed'),
(20, 19, 101, '2024-08-10', '15:00:00', '16:30:00', 219, 'Cash', 'Completed'),
(21, 20, 102, '2024-08-15', '13:30:00', '14:45:00', 220, 'Credit Card', 'Completed'),
(22, 21, 103, '2024-09-01', '09:15:00', '10:30:00', 221, 'Cash', 'Completed'),
(22, 22, 104, '2024-09-05', '14:00:00', '15:30:00', 222, 'Credit Card', 'Completed');