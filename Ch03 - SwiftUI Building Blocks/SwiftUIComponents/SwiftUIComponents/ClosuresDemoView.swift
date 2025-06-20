//
//  ContentView.swift
//  SwiftUIComponents
//
//  Created by 박효준 on 6/20/25.
//

import SwiftUI

struct ClosuresDemoView: View {
    @State private var message = ""
    @State private var dirty = false
    @StateObject private var viewModel = PersonViewModel()
    
    var body: some View {
        Form {
            Section("\(self.dirty ? "*" : "")Input Fields") {
                TextField("Frist Name", text: $viewModel.firstName)
                    .onChange(of: viewModel.firstName) {
                        self.dirty = true
                    }
                
                TextField("Last Name", text: $viewModel.lastName)
                    .onChange(of: viewModel.lastName) {
                        self.dirty = true
                    }
            }
            .onSubmit {
                viewModel.save()
            }
        }
    }
}

#Preview {
    ClosuresDemoView()
}
