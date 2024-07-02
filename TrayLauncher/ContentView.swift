//
//  ContentView.swift
//  TrayLauncher
//
//  Created by Beak on 2024/6/26.
//

import SwiftUI
import ACarousel

struct ContentView: View {
    
    var body: some View {
        
        ZStack {
            ACarousel(AppManager.shared.pages, id: \.self.id, spacing: 0, headspace: 0, sidesScaling: 1) { page in
                PageView(page: page)
            }
            .frame(width: 320, height: 320)
        }
        .frame(width: 320, height: 320)
        .onDrop(of: [.text, .plainText], isTargeted: nil) { providers in
            
            print("onDrop providers=\(providers)")
            
            return true
        }
    }
}

#Preview {
    ContentView()
}
