//
//  MarkableAsDeleted.swift
//  Appetizer
//
//  Created by Wilhelm Oks on 26.12.20.
//  Copyright © 2020 Wilhelm Oks. All rights reserved.
//

import Foundation

/// This is a wrapper for `Element`s of `Collection`s where each element can be marked as deleted but will remain in the collection.
/// The main purpose of this wrapper is for using it in collections whose elements are being used as bindings inside of ForEach statements in SwiftUI.
/// Removing an element from a collection would cause a crash in ForEach.
/// Instead, using collections with elements of this type, each element can be marked as deleted instead of removing it, which will prevent the crash.
/// When the elements are being constructed in ForEach, those marked as deleted can be skipped by using the if statement.
/// Collections that have this type as their element's type have convenience functions for accessing the deleted state.
struct MarkableAsDeleted<T> {
    var value: T
    var isDeleted = false
}

extension Collection {
    func existing<T>() -> [T] where Element == MarkableAsDeleted<T> {
        return self.filter { !$0.isDeleted }.map { $0.value }
    }
    
    func deleted<T>() -> [T] where Element == MarkableAsDeleted<T> {
        return self.filter { $0.isDeleted }.map { $0.value }
    }
}

extension Array {
    mutating func markDeleted<T>(at index: Int) where Element == MarkableAsDeleted<T> {
        self[index].isDeleted = true
    }
    
    mutating func append<T>(_ element: T) where Element == MarkableAsDeleted<T> {
        self.append(MarkableAsDeleted(value: element))
    }
    
    mutating func insert<T>(_ element: T, at index: Int) where Element == MarkableAsDeleted<T> {
        self.insert(MarkableAsDeleted(value: element), at: index)
    }
    
    subscript<T>(_ index: Int) -> T where Element == MarkableAsDeleted<T> {
        get {
            return self[index].value
        }
        set {
            self[index].value = newValue
        }
    }
}

extension Collection {
    func markableAsDeleted<T>() -> [MarkableAsDeleted<T>] where Element == T {
        return self.map { MarkableAsDeleted(value: $0) }
    }
}

extension MarkableAsDeleted: Identifiable where T: Identifiable {
    var id: T.ID { value.id }
}
