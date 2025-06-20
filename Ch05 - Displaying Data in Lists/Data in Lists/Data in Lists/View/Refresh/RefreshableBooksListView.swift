//
//  ContentView.swift
//  Data in Lists
//
//  Created by 박효준 on 6/20/25.
//

import SwiftUI

struct RefreshableBooksListView: View {
    @StateObject private var viewModel = RefreshableBooksViewModel()
    
    var body: some View {
        List(viewModel.books) {
            BookRowView(book: $0)
        }
        .refreshable {
            await viewModel.refresh()
        }
        .animation(.default, value: viewModel.books)
    }
}

#Preview {
    RefreshableBooksListView()
}
