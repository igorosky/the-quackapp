/**
 * *****************************************************************************
 * @file           : HomeView.swift
 * @author         : Alex Rogoziński
 * @brief          : This file contains the UI view for the home screen of 
                     the app.
 * *****************************************************************************
 */

import SwiftUI

struct HomeView: View {
    @ObservedObject private var duckOfTheDay = DuckOfTheDay.shared
    @StateObject    private var store        = DucksStore()

    var body: some View {
        ZStack {
            LinearGradient(colors: [Theme.bgTop, Theme.bgBottom], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                // Header with app title and settings button
                HStack {
                    Text("TheQuackApp")
                        .font(.title2).bold()
                        .foregroundColor(.white)
                    Spacer()
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(8)
                    }
                }
                .padding([.horizontal, .top])

                // Greeting title
                Text("Hello, Ornithologist!")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                // Duck of the day section
                VStack(spacing: 5) {
                    Text("Duck of the day")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    // Ensure there is a selection for today when this view appears
                    Color.clear.onAppear {
                        DuckOfTheDay.shared.updateIfNeeded(from: store.ducks)
                    }
                    .onReceive(store.$ducks) { 
                        ducks in DuckOfTheDay.shared.updateIfNeeded(from: ducks)
                    }

                    if store.isLoading {
                        ZStack {
                            RoundedRectangle(cornerRadius: 28)
                                .fill(Theme.cardBackground.opacity(0.98))
                                .frame(height: 370)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 28)
                                        .stroke(Color.black.opacity(0.02))
                                )
                            
                            // Loading state animation
                            VStack(spacing: 12) {
                                ProgressView()
                                    .scaleEffect(1.5)
                                Text("Loading duck...")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary.opacity(0.7))
                            }
                        }
                    } 
                    else if let duck = duckOfTheDay.currentDuck {
                        // Duck image and part of description
                        VStack(spacing: 0) {
                            VStack(spacing: 0) {
                                MediaImage(imageNameOrURL: duck.images.first)
                                    .frame(height: 230)
                                    .frame(maxWidth: .infinity)
                                    .clipped()
                                    .clipShape(UnevenRoundedRectangle(cornerRadii: .init(
                                        topLeading: 28,
                                        bottomLeading: 0,
                                        bottomTrailing: 0,
                                        topTrailing: 28
                                    )))

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(duck.name)
                                        .font(.title3).bold()
                                    Text(duck.shortDescription)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .lineLimit(2)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                            }
                            .background(Theme.cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 28))
                            .overlay(
                                RoundedRectangle(cornerRadius: 28)
                                    .stroke(Color.black.opacity(0.02))
                            )

                            // Check details button
                            NavigationLink(destination: DuckDetailView(duck: duck)) {
                                Text("Check details")
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(RoundedRectangle(cornerRadius: 24).fill(Theme.buttonGreen))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 24)
                                    .padding(.top, 16)
                            }
                        }
                    } 
                    else {
                        ZStack {
                            RoundedRectangle(cornerRadius: 28)
                                .fill(Theme.cardBackground.opacity(0.98))
                                .frame(height: 370)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 28)
                                        .stroke(Color.black.opacity(0.02))
                                )
                            
                            // No duck available state
                            VStack(spacing: 12) {
                                Image(systemName: "bird.fill")
                                    .font(.system(size: 36, weight: .light))
                                    .foregroundColor(.secondary.opacity(0.7))
                                Text("No ducks available")
                                    .font(.headline)
                                    .foregroundColor(.secondary.opacity(0.7))
                                Text("Please check your server connection")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary.opacity(0.5))
                                    .multilineTextAlignment(.center)
                            }
                        }
                    }
                }
                .padding(.horizontal)

                Divider().padding(.horizontal)

                // Search ducks button
                NavigationLink(destination: DucksListView()) {
                    Text("Search for ducks")
                        .font(.title2)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 30).fill(Theme.cardBackground))
                        .padding(.horizontal)
                }

                Spacer(minLength: 40)
            }
        }
    }
}
