//
//  main.swift
//  VariableBlurDemo-MacOS
//
//  Created by Eskil Gjerde Sviggum on 08/12/2023.
//

import Cocoa

let app = NSApplication.shared
app.setActivationPolicy(.regular)
let appDelegate = AppDelegate()
app.delegate = appDelegate

app.run()
