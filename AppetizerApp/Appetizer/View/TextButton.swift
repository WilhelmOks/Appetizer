//
//  TextButton.swift
//  Appetizer
//
//  Created by Wilhelm Oks on 22.08.20.
//  Copyright © 2020 Wilhelm Oks. All rights reserved.
//

import SwiftUI

struct TextButton: View {
    @State var text: String
    var action: () -> ()
    
    var body: some View {
        Button(action: action) {
            Text(text)
        }
    }
}

struct TextButton_Previews: PreviewProvider {
    static var previews: some View {
        TextButton(text: "text") {}
    }
}
