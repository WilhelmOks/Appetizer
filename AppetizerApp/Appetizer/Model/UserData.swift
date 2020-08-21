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
        /*
        let index = tasks.firstIndex { $0.id == task.id }
        if let index = index {
            tasks.remove(at: index)
        }*/
        
        if let task = tasks.first(where: { $0.id == task.id }) {
            task.deleted = true
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
