//
//  IconImageView.swift
//  Appetizer
//
//  Created by Wilhelm Oks on 11.08.20.
//  Copyright © 2020 Wilhelm Oks. All rights reserved.
//

import SwiftUI

struct IconImageView: View {
    @Binding var filePath: String
    
    static let blankImage = NSImage()
    static var cachedImage: [String: NSImage] = [:]
    static let bgImage = NSImage(imageLiteralResourceName:  "image_bg")
    
    var image: NSImage {
        /*
        if let image = Self.cachedImage[filePath] {
            return image
        }
        
        let image = NSImage(contentsOfFile: filePath) ?? Self.blankImage
        
        Self.cachedImage[filePath] = image
        
        return image
        */
        NSImage(contentsOfFile: filePath) ?? Self.blankImage
    }
    
    var body: some View {
        ZStack {
            Image(nsImage: Self.bgImage)
                .resizable(resizingMode: .tile)
            
            Image(nsImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
}

struct IconImageView_Previews: PreviewProvider {
    @State static var filePath = ""
    
    static var previews: some View {
        IconImageView(filePath: $filePath)
            .frame(width: 300, height: 300)
    }
}
