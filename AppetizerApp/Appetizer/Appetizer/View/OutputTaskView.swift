//
//  OutputTaskView.swift
//  Appetizer
//
//  Created by Wilhelm Oks on 28.07.20.
//  Copyright © 2020 Wilhelm Oks. All rights reserved.
//

import SwiftUI

struct OutputTaskView: View {
    @EnvironmentObject var userData: UserData
    @State var task: Task
    @State var outputTask: OutputTask
    @State var parentView: OutputTaskListView
    
    var body: some View {
        HStack {
            Button(action: { self.task.removeOutputTask(self.outputTask)
                self.parentView.update()
            }) {
                Text("-")
            }
            Text(outputTask.name)
            Spacer()
        }
    }
}

struct OutputTaskView_Previews: PreviewProvider {
    @State static var task1 = Task(name: "Task 1")
    @State static var outputTask1 = OutputTask(name: "OutputTask 1")
    @State static var parentView = OutputTaskListView(task: task1)
    
    static var previews: some View {
        OutputTaskView(task: task1, outputTask: outputTask1, parentView: parentView)
        .frame(width: 300, height: nil, alignment: .center)
    }
}
