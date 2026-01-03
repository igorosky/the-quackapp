/**
 * *****************************************************************************
 * @file           : MediaGridView.swift
 * @author         : Alex Rogoziński
 * @brief          : This file contains the UI view for displaying a grid of 
                     media items (images, videos, sounds) for a specific duck.
 * *****************************************************************************
 */

import SwiftUI

struct MediaGridView: View {
    let duck: Duck
    let mediaType: DuckDetailView.MediaType
    let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)
    
    var items: [String] {
        switch mediaType {
            case .images: return duck.images
            case .videos: return duck.videos
            case .sounds: return duck.sounds
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Theme.bgTop, Theme.bgBottom], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            // Scrollable grid of media items
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(mediaType.rawValue)
                        .font(.largeTitle.weight(.bold))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
                        .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
                        .padding(.horizontal)
                        .padding(.top, 8)
                    
                    if items.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: mediaType == .images ? "photo.on.rectangle" : 
                                              mediaType == .videos ? "play.rectangle" : "waveform")
                                .font(.system(size: 40))
                                .foregroundColor(.secondary)
                            Text("No \(mediaType.rawValue.lowercased()) available")
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.top, 60)
                    } 
                    else {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(Array(items.enumerated()), id: \.element) { index, item in
                                NavigationLink(destination: MediaView(title: mediaType.rawValue, items: items, mediaType: mediaType, startIndex: index)) {
                                    // Show thumbnail for images and generic icon for other media types
                                    if mediaType == .images {
                                        MediaImage(imageNameOrURL: item)
                                            .frame(height: 140)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                            .clipped()
                                    } 
                                    else {
                                        MediaItemView(mediaType: mediaType)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
}

struct MediaItemView: View {
    let mediaType: DuckDetailView.MediaType
    
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Theme.cardBackground)
            .aspectRatio(1.0, contentMode: .fit)
            .overlay(
                VStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Theme.bgBottom.opacity(0.8))
                        .overlay(
                            Image(systemName: mediaType == .images ? "photo" :
                                              mediaType == .videos ? "play.circle.fill" : "speaker.wave.2.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                        )
                }
                .padding(8)
            )
    }
}
