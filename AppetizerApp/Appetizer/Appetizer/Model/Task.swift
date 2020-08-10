//
//  Task.swift
//  Appetizer
//
//  Created by Wilhelm Oks on 08.03.20.
//  Copyright © 2020 Wilhelm Oks. All rights reserved.
//

import Foundation

class Task : Identifiable, ObservableObject {
    var id: String { name }
    @Published var name: String
    @Published var outputTasks: [OutputTask] = []
    @Published var enabled: Bool = true
    
    init(name: String) {
        self.name = name
    }
    
    init(_ task: Task) {
        name = task.name
        outputTasks = task.outputTasks.map { OutputTask($0) }
        enabled = task.enabled
    }
    
    func with(outputTasks: [OutputTask]) -> Self {
        self.outputTasks = outputTasks
        return self
    }
    
    func addOutputTask() {
        let newOutputTask = OutputTask(name: String(Int.random(in: 0..<100000)))
        outputTasks.append(newOutputTask)
    }
    
    func removeOutputTask(_ outputTask: OutputTask) {
        let index = outputTasks.firstIndex { $0.id == outputTask.id }
        if let index = index {
            outputTasks.remove(at: index)
        }
    }
}
