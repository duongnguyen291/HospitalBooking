const Patient = require('../models/patient.model')

exports.updateInfo = (req, res) => {
    console.log("controller >> ", req.body);
    const data = req.body;
    const user = req.session.user;
    const gender = req.body?.woman == 'on' ? 1 : 0
    
    const p = new Patient({
        Account_ID: user.Account_ID,
        Name: data.Name,
        Phone: data.Phone,
        Address: data.Address,
        DOB: data.DOB,
        Health_Insurance: data.Health_Insurance,
        Gender: gender,
    })

    Patient.create(p, (err, user) => {
        if (!err) {
        } else {
            console.log(err);
        }
        console.log("Test >> ", user);
        req.session.loggedinUser = true;
        req.session.user = user;
        res.redirect('/patientSchedule');
    })
}