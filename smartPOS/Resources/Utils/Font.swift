//
//  Font.swift
//  SwiftEntryKit_Example
//
//  Created by Daniel Huri on 4/23/18.
//  Copyright (c) 2018 huri000@gmail.com. All rights reserved.
//

import UIKit

typealias MainFont = Font.Poppins

enum Font {
    enum Poppins: String {
        case extraLight = "ExtraLight"
        case thinItalic = "ThinItalic"
        case extraLightItalic = "ExtraLightItalic"
        case boldItalic = "BoldItalic"
        case light = "Light"
        case medium = "Medium"
        case semiBoldItalic = "SemiBoldItalic"
        case extraBoldItalic = "ExtraBoldItalic"
        case extraBold = "ExtraBold"
        case blackIlatic = "BlackIlatic"
        case regular = "Regular"
        case mediumItalic = "MediumItalic"
        case italic = "Italic"
        case lightItalic = "LightItalic"
        case bold = "Bold"
        case semiBold = "SemiBold"
        case thin = "Thin"

        func with(size: CGFloat) -> UIFont {
            return UIFont(name: "Poppins-\(rawValue)", size: size)!
        }
    }
}
