/**
 * *****************************************************************************
 * @file           : ContentView.swift
 * @author         : Alex Rogoziński
 * @brief          : This file contains the main content view that hosts the
                     navigation stack for the app.
 * *****************************************************************************
 */

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            HomeView()
        }
    }
}
