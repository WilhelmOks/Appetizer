/**
*  Appetizer
*  Copyright (c) Wilhelm Oks 2020
*  Licensed under the MIT license (see LICENSE file)
*/

import Foundation
import AppKit

public extension NSImage {
    enum ImageFileReadError : Error {
        case invalidImageFile(_ filePath: String)
        case invalidSvgFile(_ filePath: String)
        case svgParsingError(_ filePath: String)
    }

    enum ImageFileWriteError : Error {
        case dataRepresentationError
    }

    static func from(filePath path: String, sizeX: Int, sizeY: Int) throws -> NSImage {
        guard let image = NSImage(contentsOfFile: path) else {
            throw ImageFileReadError.invalidImageFile(path)
        }
        return image
    }
    
    func scaled(toSize size: CGSize, padding: Int) -> NSImage {
        guard let bitmapRep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: Int(size.width), pixelsHigh: Int(size.height), bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .calibratedRGB, bytesPerRow: 0, bitsPerPixel: 0) else {
            fatalError("Could not create NSBitmapImageRep")
        }
        bitmapRep.size = size
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmapRep)
        self.draw(in: NSRect(x: CGFloat(0 + padding), y: CGFloat(0 + padding), width: size.width - CGFloat(padding * 2), height: size.height - CGFloat(padding * 2)), from: .zero, operation: .copy, fraction: 1.0)
        NSGraphicsContext.restoreGraphicsState()
        
        let resizedImage = NSImage(size: size)
        resizedImage.addRepresentation(bitmapRep)
        return resizedImage
    }
    
    func tinted(withColor tint: NSColor?) -> NSImage {
        guard let copy = self.copy() as? NSImage else { return self }
        guard let tint = tint else { return copy }
        copy.lockFocus()
        tint.set()
        let imageRect = NSRect(origin: NSZeroPoint, size: self.size)
        imageRect.fill(using: .sourceAtop)
        copy.unlockFocus()
        return copy
    }
    
    func saveAsPng(fileUrl url: URL) throws {
        guard let imageData = self.tiffRepresentation else {
            throw ImageFileWriteError.dataRepresentationError
        }
        guard let imageRep = NSBitmapImageRep(data: imageData) else {
            throw ImageFileWriteError.dataRepresentationError
        }
        guard let pngImage = imageRep.representation(using: .png, properties: [:]) else {
            throw ImageFileWriteError.dataRepresentationError
        }
        try pngImage.write(to: url)
    }
}
