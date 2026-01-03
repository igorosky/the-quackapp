/**
 * *****************************************************************************
 * @file           : MediaImage.swift
 * @author         : Alex Rogoziński
 * @brief          : This file contains media display helper view for showing 
                     duck images from either local asset names or remote URLs.
 * *****************************************************************************
 */

import SwiftUI

struct MediaImage: View {
    let imageNameOrURL: String?
    var placeholder: Image = Image(systemName: "photo")

    var body: some View {
        Group {
            if let src = imageNameOrURL, !src.isEmpty {
                if let url = URL(string: src), url.scheme?.starts(with: "http") == true {
                    // Remote image 
                    if #available(iOS 15.0, *) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                                case .empty:
                                    ZStack { ProgressView() }
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                case .failure(_):
                                    placeholder
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.secondary)
                                @unknown default:
                                    placeholder
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.secondary)
                            }
                        }
                    } 
                    else {
                        // Fallback for older platforms: show placeholder
                        placeholder
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.secondary)
                    }
                } 
                else {
                    // Treat it as local asset name
                    Image(src)
                        .resizable()
                        .scaledToFill()
                }
            } 
            else {
                placeholder
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.secondary)
            }
        }
        .background(Color.gray.opacity(0.08))
        .clipped()
    }
}
