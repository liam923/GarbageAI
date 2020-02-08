const express = require('express');
const router = express.Router();
const config = require('config');

function setPositive(req, parameterName, configName) {
    if (parameterName in req.query) {
        const num = Number(req.query[parameterName]);
        if (!isNaN(num) && num > 0) {
            config[configName] = req.query[parameterName];
        }
    }
}

function setString(req, parameterName, configName) {
    if (parameterName in req.query) {
        config[configName] = req.query[parameterName];
    }
}

router.put('/', function(req, res, next) {
    setPositive(req, "openTime", "openTime");
    setPositive(req, "forever", "forever");
    setPositive(req, "openDutyCycle", "openDutyCycle");
    setPositive(req, "closeDutyCycle", "closeDutyCycle");
    setPositive(req, "servoGPIO", "servoGPIO");

    setString(req, "successMessage", "successMessage");
    setString(req, "forbiddenMessage", "forbiddenMessage");
    setString(req, "accessToken", "accessToken");

    res.send(config.successMessage);
});

module.exports = router;
