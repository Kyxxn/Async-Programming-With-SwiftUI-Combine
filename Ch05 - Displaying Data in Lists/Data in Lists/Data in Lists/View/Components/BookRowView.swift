import SwiftUI

struct BookRowView: View {
    var book: Book
    
    var body: some View {
        HStack {
            Text(book.title)
                .font(.headline)
            Spacer()
            Text(book.author)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}
