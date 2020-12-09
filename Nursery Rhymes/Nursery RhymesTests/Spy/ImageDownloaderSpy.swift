//
//  ImageDownloaderSpy.swift
//  Nursery RhymesTests
//
//  Created by Maciej Gad on 09/12/2020.
//

import Foundation
import Connection
import Models

class ImageDownloaderSpy: ImageDownloaderInput {
    
    var result: Result<Image, ConnectionError>?
    
    var task: SpyTask? = nil
    
    var fetchUrl: URL? = nil
    func fetch(url: URL, completion: @escaping (Result<Image, ConnectionError>) -> Void) -> Task {
        fetchUrl = url
        if let result = self.result {
            completion(result)
        }
        let task = SpyTask()
        self.task = task
        return task
    }
    
    var fetchFile: String? = nil
    func fetch(file: String, completion: @escaping (Result<Image, ConnectionError>) -> Void) -> Task {
        fetchFile = file
        if let result = self.result {
            completion(result)
        }
        let task = SpyTask()
        self.task = task
        return task
    }
}

class SpyTask: Task {
    var state: TaskState = .running
    var cancelCalled = false
    
    func cancel() {
        cancelCalled = true
    }
    
    
}
