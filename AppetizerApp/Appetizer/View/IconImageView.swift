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
    
    var body: some View {
        ZStack {
            Image(nsImage: NSImage(imageLiteralResourceName:  "image_bg"))
                .resizable(resizingMode: .tile)
            
            Image(nsImage: NSImage(contentsOfFile: filePath) ?? NSImage())
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
