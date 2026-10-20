import SwiftUI
import AppKit

// MARK: - Spotify Bridge & Manager
final class SpotifyManager: ObservableObject {
    @Published var isRunning: Bool = false
    @Published var isPlaying: Bool = false
    @Published var title: String = "No Track Playing"
    @Published var artist: String = ""
    @Published var album: String = ""
    @Published var position: Double = 0
    @Published var duration: Double = 1
    @Published var volume: Double = 50
    @Published var artwork: NSImage? = nil

    private var currentArtUrl: String = ""
    private var timer: Timer?

    init() {
        refresh(includeArt: true)
        timer = Timer.scheduledTimer(withTimeInterval: 0.6, repeats: true) { [weak self] _ in
            self?.refresh(includeArt: false)
        }
    }

    deinit {
        timer?.invalidate()
    }

    func refresh(includeArt: Bool = true) {
        let script = """
        if application "Spotify" is running then
            tell application "Spotify"
                set pstate to player state as string
                set tname to name of current track
                set tartist to artist of current track
                set talbum to album of current track
                set tpos to player position as string
                set tdur to ((duration of current track) / 1000) as string
                set tvol to sound volume as string
                try
                    set tart to artwork url of current track
                on error
                    set tart to ""
                end try
                return pstate & "@|@" & tname & "@|@" & tartist & "@|@" & talbum & "@|@" & tpos & "@|@" & tdur & "@|@" & tvol & "@|@" & tart
            end tell
        else
            return "stopped"
        end if
        """
        guard let res = runAppleScript(script), res != "stopped" else {
            DispatchQueue.main.async {
                self.isRunning = false
                self.isPlaying = false
            }
            return
        }

        let parts = res.components(separatedBy: "@|@")
        guard parts.count >= 8 else { return }

        let playing = parts[0] == "playing"
        let t = parts[1]
        let a = parts[2]
        let alb = parts[3]
        let pos = Double(parts[4]) ?? 0
        let dur = max(Double(parts[5]) ?? 1, 1)
        let vol = Double(parts[6]) ?? 50
        let artUrl = parts[7]

        DispatchQueue.main.async {
            self.isRunning = true
            self.isPlaying = playing
            self.title = t.isEmpty ? "Unknown Title" : t
            self.artist = a.isEmpty ? "Unknown Artist" : a
            self.album = alb
            self.position = pos
            self.duration = dur
            self.volume = vol

            if includeArt && (artUrl != self.currentArtUrl || self.artwork == nil) && !artUrl.isEmpty {
                self.currentArtUrl = artUrl
                DispatchQueue.global(qos: .userInitiated).async {
                    if let url = URL(string: artUrl), let data = try? Data(contentsOf: url), let img = NSImage(data: data) {
                        DispatchQueue.main.async {
                            self.artwork = img
                        }
                    }
                }
            }
        }
    }

    func playPause() {
        _ = runAppleScript("tell application \"Spotify\" to playpause")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.refresh(includeArt: false)
        }
    }

    func next() {
        _ = runAppleScript("tell application \"Spotify\" to next track")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.refresh(includeArt: true)
        }
    }

    func previous() {
        _ = runAppleScript("tell application \"Spotify\" to previous track")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.refresh(includeArt: true)
        }
    }

    func seek(to seconds: Double) {
        let clamped = max(0, min(seconds, duration))
        self.position = clamped
        _ = runAppleScript("tell application \"Spotify\" to set player position to \(Int(clamped))")
    }

    func setVolume(_ newVol: Double) {
        self.volume = newVol
        _ = runAppleScript("tell application \"Spotify\" to set sound volume to \(Int(newVol))")
    }

    private func runAppleScript(_ source: String) -> String? {
        var error: NSDictionary?
        if let scriptObject = NSAppleScript(source: source) {
            let output = scriptObject.executeAndReturnError(&error)
            if error == nil {
                return output.stringValue
            }
        }
        return nil
    }
}

// MARK: - Format Helpers
func formatTime(_ seconds: Double) -> String {
    let s = Int(max(0, seconds))
    let m = s / 60
    let rem = s % 60
    return String(format: "%02d:%02d", m, rem)
}

// MARK: - Custom Spotify Green Badge
struct SpotifyBadgeView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(red: 0.118, green: 0.843, blue: 0.376)) // Official Spotify Green #1ED760
                .frame(width: 24, height: 24)

            // 3 Curved Waves
            VStack(spacing: 2.2) {
                RoundedRectangle(cornerRadius: 1.5)
                    .fill(Color.black)
                    .frame(width: 13, height: 2.2)
                RoundedRectangle(cornerRadius: 1.5)
                    .fill(Color.black)
                    .frame(width: 10, height: 2.0)
                RoundedRectangle(cornerRadius: 1.5)
                    .fill(Color.black)
                    .frame(width: 7.5, height: 1.8)
            }
        }
        .shadow(color: Color.black.opacity(0.35), radius: 4, x: 0, y: 2)
    }
}

// MARK: - SwiftUI Player View (Apple Media Player Lockscreen Card)
struct PlayerView: View {
    @ObservedObject var manager: SpotifyManager

    var body: some View {
        VStack(spacing: 16) {
            // 1. Artwork with Spotify Badge
            ZStack(alignment: .bottomTrailing) {
                if let art = manager.artwork {
                    Image(nsImage: art)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 236, height: 236)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                } else {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color(white: 0.16))
                        .frame(width: 236, height: 236)
                        .overlay(
                            Image(systemName: "music.note")
                                .font(.system(size: 52))
                                .foregroundColor(.white.opacity(0.25))
                        )
                }

                SpotifyBadgeView()
                    .padding(10)
            }
            .shadow(color: Color.black.opacity(0.45), radius: 16, x: 0, y: 8)

            // 2. Title & Artist (Centered)
            VStack(spacing: 4) {
                Text(manager.title)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .multilineTextAlignment(.center)

                Text(manager.artist)
                    .font(.system(size: 13, weight: .regular, design: .rounded))
                    .foregroundColor(Color.white.opacity(0.65))
                    .lineLimit(1)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: 240)

            // 3. Scrubber Bar with Elapsed & Remaining Time
            VStack(spacing: 6) {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        // Background track
                        Capsule()
                            .fill(Color.white.opacity(0.2))
                            .frame(height: 4)

                        // Filled progress track
                        Capsule()
                            .fill(Color.white.opacity(0.95))
                            .frame(
                                width: max(0, min(geo.size.width * CGFloat(manager.position / manager.duration), geo.size.width)),
                                height: 4
                            )
                    }
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { val in
                                let pct = max(0, min(val.location.x / geo.size.width, 1.0))
                                manager.seek(to: Double(pct) * manager.duration)
                            }
                    )
                }
                .frame(height: 6)

                HStack {
                    Text(formatTime(manager.position))
                        .font(.system(size: 10, weight: .medium, design: .rounded))
                        .foregroundColor(Color.white.opacity(0.55))

                    Spacer()

                    Text(formatTime(manager.duration))
                        .font(.system(size: 10, weight: .medium, design: .rounded))
                        .foregroundColor(Color.white.opacity(0.55))
                }
            }
            .padding(.horizontal, 4)

            // 4. Media Controls (Plus, Prev, Play/Pause, Next, AirPlay)
            HStack(spacing: 0) {
                Button(action: {
                    // Open Spotify application
                    NSWorkspace.shared.open(URL(fileURLWithPath: "/Applications/Spotify.app"))
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                        .frame(width: 32, height: 32)
                }
                .buttonStyle(.plain)

                Spacer()

                Button(action: { manager.previous() }) {
                    Image(systemName: "backward.fill")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 36, height: 36)
                }
                .buttonStyle(.plain)

                Spacer()

                Button(action: { manager.playPause() }) {
                    Image(systemName: manager.isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)

                Spacer()

                Button(action: { manager.next() }) {
                    Image(systemName: "forward.fill")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 36, height: 36)
                }
                .buttonStyle(.plain)

                Spacer()

                Button(action: {
                    // Open sound preferences / output selector
                    NSWorkspace.shared.open(URL(fileURLWithPath: "/System/Library/PreferencePanes/Sound.prefPane"))
                }) {
                    Image(systemName: "airplayaudio")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                        .frame(width: 32, height: 32)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 2)
            .padding(.vertical, 2)

            // 5. Volume Slider with Speaker Icons
            HStack(spacing: 12) {
                Image(systemName: "speaker.fill")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(Color.white.opacity(0.45))

                Slider(value: Binding(
                    get: { manager.volume },
                    set: { manager.setVolume($0) }
                ), in: 0...100)
                .tint(Color.white.opacity(0.85))

                Image(systemName: "speaker.wave.3.fill")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(Color.white.opacity(0.45))
            }
            .padding(.horizontal, 4)
        }
        .padding(22)
        .frame(width: 284)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(.ultraThinMaterial)

                // Dark iOS Lockscreen tint overlay
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(Color(red: 0.08, green: 0.10, blue: 0.16).opacity(0.82))

                // Delicate glass highlight border
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(Color.white.opacity(0.18), lineWidth: 1)
            }
        )
    }
}

// MARK: - App & Window Management
class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSPanel!
    var globalMonitor: Any?

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)

        let manager = SpotifyManager()
        let contentView = PlayerView(manager: manager)

        let panel = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: 284, height: 440),
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        panel.isFloatingPanel = true
        panel.level = .floating
        panel.backgroundColor = .clear
        panel.isOpaque = false
        panel.hasShadow = true
        panel.contentView = NSHostingView(rootView: contentView)

        // Calculate placement directly below Sketchybar & cursor
        let mouseLoc = NSEvent.mouseLocation
        let screen = NSScreen.main ?? NSScreen.screens.first!
        let screenFrame = screen.frame

        let cardWidth: CGFloat = 284
        let cardHeight: CGFloat = 440
        let topBarHeight: CGFloat = 36 // Sketchybar height

        var posX = mouseLoc.x - (cardWidth / 2)
        if posX + cardWidth > screenFrame.maxX - 12 {
            posX = screenFrame.maxX - cardWidth - 12
        }
        if posX < screenFrame.minX + 12 {
            posX = screenFrame.minX + 12
        }

        let posY = screenFrame.maxY - topBarHeight - cardHeight - 8

        panel.setFrameOrigin(NSPoint(x: posX, y: posY))
        panel.orderFrontRegardless()
        self.window = panel

        // Dismiss on clicking outside the card
        globalMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { _ in
            NSApp.terminate(nil)
        }

        // Dismiss on Escape key
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            if event.keyCode == 53 { // ESC
                NSApp.terminate(nil)
                return nil
            }
            return event
        }
    }
}

// Single instance toggle: if already running, kill existing and exit
let pidFile = "/tmp/sketchybar_spotify_player.pid"
if let pidStr = try? String(contentsOfFile: pidFile, encoding: .utf8),
   let oldPid = Int32(pidStr.trimmingCharacters(in: .whitespacesAndNewlines)) {
    if kill(oldPid, 0) == 0 {
        kill(oldPid, SIGTERM)
        try? FileManager.default.removeItem(atPath: pidFile)
        exit(0)
    }
}
try? "\(getpid())".write(toFile: pidFile, atomically: true, encoding: .utf8)

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()
