/**
 * ******************************************************************************
 * @file           : MediaView.swift
 * @author         : Alex Rogoziński
 * @brief          : This file contains the UI view for displaying media
                     (images, videos, sounds) related to a duck.
 * ******************************************************************************
 */

import SwiftUI
import AVKit
import AVFoundation

struct MediaView: View {
    let title:     String
    let items:     [String]
    let mediaType: DuckDetailView.MediaType

    @State private var index:          Int
    @State private var avPlayer:       AVPlayer?      = nil
    @State private var audioPlayer:    AVAudioPlayer? = nil
    @State private var isPlayingAudio: Bool           = false

    // -1 previous, 1 next -> controls transition direction
    @State private var lastAction:     Int            = 0

    init(title: String, items: [String], mediaType: DuckDetailView.MediaType, startIndex: Int = 0) {
        self.title     = title
        self.items     = items
        self.mediaType = mediaType
        _index = State(initialValue: startIndex)
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: [Theme.bgTop, Theme.bgBottom], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text(title).font(.title2)

                if items.isEmpty {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 220)
                        .overlay(Text("No media available").foregroundColor(.secondary))
                } 
                else {
                    // Animated media container
                    let insertion: AnyTransition = .move(edge: lastAction >= 0 ? .trailing : .leading).combined(with: .opacity)
                    let removal: AnyTransition   = .move(edge: lastAction >= 0 ? .leading : .trailing).combined(with: .opacity)
                    let transition               = AnyTransition.asymmetric(insertion: insertion, removal: removal)

                    ZStack {
                        // Content keyed by index so transition runs on change
                        Group {
                            switch mediaType {
                                case .images:
                                    MediaImage(imageNameOrURL: items[index])
                                        .frame(height: 320)
                                        .cornerRadius(16)
                                        .clipped()

                                case .videos:
                                    if let _ = URL(string: items[index]) {
                                        if let player = avPlayer {
                                            VideoPlayer(player: player)
                                                .frame(height: 320)
                                                .cornerRadius(12)
                                        } 
                                        else {
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(Color.gray.opacity(0.3))
                                                .frame(height: 220)
                                                .overlay(Text("Preparing video...").foregroundColor(.secondary))
                                        }
                                    } 
                                    else {
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(height: 220)
                                            .overlay(Text("Invalid video URL").foregroundColor(.secondary))
                                    }

                                case .sounds:
                                    VStack(spacing: 12) {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.gray.opacity(0.12))
                                            .frame(height: 120)
                                            .overlay(
                                                Image(systemName: "waveform.circle.fill")
                                                    .font(.system(size: 48))
                                                    .foregroundColor(.green)
                                            )

                                        HStack(spacing: 20) {
                                            Button(action: toggleAudio) {
                                                Image(systemName: isPlayingAudio ? "pause.circle.fill" : "play.circle.fill")
                                                    .font(.system(size: 44))
                                            }

                                            Text(items[index].components(separatedBy: "/").last ?? "Audio")
                                                .lineLimit(1)
                                                .truncationMode(.middle)
                                        }
                                    }   
                            }
                        }
                    }
                    .id(index)
                    .transition(transition)
                    .animation(.spring(), value: index)
                }
            }

            // Navigation buttons
            HStack(spacing: 40) {
                let prevEnabled = !(items.isEmpty || index == 0)
                let nextEnabled = !(items.isEmpty || index >= items.count - 1)

                Button(action: prev) {
                    Label("Previous", systemImage: "chevron.left")
                        .frame(minWidth: 100)
                }
                .disabled(!prevEnabled)
                .padding()
                .background(RoundedRectangle(cornerRadius: 20).fill(prevEnabled ? Theme.buttonGreen : Color.gray.opacity(0.35)))
                .foregroundColor(prevEnabled ? .black : .secondary)

                Button(action: next) {
                    Label("Next", systemImage: "chevron.right")
                        .frame(minWidth: 100)
                }
                .disabled(!nextEnabled)
                .padding()
                .background(RoundedRectangle(cornerRadius: 20).fill(nextEnabled ? Theme.buttonGreen : Color.gray.opacity(0.35)))
                .foregroundColor(nextEnabled ? .black : .secondary)
            }

            Spacer()
        }
        .padding()
        .onAppear { prepareCurrent() }
        .onChange(of: index) { _, _ in prepareCurrent() }
        .onDisappear { stopAll() }
        }
    }

    private func prev() { 
        withAnimation(.spring()) { 
            lastAction = -1 
            index = max(0, index - 1) 
        }
    }
    
    private func next() { 
        withAnimation(.spring()) { 
            lastAction = 1 
            index = min((items.count - 1), index + 1) 
        } 
    }

    private func prepareCurrent() {
        stopAll()
        guard !items.isEmpty else { return }
        let current = items[index]
        switch mediaType {
            case .images:
                break
            case .videos:
                if let url = URL(string: current) {
                    avPlayer = AVPlayer(url: url)
                    // Don't autoplay here, VideoPlayer will control playback
                }
            case .sounds:
                // Attempt to load audio (supports remote URLs by downloading data)
                if let url = URL(string: current) {
                    if url.isFileURL {
                        do {
                            audioPlayer = try AVAudioPlayer(contentsOf: url)
                            audioPlayer?.prepareToPlay()
                        } 
                        catch {
                            audioPlayer = nil
                        }
                    } 
                } 
                else {
                    // Download
                    URLSession.shared.dataTask(with: url) { data, _, _ in
                        guard let data = data else { return }
                        DispatchQueue.main.async {
                            do {
                                audioPlayer = try AVAudioPlayer(data: data)
                                audioPlayer?.prepareToPlay()
                            } 
                            catch {
                                audioPlayer = nil
                            }
                        }
                    }.resume()
                }
            }
        }
    }

    private func toggleAudio() {
        guard mediaType == .sounds else { return }
        if let player = audioPlayer {
            if player.isPlaying {
                player.pause()
                isPlayingAudio = false
            } 
            else {
                player.play()
                isPlayingAudio = true
            }
        }
    }

    private func stopAll() {
        avPlayer?.pause()
        avPlayer       = nil
        audioPlayer?.stop()
        audioPlayer    = nil
        isPlayingAudio = false
    }
}
