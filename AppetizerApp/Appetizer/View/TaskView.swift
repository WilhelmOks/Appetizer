//
//  TaskView.swift
//  Appetizer
//
//  Created by Wilhelm Oks on 08.03.20.
//  Copyright © 2020 Wilhelm Oks. All rights reserved.
//

import SwiftUI

struct TaskView: View {
    @ObservedObject var viewModel: TaskViewModel

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
                }
                
                TextField("input image path (drag and drop file)", text: $viewModel.task.inputPath)
                    .disabled(true)
                    .valid(!viewModel.task.inputPath.isEmpty)
                
                HStack(alignment: .top) {
                    FileImageView(filePath: $viewModel.task.inputPath)
                        .frame(width: 48, height: 48)
                        .border(Color.secondary)
                    
                    OutputTaskListView(viewModel: viewModel)
                }
                .fixedSize(horizontal: false, vertical: true)
                
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
                        for outputTask in viewModel.outputTasks.map(\.value.outputTask) {
                            outputTask.previewImageWillChange.send()
                        }
                    }
                }
            }
            return true
        }
        return false
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskView(viewModel: makeViewModel())
            .frame(width: 600, height: nil, alignment: .center)
    }
    
    static func makeViewModel() -> TaskViewModel {
        let task = Task()
        let task1 = Task().with(outputTasks: [
            OutputTask(task: task),
            OutputTask(task: task)
        ])
        let contentViewModel = ContentViewModel(UserData())
        let vm = TaskViewModel(task: task1, contentViewModel: contentViewModel)
        return vm
    }
}
