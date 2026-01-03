/**
 * *****************************************************************************
 * @file           : SettingsView.swift
 * @author         : Alex Rogoziński
 * @brief          : This file contains the UI view for the app settings screen.
 * *****************************************************************************
 */

import SwiftUI

struct SettingsView: View {
    @ObservedObject private var settings = AppSettings.shared

    var body: some View {
        ZStack {
            LinearGradient(colors: [Theme.bgTop, Theme.bgBottom], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                     // View title
                    Text("Settings")
                        .font(.largeTitle.weight(.bold))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
                        .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 8)

                    // Display options
                    VStack(spacing: 16) {
                        Text("Display").font(.title2).bold()
                        Toggle("Scientific names", isOn: Binding(get: { settings.showScientificNames }, set: { settings.showScientificNames = $0 }))
                        Divider()
                        Toggle("Dark mode", isOn: Binding(get: { settings.darkMode }, set: { settings.darkMode = $0 }))
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).fill(Theme.cardBackground))
                    .padding(.horizontal)

                    // Information section
                    VStack(spacing: 16) {
                        Text("Information").font(.title2).bold()
                        HStack {
                            Text("App version")
                            Spacer()
                            Text("1.0.0").foregroundColor(.secondary)
                        }
                        Divider()
                        VStack(alignment: .leading, spacing: 8) {
                            Text("[DEV] Ducks server URL")
                            TextField("http://localhost/", text: Binding(get: { settings.serverBaseURL }, set: { settings.serverBaseURL = $0 }))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.URL)
                                .autocapitalization(.none)
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).fill(Theme.cardBackground))
                    .padding(.horizontal)

                    Spacer()
                }
                .padding(.top)
            }
        }
    }
}
