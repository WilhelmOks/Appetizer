//
//  OutputTaskListView.swift
//  Appetizer
//
//  Created by Wilhelm Oks on 28.07.20.
//  Copyright © 2020 Wilhelm Oks. All rights reserved.
//

import SwiftUI

struct OutputTaskListView: View {
    @EnvironmentObject var userData: UserData
    @Binding var task: Task
    @State var disabled = false

    var body: some View {
        VStack {
            ForEach(0..<task.outputTasks.count, id: \.self) { index in
                HStack {
                    GroupBox {
                        OutputTaskView(
                            task: self.$task, outputTask: self.$task.outputTasks[index],
                            previewImage: self.task.outputTasks[index].previewImage,
                            deleteClosure: { m in
                                self.task.removeOutputTask(m)
                        })
                    }
                    Spacer()
                }
            }
            HStack {
                TextButton(text: "+") {
                    self.userData.addOutputTask(forTask: self.task)
                    //self.update()
                }
                .padding(.leading, 4)
                Spacer()
            }
        }.padding(0).disabled(disabled)
    }
}

struct OutputTaskListView_Previews: PreviewProvider {
    static let task = Task(name: "Task")
    @State static var task1 = Task(name: "Task 1")
        .with(outputTasks: [
            OutputTask(task: task),
            OutputTask(task: task)
        ])
    
    static var previews: some View {
        OutputTaskListView(task: $task1)
        .frame(width: nil, height: nil)
    }
}
