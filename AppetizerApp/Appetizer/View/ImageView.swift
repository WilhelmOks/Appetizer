//
//  ImageView.swift
//  Appetizer
//
//  Created by Wilhelm Oks on 12.09.20.
//  Copyright © 2020 Wilhelm Oks. All rights reserved.
//

import SwiftUI

struct ImageView: View {
    @Binding var image: NSImage
    
    static let bgImage = NSImage(imageLiteralResourceName: "image_bg")
    
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

struct ImageView_Previews: PreviewProvider {
    @State static var image = NSImage()
    
    static var previews: some View {
        ImageView(image: $image)
            .frame(width: 200, height: 200)
    }
}
