import SwiftUI

final class UserProfile: ObservableObject {
    @Published var name: String
    @Published var favouriteProgrammingLanguage: String
    @Published var favouriteColor: Color
    
    init(name: String, favouriteProgrammingLanguage: String, favouriteColor: Color) {
        self.name = name
        self.favouriteProgrammingLanguage = favouriteProgrammingLanguage
        self.favouriteColor = favouriteColor
    }
}

struct EnvironmentObjectSampleScreen: View {
    @StateObject var profile = UserProfile(name: "Peter", favouriteProgrammingLanguage: "Swift", favouriteColor: .pink)
    @State var isSettingsShown = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Form {
                Section(header: Text("")) {
                    Text("This is just some random data")
                    Text("Let's assume this was the main screen of an app")
                    Text("Tap the cog icon to go to the fake settings screen")
                }
            }
            HStack {
                Text("Signed in as \(profile.name)")
                    .foregroundColor(Color(UIColor.systemBackground))
                Spacer()
            }
            .padding(30)
            .background(profile.favouriteColor)
        }
        .ignoresSafeArea(edges: .bottom)
        .navigationTitle("@EnvironmentObject")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action:showSetting){
                    Image(systemName: "gearshape")
                }
            }
        }
        .sheet(isPresented: $isSettingsShown) {
            NavigationStack {
                SettingsScreen()
            }
            .environmentObject(profile)
        }
    }
    
    func showSetting() {
        isSettingsShown.toggle()
    }
}
