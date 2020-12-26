//
//  TaskView.swift
//  Appetizer
//
//  Created by Wilhelm Oks on 08.03.20.
//  Copyright © 2020 Wilhelm Oks. All rights reserved.
//

import SwiftUI

struct TaskView: View {
    //@EnvironmentObject var userData: UserData
    @ObservedObject var viewModel: TaskViewModel
    //@ObservedObject var model: Task
    //@Binding var model: Task
    
    //var deleteClosure: (_ model: TaskViewModel) -> ()

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    TextButton(text: "-") {
                        viewModel.deleteTask()
                    }
                    TextButton(text: "clone") {
                        viewModel.cloneTask()
                    }
                    Toggle(isOn: self.$viewModel.task.enabled) {
                        Text("enabled")
                    }
                    Text(viewModel.task.name).font(.headline)
                }
                TextField("input image path", text: $viewModel.task.inputPath).disabled(true)
                HStack(alignment: .top) {
                    FileImageView(filePath: $viewModel.task.inputPath)
                        .frame(width: 48, height: 48)
                        .border(Color.secondary)
                    OutputTaskListView(viewModel: viewModel)
                }
                Spacer()
            }
            Spacer()
        }
        .padding(6)
        .overlay(
            RoundedRectangle(cornerRadius: 3)
            .stroke(Color.black.opacity(0.2), lineWidth: 1)
        )
        .onDrop(of: ["public.file-url"], isTargeted: nil, perform: handleOnDrop(providers:))
    }
    
    private func handleOnDrop(providers: [NSItemProvider]) -> Bool {
        if let item = providers.first {
            item.loadItem(forTypeIdentifier: "public.file-url", options: nil) { (urlData, error) in
                DispatchQueue.main.async {
                    if let urlData = urlData as? Data {
                        let url = NSURL(absoluteURLWithDataRepresentation: urlData, relativeTo: nil) as URL
                        self.$viewModel.task.inputPath.wrappedValue = url.path
                    }
                }
            }
            return true
        }
        return false
    }
}

struct TaskView_Previews: PreviewProvider {
    /*static let task = Task(name: "Task")
    @State static var task1 = Task(name: "Task 1").with(outputTasks: [
        OutputTask(task: task),
        OutputTask(task: task)
    ])*/
    
    static var previews: some View {
        TaskView(viewModel: makeViewModel())
            .frame(width: 600, height: nil, alignment: .center)
    }
    
    static func makeViewModel() -> TaskViewModel {
        let task = Task(name: "Task")
        let task1 = Task(name: "Task 1").with(outputTasks: [
            OutputTask(task: task),
            OutputTask(task: task)
        ])
        let contentViewModel = ContentViewModel(UserData())
        let vm = TaskViewModel(task: task1, contentViewModel: contentViewModel)
        return vm
    }
}
