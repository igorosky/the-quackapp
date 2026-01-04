/**
 * *****************************************************************************
 * @file           : Models.swift
 * @author         : Alex Rogoziński
 * @brief          : This file contains data models for ducks and regions,
                     as well as the remote loader for fetching duck data from
                     a server.
 * *****************************************************************************
 */

import Foundation
import Combine

enum Region: String, CaseIterable {
    case all          = "All"
    case northAmerica = "North America"
    case southAmerica = "South America"
    case europe       = "Europe"
    case asia         = "Asia"
    case africa       = "Africa"
    case oceania      = "Oceania"
    case antarctica   = "Antarctica"
}

struct Duck: Identifiable, Hashable {
    let id = UUID()
    let name:             String
    let scientificName:   String?
    let regions:          [Region]
    let shortDescription: String
    let description:      String
    // Optional extended text loaded from server
    var coolFacts:    String?
    var findThisBird: String?
    // Placeholders for media
    let images: [String]
    let videos: [String]
    let sounds: [String]
    
    // Implement Hashable manually since UUID doesn't automatically get included
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Duck, rhs: Duck) -> Bool {
        lhs.id == rhs.id
    }
}

// A simple manifest item expected from the server. The server-side `manifest.json` should be an array
// of objects describing each duck. Fields are optional to allow graceful fallback to local samples.
struct DuckManifestItem: Decodable {
    let species_name:      String?
    let scientific_name:   String?
    let basic_description: String?
    let cool_facts:        String?
    let find_this_bird:    String?
    let images:            [String]?
    let videos:            [String]?
    let sounds:            [String]?
    let regions:           [String]?
}

final class DucksStore: ObservableObject {
    @Published var ducks:    [Duck] = []
    @Published var isLoading: Bool  = true
    var baseURL: URL
    private var cancellable: AnyCancellable?

    init() {
        let base = URL(string: AppSettings.shared.serverBaseURL) ?? URL(string: "http://localhost/")!
        self.baseURL = base
        // Subscribe to settings changes so updating the server URL will refresh the manifest
        cancellable = AppSettings.shared.objectWillChange.sink { [weak self] _ in
            guard let self = self else { return }
            let newURL = URL(string: AppSettings.shared.serverBaseURL) ?? URL(string: "http://localhost/")!
            if newURL != self.baseURL {
                self.baseURL = newURL
                self.isLoading = true
                self.fetchManifest()
            }
        }
        fetchManifest()
    }

    private func fetchManifest() {
        // Try multiple common manifest locations so the app is resilient to different mount setups.
        let candidatePaths = ["manifest.json", "ducks/manifest.json", "/ducks/manifest.json"]

        func tryCandidate(_ index: Int) {
            guard index < candidatePaths.count else {
                DispatchQueue.main.async {
                    self.ducks     = []
                    self.isLoading = false
                }
                return
            }

            let path        = candidatePaths[index]
            let manifestURL = baseURL.appendingPathComponent(path)
            let request     = URLRequest(url: manifestURL, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 6)

            URLSession.shared.dataTask(with: request) { data, resp, err in
                // If data received, attempt to decode, otherwise try next candidate
                guard let data = data else {
                    tryCandidate(index + 1)
                    return
                }

                do {
                    let raw   = try JSONDecoder().decode([DuckManifestItem].self, from: data)
                    let items = raw.compactMap { item -> DuckManifestItem? in
                        if item.species_name == nil && item.basic_description == nil && (item.images == nil || item.images?.isEmpty == true) {
                            return nil
                        }
                        return item
                    }

                    var loaded: [Duck] = []
                    let group          = DispatchGroup()

                    for item in items {
                        group.enter()
                        DispatchQueue.global().async {
                            // Map provided region strings to Region enum values; default to .all
                            var regions: [Region] = []
                            if let regStrings = item.regions {
                                regions = regStrings.compactMap { Region(rawValue: $0) }
                            }
                            if regions.isEmpty { regions = [.all] }
                            var images:    [String] = []
                            var videos:    [String] = []
                            var sounds:    [String] = []
                            var basicDesc: String   = ""
                            var cool:      String?  = nil
                            var find:      String?  = nil

                            if let imgs = item.images {
                                images = imgs.map { self.baseURL.appendingPathComponent($0).absoluteString }
                            }
                            if let vids = item.videos {
                                videos = vids.map { self.baseURL.appendingPathComponent($0).absoluteString }
                            }
                            if let snds = item.sounds {
                                sounds = snds.map { self.baseURL.appendingPathComponent($0).absoluteString }
                            }
                            if let descPath = item.basic_description {
                                basicDesc = self.fetchText(relative: descPath) ?? ""
                            }
                            if let coolPath = item.cool_facts {
                                cool = self.fetchText(relative: coolPath)
                            }
                            if let findPath = item.find_this_bird {
                                find = self.fetchText(relative: findPath)
                            }

                            let name = item.species_name ?? "Unknown"
                            let duck = Duck(
                                name:             name, 
                                scientificName:   item.scientific_name, 
                                regions:          regions, 
                                shortDescription: basicDesc.isEmpty ? "" : String(basicDesc.prefix(140)), 
                                description:      basicDesc.isEmpty ? "No description available." : basicDesc, 
                                coolFacts:        cool, 
                                findThisBird:     find, 
                                images:           images, 
                                videos:           videos, 
                                sounds:           sounds
                            )
                            DispatchQueue.main.async {
                                loaded.append(duck)
                                group.leave()
                            }
                        }
                    }

                    group.notify(queue: .main) {
                        self.ducks     = loaded
                        self.isLoading = false
                    }
                } 
                catch {
                    // Decoding failed for this candidate, try next
                    tryCandidate(index + 1)
                }
            }.resume()
        }

        tryCandidate(0)
    }

    // Synchronous helper to fetch small text, returns nil on failure
    private func fetchText(relative: String) -> String? {
        let url = baseURL.appendingPathComponent(relative)
        if let data = try? Data(contentsOf: url), let s = String(data: data, encoding: .utf8) {
            return s.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return nil
    }
}
