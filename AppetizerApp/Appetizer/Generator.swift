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
                let filteredOutputTasks = task.outputTasks.filter{ $0.enabled && $0.isReady }
                for outputTask in filteredOutputTasks {
                    var outputImage = inputImage.scaled(toSize: CGSize(width: 16, height: 16), padding: 0)
                    outputImage = process(image: outputImage, outputTask: outputTask)
                    let outputUrl = URL(fileURLWithPath: outputTask.outputPath)
                    try outputImage.saveAsPng(fileUrl: outputUrl)
                }
            }
        } catch let error {
            print(error)
        }
    }
    
    func process(image: NSImage, outputTask: OutputTask) -> NSImage {
        var outputImage = image
        if outputTask.clearWhite {
            outputImage = outputImage.clearedWhite()
        }
        if let tint = outputTask.color {
            outputImage = outputImage.tinted(withColor: tint)
        }
        return outputImage
    }
}
