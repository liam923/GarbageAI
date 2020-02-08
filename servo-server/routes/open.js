var express = require('express');
var router = express.Router();
var manager = require('../manager');
var config = require('config');

router.post('/', function(req, res, next) {
    var duration = null;
    if ("duration" in req.query) {
        const num = Number(req.query.duration);
        if (!isNaN(num) && num > 0) {
            duration = req.query.duration;
        }
    }
    if (duration === null) {
        duration = config.openTime;
    }

    var direction = "";
    if ("direction" in req.query) {
        direction = req.query.direction;
    }
    if (direction !== "left" && direction !== "right") {
        res.status(400).send({
            message: "Expected direction to be left or right"
        });
    } else {
        manager.open(duration, direction);
        res.send(config.successMessage);
    }
});

router.post('/hold/', function(req, res, next) {
    manager.open(config.forever);
    res.send(config.successMessage);
});

module.exports = router;
