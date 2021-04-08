//
//  EqpItemSubExpViewController.swift
//  EqpInspApp
//
//  Created by Hidetatsu Miyamoto on 2021/04/07.
//

import UIKit

class EqpItemSubExpViewController: UIViewController {
    var eqptype: String!
    var itemcode : String!
    var seqnum: String!
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        GetData()
    }
    
    func GetData() {
        var count = 0
        var befResult:String = ""
        var aftResult:String = ""
        let x = 10, width = 200, height = 20
        var y = 100
        
        textView.text = ""

        for expitemdata in EqpInspSingleton.shared.expitemdatas {
            if expitemdata["ItemCode"]! != itemcode ||
                expitemdata["SeqNum"]! != seqnum {
                continue
            }
            
            if count == 0 {
                let subItemNameLabel = UILabel()
                subItemNameLabel.frame = CGRect(x: x, y: y, width: Int(view.frame.width) - 20, height: height)
                subItemNameLabel.text = expitemdata["SubItemName"]!
                view.addSubview(subItemNameLabel)
                
                y += 20
                let judgementCriteriaLabel = UILabel()
                judgementCriteriaLabel.frame = CGRect(x: x, y: y, width: Int(view.frame.width) - 20, height: height)
                judgementCriteriaLabel.text = expitemdata["JudgementCriteria"]!
                view.addSubview(judgementCriteriaLabel)
                
                y += 20
                let inspectionPointLabel = UILabel()
                inspectionPointLabel.frame = CGRect(x: x, y: y, width: Int(view.frame.width) - 20, height: height)
                inspectionPointLabel.text = expitemdata["InspectionPoint"]!
                inspectionPointLabel.textColor = UIColor.blue
                view.addSubview(inspectionPointLabel)
                
                if !inspectionPointLabel.text!.isEmpty {
                    y += 20
                }
                
                y += 20
                let befTitleLabel = UILabel()
                befTitleLabel.frame = CGRect(x: x + 100, y: y, width: width / 2, height: height)
                befTitleLabel.text = expitemdata["BefTitle"]!
                view.addSubview(befTitleLabel)
                
                let aftTitleLabel = UILabel()
                aftTitleLabel.frame = CGRect(x: x + 200, y: y, width: width / 2, height: height)
                aftTitleLabel.text = expitemdata["AftTitle"]!
                view.addSubview(aftTitleLabel)
                
                /*textView.text += expitemdata["SubItemName"]!
                textView.text += "\n"
                textView.text += expitemdata["JudgementCriteria"]!
                textView.text += "\n"
                textView.text += expitemdata["InspectionPoint"]!
                textView.text += "\n"
                textView.text += "\(expitemdata["BefTitle"]!)　　\(expitemdata["AftTitle"]!)"
                textView.text += "\n\n"*/
                
                befResult = expitemdata["BefResult"]!
                aftResult = expitemdata["AftResult"]!
            }
            
            y += 20
            let itemLabelLabel = UILabel()
            itemLabelLabel.frame = CGRect(x: x, y: y, width: width / 2, height: height)
            itemLabelLabel.text = expitemdata["ItemLabel"]!
            view.addSubview(itemLabelLabel)
            
            let befValueLabel = UILabel()
            befValueLabel.frame = CGRect(x: x + 100, y: y, width: width / 2, height: height)
            befValueLabel.text = expitemdata["BefValue"]!
            view.addSubview(befValueLabel)
            
            let aftValueLabel = UILabel()
            aftValueLabel.frame = CGRect(x: x + 200, y: y, width: width / 2, height: height)
            aftValueLabel.text = expitemdata["AftValue"]!
            view.addSubview(aftValueLabel)
            
            /*textView.text += "\(expitemdata["ItemLabel"]!):\(expitemdata["BefValue"]!)　　\(expitemdata["AftValue"]!)"
            textView.text += "\n"*/
            
            count += 1
        }
        
        y += 20
        SetResultLabel(x: x + 100, y: y, width: width / 2, height: height, result: befResult)

        SetResultLabel(x: x + 200, y: y, width: width / 2, height: height, result: aftResult)

        /*textView.text += "\(befResult)　　\(aftResult)"*/
    }
    
    func SetResultLabel(x:Int, y:Int, width:Int, height:Int, result:String)
    {
        let resultLabel = UILabel()
        resultLabel.frame = CGRect(x: x, y: y, width: width, height: height)
        resultLabel.text = result
        
        if result == "OK" {
            resultLabel.textColor = UIColor.blue
        } else if result == "NG" {
            resultLabel.textColor = UIColor.red
        } else if result == "Need" {
            resultLabel.text = "要"
        } else if result == "Needless" {
            resultLabel.text = "不要"
        } else if result == "Execute" {
            resultLabel.text = "実施"
        } else if result == "-" {
            resultLabel.text = "未実施"
        }
        
        view.addSubview(resultLabel)

    }
    /*func GetData() {
        //URLを生成
        let server = "http://192.168.1.9"
        let application = "WebApplication1"
        let service = "eqpapi/EqpItemSubExps"
        // Swift で日本語を含む URL を扱う　https://qiita.com/yum_fishing/items/db029c097197e6b27fba
        let _eqptype = eqptype!.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        let url = URL(string: "\(server)/\(application)/\(service)/\(_eqptype)/\(itemcode!)/\(seqnum!)")!

        //Requestを生成
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in  //非同期で通信を行う
            guard let data = data else { return }
            do {
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
            }
        }
        task.resume()
    }*/
}