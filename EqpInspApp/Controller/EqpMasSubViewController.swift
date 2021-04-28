//
//  EqpMasSubViewController.swift
//  EqpInspApp
//
//  Created by Hidetatsu Miyamoto on 2021/04/07.
//

import UIKit

class EqpMasSubViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var eqpType: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    
    var resultText : String = ""
    var coupons: [[String: Any]] = [] { //パースした[String: Any]型のクーポンデータを格納するメンバ変数
        didSet{
            self.tableView.reloadData()
        }
    }
    
    var judgementCriteriaSize = CGSize(width: 123, height: 29)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        eqpType.text = "DEB_T6577"
        eqpType.text = "INSPECTRA EXⅡ"
        
        textView.text = ""
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.coupons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 動的にセルを追加する場合
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "couponCell")

        // https://qiita.com/Ajyarimochi/items/0154030bde239d703806
        // SwiftのTableViewCellを使ってTableViewを自由にカスタマイズ
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        
        //辞書型変数のcouponを定義
        let coupon = self.coupons[indexPath.row]
        
        cell.textLabel?.font = UIFont(name: "Arial", size: 20)
        cell.detailTextLabel?.font = UIFont(name: "Arial", size: 20)

        /*
        // yyyy-mm-ddThh:mm:00
        let dateTimeString:String = coupon["BirthDay"] as! String
        let dateString:String = String(dateTimeString.prefix(10))
        let date = DateUtils.dateFromString(string: dateString, format: "yyyy-MM-dd")
        let birthDay = DateUtils.stringFromDate(date: date, format: "yyyy年MM月dd日")
        
        //モデルフィールドの名前でデータを取り出し、String型にキャストしてセルに渡す
        cell.textLabel?.text = (coupon["Name"] as! String)
        cell.detailTextLabel?.text = "生年月日：" + birthDay/*(coupon["BirthDay"] as! String)*/
        */
        
        // 動的にセルを追加する場合
        //cell.textLabel?.text = coupon["ItemName"] as? String
        //cell.detailTextLabel?.text = coupon["SubItemName"] as? String
        
        (cell.viewWithTag(1) as! UILabel).text = coupon["ItemName"] as? String
        (cell.viewWithTag(2) as! UILabel).text = coupon["SubItemName"] as? String

        let judgementCriteriaLabel = cell.viewWithTag(3) as! UILabel
        judgementCriteriaLabel.text = ""
        if !(coupon["JudgementCriteria"] as? String)!.isEmpty {
            judgementCriteriaLabel.text = "(" + (coupon["JudgementCriteria"] as? String)! + ")"
        }

        let inspectionPointLabel = cell.viewWithTag(4) as! UILabel
        inspectionPointLabel.text = ""
        if !(coupon["InspectionPoint"] as? String)!.isEmpty {
            inspectionPointLabel.text = (coupon["InspectionPoint"] as? String)
            judgementCriteriaLabel.frame.size = CGSize(width: judgementCriteriaSize.width, height: judgementCriteriaSize.height)
        }
        else {
            judgementCriteriaLabel.frame.size = CGSize(width: judgementCriteriaSize.width + inspectionPointLabel.frame.width, height: judgementCriteriaSize.height)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 80
        }

    @IBAction func ButtonClick(_ sender: Any) {
        if (eqpType.text == nil) {
            return
        }
        //URLを生成
        let server = "http://\(EqpInspSingleton.shared.settings.server!)"   // 192.168.1.9
        let application = EqpInspSingleton.shared.settings.appName!
        //let service = "api/Employees"
        let service = "eqpapi/EqpInsps"
        //var parameter = eqpType.text!
        //parameter = "INSPECTRA EXⅡ".addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        // Swift で日本語を含む URL を扱う　https://qiita.com/yum_fishing/items/db029c097197e6b27fba
        let parameter = eqpType.text!.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        let url = URL(string: "\(server)/\(application)/\(service)/\(parameter)")!

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
                    self.coupons = couponData
                    //self.tableView.reloadData()
                }
            
                /* UITextView で表示する場合
                self.resultText = ""
                for item in couponData {
                    self.resultText += item["Name"] as! String
                    self.resultText += " "
                    self.resultText += item["BirthDay"] as! String
                    self.resultText += "\n"
                }
                
                // swift初心者がiOS13対応でメインスレッド以外でUI更新をしてクラッシュさせてしまった話
                // https://qiita.com/rymiyamoto/items/7ace750172b84a2ff809
                DispatchQueue.main.sync {
                    self.textView.text = self.resultText
                }
                */
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
    
    // https://softmoco.com/basics/how-to-implement-table-view-navigation.php
    // Table View からの画面遷移 (Swift)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMasSubExp" {
            if let indexPath = tableView.indexPathForSelectedRow  {
                guard let destination = segue.destination as? EqpMasSubExpViewController else {
                    fatalError("Failed to prepare DetailViewController.")
                }
                
                //destination.eqpItemSubEx.eqpType = coupons[indexPath.row]
                destination.eqptype = coupons[indexPath.row]["EqpType"] as? String
                destination.itemcode = coupons[indexPath.row]["ItemCode"] as? String
                destination.seqnum = coupons[indexPath.row]["SeqNum"] as? String
            }
        }
    }
}
