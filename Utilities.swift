//
//  Utilities.swift
//  Voat
//
//  Created by rightmeow on 8/26/17.
//  Copyright © 2017 Duckensburg. All rights reserved.
//

import Foundation

#if os(iOS)
    import UIKit
    typealias Color = UIColor
#elseif os(OSX)
    import AppKit
    typealias Color = NSColor
#endif

// MARK: - Error handler

func trace(file: String, function: String, line: Int) -> String {
    let trace = "\n" + "file: " + file + "\n" + "function: " + function + "\n" + "line: " + String(describing: line) + "\n"
    return trace
}

// MARK: - Color

extension Color {

    static var inkBlack: Color { return #colorLiteral(red: 0.05882352941, green: 0.05882352941, blue: 0.05882352941, alpha: 1) }
    static var midNightBlack: Color { return  #colorLiteral(red: 0.137254902, green: 0.137254902, blue: 0.137254902, alpha: 1) }
    static var seaweedGreen: Color { return #colorLiteral(red: 0.4470588235, green: 0.5607843137, blue: 0.2549019608, alpha: 1) }
    static var roseScarlet: Color { return #colorLiteral(red: 0.5607843137, green: 0.1960784314, blue: 0.2156862745, alpha: 1) }
    static var candyWhite: Color { return #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1) }
    static var mandarinOrange: Color { return #colorLiteral(red: 0.7411764706, green: 0.3921568627, blue: 0.2235294118, alpha: 1) }
    static var metallicGold: Color { return #colorLiteral(red: 0.831372549, green: 0.6862745098, blue: 0.2156862745, alpha: 1) }
    static var deepSeaBlue: Color { return #colorLiteral(red: 0.1568627451, green: 0.1725490196, blue: 0.231372549, alpha: 1) }
    static var mediumBlueGray: Color { return #colorLiteral(red: 0.3294117647, green: 0.3294117647, blue: 0.368627451, alpha: 1) }
    static var mildBlueGray: Color { return #colorLiteral(red: 0.4117647059, green: 0.4117647059, blue: 0.4588235294, alpha: 1) }
    static var lightBlue: Color { return #colorLiteral(red: 0.9098039216, green: 0.9254901961, blue: 0.9450980392, alpha: 1) }
    static var miamiBlue: Color { return #colorLiteral(red: 0, green: 0.5254901961, blue: 0.9764705882, alpha: 1) }

}

extension String {

    /// dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    func toSystemDate() -> NSDate {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: self)! // let it crash here
        let nsDate = date as NSDate
        return nsDate
    }
    
}

// MARK: - Human readable date

extension NSDate {

    func toRelativeDate() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self as Date))
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        if secondsAgo < minute {
            return "\(secondsAgo) seconds"
        } else if secondsAgo < hour {
            return "\(secondsAgo / minute) minutes"
        } else if secondsAgo < day {
            return "\(secondsAgo / hour) hours"
        } else if secondsAgo < week {
            return "\(secondsAgo / day) days"
        }
        return "\(secondsAgo / week) weeks"
    }

}

extension UIImageView {

    func fadeIn() {
        self.alpha = 0.0
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1
        }, completion: nil)
    }
    
}
























