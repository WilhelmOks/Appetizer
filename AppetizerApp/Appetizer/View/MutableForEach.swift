//
//  MutableForEach.swift
//  Appetizer
//
//  Created by Wilhelm Oks on 22.08.20.
//  Copyright © 2020 Wilhelm Oks. All rights reserved.
//

import SwiftUI

struct MutableForEach<
        Data: RandomAccessCollection,
        ID: Hashable,
        ViewType: View>:
        View where Data.Element: Hashable {
    
    @Binding var data: Data
    var id: KeyPath<Data.Element, ID>
    var content: (_ element: Data.Element) -> ViewType
    
    var body: some View {
        ForEach(data, id: \.self) { element in
            self.content(element)
        }
    }
}

struct MutableForEach_Previews: PreviewProvider {
    @State static var data: [String] = ["a", "b"]
    
    static var previews: some View {
        MutableForEach(data: $data, id: \.self) { element in
            Text(element)
        }
    }
}
