// Generates monogram app icons in the maarcus.dev style (navy squircle, emerald mono type).
// Usage: swift icons/generate.swift <outdir>
import AppKit

let apps: [(String, String)] = [
  ("1Password", "1p"), ("ChatGPT", "gp"), ("Claude", "cl"), ("Discord", "dc"), ("Docker", "dk"),
  ("Firefox", "ff"), ("Ghostty", "gh"), ("Google Chrome", "cr"), ("Insomnia", "in"),
  ("IntelliJ IDEA", "ij"), ("LocalSend", "ls"), ("Notion", "no"), ("Notion Calendar", "nc"),
  ("Raycast", "rc"), ("Spotify", "sp"), ("Telegram", "tg"), ("Visual Studio Code", "vs"),
  ("VLC", "vl"), ("WebStorm", "ws"), ("WezTerm", "wz"), ("WhatsApp", "wa"), ("zoom.us", "zm"),
  ("Scroll Reverser", "sr"),
]
let out = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "icons"
try? FileManager.default.createDirectory(atPath: out, withIntermediateDirectories: true)

func hex(_ v: UInt32, _ a: CGFloat = 1) -> NSColor {
  NSColor(srgbRed: CGFloat((v >> 16) & 255) / 255, green: CGFloat((v >> 8) & 255) / 255, blue: CGFloat(v & 255) / 255, alpha: a)
}
let font = NSFont(name: "GeistMonoNFM-Bold", size: 360) ?? NSFont.monospacedSystemFont(ofSize: 360, weight: .bold)

for (name, mono) in apps {
  let size = 1024
  let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: size, pixelsHigh: size, bitsPerSample: 8,
                             samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .deviceRGB,
                             bytesPerRow: 0, bitsPerPixel: 0)!
  NSGraphicsContext.saveGraphicsState()
  NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
  let rect = NSRect(x: 100, y: 100, width: 824, height: 824)
  let path = NSBezierPath(roundedRect: rect, xRadius: 185, yRadius: 185)

  NSGraphicsContext.current?.saveGraphicsState()
  let shadow = NSShadow()
  shadow.shadowColor = hex(0x0b1219, 0.5); shadow.shadowBlurRadius = 24; shadow.shadowOffset = NSSize(width: 0, height: -10)
  shadow.set()
  hex(0x0b1219).setFill(); path.fill()
  NSGraphicsContext.current?.restoreGraphicsState()

  NSGradient(starting: hex(0x16212c), ending: hex(0x0b1219))!.draw(in: path, angle: -90)
  hex(0xffffff, 0.14).setStroke(); path.lineWidth = 4; path.stroke()

  // soft emerald glow behind the monogram
  NSGraphicsContext.current?.saveGraphicsState()
  path.addClip()
  NSGradient(starting: hex(0x34d399, 0.18), ending: hex(0x34d399, 0))!
    .draw(fromCenter: NSPoint(x: 512, y: 540), radius: 0, toCenter: NSPoint(x: 512, y: 540), radius: 380, options: [])
  NSGraphicsContext.current?.restoreGraphicsState()

  let attrs: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: hex(0x34d399), .kern: -6]
  let str = NSAttributedString(string: mono, attributes: attrs)
  let s = str.size()
  str.draw(at: NSPoint(x: 512 - s.width / 2, y: 548 - s.height / 2))
  // cursor bar
  hex(0x34d399, 0.9).setFill()
  NSBezierPath(roundedRect: NSRect(x: 512 - 70, y: 330, width: 140, height: 22), xRadius: 6, yRadius: 6).fill()

  NSGraphicsContext.restoreGraphicsState()
  try! rep.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: "\(out)/\(name).png"))
}
print("wrote \(apps.count) icons to \(out)")
