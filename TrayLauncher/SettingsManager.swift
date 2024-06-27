//
//  SettingsManager.swift
//  TrayLauncher
//
//  Created by Beak on 2024/6/27.
//

import ObjectiveC
import Foundation
import AppKit

class SettingsManager: NSObject {
    
    let hideAppNameItem = NSMenuItem(title: "Hide App Name", action: #selector(toggleHideAppName), keyEquivalent: "")
    
    let settingsSubMenu = NSMenu(title: "Settings")
    
    override init() {
        super.init()
        hideAppNameItem.target = self
        hideAppNameItem.isEnabled = true
        hideAppNameItem.state = UserDefaults.standard.bool(forKey: UserDefaults.Keys.hideAppName) ? .on : .off
        settingsSubMenu.addItem(hideAppNameItem)
        UserDefaults.standard.addObserver(self, forKeyPath: UserDefaults.Keys.hideAppName, options: [.new, .initial], context: nil)
    }
    
    deinit {
        UserDefaults.standard.removeObserver(self, forKeyPath: UserDefaults.Keys.hideAppName)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == UserDefaults.Keys.hideAppName {
            // 更新NSMenuItem的state
            let hideAppName = UserDefaults.standard.bool(forKey: UserDefaults.Keys.hideAppName)
            hideAppNameItem.state = hideAppName ? .on : .off
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    @objc
    private func toggleHideAppName() {
        let hideAppName = UserDefaults.standard.bool(forKey: UserDefaults.Keys.hideAppName)
        UserDefaults.standard.setValue(!hideAppName, forKey: UserDefaults.Keys.hideAppName)
    }
    
}
