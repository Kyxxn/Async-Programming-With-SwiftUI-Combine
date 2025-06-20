import SwiftUI

struct SettingsScreen: View {
    var body: some View {
        VStack(alignment: .leading) {
            Form {
                Section {
                    NavigationLink(destination: UserProfileScreen()) {
                        Text("User Profile")
                    }
                    Text("General")
                    Text("Theme")
                    Text("App Icon")
                }
                Section {
                    Text("Notifications")
                }
                Section {
                    Text("Help")
                    Text("Feedback")
                    Text("About")
                }
            }
        }
        .navigationTitle("Settings")
    }
}
