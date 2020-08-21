//
//  OutputType.swift
//  Appetizer
//
//  Created by Wilhelm Oks on 11.08.20.
//  Copyright © 2020 Wilhelm Oks. All rights reserved.
//

import Foundation

enum OutputType : CaseIterable {
    case androidImage
    case iOSImage
    case iOSAppIcon
    case singleImage
    
    var displayName: String {
        switch self {
        case .androidImage: return "Android Image"
        case .iOSImage:     return "iOS Image"
        case .iOSAppIcon:   return "iOS App Icon"
        case .singleImage:  return "Single Image"
        }
    }
}
