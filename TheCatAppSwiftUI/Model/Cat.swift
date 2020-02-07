//
//  Cat.swift
//  SwiftUIRxSwiftTheCatApp
//
//  Created by Admin on 2/1/20.
//  Copyright © 2020 BadJesus. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Cat
struct Cat: Codable, Identifiable {
    let id: String
    let url: String
    let width, height: Int
    let categories: [Category]?
}

//// MARK: - Category
struct Category: Codable {
    let id: Int
    let name: String
}

