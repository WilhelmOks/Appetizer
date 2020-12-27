//
//  UserData.swift
//  Appetizer
//
//  Created by Wilhelm Oks on 08.03.20.
//  Copyright © 2020 Wilhelm Oks. All rights reserved.
//

import Foundation
import Combine

final class UserData: ObservableObject {
    @Published var tasks: [Task] = [] {
        didSet {
            validate()
        }
    }
    @Published var isGenerateButtonEnabled: Bool = false

    static let outputTypes: [OutputType] = OutputType.allCases
    
    var isReadyToGenerate: Bool {
        !tasks.isEmpty && tasks.allSatisfy { $0.isReady }
    }
    
    init() {

    }
    
    convenience init(tasks: [Task]) {
        self.init()
        self.tasks.append(contentsOf: tasks)
    }
    
    func validate() {
        self.isGenerateButtonEnabled = self.isReadyToGenerate
    }
    
    func generateImages() {
        Generator.shared.execute(tasks.filter{ $0.enabled && $0.isReady })
    }
}
