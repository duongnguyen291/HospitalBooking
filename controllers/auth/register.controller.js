const User = require('../../models/user.model');
const bcrypt = require('bcrypt');
require('dotenv/config');

exports.create = (req, res) => {
    res.render('register');
}

exports.register = (req, res) => {
    const { email, password} = req.body;

    if (email && password) {
        User.findByEmail(email, (err, user) => {
            if (err || user) {
                // A user with that email address does not exists
                const conflictError = 'User credentials are exist.';
                res.render('login', { email, password, conflictError });
            }
        })

            // Create a User
            const user = new User({
                email: email,
                password: password
            });
            User.create(user, (err, user) => {
                if (!err) {
                    // console.log(user);
                    req.session.loggedinUser = true;
                    req.session.user = user;
                    res.render('updateInfo');
                } else {
                    console.log(err);
                }
            })
    } else {
        const conflictError = 'User credentials are exist.';
        res.render('login', { email, password, conflictError });
    }
}

