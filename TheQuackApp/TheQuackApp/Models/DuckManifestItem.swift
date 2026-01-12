import Foundation

// A simple manifest item expected from the server. The server-side `manifest.json` should be an array
// of objects describing each duck. Fields are optional to allow graceful fallback to local samples.
struct DuckManifestItem: Decodable, Sendable {
    let species_name: String?
    let scientific_name: String?
    let basic_description: String?
    let cool_facts: String?
    let find_this_bird: String?
    let images: [String]?
    let videos: [String]?
    let sounds: [String]?
    let regions: [String]?
}
