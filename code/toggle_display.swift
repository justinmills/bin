import Foundation
import CoreGraphics

// Private CGS C-function types
typealias CGSMainConnectionIDFunc = @convention(c) () -> Int32
typealias CGSConfigureDisplayEnabledFunc = @convention(c) (UnsafeMutableRawPointer?, CGDirectDisplayID, boolean_t) -> Int32

// Dynamically load private framework symbol pointers
let skylightHandle = dlopen("/System/Library/PrivateFrameworks/SkyLight.framework/SkyLight", RTLD_LAZY)

guard let skylightHandle = skylightHandle else {
    print("Error: Could not load SkyLight framework")
    exit(1)
}

guard let mainConnectionPtr = dlsym(skylightHandle, "CGSMainConnectionID"),
      let enableDisplayPtr = dlsym(skylightHandle, "CGSConfigureDisplayEnabled") else {
    print("Error: Could not resolve private display symbols")
    exit(1)
}

let CGSMainConnectionID = unsafeBitCast(mainConnectionPtr, to: CGSMainConnectionIDFunc.self)
let CGSConfigureDisplayEnabled = unsafeBitCast(enableDisplayPtr, to: CGSConfigureDisplayEnabledFunc.self)

let args = CommandLine.arguments

guard args.count >= 3 else {
    print("Usage: disable_display <display_id> <on|off>")
    exit(1)
}

guard let displayID = UInt32(args[1]) else {
    print("Invalid Display ID")
    exit(1)
}

let enable = (args[2].lowercased() == "on" || args[2] == "1") ? boolean_t(1) : boolean_t(0)

// --- SAFETY GUARDRAILS ---
// Safety Check 1: Explicit ID 1 block
if displayID == 1 {
    print("ERROR: Safety Guardrail Triggered! Disabling display ID 1 is blocked.")
    exit(1)
}

// Safety Check 2: Block built-in display hardware (laptop screen)
if CGDisplayIsBuiltin(CGDirectDisplayID(displayID)) != 0 {
    print("ERROR: Safety Guardrail Triggered! Cannot disable the built-in laptop screen.")
    exit(1)
}
// --------------------------

// 1. Begin public CoreGraphics display configuration transaction
var configRef: CGDisplayConfigRef?
let beginStatus = CGBeginDisplayConfiguration(&configRef)

guard beginStatus == .success, let config = configRef else {
    print("Failed to begin display configuration: \(beginStatus.rawValue)")
    exit(1)
}

// 2. Pass transaction reference pointer to private enable/disable symbol
let status = CGSConfigureDisplayEnabled(UnsafeMutableRawPointer(config), CGDirectDisplayID(displayID), enable)

if status != 0 {
    print("CGSConfigureDisplayEnabled failed with error code: \(status)")
    CGCancelDisplayConfiguration(config)
    exit(1)
}

// 3. Commit transaction
let commitStatus = CGCompleteDisplayConfiguration(config, .permanently)

if commitStatus == .success {
    print("Successfully set display \(displayID) state to: \(enable == 1 ? "ON" : "OFF")")
} else {
    print("Failed to commit display configuration: \(commitStatus.rawValue)")
}