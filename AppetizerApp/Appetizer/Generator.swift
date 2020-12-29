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
                    let image = process(image: inputImage, outputTask: outputTask)
                    let outputUrl = URL(fileURLWithPath: outputTask.outputPath)
                    let fileName = !outputTask.fileNameString.isEmpty ? outputTask.fileNameString : task.inputFileName
                    let sizeX = outputTask.sizeX ?? 1
                    let sizeY = outputTask.sizeY ?? 1
                    
                    switch outputTask.selectedType {
                    case .androidImage:
                        Appetizer.makeAndroidImages(
                            from: image,
                            to: outputUrl,
                            name: fileName,
                            folderPrefix: outputTask.androidFolderPrefix,
                            sizeX: sizeX,
                            sizeY: sizeY,
                            padding: outputTask.padding)
                    case .iOSImage:
                        Appetizer.makeIOSImages(
                            from: image,
                            to: outputUrl,
                            name: fileName,
                            sizeX: sizeX,
                            sizeY: sizeY,
                            padding: outputTask.padding)
                    case .iOSAppIcon:
                        Appetizer.makeIOSAppIconImages(
                            from: image,
                            to: outputUrl,
                            name: fileName,
                            padding: outputTask.padding)
                    case .singleImage:
                        Appetizer.makeSingleImage(
                            from: image,
                            to: outputUrl,
                            name: fileName,
                            sizeX: sizeX,
                            sizeY: sizeY,
                            padding: outputTask.padding)
                    }
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
    
    func processPreview(image: NSImage, outputTask: OutputTask) -> NSImage {
        let scale = 1.0
        
        let sizeX = Double(outputTask.sizeX ?? Int(image.size.width))
        let sizeY = Double(outputTask.sizeY ?? Int(image.size.height))
        
        let resX = Appetizer.scaleAndRound(sizeX, scale: scale)
        let resY = Appetizer.scaleAndRound(sizeY, scale: scale)
        
        let scaledPadding = Appetizer.scaleAndRound(outputTask.padding, scale: scale)
        
        var outputImage = image.scaled(toSize: .init(width: resX, height: resY), padding: scaledPadding)
        
        if outputTask.clearWhite {
            outputImage = outputImage.clearedWhite()
        }
        if let tint = outputTask.color {
            outputImage = outputImage.tinted(withColor: tint)
        }
        return outputImage
    }
}
