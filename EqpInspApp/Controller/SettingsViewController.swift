//
//  SettingsViewController.swift
//  EqpInspApp
//
//  Created by Hidetatsu Miyamoto on 2021/04/22.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var server: UITextField!
    @IBOutlet weak var timeoutInterval: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        server.text = EqpInspSingleton.shared.settings.server
        timeoutInterval.text = String(Int(EqpInspSingleton.shared.settings.timeoutInterval!))
    }

    @IBAction func save(_ sender: Any) {
        UserDefaults.standard.setValue(server.text, forKey: "settings.server")
        
        EqpInspSingleton.shared.settings.server = server.text
        EqpInspSingleton.shared.settings.timeoutInterval = (timeoutInterval.text! as NSString).doubleValue
    }
    
    @IBAction func initialize(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "settings.server")
        
        server.text = "192.168.1.9"
        EqpInspSingleton.shared.settings.server = server.text
        
        timeoutInterval.text = "10"
        EqpInspSingleton.shared.settings.timeoutInterval = (timeoutInterval.text! as NSString).doubleValue
    }
}
