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
    @State var task: Task
    @State var disabled = false

    var body: some View {
        VStack {
            ForEach(task.outputTasks) { outputTask in
                HStack {
                    OutputTaskView(task: self.task, outputTask: outputTask, parentView: self)
                    Spacer()
                }
            }
            HStack {
                Button(action: {
                    self.task.addOutputTask()
                    self.update()
                }) {
                    Text("+")
                }
                Spacer()
            }
        }.padding(8).disabled(disabled).border(Color.secondary)
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
        OutputTaskListView(task: task1)
        .frame(width: 300, height: 200, alignment: .center)
    }
}
