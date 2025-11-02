import SwiftUI

struct HomePage: View {
    @Binding var showDuckList: Bool
    @State private var showDetails = false
    private var sampleDuck: Duck {
        Duck(
            name: "Mallard",
            scientificName: "Anas platyrhynchos",
            description: "The mallard is a dabbling duck that breeds throughout the temperate and subtropical Americas, Eurasia, and North Africa.",
            regions: ["North America", "Europe", "Asia"],
            images: [],
            videos: [],
            sounds: []
        )
    }
    
    var body: some View {
        ZStack {
            // Background color
            Color(red: 0.8, green: 0.9, blue: 0.8)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("Hello, Ornitologist!")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                }
                
                Text("Duck of the day")
                    .font(.title2)
                    .bold()
                
                // Duck of the day card
                VStack {
                    // Duck image placeholder
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.gray.opacity(0.3))
                        
                        Text("[Image of a duck]")
                            .foregroundColor(.gray)
                    }
                    .aspectRatio(1.5, contentMode: .fit)
                    
                    // Duck info card
                    VStack(alignment: .leading, spacing: 10) {
                        Text("[Name]")
                            .font(.title3)
                            .bold()
                        
                        Text("[Short description]")
                            .foregroundColor(.gray)
                        
                        // Navigation link activated programmatically so we can prepare data later
                        Button(action: {
                            showDetails = true
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color(red: 0.4, green: 0.5, blue: 0.4))
                                
                                Text("Check details")
                                    .foregroundColor(.white)
                                    .padding(.vertical, 12)
                            }
                        }
                        // hidden NavigationLink for programmatic navigation
                        NavigationLink(destination: DuckDetailsView(duck: sampleDuck), isActive: $showDetails) {
                            EmptyView()
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                }
                
                // Search button
                Button(action: {
                    showDuckList = true
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                        
                        Text("Search for ducks")
                            .foregroundColor(.black)
                            .padding(.vertical, 15)
                    }
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    NavigationStack {
        HomePage(showDuckList: .constant(false))
    }
}