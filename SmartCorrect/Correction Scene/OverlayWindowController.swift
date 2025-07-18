import Cocoa
import SwiftUI
import Combine

class OverlayWindowController: NSWindowController {
    private var cancellables: Set<AnyCancellable> = []
    
    init(@ViewBuilder content: () -> some View) {
        let hosting = NSHostingView(rootView: content())
        
        let panel = FloatingPanel(contentRect: NSRect(x: 0, y: 0, width: 600, height: 400), contentView: hosting)

        super.init(window: panel)

        let cancellable = NotificationCenter.default.publisher(for: NSApplication.didResignActiveNotification)
            .sink { _ in
                self.closeOnFocusLoss()
            }
        
        cancellables.insert(cancellable)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        cancellables.removeAll()
    }

    func toggle() {
        if let window = self.window {
            if window.isVisible {
                window.orderOut(nil)
            } else {
                if let screen = NSScreen.main {
                    let frame = window.frame
                    let x = screen.frame.midX - frame.width / 2
                    let y = screen.frame.midY - frame.height / 2
                    window.setFrameOrigin(NSPoint(x: x, y: y))
                }
                NSApp.activate(ignoringOtherApps: true)
                window.orderFrontRegardless()
            }
        }
    }

    @objc func closeOnFocusLoss() {
        self.window?.orderOut(nil)
    }
}
