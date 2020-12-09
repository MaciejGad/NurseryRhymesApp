import Foundation
import Connection
import Models

@testable import Nursery_Rhymes

class FavouritesProviderSpy: FavouritesProviderInput {
    
    var givenList: FavouritesList? = nil
    var loadCalled = false
    func load(completion: @escaping (FavouritesList) -> Void) {
        loadCalled = true
        if let list = givenList {
            completion(list)
        }
    }
    
    var addToFavouritesId: Rhyme.ID?
    func addToFavourites(id: Rhyme.ID, completion: @escaping (Error?) -> Void) {
        addToFavouritesId = id
    }
    var removeFromFavouritesId: Rhyme.ID?
    func removeFromFavourites(id: Rhyme.ID, completion: @escaping (Error?) -> Void) {
        removeFromFavouritesId = id
    }
    
    var isFavouriteId: Rhyme.ID?
    var isFavouriteGiven: ((Rhyme.ID) -> Bool)?
    func isFavourite(id: Rhyme.ID, completion: @escaping (Bool) -> Void) {
        isFavouriteId = id
        if let isFavourite = isFavouriteGiven?(id) {
            completion(isFavourite)
        }
    }
}
