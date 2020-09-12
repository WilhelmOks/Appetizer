//
//  UserData.swift
//  Appetizer
//
//  Created by Wilhelm Oks on 08.03.20.
//  Copyright © 2020 Wilhelm Oks. All rights reserved.
//

import Foundation
import Combine

final class UserData: ObservableObject {
    //@Published var tasks = ObservableList<Task>()
    @Published var tasks: [Task] = [] {
        didSet {
            objectWillChange.send()
        }
    }
    @Published var isGenerateButtonEnabled: Bool = false
    
    var existingTasks: [Task] {
        tasks.filter{ !$0.deleted }
    }
    
    //var taskViewModels: [TaskVM] { tasks.map { TaskVM($0) } }
    
    static let outputTypes: [OutputType] = OutputType.allCases
    
    var isReadyToGenerate: Bool {
        !existingTasks.isEmpty && existingTasks.allSatisfy { $0.isReady }
    }
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        objectWillChange.sink { _ in
            self.isGenerateButtonEnabled = self.isReadyToGenerate
        }.store(in: &cancellables)
    }
    
    init(tasks: [Task]) {
        self.tasks.append(contentsOf: tasks)
    }
    
    func subscribeToChanges(_ task: Task) {
        task.objectWillChange.sink{ self.objectWillChange.send() }.store(in: &cancellables)
    }
    
    func task(id: UUID) -> Task {
        let index = tasks.firstIndex { $0.id == id }!
        return tasks[index]
    }
    
    func addTask() {
        let task = Task(name: "Task \(Int.random(in: 0...9999))")
        self.tasks.append(task)
        subscribeToChanges(task)
        objectWillChange.send()
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
        objectWillChange.send()
    }
    
    func cloneTask(_ task: Task) {
        let index = tasks.firstIndex { $0.id == task.id }
        if let index = index {
            let cloned = Task(tasks[index])
            tasks.insert(cloned, at: index + 1)
            subscribeToChanges(cloned)
        }
        objectWillChange.send()
    }
    
    func addOutputTask(forTask task: Task) {
        guard let task = self.tasks.first(where: { $0.id == task.id }) else { return }
        if let lastOutputTask = task.outputTasks.last {
            task.addOutputTask(OutputTask(lastOutputTask))
        } else {
            task.addOutputTask()
        }
        objectWillChange.send()
    }
    
    func toggleEnabled(task: Task) {
        let index = tasks.firstIndex { $0.id == task.id }
        if let index = index {
            tasks[index].toggleEnabled()
            
            //trigger list change:
            //tasks.append(Task(name: ""))
            //tasks.removeLast()
        }
        objectWillChange.send()
    }
    
    func update() {
        //tasks.append(Task(name: ""))
        //tasks.removeLast()
        objectWillChange.send()
    }
    
    func generateImages() {
        Generator.shared.execute(tasks.filter{ !$0.deleted && $0.enabled && $0.isReady })
    }
}
