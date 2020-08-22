//
//  ObservableList.swift
//  Appetizer
//
//  Created by Wilhelm Oks on 11.08.20.
//  Copyright © 2020 Wilhelm Oks. All rights reserved.
//

import Foundation

/**
 Is not allowed to contain duplicate ids.
 */
public class ObservableList<Element: Identifiable>: ObservableObject {
    @Published var ids: [Element.ID] = []
    @Published var elementsDict: [Element.ID : Element] = [:]

    var elements: [Element] { ids.map { elementsDict[$0]! } }
    
    init() {
        
    }
    
    init(_ elements: [Element]) {
        append(contentsOf: elements)
    }
    
    func firstIndex(where: (Element) -> Bool) -> Int? {
        return elements.firstIndex { `where`($0) }
    }
    
    func first(where: (Element) -> Bool) -> Element? {
        return elements.first { `where`($0) }
    }
    
    func append(_ element: Element) {
        ids.append(element.id)
        elementsDict[element.id] = element
    }
    
    func append(contentsOf array: [Element]) {
        ids.append(contentsOf: array.map { $0.id })
        for element in array {
            elementsDict[element.id] = element
        }
    }
    
    func insert(_ element: Element, at index: Int) {
        ids.insert(element.id, at: index)
        elementsDict[element.id] = element
    }
    
    func remove(at index: Int) {
        let id = ids[index]
        ids.remove(at: index)
        elementsDict[id] = nil
    }
    
    func removeFirst() {
        let id = ids.removeFirst()
        elementsDict[id] = nil
    }
    
    func removeLast() {
        let id = ids.removeLast()
        elementsDict[id] = nil
    }
    
    func element(id: Element.ID) -> Element {
        return elementsDict[id]!
    }
    
    subscript(_ index: Int) -> Element {
        get {
            return self.elementsDict[self.ids[index]]!
        }
        set {
            self.ids[index] = newValue.id
            self.elementsDict[newValue.id] = newValue
        }
    }
    
    subscript(unchecked key: Element.ID) -> Element {
        get {
            guard let result = self.elementsDict[key] else {
                fatalError("This element does not exist.")
            }
            return result
        }
        set {
            if(!self.ids.contains(key)) {
                self.ids.append(key)
            }
            self.elementsDict[key] = newValue
        }
    }
}

/*
extension Dictionary where Value: Identifiable {
    typealias Key = Value.ID
    subscript(unchecked key: Key) -> Value {
        get {
            guard let result = self[key] else {
                fatalError("This element does not exist.")
            }
            return result
        }
        set {
            self[key] = newValue
        }
    }
}
*/
