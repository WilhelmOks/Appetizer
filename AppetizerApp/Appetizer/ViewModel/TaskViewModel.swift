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
    @Published var task: Task {
        didSet {
            contentViewModel.userData.validate()
        }
    }
    @Published var outputTasks: [MarkableAsDeleted<OutputTaskViewModel>] = [] {
        didSet {
            task.outputTasks = outputTasks.existing().map(\.outputTask)
            contentViewModel.userData.validate()
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
        
        if let lastOutputTask = outputTasks.existing().last?.outputTask {
            newOutputTask.selectedTypeIndex = lastOutputTask.selectedTypeIndex
            newOutputTask.androidFolderPrefixString = lastOutputTask.androidFolderPrefixString
            newOutputTask.sizeXString = lastOutputTask.sizeXString
            newOutputTask.sizeYString = lastOutputTask.sizeYString
            newOutputTask.fileNameString = lastOutputTask.fileNameString
            newOutputTask.paddingString = lastOutputTask.paddingString
            newOutputTask.colorString = lastOutputTask.colorString
            newOutputTask.clearWhite = lastOutputTask.clearWhite
            newOutputTask.outputPath = lastOutputTask.outputPath
        }
        
        outputTasks.append(OutputTaskViewModel(outputTask: newOutputTask, taskViewModel: self))
    }
}
