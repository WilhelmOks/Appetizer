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
    
    var body: some View {
        Group {
            VStack(alignment: .center, spacing: 0) {
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [Color.clear, Color(white: 0).opacity(0.18)]), startPoint: .top, endPoint: .bottom)
                    HStack() {
                        Button(action: {  }) {
                            Text("generate")
                        }.disabled(!userData.isGenerateButtonEnabled)
                        Spacer()
                    }.padding([.leading, .trailing], 8)
                }.frame(height: 40)
                ScrollView {
                    ForEach(userData.tasks.filter { !$0.deleted }) { model in
                        TaskView(
                            model: self.$userData.tasks[self.userData.tasks.firstIndex(where: {$0.id == model.id})!],
                            delete:
                                { m in self.userData.removeTask(m)
                                    self.update()
                        })
                        .padding([.top, .bottom], 4)
                        .padding([.leading, .trailing], 8)
                    }
                    HStack {
                        Button(action: { self.userData.addTask() }) {
                            Text("+")
                        }
                        Spacer()
                    }.padding(EdgeInsets(top: 4, leading: 8, bottom: 8, trailing: 8))
                }
            }
        }.disabled(disabled).frame(minWidth: 300, minHeight: 400)
    }
    
    func update() {
        disabled.toggle()
        disabled.toggle()
    }
}

struct ContentView_Previews: PreviewProvider {
    @State static var previewTasks = [Task(name: "Task 1"), Task(name: "Task 2")]
    
    static var previews: some View {
        ContentView()
            .frame(width: 300, height: 400, alignment: .center)
            .environmentObject(UserData(tasks: previewTasks))
    }
}
