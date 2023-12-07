//
//  TestsError.swift
//
//
//  Created by Eskil Gjerde Sviggum on 07/12/2023.
//

import Foundation

enum TestsError: Error {
    case cannotFindImageResource
    case cannotMakeImageSource
    case cannotMakeCGImageFromData
    case cannotMakeImageDestination
}
