module.exports = app => {
    require('./auth.user')(app);
    require('./admin')(app);
    require('./web')(app);
    require('./auth.admin')(app);
}