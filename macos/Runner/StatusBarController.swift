//
//  StatusBarController.swift
//  Runner
//
//  Created by qiangchen on 2022/7/7.
//

import Foundation
import AppKit

class StatusBarController {
    private let popover: NSPopover
    private let statusItem: NSStatusItem
    private let statusBar = NSStatusBar()
    
    init(_ popover: NSPopover) {
        self.popover = popover
        statusItem = statusBar.statusItem(withLength: 28)
        if let btn = statusItem.button {
            btn.image = NSImage(imageLiteralResourceName: "AppIcon")
            btn.image?.size = .init(width: 20, height: 20)
            btn.image?.isTemplate = true
            btn.action = #selector(togglePopover)
            btn.target = self
        }
    }
    
    @objc func togglePopover(sender: AnyObject) {
            if(popover.isShown) {
                hidePopover(sender)
            } else {
                showPopover(sender)
            }
        }
        
        func showPopover(_ sender: AnyObject) {
            guard  let statusBarButton = statusItem.button else { return }
            popover.show(relativeTo: statusBarButton.bounds, of: statusBarButton, preferredEdge: NSRectEdge.maxY)
        }
        
        func hidePopover(_ sender: AnyObject) {
            popover.performClose(sender)
        }
}
