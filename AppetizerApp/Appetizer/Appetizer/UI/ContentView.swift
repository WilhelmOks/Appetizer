//
//  ContentView.swift
//  Appetizer
//
//  Created by Wilhelm Oks on 01.03.20.
//  Copyright © 2020 Wilhelm Oks. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var tasks: [Task]
    
    var body: some View {
        Group {
            VStack {
                Text("Appetizer").padding(8)
                List(tasks) { task in
                    TaskView(task: task)
                }
            }
        }.frame(minWidth: 400, minHeight: 300)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previewTasks = [Task(name: "Task 1"), Task(name: "Task 2")]
    
    static var previews: some View {
        ContentView(tasks: previewTasks).frame(width: 400, height: 300, alignment: .center)
    }
}
