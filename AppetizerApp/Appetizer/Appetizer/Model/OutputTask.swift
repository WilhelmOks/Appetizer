//
//  OutputTask.swift
//  Appetizer
//
//  Created by Wilhelm Oks on 28.03.20.
//  Copyright © 2020 Wilhelm Oks. All rights reserved.
//

import Foundation

class OutputTask : Identifiable {
    var id: String { name }
    var name: String
    
    init(name: String) {
        self.name = name
    }
}
