import Foundation
import Connection
import Models

class BookListForRhymeProviderSpy: BookListForRhymeProviderInput {
    
    var result: Result<BookListForRhyme, ConnectionError>?
    
    var fetchCalled: Bool = false
    var fetchId: Rhyme.ID? = nil
    
    func fetch(id: Rhyme.ID, completion: @escaping (Result<BookListForRhyme, ConnectionError>) -> Void) {
        fetchCalled = true
        fetchId = id
        if let result = self.result {
            completion(result)
        }
    }
    
}
