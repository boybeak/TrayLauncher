//
//  PageView.swift
//  TrayLauncher
//
//  Created by Beak on 2024/6/27.
//

import SwiftUI

struct PageView: View {
    
    @AppStorage(UserDefaults.Keys.hideAppName) private var hideAppName: Bool = false
    
    let page: Page
    
    @State private var showPopMenu: Bool = false
    
    private let columns = [
        GridItem(.adaptive(minimum: 80, maximum: 100), spacing: 0),
        GridItem(.adaptive(minimum: 80, maximum: 100), spacing: 0),
        GridItem(.adaptive(minimum: 80, maximum: 100), spacing: 0),
        GridItem(.adaptive(minimum: 80, maximum: 100), spacing: 0),
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading , spacing: 0) {
            ForEach(page.apps) { app in
                VStack {
                    Image(nsImage: app.icon).frame(width: 40, height: 40)
                    if !hideAppName {
                        Text(app.name).lineLimit(1)
                    }
                }
                .padding()
                .frame(width: 80, height: 80, alignment: .center)
                .contentShape(Rectangle())
                .onTapGesture {
                    AppManager.shared.openApp(withBundleID: app.bundleId)
                }
            }
        }
        .frame(width: 320, height: 320, alignment: .top)
        .contentShape(Rectangle())
    }
}
