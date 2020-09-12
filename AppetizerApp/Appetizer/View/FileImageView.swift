//
//  IconImageView.swift
//  Appetizer
//
//  Created by Wilhelm Oks on 11.08.20.
//  Copyright © 2020 Wilhelm Oks. All rights reserved.
//

import SwiftUI

struct FileImageView: View {
    @Binding var filePath: String
    
    static let blankImage = NSImage()
    static let bgImage = NSImage(imageLiteralResourceName:  "image_bg")
    
    var image: NSImage {
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

struct FileImageView_Previews: PreviewProvider {
    @State static var filePath = ""
    
    static var previews: some View {
        FileImageView(filePath: $filePath)
            .frame(width: 200, height: 200)
    }
}
