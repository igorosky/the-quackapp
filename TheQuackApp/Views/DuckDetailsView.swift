import SwiftUI

struct DuckDetailsView: View {
    let duck: Duck
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            // Background color
            Color(red: 0.8, green: 0.9, blue: 0.8)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header (use NavigationStack back button when available)
                HStack {
                    Text("Details")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                
                // Tab buttons
                HStack(spacing: 15) {
                    ForEach(["Images", "Videos", "Sounds"], id: \.self) { tab in
                        Button(action: {
                            withAnimation {
                                selectedTab = ["Images", "Videos", "Sounds"].firstIndex(of: tab) ?? 0
                            }
                        }) {
                            Text(tab)
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(
                                    Capsule()
                                        .fill(Color(red: 0.4, green: 0.5, blue: 0.4))
                                )
                        }
                    }
                }
                
                // Main image
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                    
                    if duck.images.isEmpty {
                        Text("[Image of a duck]")
                            .foregroundColor(.gray)
                    } else {
                        AsyncImage(url: duck.images.first) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                    }
                }
                .aspectRatio(1.5, contentMode: .fit)
                
                // Duck info
                VStack(alignment: .leading, spacing: 10) {
                    Text(duck.name)
                        .font(.title2)
                        .bold()
                    
                    Text(duck.scientificName)
                        .italic()
                        .foregroundColor(.gray)
                    
                    Text(duck.description)
                        .foregroundColor(.black)
                    
                    Text("Regions:")
                        .font(.headline)
                    Text(duck.regions.joined(separator: ", "))
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    DuckDetailsView(duck: Duck(
        name: "Sample Duck",
        scientificName: "Duckus Maximus",
        description: "A beautiful sample duck for preview purposes.",
        regions: ["North America", "Europe"],
        images: [],
        videos: [],
        sounds: []
    ))
}