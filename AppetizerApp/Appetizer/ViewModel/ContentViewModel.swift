//
//  ContentViewModel.swift
//  Appetizer
//
//  Created by Wilhelm Oks on 26.12.20.
//  Copyright © 2020 Wilhelm Oks. All rights reserved.
//

import Foundation

class ContentViewModel: ObservableObject {
    let userData: UserData
    
    @Published var tasks: [MarkableAsDeleted<TaskViewModel>] = [] {
        didSet {
            userData.tasks = tasks.existing().map(\.task)
        }
    }
    
    init(_ userData: UserData) {
        self.userData = userData
        tasks = userData.tasks.map{ TaskViewModel(task: $0, contentViewModel: self) }.markableAsDeleted()
    }
    
    func addTask() {
        let task = Task(name: "Task \(Int.random(in: 0...9999))")
        tasks.append(TaskViewModel(task: task, contentViewModel: self))
    }
    
    func cloneTask(_ task: TaskViewModel) {
        let index = tasks.firstIndex { $0.value.task.id == task.task.id }
        if let index = index {
            let cloned = Task(tasks[index].value.task)
            tasks.insert(TaskViewModel(task: cloned, contentViewModel: self), at: index + 1)
        }
    }
}
