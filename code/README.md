# Supporting code

This dir contains supporting code I may need to compile to build more binaries to call for various things.

## `toggle-display`

This is some code Gemini generated to help me disconnect an external monitor when my KVM switch deactivates the current laptop. This helps when the KVM has EDID which makes the monitor appear connected even after switching to the other laptop. I'm using this as part of a hammerspoon config to auto disconnect the display when the KVM switches away so hammerspoon will shuffle all windows back to the laptop and restore it as the primary display so things like Alfred and cmd+tab popups show there.

To compile:
    swiftc toggle_display.swift -o toggle-display
