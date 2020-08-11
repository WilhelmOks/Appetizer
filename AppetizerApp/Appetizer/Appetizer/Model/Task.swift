//
//  Task.swift
//  Appetizer
//
//  Created by Wilhelm Oks on 08.03.20.
//  Copyright © 2020 Wilhelm Oks. All rights reserved.
//

import Foundation

class Task : Identifiable, ObservableObject {
    let id = UUID()
    @Published var name: String
    @Published var outputTasks: [OutputTask] = []
    @Published var enabled: Bool = true
    @Published var inputPath: String = ""
    
    init(name: String) {
        self.name = name
    }
    
    init(_ task: Task) {
        name = task.name
        outputTasks = task.outputTasks.map { OutputTask($0) }
        enabled = task.enabled
        inputPath = task.inputPath
    }
    
    func with(outputTasks: [OutputTask]) -> Self {
        self.outputTasks = outputTasks
        return self
    }
    
    func toggleEnabled() {
        self.enabled.toggle()
    }
    
    func addOutputTask() {
        let newOutputTask = OutputTask(name: String(Int.random(in: 0..<100000)))
        outputTasks.append(newOutputTask)
    }
    
    func addOutputTask(_ outputTask: OutputTask) {
        outputTasks.append(outputTask)
    }
    
    func removeOutputTask(_ outputTask: OutputTask) {
        let index = outputTasks.firstIndex { $0.id == outputTask.id }
        if let index = index {
            outputTasks.remove(at: index)
        }
    }
}

class TaskVM : ObservableObject, Identifiable {
    @Published var task: Task
    
    var name: String { task.name }
    
    var enabled: Bool {
        get { task.enabled }
        set { task.enabled = newValue }
    }
    
    var inputPathTextFieldContent: String {
        get { task.inputPath }
        set { task.inputPath = newValue }
    }
    //@Published var inputPathTextFieldContent: String
    
    init(_ task: Task) {
        self.task = task
        //self.inputPathTextFieldContent = task.inputPath
    }
}
