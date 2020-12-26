//
//  OutputTaskView.swift
//  Appetizer
//
//  Created by Wilhelm Oks on 28.07.20.
//  Copyright © 2020 Wilhelm Oks. All rights reserved.
//

import SwiftUI

struct OutputTaskView: View {
    //@EnvironmentObject var userData: UserData
    //@Binding var task: Task
    //@Binding var outputTask: OutputTask
    @ObservedObject var viewModel: OutputTaskViewModel
    @State var previewImage: NSImage
    
    //var deleteClosure: (_ outputTask: OutputTask) -> ()
    
    var body: some View {
        HStack(alignment: .top, spacing: 4) {
            TextButton(text: "-") {
                //self.deleteClosure(self.outputTask)
                viewModel.deleteOutputTask()
            }
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .center) {
                    Picker(selection: $viewModel.outputTask.selectedTypeIndex, label: Text("")) {
                        ForEach(0..<UserData.outputTypes.count) {
                            Text(UserData.outputTypes[$0].displayName)
                        }
                    }
                    .frame(width: 150, height: nil)
                    
                    if viewModel.outputTask.needsSize {
                        GroupBox(label: Text("size")) {
                            HStack(spacing: 2) {
                                TextField("width", text: $viewModel.outputTask.sizeXString)
                                .frame(width: 50)
                                
                                Text("x")
                                
                                TextField("height", text: $viewModel.outputTask.sizeYString)
                                .frame(width: 50)
                            }
                        }.frame(width: 130)
                    }
                    
                    if viewModel.outputTask.selectedType == .androidImage {
                        GroupBox(label: Text("Android folder prefix")) {
                            HStack(spacing: 2) {
                                TextField(viewModel.outputTask.androidFolderPrefixDefault, text: $viewModel.outputTask.androidFolderPrefixString)
                                .frame(width: 110)
                            }
                        }.frame(width: 130)
                    }
                    
                    Spacer()
                }
                
                HStack(alignment: .center) {
                    GroupBox(label: Text("name")) {
                        HStack(spacing: 2) {
                            TextField("", text: $viewModel.outputTask.fileNameString)
                            .frame(width: 80)
                        }
                    }.frame(width: 100).padding(.leading, 4)
                    
                    GroupBox(label: Text("padding")) {
                        HStack(spacing: 2) {
                            TextField("0", text: $viewModel.outputTask.paddingString)
                            .frame(width: 40)
                        }
                    }.frame(width: 60)
                    
                    GroupBox(label: Text("color")) {
                        HStack(spacing: 2) {
                            TextField("#RRGGBB", text: $viewModel.outputTask.colorString)
                            .frame(width: 80)
                        }
                    }.frame(width: 100)
                    
                    Toggle(isOn: $viewModel.outputTask.clearWhite) {
                        Text("clear white")
                    }
                    
                    Spacer()
                }
                
                HStack(alignment: .bottom) {
                    TextField("output image path", text: $viewModel.outputTask.outputPath)
                    .truncationMode(.head)
                    .disabled(true)
                    .padding(.leading, 8)
                    
                    TextButton(text: "pick") {
                        self.pickOutputFile()
                    }
                    
                    ImageView(image: $viewModel.outputTask.previewImage)
                    .frame(width: 48, height: 48)
                    .border(Color.secondary)
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
        $viewModel.outputTask.outputPath.wrappedValue = path
        /*
        DispatchQueue.main.async {
            self.userData.update() //needed for the case when an existing file is selected
        }*/
    }
}

struct OutputTaskView_Previews: PreviewProvider {
    @State static var task1 = Task(name: "Task 1")
    @State static var outputTask1 = OutputTask(task: task1)
    //@State static var parentView = OutputTaskListView(task: $task1)
    
    static var previews: some View {
        //OutputTaskView(task: $task1, outputTask: $outputTask1, previewImage: NSImage(), deleteClosure: { m in })
        OutputTaskView(viewModel: OutputTaskViewModel(outputTask: OutputTask(task: Task(name: "?")), taskViewModel: TaskViewModel(task: Task(name: "?"), contentViewModel: ContentViewModel(UserData()))), previewImage: NSImage())
        .frame(width: 550, height: nil, alignment: .center)
    }
}
