exports.loggedin = (req, res, next) => {
    if (req.session.loggedinAdmin) {
        res.locals.user = req.session.user
        next();
    } else {
        res.redirect('/adminLogin')
    }
}

exports.isAuth = (req, res, next) => {
    if (req.session.loggedinAdmin) {
        res.locals.user = req.session.user
        res.redirect('/adminDoctors');
    } else {
        next();
    }
}