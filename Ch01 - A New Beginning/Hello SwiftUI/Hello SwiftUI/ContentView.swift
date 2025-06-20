//
//  ContentView.swift
//  Hello SwiftUI
//
//  Created by 박효준 on 6/20/25.
//

import SwiftUI

struct ContentView: View {
    @State private var name = ""
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            TextField("Enter your name:", text: $name)
            Text("Hello, \(name.isEmpty ? "빈 상태" : name)!")
                
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
