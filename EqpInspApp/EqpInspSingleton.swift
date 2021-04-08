//
//  EqpInspSingleton.swift
//  EqpInspApp
//
//  Created by Hidetatsu Miyamoto on 2021/04/07.
//

import Foundation

class EqpInspSingleton {
    private init() {}
    static let shared = EqpInspSingleton()
    var expitemdatas: [[String: String]] = []
}
