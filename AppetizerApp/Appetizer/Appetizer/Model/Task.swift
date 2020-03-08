//
//  Task.swift
//  Appetizer
//
//  Created by Wilhelm Oks on 08.03.20.
//  Copyright © 2020 Wilhelm Oks. All rights reserved.
//

import Foundation

class Task : Identifiable {
    var id: String { name }
    var name: String
    
    init(name: String) {
        self.name = name
    }
}
