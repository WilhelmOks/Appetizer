//
//  UserData.swift
//  Appetizer
//
//  Created by Wilhelm Oks on 08.03.20.
//  Copyright © 2020 Wilhelm Oks. All rights reserved.
//

import Foundation

final class UserData: ObservableObject  {
    @Published var tasks: [Task] = []
    
    init() {
        
    }
    
    init(tasks: [Task]) {
        self.tasks = tasks
    }
    
    func task(id: String) -> Task {
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
        //self.tasks.removeAll() { $0.id == task.id }
    }
    
    func addOutputTask(forTask task: Task) {
        self.tasks.first{ $0.id == task.id }?.addOutputTask()
    }
}
