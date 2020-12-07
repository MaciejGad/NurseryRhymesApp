//
//  NSLayoutConstraintHelper.swift
//  Nursery Rhymes
//
//  Created by Maciej Gad on 07/12/2020.
//

import Foundation
import UIKit

extension NSLayoutConstraint {
    func with<T>(_ key: ReferenceWritableKeyPath<NSLayoutConstraint, T>, _ value: T) -> Self {
        self[keyPath: key] = value
        return self
    }
}
