var express = require('express');
var router = express.Router();
var manager = require('../manager');
var config = require('config');

router.post('/', function(req, res, next) {
    manager.close();
    res.send(config.successMessage);
});

module.exports = router;
