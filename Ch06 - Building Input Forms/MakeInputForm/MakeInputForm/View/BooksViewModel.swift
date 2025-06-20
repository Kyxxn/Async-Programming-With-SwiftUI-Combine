import SwiftUI

final class BooksViewModel: ObservableObject {
    @Published var books: [Book] = Book.sampleBooks
}
