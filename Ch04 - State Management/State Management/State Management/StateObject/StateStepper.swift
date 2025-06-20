import SwiftUI

final class Counter: ObservableObject {
    @Published var count = 0
}

struct StateStepper: View {
    @StateObject var counter: Counter
    
    var body: some View {
        Section(header: Text("@StateObject")) {
            Stepper("Counter: \(counter.count)", value: $counter.count)
        }
    }
}
