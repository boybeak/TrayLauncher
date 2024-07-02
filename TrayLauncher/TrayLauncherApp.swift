//
//  TrayLauncherApp.swift
//  TrayLauncher
//
//  Created by Beak on 2024/6/26.
//

import SwiftUI
import Tray

@main
struct TrayLauncherApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var app: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    
    private var tray: Tray!
    
    private let settingsManager = SettingsManager()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        tray = Tray.install(systemSymbolName: "square.grid.3x3.topleft.filled") { tray in
            tray.setView(content: ContentView(), size: CGSize(width: 320, height: 320))
            
            let menu = NSMenu()
            
            let settingsItem = NSMenuItem()
            settingsItem.title = "settings"
            
            settingsItem.submenu = settingsManager.settingsSubMenu
            
            menu.addItem(settingsItem)
            
            tray.setMenu(menu: menu)
        }
    }
    
}
