//
//  View+Validation.swift
//  Appetizer
//
//  Created by Wilhelm Oks on 28.12.20.
//  Copyright © 2020 Wilhelm Oks. All rights reserved.
//

import SwiftUI
import AppKit

extension View {
    @ViewBuilder func valid(_ valid: Bool) -> some View {
        self.border(valid ? Color.clear : Color(NSColor.systemRed))
    }
}

struct View_Validation_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TextField("valid", text: .constant(""))
                .valid(true)
            
            TextField("invalid", text: .constant(""))
                .valid(false)
        }
    }
}
