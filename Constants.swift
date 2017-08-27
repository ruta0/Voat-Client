//
//  Constants.swift
//  Voat
//
//  Created by rightmeow on 8/27/17.
//  Copyright © 2017 Duckensburg. All rights reserved.
//

import Foundation
#if os(iOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif

// MARK: - Segue

let seguePostCellToPostVC = "seguePostCellToPostVC"

// MARK: - Device Info

let bundleID = [Bundle.main.bundleIdentifier!]
let uuid = [UIDevice.current.identifierForVendor!.uuidString]
let model = [UIDevice.current.model]
let systemName = [UIDevice.current.systemName]
let name = [UIDevice.current.name]
let systemVersion = [UIDevice.current.systemVersion]
