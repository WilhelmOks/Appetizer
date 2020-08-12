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
    @Binding var task: Task
    @Binding var outputTask: OutputTask
    
    var deleteClosure: (_ outputTask: OutputTask) -> ()

    /*init(task: Binding<Task>, outputTask: Binding<OutputTask>, parentView: OutputTaskListView, delete: @escaping (_ model: Task) -> () = { m in }) {
        
    }*/
    
    var body: some View {
        HStack {
            Button(action: { //self.task.removeOutputTask(self.outputTask)
                //self.parentView.update()
                self.deleteClosure(self.outputTask)
            }) {
                Text("-")
            }
            Picker(selection: $outputTask.selectedTypeIndex, label: Text("")) {
                ForEach(0..<UserData.outputTypes.count) {
                    Text(UserData.outputTypes[$0].displayName)
                }
                }.frame(width: 150, height: nil)
            Spacer()
        }
    }
}

struct OutputTaskView_Previews: PreviewProvider {
    @State static var task1 = Task(name: "Task 1")
    @State static var outputTask1 = OutputTask(name: "OutputTask 1")
    //@State static var parentView = OutputTaskListView(task: $task1)
    
    static var previews: some View {
        OutputTaskView(task: $task1, outputTask: $outputTask1, deleteClosure: { m in })
        .frame(width: 300, height: nil, alignment: .center)
    }
}
