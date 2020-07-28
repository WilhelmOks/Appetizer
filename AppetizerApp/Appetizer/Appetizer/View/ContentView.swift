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
    
    var body: some View {
        Group {
            VStack {
                HStack {
                    Text("Appetizer")
                    Button(action: { self.userData.addTask() }) {
                        Text("+")
                    }
                }.padding(8)
                List(userData.tasks) { task in
                    TaskView(task: task)
                }
            }
        }.frame(minWidth: 300, minHeight: 200)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previewTasks = [Task(name: "Task 1"), Task(name: "Task 2")]
    
    static var previews: some View {
        ContentView()
            .frame(width: 300, height: 200, alignment: .center)
            .environmentObject(UserData(tasks: previewTasks))
    }
}
