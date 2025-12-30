// Copyright (c) 2026 Nicolas Christe
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

// A Swift wrapper class for ESP-IDF GPIO operations.
//
// This class provides an object-oriented interface to control GPIO pins on ESP32 devices.

@_exported import ESP_GPIO
import Platform

public class Gpio {
    private let gpioNum: gpio_num_t

    /// Initializes a new GPIO instance with the specified pin number.
    ///
    /// - Parameter gpioNum: The GPIO pin number to control.
    public init(gpioNum: gpio_num_t) {
        self.gpioNum = gpioNum
    }

    /// Configure the GPIO as an output pin.
    ///
    /// - Returns: The `esp_err_t` result returned by `gpio_config`.
    public func setOutput() -> esp_err_t {
        var cfg = gpio_config_t(
            pin_bit_mask: 1 << UInt64(gpioNum.rawValue),
            mode: GPIO_MODE_OUTPUT,
            pull_up_en: GPIO_PULLUP_DISABLE,
            pull_down_en: GPIO_PULLDOWN_DISABLE,
            intr_type: GPIO_INTR_DISABLE)
        return gpio_config(&cfg)
    }

    /// Configure the GPIO as an input pin.
    ///
    /// - Parameters:
    ///   - pullUp: pull-up configuration (default: `GPIO_PULLUP_DISABLE`).
    ///   - pulldown: pull-down configuration (default: `GPIO_PULLDOWN_DISABLE`).
    ///   - intr: interrupt type (default: `GPIO_INTR_DISABLE`).
    /// - Returns: The `esp_err_t` result returned by `gpio_config`.
    public func setInput(
        pullUp: gpio_pullup_t = GPIO_PULLUP_DISABLE, pulldown: gpio_pulldown_t = GPIO_PULLDOWN_DISABLE,
        intr: gpio_int_type_t = GPIO_INTR_DISABLE
    ) -> esp_err_t {
        var cfg = gpio_config_t(
            pin_bit_mask: 1 << UInt64(gpioNum.rawValue),
            mode: GPIO_MODE_INPUT,
            pull_up_en: pullUp,
            pull_down_en: pulldown,
            intr_type: intr)
        return gpio_config(&cfg)
    }

    /// Resets the GPIO pin to its default state.
    ///
    /// - Returns: The `esp_err_t` result returned by `gpio_reset_pin`.
    public func reset() -> esp_err_t {
        return gpio_reset_pin(gpioNum)
    }   

    /// Read the current logical level of the GPIO.
    ///
    /// - Returns: `true` if the pin reads high (non-zero), `false` otherwise.
    public func getLevel() -> Bool {
        return gpio_get_level(gpioNum) != 0
    }

    /// Set the output level of the GPIO.
    ///
    /// - Parameter level: `true` to drive the pin high, `false` to drive it low.
    /// - Returns: The `esp_err_t` result returned by `gpio_set_level`.
    public func set(level: Bool) -> esp_err_t {
        gpio_set_level(gpioNum, level ? 1 : 0)
    }

    /// Adds an ISR handler for this GPIO pin.
    ///
    /// - Parameter handler: The ISR handler to add.
    /// - Returns: The `esp_err_t` result returned by `gpio_isr_handler_add`.
    func setIsrHandler(_ handler: IsrHandler) -> esp_err_t {
        return gpio_isr_handler_add(gpioNum, handler.handler, handler.args)
    }

    /// Removes the ISR handler for this GPIO pin.
    ///
    /// - Returns: The `esp_err_t` result returned by `gpio_isr_handler_remove`.
    func removeIsrHandler() -> esp_err_t {
        return gpio_isr_handler_remove(gpioNum)
    }
}
