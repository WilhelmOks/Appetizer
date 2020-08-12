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
                    Button(action: { //self.userData.removeTask(self.model)
                        self.deleteClosure(self.model)
                    }) {
                        Text("-")
                    }
                    Button(action: { self.userData.cloneTask(self.model)
                    }) {
                        Text("clone")
                    }
                    Button(action: { self.userData.toggleEnabled(task: self.model)
                    }) {
                        Text(self.model.enabled ? "enabled" : "disabled")
                    }
                    Text(model.name).font(.headline)
                }
                TextField("input image path", text: $model.inputPath).disabled(true)
                HStack(alignment: .top) {
                    IconImageView(filePath: $model.inputPath)
                        .frame(width: 64, height: 64)
                        .border(Color.secondary)
                    OutputTaskListView(task: $model)
                }
                Spacer()
            }
            Spacer()
        }.padding(8).border(Color.secondary).onDrop(of: ["public.file-url"], isTargeted: nil, perform: handleOnDrop(providers:))
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
    @State static var task1 = Task(name: "Task 1").with(outputTasks: [
        OutputTask(name: "Output Task 1"),
        OutputTask(name: "Output Task 2")
    ])
    
    static var previews: some View {
        TaskView(model: $task1)
            .frame(width: 300, height: nil, alignment: .center)
    }
}
