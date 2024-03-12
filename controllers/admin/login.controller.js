const admin = require('../../models/admin.model');

exports.showLoginForm = (req, res) => {
    res.render('adminLogin');
}

exports.login = (req, res) => {
    const { email, password } = req.body;
    if (email && password) {
        admin.findByEmail(email, (err, admin) => {
            if (!admin) {
                res.redirect('/adminLogin');
            } else {
                    if (password == admin.Password) {
                        req.session.loggedinAdmin = true;
                        req.session.loggedinUser = false;
                        req.session.admin = admin;
                        res.redirect('/adminDoctors');
                    } else {
                        // A admin with that email address does not exists
                        const conflictError = 'Admin credentials are not valid!';
                        res.render('adminLogin', { email, password, conflictError });
                    }
            }
        })
    } else {
        // A admin with that email address does not exists
        const conflictError = 'No matched account!';
        res.render('adminLogin', { email, password, conflictError });
    }
}

exports.logout = (req, res) => {
    req.session.destroy((err) => {
        if (err) res.redirect('/500');
        res.redirect('/');
    })
}