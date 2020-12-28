//
//  ContentView.swift
//  Appetizer
//
//  Created by Wilhelm Oks on 01.03.20.
//  Copyright © 2020 Wilhelm Oks. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userData: UserData
    @State var disabled = false
    @ObservedObject var viewModel: ContentViewModel
    
    var body: some View {
        Group {
            VStack(alignment: .center, spacing: 0) {
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [Color.clear, Color(white: 0).opacity(0.18)]), startPoint: .top, endPoint: .bottom)
                    HStack() {
                        TextButton(text: "generate") {
                            self.userData.generateImages()
                        }
                        .disabled(!userData.isGenerateButtonEnabled)
                        Spacer()
                    }.padding([.leading, .trailing], 8)
                }.frame(height: 40)
                ScrollView {
                    ForEach(0..<viewModel.tasks.count, id: \.self) { index in
                        if !viewModel.tasks[index].isDeleted {
                            TaskView(viewModel: viewModel.tasks[index])
                                .padding(.vertical, 4)
                                .padding(.horizontal, 8)
                        }
                    }
                    HStack {
                        TextButton(text: "+") {
                            viewModel.addTask()
                        }
                        Spacer()
                    }.padding(EdgeInsets(top: 4, leading: 8, bottom: 8, trailing: 8))
                }
            }
        }.disabled(disabled).frame(minWidth: 300, minHeight: 400)
    }
    
    /*
    func update() {
        disabled.toggle()
        disabled.toggle()
    }*/
}

struct ContentView_Previews: PreviewProvider {
    @State static var previewTasks = [Task(), Task()]
    
    static var previews: some View {
        let userData = UserData(tasks: previewTasks)
        ContentView(viewModel: ContentViewModel(userData))
            .frame(width: 300, height: 400, alignment: .center)
            .environmentObject(userData)
    }
}
