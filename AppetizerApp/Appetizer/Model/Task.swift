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
    @Published var name: String
    @Published var outputTasks: [OutputTask] = [] {
        didSet {
            objectWillChange.send()
        }
    }
    @Published var enabled: Bool = true {
        didSet {
            objectWillChange.send()
        }
    }
    @Published var inputPath: String = "" {
        didSet {
            objectWillChange.send()
        }
    }
    
    var isReady: Bool {
        !outputTasks.isEmpty && outputTasks.allSatisfy{ $0.isReady } && !inputPath.isEmpty || !enabled
    }
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    private var cancellables: Set<AnyCancellable> = []
    
    init(name: String) {
        self.name = name
        
        subscribeToChanges()
    }
    
    init(_ task: Task) {
        name = task.name
        outputTasks = task.outputTasks.map { OutputTask($0) }
        enabled = task.enabled
        inputPath = task.inputPath
        //deleted = task.deleted
        
        subscribeToChanges()
    }
    
    func subscribeToChanges() {
        objectWillChange.sink { [weak self] _ in
            guard let this = self else { return }
            for outputTask in this.outputTasks {
                outputTask.previewImageWillChange.send()
            }
        }.store(in: &cancellables)
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
        objectWillChange.send()
    }
    
    func addOutputTask(_ outputTask: OutputTask) {
        outputTasks.append(outputTask)
        objectWillChange.send()
    }
    
    func removeOutputTask(_ outputTask: OutputTask) {
        let index = outputTasks.firstIndex { $0.id == outputTask.id }
        if let index = index {
            outputTasks.remove(at: index)
            objectWillChange.send()
        }
    }
}
/*
final class TaskVM : ObservableObject, Identifiable {
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
}*/
