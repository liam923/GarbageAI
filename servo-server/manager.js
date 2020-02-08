const Gpio = require('pigpio').Gpio;
const config = require('config');

var timer = null;
const servo = new Gpio(config.servoGPIO, {mopde: Gpio.OUTPUT});

function setDutyCycle(dutyCycle, delay) {
    if (delay == 0 || typeof delay === 'undefined') {
        clearTimeout(timer);
        servo.servoWrite(dutyCycle);
    } else {
        timer = setTimeout(function() {
            clearTimeout(timer);
            servo.servoWrite(dutyCycle);
        }, delay);
    }
}

class Manager {
    /**
     * Opens the door for a set period of time.
     * @param time the time interval, in seconds, to hold the door open
     */
    open(time) {
        setDutyCycle(config.openDutyCycle);
        setDutyCycle(config.closeDutyCycle, time * 1000);
    }

    /**
     * Closes the door immediately.
     */
    close() {
        setDutyCycle(config.closeDutyCycle);
    }
}

module.exports = new Manager();