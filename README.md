# SwiftGPIO

SwiftGPIO provides small, Swifty helpers around the ESP-IDF GPIO C API. It exposes a concise, type-safe interface for configuring GPIO pins, reading input levels and driving outputs from Swift.

## Features
- Configure a GPIO pin as input or output.
- Configure pull-up / pull-down and interrupt type when setting a pin as input.
- Read pin level as a `Bool`.
- Set pin output level using a `Bool`.

## API
All APIs are provided as an extension on the C enum `gpio_num_t` (exported via the `ESP_GPIO` module). The main methods are:

- `setOutput() -> esp_err_t` — configure the pin as an output.
- `setInput(pullUp: gpio_pullup_t = GPIO_PULLUP_DISABLE, pulldown: gpio_pulldown_t = GPIO_PULLDOWN_DISABLE, intr: gpio_int_type_t = GPIO_INTR_DISABLE) -> esp_err_t` — configure the pin as an input with optional pull / interrupt settings.
- `getLevel() -> Bool` — return `true` when the pin reads high, `false` when low.
- `set(level: Bool)` — set the output level (high when `true`).

These are simple thin wrappers over the `gpio_config`, `gpio_get_level` and `gpio_set_level` C functions.

## Usage examples

Basic output example:

```swift
import ESP_GPIO

let pin: gpio_num_t = .GPIO_NUM_2
_ = pin.setOutput()
pin.set(level: true) // drive high
pin.set(level: false) // drive low
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.