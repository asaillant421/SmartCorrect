import Cocoa
import SwiftUI
import Combine

class OverlayWindowController: NSWindowController {
    private var cancellables: Set<AnyCancellable> = []
    private var globalMouseMonitor: Any?
    private var globalKeyMonitor: Any?
    
    init(@ViewBuilder content: () -> some View) {
        let hosting = NSHostingView(rootView: content())
        
        let panel = FloatingPanel(contentRect: NSRect(x: 0, y: 0, width: 600, height: 400), contentView: hosting)

        super.init(window: panel)

        // Commented out to prevent panel from closing when app loses focus
        // let cancellable = NotificationCenter.default.publisher(for: NSApplication.didResignActiveNotification)
        //     .sink { _ in
        //         self.closeOnFocusLoss()
        //     }
        // 
        // cancellables.insert(cancellable)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        cancellables.removeAll()
        stopMouseMonitoring()
        stopKeyMonitoring()
    }

    func toggle() {
        if let window = self.window {
            if window.isVisible {
                hide()
            } else {
                show()
            }
        }
    }
    
    func show() {
        guard let window = self.window else { return }
        
        if window.frame.origin == CGPoint.zero, let screen = NSScreen.main {
            let frame = window.frame
            let x = screen.frame.midX - frame.width / 2
            let y = screen.frame.midY - frame.height / 2
            window.setFrameOrigin(NSPoint(x: x, y: y))
        }
        
        window.orderFrontRegardless()
        startMouseMonitoring()
        startKeyMonitoring()
    }
    
    private func hide() {
        stopMouseMonitoring()
        stopKeyMonitoring()
        window?.orderOut(nil)
    }

    @objc func closeOnFocusLoss() {
        self.window?.orderOut(nil)
    }
    
    private func startMouseMonitoring() {
        guard globalMouseMonitor == nil else { return }
        
        globalMouseMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown]) { [weak self] event in
            self?.handleGlobalMouseClick(event)
        }
    }
    
    private func stopMouseMonitoring() {
        if let monitor = globalMouseMonitor {
            NSEvent.removeMonitor(monitor)
            globalMouseMonitor = nil
        }
    }
    
    private func handleGlobalMouseClick(_ event: NSEvent) {
        guard let window = self.window, window.isVisible else { return }
        
        let clickLocation = event.locationInWindow
        let windowFrame = window.frame
        
        // Check if click is outside the window bounds
        if !windowFrame.contains(clickLocation) {
            hide()
        }
    }
    
    private func startKeyMonitoring() {
        guard globalKeyMonitor == nil else { return }
        
        globalKeyMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.keyDown]) { [weak self] event in
            self?.handleGlobalKeyDown(event)
        }
    }
    
    private func stopKeyMonitoring() {
        if let monitor = globalKeyMonitor {
            NSEvent.removeMonitor(monitor)
            globalKeyMonitor = nil
        }
    }
    
    private func handleGlobalKeyDown(_ event: NSEvent) {
        // Check if the pressed key is Escape (keyCode 53)
        guard let window = self.window,
                window.isVisible,
                event.keyCode == 53 else { return }
        
        hide()
    }
}
