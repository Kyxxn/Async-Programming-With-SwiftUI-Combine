//
//  MakeInputFormApp.swift
//  MakeInputForm
//
//  Created by 박효준 on 6/20/25.
//

import SwiftUI

@main
struct MakeInputFormApp: App {
    @StateObject private var viewModel = BooksViewModel()
    
    var body: some Scene {
        WindowGroup {
            BooksListView(booksViewModel: viewModel)
        }
    }
}
