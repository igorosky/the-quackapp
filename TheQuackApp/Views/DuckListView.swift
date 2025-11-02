import SwiftUI

struct DuckListView: View {
    @Binding var showDuckList: Bool
    @State private var searchText = ""
    @State private var selectedRegion = "All"
    
    // Sample data - will be replaced with API data later
    let sampleDucks = [
        Duck(
            name: "Mallard",
            scientificName: "Anas platyrhynchos",
            description: "The mallard is a dabbling duck that breeds throughout the temperate and subtropical Americas, Eurasia, and North Africa.",
            regions: ["North America", "Europe", "Asia"],
            images: [],
            videos: [],
            sounds: []
        )
    ]
    
    var filteredDucks: [Duck] {
        sampleDucks.filter { duck in
            let matchesSearch = searchText.isEmpty || 
                duck.name.localizedCaseInsensitiveContains(searchText) ||
                duck.scientificName.localizedCaseInsensitiveContains(searchText)
            let matchesRegion = selectedRegion == "All" || duck.regions.contains(selectedRegion)
            return matchesSearch && matchesRegion
        }
    }
    
    var body: some View {
        ZStack {
            // Background color
            Color(red: 0.8, green: 0.9, blue: 0.8)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header
                HStack {
                    Button(action: {
                        // back to home
                        showDuckList = false
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                    }

                    Text("Ducks")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.leading, 6)
                    
                    Spacer()
                    
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                }
                
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Enter duck's name...", text: $searchText)
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                
                // Region selector
                HStack {
                    Text("Region: ")
                        .bold()
                    Text(selectedRegion)
                }
                .padding(.vertical, 10)
                
                // Duck list
                ScrollView {
                    LazyVStack(spacing: 15) {
                        ForEach(filteredDucks) { duck in
                            NavigationLink(destination: DuckDetailsView(duck: duck)) {
                                DuckRowView(duck: duck)
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }
}

struct DuckRowView: View {
    let duck: Duck
    @AppStorage("showScientificNames") private var showScientificNames = true
    
    var body: some View {
        HStack(spacing: 15) {
            // Duck image
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 60, height: 60)
                
                if duck.images.isEmpty {
                    Image(systemName: "photo")
                        .foregroundColor(.gray)
                } else {
                    AsyncImage(url: duck.images.first) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(duck.name)
                    .font(.headline)
                    .foregroundColor(.black)
                
                if showScientificNames {
                    Text(duck.scientificName)
                        .font(.subheadline)
                        .italic()
                        .foregroundColor(.gray)
                }
                
                Text(duck.regions.first ?? "")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
    }
}

#Preview {
    DuckListView(showDuckList: .constant(true))
}