//
//  EqpItemSubViewController.swift
//  EqpInspApp
//
//  Created by Hidetatsu Miyamoto on 2021/04/07.
//

import UIKit

struct EqpInspSubItemCellData {
    var EqpType:String?
    var ItemCode:String?
    //var ItemName:String?
    var SeqNum:String?
    var SubItemName:String?
    var JudgementCriteria:String?
    var InspectionPoint:String?
}

class EqpItemSubViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var eqpType: UITextField!
    @IBOutlet weak var eqpID: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var interval: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    // UITextField の入力に pickerView を設定する方法
    // https://hawksnowlog.blogspot.com/2019/11/use-pickerview-as-keyboard-on-textfield.html
    var pickerView = UIPickerView()
    var eqpTypeArray = ["Orange", "Grape", "Banana"]/*[String]()*/

    var resultText : String = ""
    
    /* セクションを使用しない場合
    var coupons: [[String: String]] = [] { //パースした[String: String]型のクーポンデータを格納するメンバ変数
        didSet{
            self.tableView.reloadData()
        }
    }*/
    
    // 【Swift】複数の section がある tableView で二次元配列を使う。
    // https://qiita.com/BMJr/items/ca7bcf76d36acbdef75e
    var mySections: [String] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var twoDimArray = [[EqpInspSubItemCellData]]()
    
    var judgementCriteriaSize = CGSize(width: 123, height: 29)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        eqpType.text = "DEB_T6577"
        eqpID.text = "e20200403"
        date.text = "20200403"
        //eqpID.text = "e20062415"
        //date.text = "20200624"
        interval.text = "D"
        
        /*eqpType.text = "T5588+M6300_D"
        eqpID.text = "e08191000"
        date.text = "20200819"
        interval.text = "D"*/
        
        textView.text = ""
        
        //【Swift】 UITextFieldに文字数制限を設ける方法
        // https://qiita.com/ydzum1123/items/3578a886c70dc23f121c
        // date の入力チェックをオブザーバ登録
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(notification:)), name: UITextField.textDidChangeNotification, object: date)
        
        createPickerView()
        
        indicator.center = self.view.center
    }
    
    //MARK:- 日付のオブザーバ
    // オブザーバの破棄
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func textFieldDidChange(notification: NSNotification) {
        let textField = notification.object as! UITextField
        
        if let text = textField.text {
            print(text.count)
            if text.count == 8 {
                indicator.startAnimating()
                
                //URLを生成
                let server = "http://192.168.1.9"
                let application = "WebApplication1"
                let service = "eqpapi/EqpTypeIds"
                let _stdate = date.text!
                let _interval = interval.text!
                let url = URL(string: "\(server)/\(application)/\(service)/\(_stdate)/\(_interval)")!

                //Requestを生成
                let request = URLRequest(url: url)
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in  //非同期で通信を行う
                    guard let data = data else { return }
                    do {
                        print(data)
                        
                        var eqpTypeIds:[EqpInsp.EqpTypeId] = []
                        
                        do {
                            eqpTypeIds = try JSONDecoder().decode([EqpInsp.EqpTypeId].self, from: data)
                            print(eqpTypeIds)
                        /*} catch let error as NSError {
                            print("【エラーが発生しました : \(error)】")
                        }*/
                        } catch {
                            print(error.localizedDescription)
                            throw NSError(domain: error.localizedDescription, code: -1, userInfo: nil)
                        }
                        
                        self.eqpTypeArray = []
                        self.eqpTypeArray.append("選択してください")

                        for eqpTypeId in eqpTypeIds {
                            let value = eqpTypeId.EqpType + ":" + eqpTypeId.EqpId
                            self.eqpTypeArray.append(value)
                        }
                        
                        DispatchQueue.main.async() { () -> Void in
                            self.pickerView.selectRow(0, inComponent: 0, animated: false)
                            self.eqpType.text = self.eqpTypeArray[0]
                            self.indicator.stopAnimating()
                        }
                    } catch let error {
                        print(error)
                    }
                }
                task.resume()
            }
        }
    }
    
    //MARK:- UIPickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //print("pickerViewCount:\(eqpTypeArray.count)")
        return eqpTypeArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //print("picerViewRow:\(eqpTypeArray[row])")
        return eqpTypeArray[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row != 0 {
            //eqpType.text = eqpTypeArray[row]
            //result.text = data[row]
            let eqpTypeId:[String] = eqpTypeArray[row].components(separatedBy: ":")
            eqpType.text = eqpTypeId[0]
            eqpID.text = eqpTypeId[1]
        }
    }
    
    func createPickerView() {
        pickerView.delegate = self
        eqpType.inputView = pickerView
        // toolbar
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePicker))
        toolbar.setItems([doneButtonItem], animated: true)
        eqpType.inputAccessoryView = toolbar
    }

    @objc func donePicker() {
        eqpType.endEditing(true)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        eqpType.endEditing(true)
    }
    
    //MARK:- UITableView
    func numberOfSections(in tableView: UITableView) -> Int {
        /*return 1*/
        return mySections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*return self.coupons.count*/
        return twoDimArray[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mySections[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 動的にセルを追加する場合
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "couponCell")

        // https://qiita.com/Ajyarimochi/items/0154030bde239d703806
        // SwiftのTableViewCellを使ってTableViewを自由にカスタマイズ
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        
        /*//辞書型変数のcouponを定義
        let coupon = self.coupons[indexPath.row]*/
        
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
        
        /* セクションを使用しない場合
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
        }*/
        
        let eqpInspSubItemCellData:EqpInspSubItemCellData = twoDimArray[indexPath.section][indexPath.row]
        
        (cell.viewWithTag(1) as! UILabel).isHidden = true
        
        let subItemNameLabel = cell.viewWithTag(2) as! UILabel
        subItemNameLabel.text = eqpInspSubItemCellData.SubItemName
        subItemNameLabel.frame = CGRect(x: subItemNameLabel.frame.origin.x, y: 12, width: subItemNameLabel.frame.width, height: subItemNameLabel.frame.height)

        let judgementCriteriaLabel = cell.viewWithTag(3) as! UILabel
        judgementCriteriaLabel.frame = CGRect(x: judgementCriteriaLabel.frame.origin.x, y: 38, width: judgementCriteriaLabel.frame.width, height: judgementCriteriaLabel.frame.height)
        judgementCriteriaLabel.text = ""
        if !eqpInspSubItemCellData.JudgementCriteria!.isEmpty {
            judgementCriteriaLabel.text = "(" + eqpInspSubItemCellData.JudgementCriteria! + ")"
        }

        let inspectionPointLabel = cell.viewWithTag(4) as! UILabel
        inspectionPointLabel.frame = CGRect(x: inspectionPointLabel.frame.origin.x, y: 38, width: inspectionPointLabel.frame.width, height: inspectionPointLabel.frame.height)
        inspectionPointLabel.text = ""
        if !eqpInspSubItemCellData.InspectionPoint!.isEmpty {
            inspectionPointLabel.text = eqpInspSubItemCellData.InspectionPoint
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

    //MARK:-
    @IBAction func ButtonClick(_ sender: Any) {
        if (eqpType.text == nil) {
            return
        }

        eqpType.endEditing(true)

        indicator.startAnimating()
        
        //URLを生成
        let server = "http://192.168.1.9"
        let application = "WebApplication1"
        let service = "eqpapi/EqpInspSubLists"
        // Swift で日本語を含む URL を扱う　https://qiita.com/yum_fishing/items/db029c097197e6b27fba
        //let _eqptype = eqpType.text!.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        let _eqptype = eqpType.text!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
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
                
                /* json の読み込み確認
                // Codableを使ったJSONのパース
                // https://teratail.com/questions/141524
                let jsonString = """
                [{
                "EqpInspSubItems":
                  [{"EqpInspSubExpItems":
                    [{"ExpSeqNum":"1","ItemLabel":"値1","BefValue":"","AftValue":""}
                    ],
                    "SeqNum":"1",
                    "SubItemName":"温度",
                    "JudgementCriteria":"25℃ ± 5℃",
                    "InspectionPoint":"",
                    "BefTitle":"-hidden-",
                    "AftTitle":"調整後",
                    "BefResult":"",
                    "AftResult":"-"}
                  ],
                  "EqpType":"DEB_T6577",
                  "ItemCode":"00102",
                  "ItemName":"設置環境・測定結果"
                }]
                """

                let jsonData = jsonString.data(using: .utf8)!

                do {
                    let ss = try JSONDecoder().decode([EqpInsp.EqpInspItem].self, from: jsonData)
                    print(ss)
                    
                } catch {
                    print(error.localizedDescription)
                }
                */
                
                var eqpInspItems:[EqpInsp.EqpInspItem] = []
                
                do {
                    eqpInspItems = try JSONDecoder().decode([EqpInsp.EqpInspItem].self, from: data)
                    print(eqpInspItems)
                /*} catch let error as NSError {
                    print("【エラーが発生しました : \(error)】")
                }*/
                } catch {
                    print(error.localizedDescription)
                    throw NSError(domain: error.localizedDescription, code: -1, userInfo: nil)
                }

                // シングルトンにデータを格納する
                EqpInspSingleton.shared.eqpInspItems = eqpInspItems

                /* セクションを使用しない場合
                var _couponData:[[String:String]] = []
                
                for eqpInspItem in eqpInspItems {
                    for eqpInspSubItem in eqpInspItem.EqpInspSubItems {
                        var item:[String:String]
                        item = [
                            "EqpType":"\(eqpInspItem.EqpType)",
                            "ItemCode":"\(eqpInspItem.ItemCode)",
                            "ItemName":"\(eqpInspItem.ItemName)",
                            "SeqNum":"\(eqpInspSubItem.SeqNum)",
                            "SubItemName":"\(eqpInspSubItem.SubItemName)",
                            "JudgementCriteria":"\(eqpInspSubItem.JudgementCriteria)",
                            "InspectionPoint":"\(eqpInspSubItem.InspectionPoint)"
                        ]
                        
                        _couponData.append(item)
                    }
                }*/
                
                var _mySections:[String] = []
                self.twoDimArray = [[EqpInspSubItemCellData]]()
                
                for eqpInspItem in eqpInspItems {
                    _mySections.append(eqpInspItem.ItemName)
                    
                    // Swiftで多次元配列を使う場合
                    // https://qiita.com/sassywind/items/9282b63f51d85f58c3e5
                    self.twoDimArray.append([EqpInspSubItemCellData]())
                    
                    for eqpInspSubItem in eqpInspItem.EqpInspSubItems {
                        var eqpInspSubItemCellData = EqpInspSubItemCellData()
                        eqpInspSubItemCellData.EqpType = eqpInspItem.EqpType
                        eqpInspSubItemCellData.ItemCode = eqpInspItem.ItemCode
                        eqpInspSubItemCellData.SeqNum = eqpInspSubItem.SeqNum
                        eqpInspSubItemCellData.SubItemName = eqpInspSubItem.SubItemName
                        eqpInspSubItemCellData.JudgementCriteria  = eqpInspSubItem.JudgementCriteria
                        eqpInspSubItemCellData.InspectionPoint = eqpInspSubItem.InspectionPoint
                        
                        self.twoDimArray[_mySections.count - 1].append(eqpInspSubItemCellData)
                    }
                }
                
                DispatchQueue.main.async() { () -> Void in
                    //self.coupons = couponData
                    /*self.coupons = _couponData*/
                    //self.tableView.reloadData()
                    
                    //self.mySections = []
                    //self.tableView.reloadData()
                    
                    self.mySections = _mySections
                    
                    self.indicator.stopAnimating()
                }
                
                /* 受信データが階層化されてない場合
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
                */
                
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
                
                /* セクションを使用しない場合
                //destination.eqpItemSubEx.eqpType = coupons[indexPath.row]
                destination.eqptype = coupons[indexPath.row]["EqpType"]
                destination.itemcode = coupons[indexPath.row]["ItemCode"]
                destination.seqnum = coupons[indexPath.row]["SeqNum"]*/
                
                destination.eqptype = twoDimArray[indexPath.section][indexPath.row].EqpType
                destination.itemcode = twoDimArray[indexPath.section][indexPath.row].ItemCode
                destination.seqnum = twoDimArray[indexPath.section][indexPath.row].SeqNum
            }
        }
    }
}
