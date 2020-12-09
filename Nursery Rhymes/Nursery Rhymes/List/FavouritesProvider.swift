import Foundation
import Models

typealias FavouritesList = Set<Rhyme.ID>

protocol FavouritesProviderInput {
    func load(completion: @escaping (FavouritesList) -> Void)
    func addToFavourites(id: Rhyme.ID, completion: @escaping (Error?) -> Void)
    func removeFromFavourites(id: Rhyme.ID, completion: @escaping (Error?) -> Void)
    func isFavourite(id: Rhyme.ID, completion: @escaping (Bool) -> Void)
}

/**
 In the real-life application user's favorites should be store in the backend or in the CoreData database (or similar) rather than being saved to a JSON file
 */

class FavouritesProvider: FavouritesProviderInput {
    
    private let localDataProvider: LocalDataProviderInput
    private let filename = "favourites.json"
    private var favouritesList: FavouritesList? = nil
    
    init(localDataProvider: LocalDataProviderInput) {
        self.localDataProvider = localDataProvider
    }
    
    func load(completion: @escaping (FavouritesList) -> Void) {
        if let localFavouritesList = self.favouritesList {
            DispatchQueue.main.async {
                completion(localFavouritesList)
            }
            return
        }
        #if DEBUG
        if ProcessInfo.processInfo.arguments.contains("RESET_FAVOURITES") {
            let favouritesList = FavouritesList()
            self.favouritesList = favouritesList
            completion(favouritesList)
            return
        }
        #endif
        localDataProvider.data(filename: filename) { [weak self] result in
            switch result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                do {
                    let list = try jsonDecoder.decode(FavouritesList.self, from: data)
                    self?.favouritesList = list
                    completion(list)
                } catch {
                    completion(FavouritesList())
                }
            case .failure:
                completion(FavouritesList())
            }
        }
    }
    
    func isFavourite(id: Rhyme.ID, completion: @escaping (Bool) -> Void) {
        load { list in
            completion(list.contains(id))
        }
    }
    
    func addToFavourites(id: Rhyme.ID, completion: @escaping (Error?) -> Void) {
        load { [weak self] aList in
            var list = aList
            list.insert(id)
            self?.save(list: list, completion: { error in
                if error != nil {
                    self?.favouritesList?.remove(id)
                }
                completion(error)
            })
        }
    }
    
    func removeFromFavourites(id: Rhyme.ID, completion: @escaping (Error?) -> Void) {
        load {[weak self] aList in
            var list = aList
            list.remove(id)
            self?.save(list: list, completion: { error in
                if error != nil {
                    self?.favouritesList?.insert(id)
                }
                completion(error)
            })

        }
    }
    
    private func save(list: FavouritesList, completion: @escaping (Error?) -> Void) {
        self.favouritesList = list
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(list)
            self.localDataProvider.save(data: data, filename: self.filename, completion: completion)
        } catch {
            completion(error)
        }
    }
}
