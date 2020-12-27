//
//  TaskViewModel.swift
//  Appetizer
//
//  Created by Wilhelm Oks on 26.12.20.
//  Copyright © 2020 Wilhelm Oks. All rights reserved.
//

import Foundation

class TaskViewModel: ObservableObject {    
    let contentViewModel: ContentViewModel
    @Published var task: Task
    @Published var outputTasks: [MarkableAsDeleted<OutputTaskViewModel>] = [] {
        didSet {
            task.outputTasks = outputTasks.existing().map(\.outputTask)
        }
    }
    
    init(task: Task, contentViewModel: ContentViewModel) {
        self.contentViewModel = contentViewModel
        self.task = task
        self.outputTasks = task.outputTasks.map{ OutputTaskViewModel(outputTask: $0, taskViewModel: self) }.markableAsDeleted()
    }
    
    func cloneTask() {
        contentViewModel.cloneTask(self)
    }
    
    func deleteTask() {
        if let index =
            contentViewModel.tasks.firstIndex(where: { $0.value.task.id == self.task.id }) {
            contentViewModel.tasks.markDeleted(at: index)
        }
    }
    
    func addOutputTask() {
        let newOutputTask = OutputTask(task: task)
        outputTasks.append(OutputTaskViewModel(outputTask: newOutputTask, taskViewModel: self))
    }
}
