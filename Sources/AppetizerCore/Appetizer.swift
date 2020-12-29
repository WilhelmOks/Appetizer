/**
*  Appetizer
*  Copyright (c) Wilhelm Oks 2020
*  Licensed under the MIT license (see LICENSE file)
*/

import Foundation
import AppKit
import HexNSColor

public extension String {
    func colorFromHex() -> NSColor {
        if self.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == "white" {
            return .white
        } else {
            return NSColor.fromHexString(self) ?? .white
        }
    }
}

public extension String {
    var isValidFileName: Bool {
        return !self.contains("/")
    }
}

public enum Appetizer {
    public struct DpiInfo {
        let name: String
        let scale: Double
    }

    public struct SizeDpiInfo {
        let size: Double
        let scale: Int
    }

    public static func scaleAndRound(_ double: Double, scale: Double) -> Int {
        return Int(round(double * scale))
    }

    public static func scaleAndRound(_ double: Double, scale: Int) -> Int {
        return Int(round(double * Double(scale)))
    }

    public static func scaleAndRound(_ integer: Int, scale: Double) -> Int {
        return Int(round(Double(integer) * scale))
    }

    public static func makeAndroidImages(from image: NSImage, to destinationFolderUrl: Foundation.URL, name: String, folderPrefix: String, sizeX: Int, sizeY: Int, padding: Int) {
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

    public static func makeIOSImages(from image: NSImage, to destinationFolderUrl: Foundation.URL, name: String, sizeX: Int, sizeY: Int, padding: Int) {
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

    public static func makeIOSAppIconImages(from image: NSImage, to destinationFolderUrl: Foundation.URL, name: String, padding: Int) {
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

    public static func makeSingleImage(from image: NSImage, to destinationFolderUrl: Foundation.URL, name: String, sizeX: Int, sizeY: Int, padding: Int) {
        
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
}
