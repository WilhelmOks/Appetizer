//
//  TaskView.swift
//  Appetizer
//
//  Created by Wilhelm Oks on 08.03.20.
//  Copyright © 2020 Wilhelm Oks. All rights reserved.
//

import SwiftUI

struct TaskView: View {
    @EnvironmentObject var userData: UserData
    //@ObservedObject var viewModel: TaskVM
    //@ObservedObject var model: Task
    @Binding var model: Task
    
    private var deleteClosure: (_ model: Task) -> ()
    
    init(model: Binding<Task>, delete: @escaping (_ model: Task) -> () = { m in }) {
        self._model = model
        self.deleteClosure = delete
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    TextButton(text: "-") {
                        self.deleteClosure(self.model)
                    }
                    TextButton(text: "clone") {
                        self.userData.cloneTask(self.model)
                    }
                    Toggle(isOn: self.$model.enabled) {
                        Text("enabled")
                    }
                    Text(model.name).font(.headline)
                }
                TextField("input image path", text: $model.inputPath).disabled(true)
                HStack(alignment: .top) {
                    FileImageView(filePath: $model.inputPath)
                        .frame(width: 48, height: 48)
                        .border(Color.secondary)
                    OutputTaskListView(task: $model)
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
                        self.model.inputPath = url.path
                    }
                }
            }
            return true
        }
        return false
    }
}

struct TaskView_Previews: PreviewProvider {
    static let task = Task(name: "Task")
    @State static var task1 = Task(name: "Task 1").with(outputTasks: [
        OutputTask(task: task),
        OutputTask(task: task)
    ])
    
    static var previews: some View {
        TaskView(model: $task1)
            .frame(width: 600, height: nil, alignment: .center)
    }
}
