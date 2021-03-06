//
//  OutputTaskListView.swift
//  Appetizer
//
//  Created by Wilhelm Oks on 28.07.20.
//  Copyright © 2020 Wilhelm Oks. All rights reserved.
//

import SwiftUI

struct OutputTaskListView: View {
    @ObservedObject var viewModel: TaskViewModel

    var body: some View {
        VStack {
            ForEach(0..<viewModel.outputTasks.count, id: \.self) { index in
                if !viewModel.outputTasks[index].isDeleted {
                    HStack {
                        GroupBox {
                            OutputTaskView(
                                viewModel: OutputTaskViewModel(
                                    outputTask: viewModel.outputTasks[index].outputTask,
                                    taskViewModel: viewModel
                                ),
                                previewImage: viewModel.outputTasks[index].value.outputTask.previewImage
                            )
                        }
                        Spacer()
                    }
                }
            }
            HStack {
                TextButton(text: "+") {
                    viewModel.addOutputTask()
                }
                .padding(.leading, 4)
                Spacer()
            }
        }
        .padding(0)
    }
}

struct OutputTaskListView_Previews: PreviewProvider {
    static let task = Task()
    @State static var task1 = Task()
        .with(outputTasks: [
            OutputTask(task: task),
            OutputTask(task: task)
        ])
    
    static var previews: some View {
        let taskViewModel = TaskViewModel(task: task1, contentViewModel: ContentViewModel(UserData()))
        OutputTaskListView(viewModel: taskViewModel)
        .frame(width: nil, height: nil)
    }
}
