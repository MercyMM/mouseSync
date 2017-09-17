//
//  AppDelegate.swift
//  mouseSync
//
//  Created by Chih-Hao on 2017/9/16.
//  Copyright © 2017年 Chih-Hao. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        var previousX = NSEvent.mouseLocation().x;
        var previousY = NSEvent.mouseLocation().y;
        
        NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved,.leftMouseDown]) {
            self.mouseLocation = NSEvent.mouseLocation()
            
            previousX = NSEvent.mouseLocation().x;
            previousY = NSEvent.mouseLocation().y;
            
            return $0
        }
        
        NSEvent.addGlobalMonitorForEvents(matching: [.mouseMoved]) { _ in
            self.mouseLocation = NSEvent.mouseLocation()
           
            
        }
        
        NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown]) {_ in
            self.mouseLocation = NSEvent.mouseLocation()
             print(String(format: "%.0f, %.0f", self.mouseLocation.x, self.mouseLocation.y))
//            self.mouseMoveAndClick(onPoint: self.mouseLocation)
        }

    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    
    
    let SCREEN_WIDTH = NSScreen.main()!.frame.width
    let SCREEN_HEIGHT = NSScreen.main()!.frame.height
    
    var mouseLocation: CGPoint = .zero
    
    
    func mouseDown(with event: NSEvent) {
        self.mouseMoveAndClick(onPoint: self.mouseLocation)
    }
    

    
    
    func move(_ dx:CGFloat , _ dy:CGFloat){
        var mouseLoc = NSEvent.mouseLocation()
        mouseLoc.y = NSHeight(NSScreen.screens()![0].frame) - mouseLoc.y;
        let newLoc = CGPoint(x: mouseLoc.x-CGFloat(dx), y: mouseLoc.y+CGFloat(dy))
        CGDisplayMoveCursorToPoint(0, newLoc)
    }
    
    func mouseMoveAndClick(onPoint point: CGPoint) {
        guard let moveEvent = CGEvent(mouseEventSource: nil, mouseType: .mouseMoved, mouseCursorPosition: point, mouseButton: .left) else {
            return
        }
        guard let downEvent = CGEvent(mouseEventSource: nil, mouseType: .leftMouseDown, mouseCursorPosition: point, mouseButton: .left) else {
            return
        }
        guard let upEvent = CGEvent(mouseEventSource: nil, mouseType: .leftMouseUp, mouseCursorPosition: point, mouseButton: .left) else {
            return
        }
        moveEvent.post(tap: CGEventTapLocation.cghidEventTap)
        downEvent.post(tap: CGEventTapLocation.cghidEventTap)
        upEvent.post(tap: CGEventTapLocation.cghidEventTap)
    }


}

