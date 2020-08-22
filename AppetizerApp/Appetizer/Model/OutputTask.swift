//
//  OutputTask.swift
//  Appetizer
//
//  Created by Wilhelm Oks on 28.03.20.
//  Copyright © 2020 Wilhelm Oks. All rights reserved.
//

import Foundation

final class OutputTask : Identifiable, ObservableObject {
    let id = UUID()
    @Published var name: String
    @Published var enabled: Bool = true
    @Published var selectedTypeIndex: Int = 0 {
        didSet {
            NotificationCenter.default.post(Notification(name: .init("OutputTaskDidChange")))
        }
    }
    @Published var outputPath: String = ""
    @Published var deleted = false
    
    var isReady: Bool {
        !outputPath.isEmpty || !enabled
    }
    
    init(name: String) {
        self.name = name
    }
    
    init(_ outputTask: OutputTask) {
        name = outputTask.name
        enabled = outputTask.enabled
        selectedTypeIndex = outputTask.selectedTypeIndex
        outputPath = outputTask.outputPath
        deleted = outputTask.deleted
    }
    
    func update() {
        enabled.toggle()
        enabled.toggle()
    }
}
