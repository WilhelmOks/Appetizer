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

    var body: some View {
        VStack {
            ForEach(task.outputTasks) { outputTask in
                HStack {
                    OutputTaskView(task: self.task, outputTask: outputTask)
                    Spacer()
                }
            }
            HStack {
                Button(action: { self.task.addOutputTask() }) {
                    Text("+")
                }
                Spacer()
            }
        }
    }
}

struct OutputTaskListView_Previews: PreviewProvider {
    
    static var previews: some View {
        OutputTaskListView(
            task: Task(name: "Task 1")
                .with(outputTasks: [
                    OutputTask(name: "Output Task 1"),
                    OutputTask(name: "Output Task 2")
                ]
            )
        ).frame(width: 300, height: 200, alignment: .center)
    }
}
