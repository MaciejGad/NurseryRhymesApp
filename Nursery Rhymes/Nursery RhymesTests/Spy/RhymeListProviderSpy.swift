import Foundation
import Connection
import Models

class RhymeListProviderSpy: RhymeListProviderInput {
    
    var result: Result<List, ConnectionError>?
    
    var fetchListCalled: Bool = false
    
    func fetchList(completion: @escaping (Result<List, ConnectionError>) -> Void) {
        fetchListCalled = true
        if let result = self.result {
            completion(result)
        }
    }
}
