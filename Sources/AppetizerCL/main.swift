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
        
        let inputFilePathString = inputFilePath.path.pathString
        
        let bigImage = try NSImage.from(filePath: inputFilePathString, sizeX: sizeX, sizeY: sizeY)
        
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
            makeIOSImages(from: tintedImage, to: iosIconPathUrl, name: name, sizeX: sizeX, sizeY: sizeY, padding: padding)
        }
        
        if let iosAppIconPathUrl = iosAppIconPath?.path.asURL {
            didSpecifyOutput = true
            makeIOSAppIconImages(from: tintedImage, to: iosAppIconPathUrl, name: iconName, padding: padding)
        }
        
        if let androidIconPathUrl = androidIconPath?.path.asURL {
            didSpecifyOutput = true
            let name = iconName.isEmpty ? originalFileName : iconName
            makeAndroidImages(from: tintedImage, to: androidIconPathUrl, name: name, folderPrefix: androidFolderPrefix, sizeX: sizeX, sizeY: sizeY, padding: padding)
        }
        
        if let singleIconPathUrl = singleIconPath?.path.asURL {
            didSpecifyOutput = true
            let name = iconName.isEmpty ? originalFileName : iconName
            makeSingleImage(from: tintedImage, to: singleIconPathUrl, name: name, sizeX: sizeX, sizeY: sizeY, padding: padding)
        }
        
        if !didSpecifyOutput {
            print("No output generated. Please set an argument to generate iOS or Android icons.")
        }
    } catch let error {
        print(error)
    }
}

fileprivate extension String {
    func colorFromHex() -> NSColor {
        if self.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == "white" {
            return .white
        } else {
            return NSColor.fromHexString(self) ?? .white
        }
    }
}

fileprivate extension String {
    var isValidFileName: Bool {
        return !self.contains("/")
    }
}

private struct DpiInfo {
    let name: String
    let scale: Double
}

private struct SizeDpiInfo {
    let size: Double
    let scale: Int
}

private func scaleAndRound(_ double: Double, scale: Double) -> Int {
    return Int(round(double * scale))
}

private func scaleAndRound(_ double: Double, scale: Int) -> Int {
    return Int(round(double * Double(scale)))
}

private func scaleAndRound(_ integer: Int, scale: Double) -> Int {
    return Int(round(Double(integer) * scale))
}

private func makeAndroidImages(from image: NSImage, to destinationFolderUrl: Foundation.URL, name: String, folderPrefix: String, sizeX: Int, sizeY: Int, padding: Int) {
    let dpiInfos: [DpiInfo] = [
        .init(name: "mdpi", scale: 1),
        .init(name: "hdpi", scale: 1.5),
        .init(name: "xhdpi", scale: 2),
        .init(name: "xxhdpi", scale: 3),
        .init(name: "xxxhdpi", scale: 4),
    ]
    
    let outputFileName = name + ".png"
    
    do {
        for dpiInfo in dpiInfos {
            let resX = scaleAndRound(sizeX, scale: dpiInfo.scale)
            let resY = scaleAndRound(sizeY, scale: dpiInfo.scale)
            
            let scaledPadding = scaleAndRound(padding, scale: dpiInfo.scale)
            
            let scaledImage = image.scaled(toSize: .init(width: resX, height: resY), padding: scaledPadding)
            
            let outputDpiDirectoryUrl = destinationFolderUrl.appendingPathComponent("\(folderPrefix)-\(dpiInfo.name)")
            try? FileManager.default.createDirectory(atPath: outputDpiDirectoryUrl.path, withIntermediateDirectories: true, attributes: nil)
            let outputFileUrl = outputDpiDirectoryUrl.appendingPathComponent(outputFileName)
            
            try scaledImage.saveAsPng(fileUrl: outputFileUrl)
        }
    } catch {
        print(error)
    }
}

private func makeIOSImages(from image: NSImage, to destinationFolderUrl: Foundation.URL, name: String, sizeX: Int, sizeY: Int, padding: Int) {
    let dpiInfos: [DpiInfo] = [
        .init(name: "", scale: 1),
        .init(name: "@2x", scale: 2),
        .init(name: "@3x", scale: 3),
    ]
    
    do {
        try FileManager.default.createDirectory(atPath: destinationFolderUrl.path, withIntermediateDirectories: true, attributes: nil)
    
        for dpiInfo in dpiInfos {
            let resX = scaleAndRound(sizeX, scale: dpiInfo.scale)
            let resY = scaleAndRound(sizeY, scale: dpiInfo.scale)
            
            let scaledPadding = scaleAndRound(padding, scale: dpiInfo.scale)
            
            let scaledImage = image.scaled(toSize: .init(width: resX, height: resY), padding: scaledPadding)
            
            let outputFileName = name + dpiInfo.name + ".png"
            let outputFileUrl = destinationFolderUrl.appendingPathComponent(outputFileName)
            
            try scaledImage.saveAsPng(fileUrl: outputFileUrl)
        }
    } catch {
        print(error)
    }
}

private func makeIOSAppIconImages(from image: NSImage, to destinationFolderUrl: Foundation.URL, name: String, padding: Int) {
    let sizes: [SizeDpiInfo] = [
        .init(size: 20, scale: 2),
        .init(size: 20, scale: 3),
        .init(size: 29, scale: 2),
        .init(size: 29, scale: 3),
        .init(size: 40, scale: 2),
        .init(size: 40, scale: 3),
        .init(size: 60, scale: 2),
        .init(size: 60, scale: 3),
        
        .init(size: 20, scale: 1),
        //.init(size: 20, scale: 2),
        .init(size: 29, scale: 1),
        //.init(size: 29, scale: 2),
        .init(size: 40, scale: 1),
        //.init(size: 40, scale: 2),
        .init(size: 76, scale: 1),
        .init(size: 76, scale: 2),
        
        .init(size: 83.5, scale: 2),
        
        .init(size: 1024, scale: 1),
    ]
    
    do {
        try FileManager.default.createDirectory(atPath: destinationFolderUrl.path, withIntermediateDirectories: true, attributes: nil)
        
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1
        formatter.usesGroupingSeparator = false
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.numberStyle = .decimal
        
        for sizeInfo in sizes {
            let res = scaleAndRound(sizeInfo.size, scale: sizeInfo.scale)
            
            let scaledPadding = padding * sizeInfo.scale
            
            let scaledImage = image.scaled(toSize: .init(width: res, height: res), padding: scaledPadding)
            
            let sizeName = formatter.string(from: NSNumber(value: sizeInfo.size)) ?? "0"
            let scaleName = sizeInfo.scale == 1 ? "" : "@\(sizeInfo.scale)x"
            
            let outputFileName = "\(name)\(sizeName)\(scaleName).png"
            let outputFileUrl = destinationFolderUrl.appendingPathComponent(outputFileName)
            
            try scaledImage.saveAsPng(fileUrl: outputFileUrl)
        }
    } catch {
        print(error)
    }
}

private func makeSingleImage(from image: NSImage, to destinationFolderUrl: Foundation.URL, name: String, sizeX: Int, sizeY: Int, padding: Int) {
    
    do {
        try FileManager.default.createDirectory(atPath: destinationFolderUrl.path, withIntermediateDirectories: true, attributes: nil)
    
        let resX = sizeX
        let resY = sizeY
        
        let scaledPadding = padding
        
        let scaledImage = image.scaled(toSize: .init(width: resX, height: resY), padding: scaledPadding)
        
        let outputFileName = name + ".png"
        let outputFileUrl = destinationFolderUrl.appendingPathComponent(outputFileName)
        
        try scaledImage.saveAsPng(fileUrl: outputFileUrl)
    } catch {
        print(error)
    }
}

main()
