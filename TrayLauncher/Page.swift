//
//  Page.swift
//  TrayLauncher
//
//  Created by Beak on 2024/6/26.
//

import Foundation
import AppKit

class Page: NSObject {
    var id: Int
    var apps: [AppInfo]
    
    init(id: Int, apps: [AppInfo]) {
        self.id = id
        self.apps = apps
    }
}

class AppInfo: NSObject, Identifiable {
    
    var id: String {
        return bundleId
    }
    
    var bundleId: String
    var name: String
    var icon: NSImage
    var createAt: Date
    
    init(bundleId: String, name: String, icon: NSImage, createAt: Date) {
        self.bundleId = bundleId
        self.name = name
        self.icon = icon
        self.createAt = createAt
    }
    
}
