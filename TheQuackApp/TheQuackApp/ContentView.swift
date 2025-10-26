import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            // Background color
            Color(red: 0.8, green: 0.9, blue: 0.8)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("Hello, Ornitologist!")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        // Settings action
                    }) {
                        Image(systemName: "gearshape.fill")
                            .font(.title)
                            .foregroundColor(Color(red: 0.4, green: 0.5, blue: 0.4))
                    }
                }
                
                Text("Duck of the day")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                
                // Duck image placeholder
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.gray.opacity(0.3))
                    
                    Text("[Image of a duck]")
                        .foregroundColor(.gray)
                }
                .aspectRatio(2.0, contentMode: .fit)
                
                // Duck info card
                VStack(alignment: .leading, spacing: 10) {
                    Text("[Name]")
                        .font(.title3)
                        .bold()
                    
                    Text("[Short description]")
                        .foregroundColor(.gray)
                    
                    Button(action: {
                        // Check details action
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color(red: 0.4, green: 0.5, blue: 0.4))
                            
                            Text("Check details")
                                .foregroundColor(.white)
                                .padding(.vertical, 12)
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                
                // Search button
                Button(action: {
                    // Search action
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
    ContentView()
}
