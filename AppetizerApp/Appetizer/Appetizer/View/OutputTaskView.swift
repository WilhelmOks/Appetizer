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
    @State var outputPath: String = ""
    
    var deleteClosure: (_ outputTask: OutputTask) -> ()

    /*init(task: Binding<Task>, outputTask: Binding<OutputTask>, parentView: OutputTaskListView, delete: @escaping (_ model: Task) -> () = { m in }) {
        
    }*/
    
    var body: some View {
        HStack(alignment: .top, spacing: 4) {
            Button(action: { //self.task.removeOutputTask(self.outputTask)
                //self.parentView.update()
                self.deleteClosure(self.outputTask)
            }) {
                Text("-")
            }
            VStack(alignment: .leading, spacing: 4) {
                Picker(selection: $outputTask.selectedTypeIndex, label: Text("")) {
                    ForEach(0..<UserData.outputTypes.count) {
                        Text(UserData.outputTypes[$0].displayName)
                    }
                }.frame(width: 150, height: nil)
                TextField("output image path", text: $outputPath).disabled(true).padding(.leading, 8)
            }
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
