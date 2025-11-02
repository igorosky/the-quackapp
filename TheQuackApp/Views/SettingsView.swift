import SwiftUI

struct SettingsView: View {
    @AppStorage("showScientificNames") private var showScientificNames = true
    @AppStorage("darkMode") private var darkMode = false
    
    var body: some View {
        ZStack {
            // Background color
            Color(red: 0.8, green: 0.9, blue: 0.8)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header (use NavigationStack/back automatically)
                HStack {
                    Text("Settings")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                
                // Settings content
                VStack(spacing: 0) {
                    // Display section
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Display")
                            .font(.title2)
                            .bold()
                        
                        Toggle("Scientific names", isOn: $showScientificNames)
                        Divider()
                        Toggle("Dark mode", isOn: $darkMode)
                    }
                    .padding()
                    .background(Color.white)
                    
                    Divider()
                    
                    // Information section
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Information")
                            .font(.title2)
                            .bold()
                        
                        HStack {
                            Text("App version")
                            Spacer()
                            Text("1.0.0")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color.white)
                }
                .cornerRadius(15)
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    SettingsView()
}