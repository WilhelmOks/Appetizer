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

final class OutputTask : Identifiable, ObservableObject {
    let id = UUID()
    @Published var name: String //TODO: remove
    @Published var enabled: Bool = true
    @Published var selectedTypeIndex: Int = 0 {
        didSet {
            NotificationCenter.default.post(Notification(name: .init("OutputTaskDidChange")))
        }
    }
    @Published var outputPath: String = ""
    @Published var sizeXString: String = ""
    @Published var sizeYString: String = ""
    @Published var paddingString: String = ""
    @Published var colorString: String = ""
    @Published var clearWhite: Bool = false
    @Published var androidFolderPrefixString: String = ""
    @Published var fileNameString: String = ""
    @Published var deleted = false
    
    var isReady: Bool {
        let isValid = !outputPath.isEmpty && (!needsSize || sizeX != nil && sizeY != nil)
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
    
    init(name: String) {
        self.name = name
    }
    
    init(_ outputTask: OutputTask) {
        name = outputTask.name
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
        deleted = outputTask.deleted
    }
    
    func update() {
        enabled.toggle()
        enabled.toggle()
    }
}
