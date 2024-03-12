exports.loggedin = (req, res, next) => {
    if (req.session.loggedinUser) {
        res.locals.user = req.session.user
        next();
    } else {
        res.redirect('/login')
    }
}

exports.isAuth = (req, res, next) => {
    if (req.session.loggedinUser) {
        res.locals.user = req.session.user
        res.redirect('/patientSchedule');
    } else {
        next();
    }
}