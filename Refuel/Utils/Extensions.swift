//
//  Extensions.swift
//  Daily
//
//  Created by Яна Латышева on 16.03.2020.
//  Copyright © 2020 Motodolphin. All rights reserved.
//

import UIKit

// MARK: - UIView

extension UIView {

    func anchor(top: NSLayoutYAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                bottom: NSLayoutYAxisAnchor? = nil,
                paddingBottom: CGFloat = 0,
                leading: NSLayoutXAxisAnchor? = nil,
                paddingLeading: CGFloat = 0,
                trailing: NSLayoutXAxisAnchor? = nil,
                paddingTrailing: CGFloat = 0,
                left: NSLayoutXAxisAnchor? = nil,
                paddingLeft: CGFloat = 0,
                right: NSLayoutXAxisAnchor? = nil,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil,
                centerX: NSLayoutXAxisAnchor? = nil,
                centerY: NSLayoutYAxisAnchor? = nil) {

        translatesAutoresizingMaskIntoConstraints = false

        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true

        }

        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }

        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: paddingLeading).isActive = true
        }

        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -paddingTrailing).isActive = true
        }

        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }

        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }

        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }

        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }

        if let centerX = centerX {
            centerXAnchor.constraint(equalTo: centerX).isActive = true
        }

        if let centerY = centerY {
            centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
    }

}

// MARK: - UIColor

extension UIColor {

    public convenience init?(hexRGBA: String) {
        let red, green, blue, alpha: CGFloat
        guard hexRGBA.hasPrefix("#"), hexRGBA.count == 9 else { return nil }
        let start = hexRGBA.index(hexRGBA.startIndex, offsetBy: 1)
        let hexColor = String(hexRGBA[start...])
        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0
        guard scanner.scanHexInt64(&hexNumber) else { return nil}
        red = CGFloat((hexNumber & 0xff000000) >> 24) / 255
        green = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
        blue = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
        alpha = CGFloat(hexNumber & 0x000000ff) / 255
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    public convenience init?(hexRGB: String) {
        self.init(hexRGBA: hexRGB + "FF")
    }

    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
    }

    func toHexString() -> String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let rgb: Int = (Int)(red*255)<<16 | (Int)(green*255)<<8 | (Int)(blue*255)<<0
        return String(format: "#%06x", rgb)
    }

}

// MARK: - Date

extension Date {

    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: self)
    }
}

// MARK: - Double

extension Double {

    init?(from localizedString: String) {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = .current
        numberFormatter.allowsFloats = true
        numberFormatter.numberStyle = .decimal
        guard let number = numberFormatter.number(from: localizedString) else {
            return nil
        }
        self = number.doubleValue
    }

    func toString() -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = .current
        numberFormatter.allowsFloats = true
        numberFormatter.numberStyle = .decimal
        /** do not work with `numberStyle = .decimal`
         numberFormatter.usesSignificantDigits = true
        numberFormatter.minimumSignificantDigits = 0
        numberFormatter.maximumSignificantDigits = 2
        */
        let number = NSNumber(value: self)
        return numberFormatter.string(from: number)
    }
}
