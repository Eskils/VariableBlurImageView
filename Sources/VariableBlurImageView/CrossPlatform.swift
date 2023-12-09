//
//  CrossPlatform.swift
//
//
//  Created by Eskil Gjerde Sviggum on 08/12/2023.
//

import Foundation

#if canImport(UIKit)
import UIKit
typealias CPImage = UIImage
#elseif canImport(AppKit)
import AppKit
typealias CPImage = NSImage
#endif

