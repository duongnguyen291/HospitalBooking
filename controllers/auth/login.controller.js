const User = require('../../models/user.model');

exports.showLoginForm = (req, res) => {
    res.render('login');
}

exports.login = (req, res) => {
    const { email, password } = req.body;
    if (email && password) {
        User.findByEmail(email, (err, user) => {
            if (!user) {
                res.redirect('/login');
            } else {
                    if (password == user.Password) {
                        req.session.loggedinUser = true;
                        req.session.loggedinAdmin = false;
                        req.session.user = user;
                        res.redirect('/patientSchedule');
                    } else {
                        // A user with that email address does not exists
                        const conflictError = 'User credentials are not valid!';
                        res.render('login', { email, password, conflictError });
                    }
            }
        })
    } else {
        // A user with that email address does not exists
        const conflictError = 'No matched account!';
        res.render('login', { email, password, conflictError });
    }
}

exports.logout = (req, res) => {
    req.session.destroy((err) => {
        if (err) res.redirect('/500');
        res.redirect('/');
    })
}