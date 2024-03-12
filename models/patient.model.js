var config = require('../dbConfig');
const sql = require('msnodesqlv8');

const Patient = function (patient) {
  this.Account_ID = patient.Account_ID;
  this.Name = patient.Name;
  this.Phone = patient.Phone;
  this.Address = patient.Address;
  this.DOB = patient.DOB;
  this.Health_Insurance = patient.Health_Insurance;
  this.Gender = patient.Gender;
};

Patient.create = (newPatient, result) => {
  sql.query(config, "INSERT INTO Patient (Name, Phone, Address, DOB, Health_Insurance, Gender) OUTPUT INSERTED.Patient_ID VALUES (?, ?, ?, ?, ?, ?);",
    [newPatient.Name,
    newPatient.Phone,
    newPatient.Address,
    newPatient.DOB,
    newPatient.Health_Insurance,
    newPatient.Gender],
    (err, res) => {
      if (err) {
        console.log("error: ", err);
        return;
      }
      
      const patientID = res[0].Patient_ID;

      console.log("Created patient with ID: ", patientID);

      // Thực hiện truy vấn UPDATE
      sql.query(config, "UPDATE Account SET Patient_ID = ? WHERE Account_ID = ?", [patientID, newPatient.Account_ID], (updateErr, updateRes) => {
        if (updateErr) {
          console.log("error updating Account: ", updateErr);
          return;
        }
        sql.query(config, "SELECT * FROM Account WHERE Account_ID = ?", [newPatient.Account_ID], (error, res) => {
          if (error) {
            console.log("error Account: ", error);
            return;
          }
          if(res[0]) {
            result(null, res[0]);
          }
        });
      });
    }
  );
};

module.exports = Patient;
