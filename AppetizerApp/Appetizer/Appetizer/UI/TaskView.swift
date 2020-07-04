//
//  TaskView.swift
//  Appetizer
//
//  Created by Wilhelm Oks on 08.03.20.
//  Copyright © 2020 Wilhelm Oks. All rights reserved.
//

import SwiftUI

struct TaskView: View {
    @EnvironmentObject var userData: UserData
    var task: Task
    
    var body: some View {
        HStack {
            Button(action: { self.userData.removeTask(self.task) }) {
                Text("-")
            }
            Group() {
                Text("-").padding(EdgeInsets(top: 2, leading: 8, bottom: 2, trailing: 8)).background(Color.white)
            }.onTapGesture { self.userData.removeTask(self.task) }
            Text(task.name).font(.headline).padding(8)
            Spacer()
        }
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskView(task: Task(name: "Task 1"))
            .frame(width: 300, height: nil, alignment: .center)
    }
}
