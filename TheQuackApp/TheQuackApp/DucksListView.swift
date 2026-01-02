/**
 * ******************************************************************************
 * @file           : DucksListView.swift
 * @author         : Alex Rogoziński
 * @brief          : This file contains the UI view for displaying a list of
                     ducks with search and region filtering capabilities.
 * ******************************************************************************
 */

import SwiftUI

struct DucksListView: View {
    @StateObject private var store = DucksStore()
    @State private var searchText: String     = ""
    @State private var selectedRegion: Region = .all
    
    var filteredDucks: [Duck] {
        store.ducks.filter { duck in
            let matchesSearch = searchText.isEmpty || duck.name.localizedCaseInsensitiveContains(searchText)
            let matchesRegion = selectedRegion == .all || duck.regions.contains(selectedRegion)
            return matchesSearch && matchesRegion
        }
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [Theme.bgTop, Theme.bgBottom]), 
                                   startPoint: .top, 
                                   endPoint: .bottom)
                    .ignoresSafeArea()
                    
                    VStack(spacing: 0) {
                        // Fixed header section
                        VStack(spacing: 16) {
                            Text("Discover Ducks")
                                .font(.system(size: 34, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top)
                            
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                TextField("Enter duck's name...", text: $searchText)

                                if !searchText.isEmpty {
                                    Button(action: { searchText = "" }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 20).fill(Theme.searchBackground))
                        }
                        .padding([.horizontal, .top])
                        .padding(.bottom, 16)
                        
                        // Region picker in connected white container
                        HStack {
                            Picker("Select Region", selection: $selectedRegion) {
                                ForEach(Region.allCases, id: \.self) { region in
                                    Text(region.rawValue)
                                        .tag(region)
                                }
                            }
                            .pickerStyle(.menu)
                            .tint(.primary)
                            Spacer()
                        }
                        .padding()
                        .background(Theme.cardBackground)
                        .clipShape(
                            RoundedCorner(radius: 30, corners: [.topLeft, .topRight])
                        )
                        .padding(.horizontal)
                        
                        // Scrollable content area
                        ScrollView(showsIndicators: true) {
                            VStack(spacing: 0) {
                                if store.isLoading {
                                    VStack(spacing: 12) {
                                        ProgressView()
                                            .scaleEffect(1.5)
                                        Text("Loading ducks...")
                                            .font(.headline)
                                            .foregroundColor(.secondary.opacity(0.7))
                                    }
                                    .frame(maxWidth: .infinity, minHeight: 200)
                                    .padding(.vertical, 20)
                                } 
                                else if filteredDucks.isEmpty {
                                    VStack(spacing: 12) {
                                        Image(systemName: "magnifyingglass")
                                            .font(.system(size: 36, weight: .light))
                                            .foregroundColor(.secondary.opacity(0.7))
                                        Text("No ducks found")
                                            .font(.headline)
                                            .foregroundColor(.secondary.opacity(0.7))
                                        Text("Try adjusting your search or region filter")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary.opacity(0.5))
                                            .multilineTextAlignment(.center)
                                    }
                                    .frame(maxWidth: .infinity, minHeight: 200)
                                    .padding(.vertical, 20)
                                } 
                                else {
                                    VStack(spacing: 0) {
                                        ForEach(filteredDucks) { duck in
                                            NavigationLink(destination: DuckDetailView(duck: duck)) {
                                                DuckRow(duck: duck)
                                                    .padding(.horizontal)
                                                    .padding(.vertical, 8)
                                            }
                                            .buttonStyle(.plain)
                                            
                                            if duck != filteredDucks.last {
                                                Divider()
                                                    .padding(.horizontal)
                                            }
                                        }
                                    }
                                    .padding(.vertical, 8)
                                }
                            }
                            .background(Theme.cardBackground)
                            .clipShape(
                                RoundedCorner(radius: 30, corners: [.bottomLeft, .bottomRight])
                            )
                            .padding(.horizontal)
                        }
                        .frame(minHeight: geometry.size.height * 0.7)
                    }
                }
            }
        }
    }
}
    

struct DuckRow: View {
    let duck: Duck
    @ObservedObject private var settings = AppSettings.shared

    var body: some View {
        HStack(spacing: 16) {
            MediaImage(imageNameOrURL: duck.images.first)
                .frame(width: 72, height: 72)
                .cornerRadius(12)
                .shadow(radius: 6)

            VStack(alignment: .leading, spacing: 4) {
                Text(duck.name).font(.headline)

                if settings.showScientificNames, let sci = duck.scientificName {
                    Text(sci)
                        .font(.subheadline)
                        .italic()
                        .foregroundColor(.secondary)
                }

                Text(duck.regions.map { $0.rawValue }.joined(separator: ", "))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(.vertical, 12)
    }
}

// Extension for custom corner rounding
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}


struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
