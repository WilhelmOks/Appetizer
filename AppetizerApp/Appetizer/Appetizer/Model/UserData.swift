//
//  UserData.swift
//  Appetizer
//
//  Created by Wilhelm Oks on 08.03.20.
//  Copyright © 2020 Wilhelm Oks. All rights reserved.
//

import Foundation

final class UserData: ObservableObject {
    //@Published var tasks = ObservableList<Task>()
    @Published var tasks: [Task] = []
    
    //var taskViewModels: [TaskVM] { tasks.map { TaskVM($0) } }
    
    static let outputTypes: [OutputType] = OutputType.allCases
    
    init() {
        registerNotifications()
    }
    
    init(tasks: [Task]) {
        self.tasks.append(contentsOf: tasks)
        registerNotifications()
    }
    
    func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(outputTaskDidChange), name: NSNotification.Name.init(rawValue: "OutputTaskDidChange"), object: nil)
    }
    
    @objc func outputTaskDidChange() {
        /*
        for task in tasks {
            task.toggleEnabled()
            task.toggleEnabled()
            /*
            for outputTask in task.outputTasks {
                outputTask.update()
            }
            */
        }
        */
    }
    
    func task(id: UUID) -> Task {
        let index = tasks.firstIndex { $0.id == id }!
        return tasks[index]
    }
    
    func addTask() {
        self.tasks.append(.init(name: "Task \(Int.random(in: 0...9999))"))
    }
    
    func removeTask(_ task: Task) {
        let index = tasks.firstIndex { $0.id == task.id }
        if let index = index {
            tasks.remove(at: index)
        }
    }
    
    func cloneTask(_ task: Task) {
        let index = tasks.firstIndex { $0.id == task.id }
        if let index = index {
            let cloned = Task(tasks[index])
            tasks.insert(cloned, at: index + 1)
        }
    }
    
    func addOutputTask(forTask task: Task) {
        guard let task = self.tasks.first(where: { $0.id == task.id }) else { return }
        if let lastOutputTask = task.outputTasks.last {
            task.addOutputTask(OutputTask(lastOutputTask))
        } else {
            task.addOutputTask()
        }
    }
    
    func toggleEnabled(task: Task) {
        let index = tasks.firstIndex { $0.id == task.id }
        if let index = index {
            tasks[index].toggleEnabled()
            
            //trigger list change:
            tasks.append(Task(name: ""))
            tasks.removeLast()
        }
    }
}

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
    
    subscript(unchecked key: Element.ID) -> Element {
        get {
            guard let result = self.elementsDict[key] else {
                fatalError("This element does not exist.")
            }
            return result
        }
        set {
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
