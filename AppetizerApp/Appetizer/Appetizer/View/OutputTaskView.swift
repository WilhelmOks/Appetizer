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
    
    var body: some View {
        HStack {
            Button(action: { self.task.removeOutputTask(self.outputTask) }) {
                Text("-")
            }
            Text(outputTask.name)
            Spacer()
        }
    }
}

struct OutputTaskView_Previews: PreviewProvider {
    static var previews: some View {
        OutputTaskView(task: Task(name: "Task 1"), outputTask: OutputTask(name: "OutputTask 1"))
        .frame(width: 300, height: nil, alignment: .center)
    }
}
