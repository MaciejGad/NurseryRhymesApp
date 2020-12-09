import Foundation
import Connection
import Models

class SingleRhymeProviderSpy: SingleRhymeProviderInput {
    
    var result: Result<Rhyme, ConnectionError>?
    
    var fetchCalled: Bool = false
    var fetchId: Rhyme.ID? = nil
    
    func fetch(id: Rhyme.ID, completion: @escaping (Result<Rhyme, ConnectionError>) -> Void) {
        fetchCalled = true
        fetchId = id
        if let result = self.result {
            completion(result)
        }
    }
}
