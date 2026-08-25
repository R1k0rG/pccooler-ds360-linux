#!/usr/bin/env python3
import hid
import sys
import time
import psutil

# USB HID Vendor ID and Product ID for the device
VID = 0x2E3C
PID = 0x0A15

# Common CPU temperature sensor tags across different architectures
CPU_SENSOR_TAGS = ['tctl', 'tdie', 'core', 'cpu', 'package', 'k10temp']


def get_cpu_temp() -> int:
    """Retrieve current CPU temperature using psutil sensors.

    Returns:
        int: CPU temperature in Celsius, or fallback default (40°C).
    """
    temps = psutil.sensors_temperatures()

    # Search for a primary CPU sensor match
    for name, entries in temps.items():
        for entry in entries:
            if entry.current is not None and entry.current > 0:
                sensor_name = f"{entry.label.lower()} {name.lower()}"
                if any(tag in sensor_name for tag in CPU_SENSOR_TAGS):
                    return int(entry.current)

    # Fallback: Use the first available valid temperature sensor
    for name, entries in temps.items():
        for entry in entries:
            if entry.current is not None and entry.current > 0:
                return int(entry.current)

    # Default fallback if no sensors are responsive
    return 40


def main():
    try:
        d = hid.device()
        d.open(VID, PID)
        d.set_nonblocking(False)
        print("✅ Pump display daemon started successfully! Updating screen...")

        while True:
            temp = get_cpu_temp()

            # Construct 64-byte HID report
            buf = [0] * 64
            buf[0] = 0x20  # Report ID
            buf[1] = 0x01  # Mode: CPU
            buf[2] = 0x01  # Power: ON
            buf[3] = 0x00  # Unit: Celsius (°C)

            buf[6] = temp  # Current CPU temperature
            buf[7] = temp  # Duplicate temperature field

            d.write(bytes(buf))
            d.read(64, timeout_ms=50)

            # Update twice per second for smooth telemetry
            time.sleep(0.5)

    except KeyboardInterrupt:
        print("\nProcess interrupted by user. Exiting...")
        d.close()
    except Exception as e:
        print(f"❌ Error: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == '__main__':
    main()
