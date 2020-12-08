import Foundation

protocol LocalDataProviderInput {
    func data(filename: String, completion: @escaping (Result<Data, NSError>) -> Void)
    func save(data: Data, filename: String, completion: @escaping (NSError?) -> Void)
}

class LocalDataProvider: LocalDataProviderInput {
    let workingQueue: DispatchQueue
    let outputQueue: DispatchQueue
    
    init(workingQueue: DispatchQueue = .global(qos: .userInitiated), outputQueue: DispatchQueue = .main) {
        self.workingQueue = workingQueue
        self.outputQueue = outputQueue
    }
    
    func data(filename: String, completion: @escaping (Result<Data, NSError>) -> Void) {
        workingQueue.async {
            do {
                let baseURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                let fileURL = baseURL.appendingPathComponent(filename)
                let data = try Data(contentsOf: fileURL)
                self.outputQueue.async {
                    completion(.success(data))
                }
            } catch {
                self.outputQueue.async {
                    completion(.failure(error as NSError))
                }
            }
        }
    }
    
    func save(data: Data, filename: String, completion: @escaping (NSError?) -> Void) {
        workingQueue.async {
            do {
                let baseURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                let fileURL = baseURL.appendingPathComponent(filename)
                try data.write(to: fileURL)
                self.outputQueue.async {
                    completion(nil)
                }
            } catch {
                self.outputQueue.async {
                    completion(error as NSError)
                }
            }
        }
    }
}
