//
//  OutputTask.swift
//  Appetizer
//
//  Created by Wilhelm Oks on 28.03.20.
//  Copyright © 2020 Wilhelm Oks. All rights reserved.
//

import Foundation

class OutputTask : Identifiable, ObservableObject {
    let id = UUID()
    @Published var name: String
    
    init(name: String) {
        self.name = name
    }
    
    init(_ outputTask: OutputTask) {
        name = outputTask.name
    }
}
