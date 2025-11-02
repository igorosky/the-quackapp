import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("showScientificNames") private var showScientificNames = true
    @AppStorage("darkMode") private var darkMode = false
    
    var body: some View {
        ZStack {
            // Background color
            Color(red: 0.8, green: 0.9, blue: 0.8)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                    
                    Text("Settings")
                        .font(.title)
                        .bold()
                    
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