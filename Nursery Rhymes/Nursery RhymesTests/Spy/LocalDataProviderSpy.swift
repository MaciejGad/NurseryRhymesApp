import Foundation

@testable import Nursery_Rhymes

class LocalDataProviderSpy: LocalDataProviderInput {
    
    var dataFilename: String?
    var givenData: Result<Data, NSError>?
    func data(filename: String, completion: @escaping (Result<Data, NSError>) -> Void) {
        dataFilename = filename
        if let givenData = self.givenData {
            completion(givenData)
        }
    }
    
    var saveData: Data?
    var saveFilename: String?
    var givenSaveSuccess: Bool?
    var givenSaveError: NSError?
    
    func save(data: Data, filename: String, completion: @escaping (NSError?) -> Void) {
        saveData = data
        saveFilename = filename
        if let givenSuccess = givenSaveSuccess {
            if givenSuccess {
                completion(nil)
            } else {
                completion(givenSaveError ?? NSError())
            }
        }
    }
    
    
}
