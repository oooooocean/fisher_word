import Cocoa
import FlutterMacOS

@NSApplicationMain
class AppDelegate: FlutterAppDelegate {
    var statusBarCtl: StatusBarController?
    lazy var popover: NSPopover = {
        let view = NSPopover()
        view.behavior = .semitransient
        view.contentSize = .init(width: 360, height: 240)
        return view
    }()
    
    
    override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
    
    override func applicationDidFinishLaunching(_ notification: Notification) {
        popover.contentViewController = mainFlutterWindow.contentViewController as! FlutterViewController
        mainFlutterWindow.close()
        
        statusBarCtl = StatusBarController(popover)
        super.applicationDidFinishLaunching(notification)
    }
}
