const nodemailer = require('nodemailer');
const utils = require('../utils/utils')

module.exports = app => {
  const router = require('express').Router();
  var config = require('../dbConfig');
  const sql = require('msnodesqlv8');
  const authMiddleware = require('../middlewares/auth.middleware.admin')

  router.get('/adminDoctors', authMiddleware.loggedin, async (req, res) => {
    sql.query(config, 'SELECT * FROM staff JOIN specialization ON staff.specialization_id = specialization.specialization_id', (err, results) => {
      const doctors = results;
      doctors.forEach(doctor => {
        router.get(`/adminDoctors/${doctor.Staff_ID}`, authMiddleware.loggedin, (req, res) => {
          const options = { day: '2-digit', month: '2-digit', year: 'numeric' };
          const formattedDate = new Date(doctor.DOB).toLocaleDateString('en-GB', options);
          res.render('adminDoctorIn4', { doctor, formattedDate });
        });
      });
      sql.query(config, 'SELECT COUNT(staff_id) AS staffCount FROM staff', (err, countResult) => {
        const staffCount = countResult[0].staffCount;
        sql.query(config, 'SELECT COUNT(patient_id) AS patientCount FROM Patient', (err, countRes) => {
          const patientCount = countRes[0].patientCount;
          sql.query(config, 'SELECT * FROM Specialization', (err, countResu) => {
            const specializations = countResu;
            res.render('adminDoctors', { doctors, staffCount, patientCount, specializations });
          });
        })
      });
    });
  });

  router.post('/adminDoctors', async (req, res) => {
    const { Name, Phone, Specialization, Salary, Address, Gender, DOB } = req.body;

    if (Name && Specialization) {
      // Insert into staff table
      sql.query(config, 'INSERT INTO staff (Name, Salary, Phone, Address, DOB, Specialization_ID, Gender) VALUES (?, ?, ?, ?, ?, ?, ?)', [Name, Salary, Phone, Address, DOB, Specialization, Gender], (err, result) => {

        // Retrieve the last inserted Staff_ID
        sql.query(config, 'SELECT TOP 1 Staff_ID FROM staff ORDER BY Staff_ID DESC;', (err, result) => {

          const staffID = result[0].Staff_ID;
          console.log(staffID);

          // Construct email and insert into account table
          const formattedName = Name.toLowerCase().replace(/\s+/g, '_');
          const Email = `${formattedName}@gmail.com`;
          console.log(Email);
          sql.query(config, 'INSERT INTO account (Email, Password, Staff_ID, Type_Of_Account) VALUES (?, ?, ?, ?)', [Email, '123456', staffID, 2], (err, result) => {
            if (err) {
                console.error("Error inserting into account table:", err);
                // Handle the error, e.g., send an error response to the client
                return res.status(500).json({ error: "Internal Server Error" });
            }
        
            // Query was successful, you can proceed with other tasks or send a success response
            console.log("Account record inserted successfully");
            res.status(200).json({ message: "Account created successfully" });
        });
        });
      });
    }
  });


  router.delete('/adminDoctors', async (req, res) => {
    const { Staff_Id } = req.body;
    
    // Check if the Staff_Id for removing the doctor is present
    if (Staff_Id) {
      // Remove the doctor from the database using Staff_Id
      sql.query(config, ' DELETE FROM Appointment WHERE Staff_ID = ?', [Staff_Id], (err, result) => {
        sql.query(config, 'DELETE FROM Account WHERE Staff_ID = ?', [Staff_Id], (err, result) => {
          sql.query(config,'DELETE FROM staff WHERE Staff_ID = ?', [Staff_Id], (err, result) =>{
            if (err) {
              console.error('Error removing doctor: ', err);
              res.status(500).json({ error: 'Error removing doctor' });
              return;
            }
            // If the deletion was successful, send a success response
            res.status(200).json({ message: 'Doctor removed successfully' });
          })
      });
    }
    );
    } else {
      // If Staff_Id is missing, respond with an error
      res.status(400).json({ error: 'Missing doctor ID' });
    }
  });
  router.post('/adminDoctors/in4', authMiddleware.loggedin, (req, res) => {
    const { doctorId } = req.body;
    let doctor;
    sql.query(config, 'SELECT * FROM staff WHERE Staff_ID = ?', [doctorId], (err, result) => {
      doctor = result;
    });
    res.render('adminDoctorIn4', { doctor });
  });

  router.get('/adminAnalyst', authMiddleware.loggedin, (req, res) => {
    sql.query(config, 'SELECT * FROM staff', (err, results) => {
      const doctors = results;
      sql.query(config, 'SELECT COUNT(staff_id) AS staffCount FROM staff', (err, countResult) => {
        const staffCount = countResult[0].staffCount;
        sql.query(config, 'SELECT COUNT(patient_id) AS patientCount FROM Patient', (err, countRes) => {
          const patientCount = countRes[0].patientCount;
          res.render('adminAnalyst', { doctors, staffCount, patientCount });
        })
      });
    });
  });
  router.get('/adminAppointment', authMiddleware.loggedin, (req, res) => {
    sql.query(config, `SELECT a.Appointment_ID, a.Date, a.Start_Hour, a.Status, a.Created_At, p.Name as Patient, s.Name as Service, st.Name as Staff FROM Appointment a 
    LEFT JOIN Patient p ON a.Patient_ID = p.Patient_ID 
    JOIN staff st ON a.Staff_ID = st.Staff_ID 
    JOIN Service s ON a.Service_ID = s.Service_ID ORDER BY a.Created_At DESC;`,
      (err, results) => {
        const appointments = results || [];
        appointments.forEach(appointment => {
          appointment.Date = utils.formatDate(new Date(appointment.Date));
          appointment.Start_Hour = utils.formatHour(new Date(appointment.Start_Hour))
        });
        sql.query(config, 'SELECT * FROM staff', (err, results) => {
          const doctors = results;
          sql.query(config, 'SELECT COUNT(staff_id) AS staffCount FROM staff', (err, countResult) => {
            const staffCount = countResult[0].staffCount;
            sql.query(config, 'SELECT COUNT(patient_id) AS patientCount FROM Patient', (err, countRes) => {
              const patientCount = countRes[0].patientCount;
              sql.query(config, 'SELECT COUNT(*) AS pendingAppointment FROM Appointment WHERE Status = ?', ["Pending"], (err, countPendingAppointment) => {
                const pendingAppointment = countPendingAppointment[0].pendingAppointment;
                sql.query(config, 'SELECT COUNT(*) AS countAttend FROM Appointment WHERE Status != ?', ["Pending"], (err, countAttend) => {
                  const attend = countAttend[0].countAttend;
                  res.render('adminAppointment', { appointments, doctors, staffCount, patientCount, pendingAppointment , attend});
                })
              })
            })
          });
        });
      });
  });
  router.get('/adminPatient', authMiddleware.loggedin, (req, res) => {
    //sql.query(config, 'SELECT * FROM staff JOIN specialization ON staff.specialization_id = specialization.specialization_id', (err, results) => {      sql.query(config, 'SELECT * FROM staff JOIN specialization ON staff.specialization_id = specialization.specialization_id', (err, results) => {
    sql.query(config, 'SELECT * FROM patient', (err, results) => {
      const patients = results;
      patients.forEach(patient => {
        router.get(`/adminPatient/${patient.Patient_ID}`, authMiddleware.loggedin, (req, res) => {
          const options = { day: '2-digit', month: '2-digit', year: 'numeric' };
          const formattedDate = new Date(patient.DOB).toLocaleDateString('en-GB', options);
          res.render('adminPatientIn4', { patient, formattedDate });
        });
      });
      sql.query(config, 'SELECT COUNT(staff_id) AS staffCount FROM staff', (err, countResult) => {
        const staffCount = countResult[0].staffCount;
        sql.query(config, 'SELECT COUNT(patient_id) AS patientCount FROM Patient', (err, countRes) => {
          const patientCount = countRes[0].patientCount;
          res.render('adminPatient', { patients, staffCount, patientCount });
        })
      });
    });
  });
  router.post('/changeAppointmentStatus', (req, res) => {
    console.log("Demo >> ",req.body.newStatus, req.body.appointmentId);
    if (req.body.newStatus === "Approved") {
      sql.query(config, 'SELECT * FROM Appointment a INNER JOIN Room r ON a.Room_ID = r.Room_ID WHERE Appointment_ID = ?;', [req.body.appointmentId], (err, appointment) => {
        const a = appointment[0];
        console.log(a);
        sql.query(config, 'SELECT * FROM Account WHERE Staff_ID = ?;', [a.Staff_ID], (err, account) => {
          console.log(account[0]);
          const accountStaff = account[0];
          console.log("email use >> ",process.env.EMAIL_USER);
          console.log("email pass >> ",process.env.EMAIL_PASS);
          const transporter = nodemailer.createTransport({
            service: 'gmail',
            auth: {
              user: process.env.EMAIL_USER,
              pass: process.env.EMAIL_PASS,
            },
          });
          
          // Define the email options
          const mailOptions = {
            from: '13charlottekatakuri@gmail.com',
            to: accountStaff.Email,
            subject: 'Your upcoming appointment',
            text: `You have an appointment on ${utils.formatDate(a.Date)} at ${utils.formatHour(a.Start_Hour)} in room ${a.Name}`,
          };
          
          // Send the email
          transporter.sendMail(mailOptions, (error, info) => {
            if (error) {
              console.error('Error sending email:', error);
            } else {
              console.log('Email sent:', info.response);
            }
          });
        });
      });
    }
    sql.query(config, 'UPDATE Appointment SET Status = ? WHERE Appointment_ID = ?;', [req.body.newStatus, req.body.appointmentId], (err, results) => {
      res.redirect("/adminAppointment")
    });
  })

  app.use(router);
}