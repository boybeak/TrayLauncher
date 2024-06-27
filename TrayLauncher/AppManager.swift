//
//  AppManager.swift
//  TrayLauncher
//
//  Created by Beak on 2024/6/26.
//

import Cocoa

class AppManager {
    
    // 单例实例
    static let shared = AppManager()
    
    private let PAGE_COLUMN_COUNT = 4, PAGE_ROW_COUNT = 4
    
    var pages = [Page]()
    
    // 私有化初始化方法，防止外部实例化
    private init() {
        let apps = getApplicationsFromDirectories().map { name, icon, bundleID, creationDate in
            AppInfo(bundleId: bundleID!, name: name, icon: icon!, createAt: creationDate!)
        }
        let pageCount = PAGE_COLUMN_COUNT * PAGE_ROW_COUNT
        var lastPage: Page? = nil
        for (index, app) in apps.enumerated() {
            if index % pageCount == 0 {
                let page = Page(id: pages.count, apps: [AppInfo]())
                pages.append(page)
                lastPage = page
            }
            lastPage?.apps.append(app)
        }
    }

    // 获取应用列表（通过手动遍历目录）
    func getApplicationsFromDirectories() -> [(name: String, icon: NSImage?, bundleID: String?, creationDate: Date?)] {
        var applications: [(name: String, icon: NSImage?, bundleID: String?, creationDate: Date?)] = []
        
        let fileManager = FileManager.default
        let applicationDirectories = [
            "/Applications",
            "/System/Applications",
            "\(NSHomeDirectory())/Applications"
        ]
        
        for applicationsPath in applicationDirectories {
            var isDirectory: ObjCBool = false
            if fileManager.fileExists(atPath: applicationsPath, isDirectory: &isDirectory), isDirectory.boolValue {
                do {
                    let appPaths = try fileManager.contentsOfDirectory(atPath: applicationsPath)
                    
                    for appPath in appPaths {
                        let fullPath = "\(applicationsPath)/\(appPath)"
                        if fullPath.hasSuffix(".app") {
                            let appName = (appPath as NSString).deletingPathExtension
                            
                            // 获取应用图标
                            let icon = NSWorkspace.shared.icon(forFile: fullPath)
                            
                            // 获取应用的 bundle ID
                            let bundleURL = URL(fileURLWithPath: fullPath)
                            let bundle = Bundle(url: bundleURL)
                            let bundleID = bundle?.bundleIdentifier
                            
                            // 获取文件的创建日期
                            let attributes = try fileManager.attributesOfItem(atPath: fullPath)
                            let creationDate = attributes[.creationDate] as? Date
                            
                            applications.append((name: appName, icon: icon, bundleID: bundleID, creationDate: creationDate))
                        }
                    }
                } catch {
                    print("Error getting applications from \(applicationsPath): \(error)")
                }
            } else {
                print("Directory does not exist: \(applicationsPath)")
            }
        }
        
        // 按照创建日期进行排序
        applications.sort { (app1, app2) -> Bool in
            guard let date1 = app1.creationDate, let date2 = app2.creationDate else {
                return false
            }
            return date1 < date2
        }
        
        return applications
    }

    // 打开应用程序
    func openApplication(named bundleID: String) {
        let workspace = NSWorkspace.shared
        
        // 获取应用程序路径
        if let appURL = workspace.urlForApplication(withBundleIdentifier: bundleID) {
            let configuration = NSWorkspace.OpenConfiguration()
            workspace.openApplication(at: appURL, configuration: configuration) { app, error in
                if let error = error {
                    print("Failed to open \(bundleID): \(error)")
                } else {
                    print("\(bundleID) opened successfully.")
                }
            }
        } else {
            print("Application \(bundleID) not found.")
        }
    }
    
    func openApp(withBundleID bundleID: String) {
        DispatchQueue.global().async {
            let workspace = NSWorkspace.shared
            
            // 尝试根据Bundle ID获取应用的URL
            if let appURL = workspace.urlForApplication(withBundleIdentifier: bundleID) {
                do {
                    // 尝试打开应用
                    try workspace.launchApplication(at: appURL, options: [], configuration: [:])
                    print("Application opened successfully.")
                } catch {
                    print("Failed to open application: \(error)")
                }
            } else {
                print("No application found with bundle ID \(bundleID)")
            }
        }
    }
    
}
