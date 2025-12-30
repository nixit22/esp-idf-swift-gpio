idf_component_register(
    SRCS 
        GPIO.swift
        gpio.c
    INCLUDE_DIRS "."
    REQUIRES esp_driver_gpio SwiftPlatform
)

swift_configure_component("GPIO")
