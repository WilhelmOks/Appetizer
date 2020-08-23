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

    static func from(filePath path: String) throws -> NSImage {
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
    
    private func cgImageFromCiImage(_ inputImage: CIImage, rect: CGRect) -> CGImage {
        let context = CIContext(options: nil)
        if let cgImage = context.createCGImage(inputImage, from: rect) {
            return cgImage
        }
        fatalError("could not convert CIImage to CGImage")
    }
    
    func clearedWhite() -> NSImage {
        let sourceNsImage = self
        let cgImage = sourceNsImage.cgImage(forProposedRect: nil, context: nil, hints: [:])!
        let ciImage = CIImage(cgImage: cgImage)
        let filter = ClearWhiteFilter()
        filter.assignInputImage(ciImage)
        let outputImage = filter.outputImage!
        
        let imageSize = CGSize(width: cgImage.width, height: cgImage.height)
        let outputCgImage = cgImageFromCiImage(outputImage, rect: .init(origin: .zero, size: imageSize))
        
        return NSImage(cgImage: outputCgImage, size: sourceNsImage.size)
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

@objcMembers fileprivate class ClearWhiteFilter : CIFilter {
    var inputImage: CIImage?
    
    private static let kernels = CIKernel.makeKernels(source:
        """
        kernel vec4 clearWhite(sampler image) {
            vec4 t = sample(image, samplerCoord(image));
            float brightness = (t.r + t.g + t.b) / 3.0;
            float i = 1.0 - brightness;
            t.a = min(i, t.a);
            return t;
        }
        """
    )!
    
    override public var outputImage: CIImage? {
        let src = CISampler(image: self.inputImage!)
        let kernel = ClearWhiteFilter.kernels[0]
        return self.apply(kernel, arguments: [src], options: nil)
    }
    
    func assignInputImage(_ image: CIImage) {
        self.setValue(image, forKey: kCIInputImageKey)
    }
}
