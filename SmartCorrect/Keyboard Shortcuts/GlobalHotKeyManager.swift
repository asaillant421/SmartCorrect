import Carbon.HIToolbox
import Foundation

class GlobalHotKeyManager {
    private static var hotKeyHandler: (() -> Void)?

    static func registerHotKey(handler: @escaping () -> Void) {
        hotKeyHandler = handler

        let keyCode = UInt32(kVK_ANSI_Semicolon)
        let modifierFlags: UInt32 = UInt32(cmdKey) | UInt32(optionKey)

        var hotKeyRef: EventHotKeyRef?
        let hotKeyID = EventHotKeyID(signature: OSType("cust".fourCharCode), id: 1)

        RegisterEventHotKey(
            keyCode,
            modifierFlags,
            hotKeyID,
            GetApplicationEventTarget(),
            0,
            &hotKeyRef
        )

        let eventSpec = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed))
        InstallEventHandler(GetApplicationEventTarget(), hotKeyCallback, 1, [eventSpec], nil, nil)
    }

    static func handleHotKeyEvent() {
        hotKeyHandler?()
    }
}

/// ✅ C-compatible function — cannot capture Swift context
private func hotKeyCallback(nextHandler: EventHandlerCallRef?, theEvent: EventRef?, userData: UnsafeMutableRawPointer?) -> OSStatus {
    GlobalHotKeyManager.handleHotKeyEvent()
    return noErr
}

extension String {
    var fourCharCode: FourCharCode {
        return utf8.reduce(0) { ($0 << 8) + FourCharCode($1) }
    }
}
