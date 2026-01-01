import SwiftUI

struct SettingsView: View {
    @ObservedObject private var settings         = AppSettings.shared
    @AppStorage("darkMode") private var darkMode = false

    var body: some View {
        ZStack {
            LinearGradient(colors: [Theme.bgTop, Theme.bgBottom], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Settings")
                        .font(.largeTitle.weight(.bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 8)

                    VStack(spacing: 16) {
                        Text("Display").font(.title2).bold()
                        Toggle(isOn: Binding(get: { settings.showScientificNames }, set: { settings.showScientificNames = $0 })) {
                            Text("Scientific names")
                        }
                        Divider()
                        Toggle("Dark mode", isOn: $darkMode)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).fill(Theme.cardBackground))
                    .padding(.horizontal)

                    VStack(spacing: 16) {
                        Text("Information").font(.title2).bold()
                        HStack {
                            Text("App version")
                            Spacer()
                            Text("1.0.0").foregroundColor(.secondary)
                        }
                        Divider()
                        VStack(alignment: .leading, spacing: 8) {
                            Text("[DEV] Ducks server URL").font(.subheadline).bold()
                            TextField("http://localhost/", text: Binding(get: { settings.serverBaseURL }, set: { settings.serverBaseURL = $0 }))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.URL)
                                .autocapitalization(.none)
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).fill(Theme.cardBackground))
                    .padding(.horizontal)

                    Spacer()
                }
                .padding(.top)
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View { SettingsView() }
}
