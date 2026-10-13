// Builds apple/Zoro.terminal (Terminal.app profile) from the palette.
// Usage: swift apple/generate-terminal.swift apple/Zoro.terminal
import AppKit

func c(_ hex: String) -> Data {
  let v = UInt32(hex.dropFirst(), radix: 16)!
  let col = NSColor(srgbRed: CGFloat((v >> 16) & 255) / 255, green: CGFloat((v >> 8) & 255) / 255, blue: CGFloat(v & 255) / 255, alpha: 1)
  return try! NSKeyedArchiver.archivedData(withRootObject: col, requiringSecureCoding: false)
}
let font = NSFont(name: "GeistMonoNFM-Medium", size: 15) ?? NSFont.monospacedSystemFont(ofSize: 15, weight: .medium)
let fontData = try! NSKeyedArchiver.archivedData(withRootObject: font, requiringSecureCoding: false)

let ansi = ["000000", "f87171", "34d399", "fbbf24", "60a5fa", "a78bfa", "2dd4bf", "c7c7c7",
            "262626", "fca5a5", "6ee7b7", "fcd34d", "93c5fd", "c4b5fd", "5eead4", "ededed"]
let names = ["Black", "Red", "Green", "Yellow", "Blue", "Magenta", "Cyan", "White"]
var d: [String: Any] = [
  "name": "Zoro", "type": "Window Settings", "ProfileCurrentVersion": 2.07,
  "BackgroundColor": c("#0b1219"), "TextColor": c("#e6eaef"), "TextBoldColor": c("#e6eaef"),
  "CursorColor": c("#34d399"), "SelectionColor": c("#2a3744"), "Font": fontData,
  "UseBrightBold": false, "CursorType": 0, "columnCount": 140, "rowCount": 40,
  "shellExitAction": 1, "BackgroundBlur": 0.2, "BackgroundAlphaInactiveWindow": 1.0,
]
for (i, hex) in ansi.enumerated() {
  d["ANSI" + (i < 8 ? names[i] : "Bright" + names[i - 8]) + "Color"] = c("#" + hex)
}
let out = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "Zoro.terminal"
(d as NSDictionary).write(toFile: out, atomically: true)
print("wrote \(out)")
