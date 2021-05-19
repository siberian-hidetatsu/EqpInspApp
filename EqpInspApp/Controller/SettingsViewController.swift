//
//  SettingsViewController.swift
//  EqpInspApp
//
//  Created by Hidetatsu Miyamoto on 2021/04/22.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var server: UITextField!
    @IBOutlet weak var timeoutInterval: UITextField!
    @IBOutlet weak var appName: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var initializeButton: UIButton!
    
    var saveButtonPosition:CGPoint = CGPoint()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        saveButton.layer.cornerRadius = 5
        initializeButton.layer.cornerRadius = 5
        
        saveButtonPosition = CGPoint(x: saveButton.frame.origin.x, y: saveButton.frame.origin.y)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // 画面回転を検知
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(didChangeOrientation(_:)),
                                               name: UIDevice.orientationDidChangeNotification,
                                               object: nil)

        resetView()
    }
    
    @objc private func didChangeOrientation(_ notification: Notification) {
        resetView()
    }

    func resetView()
    {
        backgroundView.frame.size = CGSize(width: view.frame.width, height: view.frame.height)
        visualEffectView.frame.size = CGSize(width: view.frame.width, height: view.frame.height)
        
        if UIApplication.shared.windows.first?.windowScene?.interfaceOrientation.isPortrait ?? true {
            saveButton.layer.frame.origin = saveButtonPosition
            
            initializeButton.frame.origin = CGPoint(x: saveButton.frame.origin.x, y: saveButton.frame.origin.y + 100)
        }
        else {
            saveButton.layer.frame.origin = CGPoint(x: 500, y: server.frame.origin.y)
            
            initializeButton.frame.origin = CGPoint(x: saveButton.frame.origin.x, y: saveButton.frame.origin.y + 80)
        }
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
        
        appName.text = EqpInspSingleton.shared.settings.appName
    }

    // 保存
    @IBAction func save(_ sender: Any) {
        UserDefaults.standard.setValue(server.text, forKey: "settings.server")
        UserDefaults.standard.setValue(timeoutInterval.text, forKey: "settings.timeoutInterval")
        UserDefaults.standard.setValue(appName.text, forKey: "settings.appName")
        
        EqpInspSingleton.shared.settings.server = server.text
        EqpInspSingleton.shared.settings.timeoutInterval = (timeoutInterval.text! as NSString).doubleValue
        EqpInspSingleton.shared.settings.appName = appName.text
    }
    
    // 初期化
    @IBAction func initialize(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "settings.server")
        UserDefaults.standard.removeObject(forKey: "settings.timeoutInterval")
        UserDefaults.standard.removeObject(forKey: "settings.appName")
        
        server.text = "192.168.1.9"
        EqpInspSingleton.shared.settings.server = server.text
        
        timeoutInterval.text = "10"
        EqpInspSingleton.shared.settings.timeoutInterval = (timeoutInterval.text! as NSString).doubleValue
        
        appName.text = "EqpInspService"
        EqpInspSingleton.shared.settings.appName = appName.text
    }
}
