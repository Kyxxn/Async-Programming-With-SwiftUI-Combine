import SwiftUI

@MainActor
class RefreshableBooksViewModel: ObservableObject {
    @Published var books: [Book] = Book.samples
    
    private func generateNewBook() -> Book {
        let title = "제목"
        let author = "저자"
        let pageCount = Int.random(in: 42...999)
        return Book(title: title, author: author, isbn: "9781234567890", pages: pageCount)
    }
    
    func refresh() async {
        do {
            try await Task.sleep(nanoseconds: 2_000_000_000)
        }
        catch {
            print("Error while refreshing books: \(error)")
        }
        let book = generateNewBook()
        books.insert(book, at: 0)
    }
}
