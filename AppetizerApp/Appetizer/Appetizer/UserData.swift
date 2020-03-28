//
//  UserData.swift
//  Appetizer
//
//  Created by Wilhelm Oks on 08.03.20.
//  Copyright © 2020 Wilhelm Oks. All rights reserved.
//

import Foundation

final class UserData: ObservableObject  {
    @Published var tasks: [Task] = []
    
    init() {
        
    }
    
    init(tasks: [Task]) {
        self.tasks = tasks
    }
    
    func addTask() {
        self.tasks.append(.init(name: "Task \(Int.random(in: 0...9999))"))
    }
}
