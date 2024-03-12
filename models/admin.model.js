var config=require('../dbConfig');
const sql= require('msnodesqlv8');

const admin = function(admin){
    this.name = admin.name;
    this.password = admin.password;
    this.email = admin.email;
};

admin.findByEmail = (email, result) => {
    sql.query(config, `SELECT * from account WHERE email = '${email}' AND Type_Of_Account = 0`, (err, res) => {
        if (err) {
            result(err, null);
            return;
        }
        if (res.length) {
            result(null, res[0])
            return;
        }
        result(null, null);
    });
}

module.exports = admin;