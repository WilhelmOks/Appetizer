//
//  UserData.swift
//  Appetizer
//
//  Created by Wilhelm Oks on 08.03.20.
//  Copyright © 2020 Wilhelm Oks. All rights reserved.
//

import Foundation

final class UserData: ObservableObject {
    @Published var tasks: [Task] = []
    
    //var taskViewModels: [TaskVM] { tasks.map { TaskVM($0) } }
    
    init() {
        
    }
    
    init(tasks: [Task]) {
        self.tasks = tasks
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
        self.tasks.first{ $0.id == task.id }?.addOutputTask()
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
