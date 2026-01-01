import SwiftUI

struct DuckDetailView: View {
    let duck: Duck
    @ObservedObject private var settings = AppSettings.shared
    @State private var selectedMediaType: MediaType?
    
    enum MediaType: String, CaseIterable, Identifiable {
        case images = "Images"
        case videos = "Videos"
        case sounds = "Sounds"
        var id: String { rawValue }
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: [Theme.bgTop, Theme.bgBottom], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    Text(duck.name)
                        .font(.largeTitle.weight(.bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 8)

                                    // media type buttons
                    HStack(spacing: 12) {
                        ForEach(MediaType.allCases) { type in
                            Button(action: {
                                selectedMediaType = type
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Theme.buttonGreen)
                                    
                                    Text(type.rawValue)
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                        .padding(.vertical, 16)
                                        .padding(.horizontal, 8)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(minHeight: 50)
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                    .navigationDestination(item: $selectedMediaType) { type in
                        MediaGridView(duck: duck, mediaType: type)
                    }

                    VStack(spacing: 12) {
                        MediaImage(imageNameOrURL: duck.images.first)
                            .frame(height: 200)
                            .cornerRadius(20)
                            .clipped()

                        VStack(alignment: .leading, spacing: 8) {
                            Text(duck.name).font(.title).bold()
                            if settings.showScientificNames, let sci = duck.scientificName {
                                Text(sci)
                                    .font(.subheadline)
                                    .italic()
                                    .foregroundColor(.secondary)
                            }
                            Divider()
                            Text(duck.description).foregroundColor(.primary)
                                .fixedSize(horizontal: false, vertical: true)
                            if let cool = duck.coolFacts, !cool.isEmpty {
                                Divider()
                                Text("Cool facts")
                                    .font(.headline)
                                Text(cool).foregroundColor(.primary).fixedSize(horizontal: false, vertical: true)
                            }
                            if let find = duck.findThisBird, !find.isEmpty {
                                Divider()
                                Text("Find this bird")
                                    .font(.headline)
                                Text(find).foregroundColor(.primary).fixedSize(horizontal: false, vertical: true)
                            }
                            Divider()
                            HStack {
                                Text("Regions:").bold()
                                Text(duck.regions.map { $0.rawValue }.joined(separator: ", "))
                                Spacer()
                            }
                        }
                        .padding()
                        .background(Theme.cardBackground)
                        .cornerRadius(24)
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 40)
                }
            }
        }
    }
}

struct DuckDetailView_Previews: PreviewProvider {
    static var previews: some View { DuckDetailView(duck: Duck.sample[0]) }
}
