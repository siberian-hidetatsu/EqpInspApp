//
//  EqpInspSingleton.swift
//  EqpInspApp
//
//  Created by Hidetatsu Miyamoto on 2021/04/07.
//

import Foundation

class EqpInspSingleton {
    private init() {}
    static var shared = EqpInspSingleton()
    var eqpInspItems: [EqpInsp.EqpInspItem] = []
    /* 受信データが階層化されてない場合
    var expitemdatas: [[String: String]] = []*/
    
    var settings:Settings = Settings()
}
