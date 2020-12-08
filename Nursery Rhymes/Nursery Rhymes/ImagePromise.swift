import Foundation
import UIKit
import Connection

protocol ImagePromiseInput {
    @discardableResult func fetch(competion: @escaping (Result<UIImage, ConnectionError>) -> Void) -> Task
}


class ImagePromise: ImagePromiseInput {
    let url: URL
    private let downloader: ImageDownloaderInput

    private var image: UIImage? = nil
    
    init(url: URL, downloader: ImageDownloaderInput) {
        self.url = url
        self.downloader = downloader
    }
    
    @discardableResult func fetch(competion: @escaping (Result<UIImage, ConnectionError>) -> Void) -> Task {
        if let image = self.image {
            competion(.success(image))
            return ComplitedTask()
        }
        return downloader.fetch(url: url) {[weak self] result in
            if case let Result.success(image) = result {
                self?.image = image
            }
            competion(result)
        }
    }
}

extension Optional where Wrapped == URL {
    func asImagePromise(downloader: ImageDownloaderInput) -> ImagePromise? {
        switch self {
        case .some(let url):
            return ImagePromise(url: url, downloader: downloader)
        case .none:
            return nil
        }
    }
}

#if DEBUG

class ImagePromiseMock: ImagePromiseInput {
    var result: Result<UIImage, ConnectionError>
    
    init(success image: UIImage) {
        result = .success(image)
    }
    
    init(failure error: ConnectionError) {
        result = .failure(error)
    }
    
    @discardableResult func fetch(competion: @escaping (Result<UIImage, ConnectionError>) -> Void) -> Task {
        competion(result)
        return ComplitedTask()
    }
}


#endif
