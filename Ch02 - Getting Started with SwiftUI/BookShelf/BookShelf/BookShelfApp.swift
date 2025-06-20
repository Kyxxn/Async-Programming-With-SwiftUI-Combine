//
//  BookShelfApp.swift
//  BookShelf
//
//  Created by 박효준 on 6/20/25.
//

import SwiftUI

@main
struct BookShelfApp: App {
    var body: some Scene {
        WindowGroup {
            BooksListView(books: Book.sampleBooks)
        }
    }
}
