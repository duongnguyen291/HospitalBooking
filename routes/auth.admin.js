var router = require('express').Router();
const login = require('../controllers/admin/login.controller');
const authMiddleware = require('../middlewares/auth.middleware.admin');

module.exports = app => {
    router.get('/adminLogin', authMiddleware.isAuth, login.showLoginForm)
    
    .post('/adminLogin', (req, res) => {
        const { email, password } = req.body;
        console.log(req.body);

        if (email && password) {
            login.login(req, res); 
        } 
    })

    .get('/logout', authMiddleware.loggedin, login.logout)
    app.use(router);
}