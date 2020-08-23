//
//  Generator.swift
//  Appetizer
//
//  Created by Wilhelm Oks on 22.08.20.
//  Copyright © 2020 Wilhelm Oks. All rights reserved.
//

import Foundation
import AppKit

final class Generator {
    public static let shared = Generator()
    
    private init() {}
    
    func execute(_ tasks: [Task]) {
        do {
            for task in tasks {
                let inputImage = try NSImage.from(filePath: task.inputPath)
                let filteredOutputTasks = task.outputTasks.filter{ !$0.deleted && $0.enabled && $0.isReady }
                for outputTask in filteredOutputTasks {
                    let scaledImage = inputImage.scaled(toSize: CGSize(width: 16, height: 16), padding: 0)
                    let outputUrl = URL(fileURLWithPath: outputTask.outputPath)
                    try scaledImage.saveAsPng(fileUrl: outputUrl)
                }
            }
        } catch let error {
            print(error)
        }
    }
}
