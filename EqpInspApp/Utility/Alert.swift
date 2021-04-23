//
//  Alert.swift
//  EqpInspApp
//
//  Created by Hidetatsu Miyamoto on 2021/04/23.
//

import Foundation
import UIKit

struct Util {
    static func CreateAlert(title: String, message: String) -> UIAlertController {
        // Swiftのエラー処理をちょいとまとめた
        // https://tkgstrator.work/?p=28598
        //let message:String = String(error.localizedDescription)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler:nil)
        alert.addAction(defaultAction)
        
        return alert
    }
}
