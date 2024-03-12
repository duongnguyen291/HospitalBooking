var router = require('express').Router();
const login = require('../controllers/auth/login.controller');
const register = require('../controllers/auth/register.controller');
const authMiddleware = require('../middlewares/auth.middleware');

module.exports = app => {
    router.get('/login', authMiddleware.isAuth, login.showLoginForm)
    
    .post('/login', (req, res) => {
        login.login(req, res); 
    })

    .post('/register', (req, res) => {
        register.register(req, res); 
    })

    .get('/logout', authMiddleware.loggedin, login.logout)
    app.use(router);
}