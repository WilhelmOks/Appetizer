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
                            deleteClosure: { m in
                                self.task.removeOutputTask(m)
                                self.update()
                        })
                    }
                    Spacer()
                }
            }
            HStack {
                Button(action: {
                    self.userData.addOutputTask(forTask: self.task)
                    self.update()
                }) {
                    Text("+")
                }
                .padding(.leading, 4)
                Spacer()
            }
        }.padding(0).disabled(disabled)
    }
    
    func update() {
        self.disabled.toggle()
        self.disabled.toggle()
    }
}

struct OutputTaskListView_Previews: PreviewProvider {
    @State static var task1 = Task(name: "Task 1")
        .with(outputTasks: [
            OutputTask(name: "Output Task 1"),
            OutputTask(name: "Output Task 2")
        ])
    
    static var previews: some View {
        OutputTaskListView(task: $task1)
        .frame(width: 300, height: 200, alignment: .center)
    }
}
