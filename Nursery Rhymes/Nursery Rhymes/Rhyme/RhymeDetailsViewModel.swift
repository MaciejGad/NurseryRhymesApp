import Foundation
import Models

struct RhymeDetailsViewModel {
    let title: String
    let author: String?
    let image: ImagePromiseInput?
    let text: String
    let books: [BookViewModel]
}
