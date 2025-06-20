import SwiftUI

struct ContentView: View {
    @State private var color = Color.accentColor
    @StateObject private var counter = Counter()
    
    var body: some View {
        VStack {
            EnvironmentObjectSampleScreen()
            ColorPicker("Select a color", selection: $color)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
