/**
*  Appetizer
*  Copyright (c) Wilhelm Oks 2020
*  Licensed under the MIT license (see LICENSE file)
*/

import Foundation
import AppKit
import SPMUtility
import HexNSColor
import AppetizerCore

func main() {
    let parser = ArgumentParser(usage: "<options>", overview: "")
    
    let inputFilePathArgument = parser.add(positional: "file", kind: PathArgument.self, usage: "The source image file.", completion: .filename)
    let sizeXArgument = parser.add(positional: "sizeX", kind: Int.self, usage: "The width of the target image, in pixels.")
    let sizeYArgument = parser.add(positional: "sizeY", kind: Int.self, usage: "The height of the target image, in pixels.")
    let paddingArgument = parser.add(option: "--padding", shortName: "-p", kind: Int.self, usage: "The amount of space to leave empty on the edges.")
    let colorArgument = parser.add(option: "--color", shortName: "-c", kind: String.self, usage: "The hex color to apply to the image. Example: ff0000 for red.")
    let iconNameArgument = parser.add(option: "--name", shortName: "-n", kind: String.self, usage: "The file name for the new icon. If omitted, the name of the source file will be used.")
    let iosIconPathArgument = parser.add(option: "--iosIcon", shortName: "-i", kind: PathArgument.self, usage: "The path to a directory where to generate the iOS icon with different sizes.")
    let iosAppIconPathArgument = parser.add(option: "--iosAppIcon", shortName: "-ia", kind: PathArgument.self, usage: "The path to a directory where to generate the iOS app icon with different sizes.")
    let androidIconPathArgument = parser.add(option: "--androidIcon", shortName: "-a", kind: PathArgument.self, usage: "The path to a directory where to generate the Android icon with different sizes.")
    let androidFolderPrefixArgument = parser.add(option: "--androidFolderPrefix", shortName: "-afp", kind: String.self, usage: "The folder prefix for the Android images. Example: 'mipmap' will generate folders like 'mipmap-mdpi' and 'mipmap-xhdpi'. Default is 'drawable'.")
    let singleIconPathArgument = parser.add(option: "--singleIcon", shortName: "-si", kind: PathArgument.self, usage: "The path to a directory where to generate a single icon with the specified size.")
    let clearWhiteArgument = parser.add(option: "--clearWhite", shortName: "-cw", kind: Bool.self, usage: "Make white color areas transparent. Useful to remove white background.")
    
    do {
        let parsedArguments = try parser.parse(Array(ProcessInfo.processInfo.arguments.dropFirst()))
        
        let inputFilePath = parsedArguments.get(inputFilePathArgument)!
        let sizeX = parsedArguments.get(sizeXArgument)!
        let sizeY = parsedArguments.get(sizeYArgument)!
        let padding = parsedArguments.get(paddingArgument) ?? 0
        let tintColor = parsedArguments.get(colorArgument)?.colorFromHex()
        let iconName = parsedArguments.get(iconNameArgument) ?? ""
        let iosIconPath = parsedArguments.get(iosIconPathArgument)
        let iosAppIconPath = parsedArguments.get(iosAppIconPathArgument)
        let androidIconPath = parsedArguments.get(androidIconPathArgument)
        let androidFolderPrefix = parsedArguments.get(androidFolderPrefixArgument) ?? "drawable"
        let singleIconPath = parsedArguments.get(singleIconPathArgument)
        let clearWhite = parsedArguments.get(clearWhiteArgument) ?? false
        
        let inputFilePathString = inputFilePath.path.pathString
        
        var bigImage = try NSImage.from(filePath: inputFilePathString)
        
        if clearWhite {
            bigImage = bigImage.clearedWhite()
        }
        
        let tintedImage = bigImage.tinted(withColor: tintColor)
        
        let fileUrl = URL(fileURLWithPath: "file:///" + inputFilePathString)
        let originalFileName = fileUrl.deletingPathExtension().lastPathComponent
        
        guard iconName.isValidFileName else {
            print("The icon name is not valid: \(iconName)")
            return
        }
        
        var didSpecifyOutput = false
        
        if let iosIconPathUrl = iosIconPath?.path.asURL {
            didSpecifyOutput = true
            let name = iconName.isEmpty ? originalFileName : iconName
            Appetizer.makeIOSImages(from: tintedImage, to: iosIconPathUrl, name: name, sizeX: sizeX, sizeY: sizeY, padding: padding)
        }
        
        if let iosAppIconPathUrl = iosAppIconPath?.path.asURL {
            didSpecifyOutput = true
            Appetizer.makeIOSAppIconImages(from: tintedImage, to: iosAppIconPathUrl, name: iconName, padding: padding)
        }
        
        if let androidIconPathUrl = androidIconPath?.path.asURL {
            didSpecifyOutput = true
            let name = iconName.isEmpty ? originalFileName : iconName
            Appetizer.makeAndroidImages(from: tintedImage, to: androidIconPathUrl, name: name, folderPrefix: androidFolderPrefix, sizeX: sizeX, sizeY: sizeY, padding: padding)
        }
        
        if let singleIconPathUrl = singleIconPath?.path.asURL {
            didSpecifyOutput = true
            let name = iconName.isEmpty ? originalFileName : iconName
            Appetizer.makeSingleImage(from: tintedImage, to: singleIconPathUrl, name: name, sizeX: sizeX, sizeY: sizeY, padding: padding)
        }
        
        if !didSpecifyOutput {
            print("No output generated. Please set an argument to generate iOS or Android icons.")
        }
    } catch let error {
        print(error)
    }
}

main()
