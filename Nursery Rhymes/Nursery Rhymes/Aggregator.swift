import Foundation
import Connection

class Aggregator<A, B, E: Error> {
    var aResult: Result<A, E>? {
        didSet {
            update()
        }
    }
    
    var bResult: Result<B, E>? {
        didSet {
            update()
        }
    }
    
    let completion: (Result<(a: A, b: B), E>) -> Void
    
    init(completion: @escaping (Result<(a: A, b: B), E>) -> Void) {
        self.completion = completion
    }
    
    func update() {
        if let error = getError() {
            completion(.failure(error))
            return
        }
        guard case let .success(a) = aResult  else {
            return
        }
        guard case let .success(b) = bResult  else {
            return
        }
        completion(.success((a: a, b: b)))
    }

    private func getError() -> E? {
        if case let .failure(error) = aResult {
            return error
        }
        if case let .failure(error) = bResult {
            return error
        }
        return nil
    }
    
}
