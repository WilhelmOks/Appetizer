//
//  Task.swift
//  Appetizer
//
//  Created by Wilhelm Oks on 08.03.20.
//  Copyright © 2020 Wilhelm Oks. All rights reserved.
//

import Foundation
import Combine

final class Task : Identifiable, ObservableObject {
    let id = UUID()
    @Published var outputTasks: [OutputTask] = []
    @Published var enabled: Bool = true
    @Published var inputPath: String = ""
    
    var isReady: Bool {
        !outputTasks.isEmpty && outputTasks.allSatisfy{ $0.isReady } && !inputPath.isEmpty || !enabled
    }
    
    init() {
        
    }
    
    init(_ task: Task) {
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
        let newOutputTask = OutputTask(task: self)
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
