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
                }
                .frame(width: 150, height: nil)
                
                HStack {
                    TextField("output image path", text: $outputTask.outputPath)
                    .truncationMode(.head)
                    .disabled(true)
                    .padding(.leading, 8)
                    
                    Button(action: { self.pickOutputFile() }) {
                        Text("pick")
                    }
                }
            }
            Spacer()
        }
    }
    
    private func pickOutputFile() {
        let dialog = NSSavePanel()
        
        dialog.title = "Choose a file for the output image"
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.allowedFileTypes = ["png"]
        dialog.canCreateDirectories = true
        dialog.treatsFilePackagesAsDirectories = true
        
        guard dialog.runModal() == .OK else { return }
        guard let result = dialog.url else { return }
        let path = result.path
        outputTask.outputPath = path
        DispatchQueue.main.async {
            self.userData.update() //needed for the case when an existing file is selected
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
