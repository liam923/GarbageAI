var createError = require('http-errors');
var express = require('express');
var path = require('path');
var logger = require('morgan');
var config = require('config');
var passport = require("passport");
var Strategy = require('passport-http-bearer').Strategy;

var openRouter = require('./routes/open');
var closeRouter = require('./routes/close');
var setDefaultsRouter = require('./routes/set-default');

var app = express();

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));

passport.use(new Strategy(
    function(token, cb) {
      return cb(null, token == config.accessToken);
    }
));

app.use('/open', passport.authenticate('bearer', { session: false }), openRouter);
app.use('/close', passport.authenticate('bearer', { session: false }), closeRouter);
app.use('/set-default', passport.authenticate('bearer', { session: false }), setDefaultsRouter);

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  next(createError(404));
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.send('error');
});

module.exports = app;
