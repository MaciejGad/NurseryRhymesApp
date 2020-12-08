import Foundation
import Models

struct ListViewModel: Identifiable {
    
    let id: Rhyme.ID
    let title: String
    let author: String?
    let image: ImagePromiseInput?
    let isFavourite: Bool
}

extension ListViewModel: Hashable {
    static func == (lhs: ListViewModel, rhs: ListViewModel) -> Bool {
        guard lhs.id == rhs.id else {
            return false
        }
        guard lhs.title == rhs.title else {
            return false
        }
        guard lhs.author == rhs.author else {
            return false
        }
        guard lhs.isFavourite == rhs.isFavourite else {
            return false
        }
        return true
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        if let author = self.author {
            hasher.combine(author)
        }
        hasher.combine(isFavourite)
    }
}

