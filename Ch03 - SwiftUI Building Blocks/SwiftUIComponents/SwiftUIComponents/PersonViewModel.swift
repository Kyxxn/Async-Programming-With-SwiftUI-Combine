import SwiftUI

final class PersonViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    
    func save() {
        print("Saving Person: \(firstName) \(lastName)")
    }
}
