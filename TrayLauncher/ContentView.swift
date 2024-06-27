//
//  ContentView.swift
//  TrayLauncher
//
//  Created by Beak on 2024/6/26.
//

import SwiftUI
import ACarousel

struct ContentView: View {
    
    @AppStorage(UserDefaults.Keys.hideAppName) private var hideAppName: Bool = false
    
    private let columns = [
        GridItem(.adaptive(minimum: 80, maximum: 100), spacing: 0),
        GridItem(.adaptive(minimum: 80, maximum: 100), spacing: 0),
        GridItem(.adaptive(minimum: 80, maximum: 100), spacing: 0),
        GridItem(.adaptive(minimum: 80, maximum: 100), spacing: 0),
    ]
    
    var body: some View {
        
        ZStack {
            ACarousel(AppManager.shared.pages, id: \.self.id, spacing: 0, headspace: 0, sidesScaling: 1) { page in
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
            .frame(width: 320, height: 320)
        }
        .frame(width: 320, height: 320)
    }
}

#Preview {
    ContentView()
}
