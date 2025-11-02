import SwiftUI

struct DuckDetailView: View {
    let duck: Duck
    
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
                            NavigationLink(destination: MediaGridView(duck: duck, mediaType: type)) {
                                Text(type.rawValue)
                                    .padding(.vertical, 10)
                                    .frame(maxWidth: .infinity)
                                    .background(Theme.buttonGreen)
                                    .foregroundColor(.white)
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding(.horizontal)

                    VStack(spacing: 12) {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Theme.bgBottom.opacity(0.8))
                            .frame(height: 220)
                            .overlay(Text("[Image of a duck]").foregroundColor(.white))

                        VStack(alignment: .leading, spacing: 8) {
                            Text(duck.name).font(.title).bold()
                            if let sci = duck.scientificName {
                                Text(sci).foregroundColor(.secondary)
                            }
                            Divider()
                            Text(duck.description).foregroundColor(.primary)
                                .fixedSize(horizontal: false, vertical: true)
                            Divider()
                            HStack {
                                Text("Regions:").bold()
                                Text(duck.region.rawValue)
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
