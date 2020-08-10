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
    @ObservedObject var model: Task
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Button(action: { self.userData.removeTask(self.model)
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
                TextField("input image path", text: $model.inputPath)
                HStack(alignment: .top) {
                    Image("inputImage").frame(width: 64, height: 64, alignment: .center).border(Color.secondary)
                    OutputTaskListView(task: model)
                }
                Spacer()
            }
            Spacer()
        }.padding(8).border(Color.secondary)
    }
}

struct TaskView_Previews: PreviewProvider {
    @State static var task1 = Task(name: "Task 1").with(outputTasks: [
        OutputTask(name: "Output Task 1"),
        OutputTask(name: "Output Task 2")
    ])
    
    static var previews: some View {
        TaskView(model: task1)
            .frame(width: 300, height: nil, alignment: .center)
    }
}
