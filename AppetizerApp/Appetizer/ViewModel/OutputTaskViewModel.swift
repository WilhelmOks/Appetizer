//
//  OutputTaskViewModel.swift
//  Appetizer
//
//  Created by Wilhelm Oks on 26.12.20.
//  Copyright © 2020 Wilhelm Oks. All rights reserved.
//

import Foundation

class OutputTaskViewModel: ObservableObject {
    let taskViewModel: TaskViewModel
    @Published var outputTask: OutputTask

    init(outputTask: OutputTask, taskViewModel: TaskViewModel) {
        self.taskViewModel = taskViewModel
        self.outputTask = outputTask
    }
    
    func deleteOutputTask() {
        if let index =
            taskViewModel.outputTasks.firstIndex(where: { $0.value.outputTask.id == self.outputTask.id }) {
            taskViewModel.outputTasks.markDeleted(at: index)
        }
    }
}
