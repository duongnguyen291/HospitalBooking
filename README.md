# Database Lab (IT3290E) Final Project - ICT K67 - HUST

# Hospital Appointment Bookking Website 
In today's era, one of the significant challenges that patients often face is the process of queuing up and scheduling medical appointments. This not only consumes a considerable amount of time and effort for the patients but also introduces uncertainty in securing desired appointment slots. Then, we introduce a modern solution to alleviate the burden on patients through the Electronic Appointment Booking System. 

## Overview

### Database Schema
![Architecture](https://github.com/qinshihuangtheconqueror/ProjectDatabase/blob/finalHUy/ERD%20hospital.png)

### Technical Specifications
* Frontend: EJS, CSS, Javascript
* Backend: ExpressJS
* Database: SQL Sever

### Features
- Authentication: Login – Signup-Logout
- Authorization:
  - Restrict users, admin, guides what they can do
- Admin:
  - An admin account is provided
  - Create, read, update the appointment status
  - Approve - Reject - Complete
  - Add/Remove Doctors
  - View the total doctors, patient, appointment,..
 - Send mail to doctors to notice they schedule
 -See the number of patients, Doctors, pending appointment, approved appointment
- Users:
  - Appointment Booking
  - View their schedule history 
- Doctors:
  - The appointment information is sent to doctor's email

## Setup
1. Press the *Fork* button (top right the page) to save copy of this project on your account.
2. Download the repository files (project) from the download section or clone this project to your local machine by typing in the bash the following command:
       git clone 
3. Install some essential libraries: npm install
4. Import & execute the SQL queries from the Database folder to the SQL Sever. Config the .env file of yours.
5. Import the project in any IDE that support the aforementioned programming languages.
6. Deploy & Run the application with npm start 😃

## Project Structure
    ├── controllers  # tables and queries used for this project
    ├── middlewares #    access to the request object (req), the response object (res), and the next middleware function in the application’s request-response cycle
    ├── models# handling functional related to the application
    ├── routes#    mapping HTTP requests to specific controllers and actions, helping to organize and structure the application's logic        
    ├── utils#  encapsulate common operations and avoid code duplication
    ├── views#  handling frontend application
    ├── .env# set up environment for running
    ├── .gitignore
    ├── README.md
    ├── app.js# configure and set up Express.js application, define middleware, and start the server
    ├── dbConfig.js # connect web with database
    ├── hospitalsql.sql
    ├── package-lock.json
    └── package.json


### Contributing 🔧
If you want to contribute to this project and make it better with new ideas, your pull request is very welcomed.
If you find any issue just put it in the repository issue section, thank you.

## Collaborators
<table>
    <tbody>
        <tr>
            <th align="center">Member name</th>
            <th align="center">Student ID</th>
        </tr>
        <tr>
            <td>Nguyễn Đình Dương</td>
            <td align="center"> 20225966&nbsp;&nbsp;&nbsp;</td>
        </tr>
        <tr>
            <td>Lê Hoàng Huy</td>
            <td align="center">20225976&nbsp;&nbsp;&nbsp;</td>
        </tr>
        <tr>
            <td>Trần Việt Anh</td>
            <td align="center"> 20226013&nbsp;&nbsp;&nbsp;</td>
        </tr>
        <tr>
            <td>Nguyễn Trọng Minh Phương</td>
            <td align="center"> 20225976&nbsp;&nbsp;&nbsp;</td>
        </tr>
    </tbody>
</table>
