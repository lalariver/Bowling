//
//  ExtensionCollection.swift
//  Bowling
//
//  Created by user on 2024/1/3.
//

import Foundation

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
