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
    @State var task: Task
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    Button(action: { self.userData.removeTask(self.task) }) {
                        Text("-")
                    }
                    Button(action: { self.userData.cloneTask(self.task) }) {
                        Text("clone")
                    }
                    Text(task.name).font(.headline)
                }
                Spacer()
            }
            VStack {
                OutputTaskListView(task: task)
                Spacer()
            }
        }.padding(8).border(Color.secondary)
    }
}

struct TaskView_Previews: PreviewProvider {
    @State static var task1 = Task(name: "Task 1").with(outputTasks: [
        OutputTask(name: "Output Task 1"),
        OutputTask(name: "Output Task 2")
    ])
    
    static var previews: some View {
        TaskView(task: task1)
            .frame(width: 300, height: nil, alignment: .center)
    }
}
