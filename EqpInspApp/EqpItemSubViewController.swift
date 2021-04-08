//
//  EqpItemSubViewController.swift
//  EqpInspApp
//
//  Created by Hidetatsu Miyamoto on 2021/04/07.
//

import UIKit

class EqpItemSubViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var eqpType: UITextField!
    @IBOutlet weak var eqpID: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var interval: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    
    var resultText : String = ""
    var coupons: [[String: String]] = [] { //パースした[String: String]型のクーポンデータを格納するメンバ変数
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
        eqpID.text = "e20200403"
        date.text = "20200403"
        interval.text = "D"
        
        /*eqpType.text = "T5588+M6300_D"
        eqpID.text = "e08191000"
        date.text = "20200819"
        interval.text = "D"*/
        
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
        
        (cell.viewWithTag(1) as! UILabel).text = coupon["ItemName"]
        (cell.viewWithTag(2) as! UILabel).text = coupon["SubItemName"]

        let judgementCriteriaLabel = cell.viewWithTag(3) as! UILabel
        judgementCriteriaLabel.text = ""
        if !coupon["JudgementCriteria"]!.isEmpty {
            judgementCriteriaLabel.text = "(" + coupon["JudgementCriteria"]! + ")"
        }

        let inspectionPointLabel = cell.viewWithTag(4) as! UILabel
        inspectionPointLabel.text = ""
        if !coupon["InspectionPoint"]!.isEmpty {
            inspectionPointLabel.text = coupon["InspectionPoint"]
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
        let server = "http://192.168.1.9"
        let application = "WebApplication1"
        let service = "eqpapi/EqpInspSubLists"
        // Swift で日本語を含む URL を扱う　https://qiita.com/yum_fishing/items/db029c097197e6b27fba
        var _eqptype = eqpType.text!.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        //_eqptype = _eqptype.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let _eqpid = eqpID.text!
        let _stdate = date.text!
        let _interval = interval.text!
        let _eddate = date.text!
        let url = URL(string: "\(server)/\(application)/\(service)/\(_eqptype)/\(_eqpid)/\(_stdate)/\(_eddate)/\(_interval)")!

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
                
                let couponData = couponDataArray.map { (couponData) -> [String: String] in
                    return couponData as! [String: String]
                }
                //print(couponData[0]["Name"] as! String)
                //print(couponData[1]["Name"] as! String)

                // シングルトンにデータを格納する
                EqpInspSingleton.shared.expitemdatas = couponData
                
                /*for item in EqpInspSingleton.shared.expitemdatas {
                    _ = item["ItemName"]
                }*/
                
                var _itemcode_seqnum:[String] = []
                var _couponData:[[String:String]] = []
                
                for item in couponData {
                    let itemcode_seqnum = item["ItemCode"]! + item["SeqNum"]!
                    if _itemcode_seqnum.contains(itemcode_seqnum) {
                        continue
                    }
                    
                    _couponData.append(item)
                    _itemcode_seqnum.append(itemcode_seqnum)
                }

                DispatchQueue.main.async() { () -> Void in
                    //self.coupons = couponData
                    self.coupons = _couponData
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
            }
        }
        task.resume()
    }
    

    // Table View からの画面遷移 (Swift)
    // まず、ストーリーボードで Table View 内の AnimalTableViewCell を選択してください。
    // ⌃ Control キーを押しながら Detail View Controller にドラッグして離すと、Segue の種類を選ぶポップアップが出てきますので、Show を選択します。
    // https://softmoco.com/basics/how-to-implement-table-view-navigation.php
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showItemSubExp" {
            if let indexPath = tableView.indexPathForSelectedRow  {
                guard let destination = segue.destination as? EqpItemSubExpViewController else {
                    fatalError("Failed to prepare DetailViewController.")
                }
                
                //destination.eqpItemSubEx.eqpType = coupons[indexPath.row]
                destination.eqptype = coupons[indexPath.row]["EqpType"]
                destination.itemcode = coupons[indexPath.row]["ItemCode"]
                destination.seqnum = coupons[indexPath.row]["SeqNum"]
            }
        }
    }
}
