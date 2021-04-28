//
//  EqpMasSubExpViewController.swift
//  EqpInspApp
//
//  Created by Hidetatsu Miyamoto on 2021/04/07.
//

import UIKit

class EqpMasSubExpViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    
    var eqptype: String!
    var itemcode : String!
    var seqnum: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //URLを生成
        let server = "http://\(EqpInspSingleton.shared.settings.server!)"   // 192.168.1.9
        let application = EqpInspSingleton.shared.settings.appName!
        let service = "eqpapi/EqpItemSubExps"
        // Swift で日本語を含む URL を扱う　https://qiita.com/yum_fishing/items/db029c097197e6b27fba
        let _eqptype = eqptype!.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        let url = URL(string: "\(server)/\(application)/\(service)/\(_eqptype)/\(itemcode!)/\(seqnum!)")!

        //Requestを生成
        var request = URLRequest(url: url)
        request.timeoutInterval = EqpInspSingleton.shared.settings.timeoutInterval!
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in  //非同期で通信を行う
            do {
                if error != nil {
                    print(error!.localizedDescription)
                    throw NSError(domain: error!.localizedDescription, code: (error! as NSError).code, userInfo: nil)
                }
                
                guard let data = data else { return }
                print(data)
                //let object = try JSONSerialization.jsonObject(with: data, options: [])  // DataをJsonに変換
                //print(object)
                
                // swiftで配列型のJSONから値を取り出す
                // https://qiita.com/Ajyarimochi/items/50cdc57f898b79cfb48e
                
                let couponDataArray = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [Any]
                print(couponDataArray)
                
                let couponData = couponDataArray.map { (couponData) -> [String: Any] in
                    return couponData as! [String: Any]
                }
                //print(couponData[0]["Name"] as! String)
                //print(couponData[1]["Name"] as! String)

                DispatchQueue.main.async() { () -> Void in
                    self.textView.text = ""
                    
                    self.textView.text += couponData[0]["SubItemName"] as! String
                    self.textView.text += "\n"
                    self.textView.text += couponData[0]["JudgementCriteria"] as! String
                    self.textView.text += "\n"
                    self.textView.text += couponData[0]["InspectionPoint"] as! String
                    self.textView.text += "\n\n"
                    
                    for item in couponData {
                        self.textView.text += item["BefTitle"] as! String
                        self.textView.text += " "
                        self.textView.text += item["AftTitle"] as! String
                        self.textView.text += " "
                        self.textView.text += item["ItemLabel"] as! String
                        self.textView.text += "\n"
                    }
                }
            } catch let error {
                print(error)
                DispatchQueue.main.sync {
                    //self.indicator.stopAnimating()
                    let alert = Util.CreateAlert(title: "通信ERROR", message: error.localizedDescription)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        task.resume()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
