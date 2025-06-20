import SwiftUI

struct UserProfileScreen: View {
    @EnvironmentObject var profile: UserProfile
    
    var body: some View {
        VStack(alignment: .leading) {
            Form {
                Section(header: Text("User profile")) {
                    TextField("Name", text: $profile.name)
                    TextField("favourite Programming Language", text: $profile.favouriteProgrammingLanguage)
                    ColorPicker("Favourite color", selection: $profile.favouriteColor)
                }
            }
        }
        .navigationTitle("User Profile")
    }
}
