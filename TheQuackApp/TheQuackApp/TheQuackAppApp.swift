//
//  TheQuackAppApp.swift
//  TheQuackApp
//
//  Created by stud on 20/10/2025.
//

import SwiftUI

@main
struct TheQuackAppApp: App {
    @AppStorage("darkMode") private var darkMode = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(darkMode ? .dark : .light)
        }
    }
}
