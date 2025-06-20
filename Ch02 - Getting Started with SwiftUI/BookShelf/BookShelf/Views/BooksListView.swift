import SwiftUI

struct BooksListView: View {
    var books: [Book]
    
    var body: some View {
        List(books) { book in
            BookRowView(book: book)
        }
        .listStyle(.plain)
    }
}

struct BooksListView_Previews: PreviewProvider {
    static var previews: some View {
        BooksListView(books: Book.sampleBooks)
    }
}
