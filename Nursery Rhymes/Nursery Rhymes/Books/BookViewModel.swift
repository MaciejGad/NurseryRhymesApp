import Foundation
import Models

struct BookViewModel: Identifiable {
    let id: Book.ID
    let title: String
    let author: String?
    let coverImage: ImagePromiseInput?
    let link: URL
}

extension BookViewModel: Hashable {
    static func == (lhs: BookViewModel, rhs: BookViewModel) -> Bool {
        guard lhs.id == rhs.id else {
            return false
        }
        guard lhs.title == rhs.title else {
            return false
        }

        guard lhs.author == rhs.author else {
            return false
        }

        guard lhs.link == rhs.link else {
            return false
        }
        return true
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(author)
        hasher.combine(link)
    }
}

