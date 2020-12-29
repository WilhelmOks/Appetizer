//
//  OutputTask.swift
//  Appetizer
//
//  Created by Wilhelm Oks on 28.03.20.
//  Copyright © 2020 Wilhelm Oks. All rights reserved.
//

import Foundation
import AppKit
import HexNSColor
import Combine

final class OutputTask : Identifiable, ObservableObject {
    let id = UUID()
    let task: Task
    
    @Published var enabled: Bool = true
    @Published var selectedTypeIndex: Int = 0
    @Published var outputPath: String = ""
    @Published var sizeXString: String = "" {
        didSet {
            previewImageWillChange.send()
        }
    }
    @Published var sizeYString: String = "" {
        didSet {
            previewImageWillChange.send()
        }
    }
    @Published var paddingString: String = "" {
        didSet {
            previewImageWillChange.send()
        }
    }
    @Published var colorString: String = "" {
        didSet {
            previewImageWillChange.send()
        }
    }
    @Published var clearWhite: Bool = false {
        didSet {
            previewImageWillChange.send()
        }
    }
    @Published var androidFolderPrefixString: String = ""
    @Published var fileNameString: String = ""
    
    @Published var previewImage: NSImage = NSImage()
    
    let previewImageWillChange = PassthroughSubject<Void, Never>()
    var previewImageCancellable: AnyCancellable?
    
    var isReady: Bool {
        let isValid = !outputPath.isEmpty && (!needsSize || sizeX != nil && sizeY != nil) && fileNameString.isValidFileName
        return isValid || !enabled
    }
    
    var selectedType: OutputType {
        OutputType.allCases[selectedTypeIndex]
    }
    
    var sizeX: Int? { Int(sizeXString) }
    var sizeY: Int? { Int(sizeYString) }
    
    var padding: Int { Int(paddingString) ?? 0 }
    
    var color: NSColor? { NSColor.fromHexString(colorString) }
    
    let androidFolderPrefixDefault = "drawable"
    var androidFolderPrefix: String {
        androidFolderPrefixString.isEmpty ? androidFolderPrefixDefault : androidFolderPrefixString
    }
    
    var needsSize: Bool { selectedType != .iOSAppIcon }
    
    init(task: Task) {
        self.task = task
        
        updatePreviewImage()
        
        previewImageCancellable = previewImageWillChange.sink { [weak self] _ in
            self?.updatePreviewImage()
        }
    }
    
    init(_ outputTask: OutputTask) {
        task = outputTask.task
        enabled = outputTask.enabled
        selectedTypeIndex = outputTask.selectedTypeIndex
        outputPath = outputTask.outputPath
        sizeXString = outputTask.sizeXString
        sizeYString = outputTask.sizeYString
        paddingString = outputTask.paddingString
        colorString = outputTask.colorString
        clearWhite = outputTask.clearWhite
        androidFolderPrefixString = outputTask.androidFolderPrefixString
        fileNameString = outputTask.fileNameString
        
        updatePreviewImage()
        
        previewImageCancellable = previewImageWillChange.sink { [weak self] _ in
            self?.updatePreviewImage()
        }
    }
    
    func updatePreviewImage() {
        if let inputImage = NSImage(contentsOfFile: task.inputPath) {
            previewImage = Generator.shared.process(image: inputImage, outputTask: self)
            //previewImage = inputImage.tinted(withColor: color)
        } else {
            previewImage = NSImage()
        }
    }
}
