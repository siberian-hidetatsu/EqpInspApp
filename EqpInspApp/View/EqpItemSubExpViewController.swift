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
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*// 画面の大きさ
        let width = UIScreen.main.bounds.size.width
        print("screen width : \(width)")
        let height = UIScreen.main.bounds.size.height
        print("screen height : \(height)")

        // 実際の画面の大きさ
        let native_width = UIScreen.main.nativeBounds.size.width
        print("native width : \(native_width)")
        let native_height = UIScreen.main.nativeBounds.size.height
        print("native height : \(native_height)")

        // 拡大率
        let scale = UIScreen.main.scale
        print("scale : \(scale)")
        let native_scale = UIScreen.main.nativeScale
        print("native scale : \(native_scale)")*/
        
        // Do any additional setup after loading the view.
        GetData()
    }
    
    func GetData() {
        // 【徹底解説】UIScrollViewクラス　その1
        // https://qiita.com/ynakaDream/items/960899183c38949c2ab0
        // contentsViewを作る
        let contentsView = UIView()
        //contentsView.frame = CGRect(x: 0, y: 0, width: 800, height: 1200)

        let x = 10, width = 200, height = 20
        var y = 100
        
        textView.text = ""

        for eqpInspItem in EqpInspSingleton.shared.eqpInspItems {
            if eqpInspItem.ItemCode != itemcode {
                continue
            }
            
            for eqpInspSubItem in eqpInspItem.EqpInspSubItems {
                if eqpInspSubItem.SeqNum != seqnum {
                    continue
                }
                
                let itemNameLabel = UILabel()
                itemNameLabel.frame = CGRect(x: x, y: y, width: Int(view.frame.width) - 20, height: height)
                itemNameLabel.text = eqpInspItem.ItemName
                itemNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
                contentsView.addSubview(itemNameLabel)
                y += 20
                
                let subItemNameLabel = UILabel()
                subItemNameLabel.frame = CGRect(x: x, y: y, width: Int(view.frame.width) - 20, height: height)
                subItemNameLabel.text = eqpInspSubItem.SubItemName
                contentsView.addSubview(subItemNameLabel)
                y += 20
                
                let judgementCriteriaLabel = UILabel()
                judgementCriteriaLabel.frame = CGRect(x: x, y: y, width: Int(view.frame.width) - 20, height: height)
                judgementCriteriaLabel.text = eqpInspSubItem.JudgementCriteria
                contentsView.addSubview(judgementCriteriaLabel)
                y += 20
                
                let inspectionPointLabel = UILabel()
                inspectionPointLabel.frame = CGRect(x: x, y: y, width: Int(view.frame.width) - 20, height: height)
                inspectionPointLabel.text = eqpInspSubItem.InspectionPoint
                inspectionPointLabel.textColor = UIColor.blue
                contentsView.addSubview(inspectionPointLabel)
                y += 20

                if !inspectionPointLabel.text!.isEmpty {
                    y += 20
                }
                
                if !eqpInspSubItem.SubItemImg.isEmpty {
                    let imageData = NSData(base64Encoded: eqpInspSubItem.SubItemImg)
                    let image = UIImage(data: imageData! as Data)
                    let subItemImg = UIImageView()
                    subItemImg.image = resize(image: image!, width: 300)
                    subItemImg.sizeToFit()
                    subItemImg.frame = CGRect(x: 0, y: CGFloat(y), width: subItemImg.image!.size.width, height: subItemImg.image!.size.height)
                    contentsView.addSubview(subItemImg)
                    
                    y += (Int(subItemImg.image!.size.height) + 20)
                }
                
                let befTitleLabel = UILabel()
                befTitleLabel.frame = CGRect(x: x + 100, y: y, width: width / 2, height: height)
                befTitleLabel.text = eqpInspSubItem.BefTitle
                contentsView.addSubview(befTitleLabel)
                
                let aftTitleLabel = UILabel()
                aftTitleLabel.frame = CGRect(x: x + 210, y: y, width: width / 2, height: height)
                aftTitleLabel.text = eqpInspSubItem.AftTitle
                contentsView.addSubview(aftTitleLabel)
                y += 21

                for eqpInspSubExpItem in eqpInspSubItem.EqpInspSubExpItems {
                    let itemLabelLabel = UILabel()
                    itemLabelLabel.frame = CGRect(x: x, y: y, width: width / 2, height: height)
                    itemLabelLabel.text = eqpInspSubExpItem.ItemLabel
                    contentsView.addSubview(itemLabelLabel)
            
                    let befValueLabel = UILabel()
                    befValueLabel.frame = CGRect(x: x + 100, y: y, width: width / 2, height: height)
                    befValueLabel.text = eqpInspSubExpItem.BefValue
                    befValueLabel.layer.borderWidth = 1
                    befValueLabel.layer.borderColor = UIColor.lightGray.cgColor
                    contentsView.addSubview(befValueLabel)
            
                    let aftValueLabel = UILabel()
                    aftValueLabel.frame = CGRect(x: x + 210, y: y, width: width / 2, height: height)
                    aftValueLabel.text = eqpInspSubExpItem.AftValue
                    aftValueLabel.layer.borderWidth = 1
                    aftValueLabel.layer.borderColor = UIColor.lightGray.cgColor
                    contentsView.addSubview(aftValueLabel)
                    y += 21
                }
        
                SetResultLabel(view: contentsView, x: x + 100, y: y, width: width / 2, height: height, result: eqpInspSubItem.BefResult)
                SetResultLabel(view: contentsView, x: x + 210, y: y, width: width / 2, height: height, result: eqpInspSubItem.AftResult)
                y += 21
            }
        }
        
        // scrollViewにcontentsViewを配置させる
        var contentsHeight = y
        let screen_height = UIScreen.main.bounds.size.height
        print("screen : \(UIScreen.main.bounds.size)")
        if CGFloat(contentsHeight) > screen_height {
            contentsHeight += 150
        }
        contentsView.frame = CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width), height: contentsHeight)
        scrollView.addSubview(contentsView)

        // scrollViewにcontentsViewのサイズを教える
        scrollView.contentSize = contentsView.frame.size
        //scrollView.contentOffset = CGPoint(x: 0,y: 0)
        
        // iOS11 で UIScrollView の contentInsetがずれる問題
        // https://qiita.com/peka2/items/b6301a0c06cc13286296
        scrollView.contentInsetAdjustmentBehavior = .never
    }
    
    // UIImageをアスペクト比をそのままにリサイズする
    // https://program-life.com/497
    func resize(image: UIImage, width: Double) -> UIImage {
            
        // オリジナル画像のサイズからアスペクト比を計算
        let aspectScale = image.size.height / image.size.width
        
        // widthからアスペクト比を元にリサイズ後のサイズを取得
        let resizedSize = CGSize(width: width, height: width * Double(aspectScale))
        
        // リサイズ後のUIImageを生成して返却
        UIGraphicsBeginImageContext(resizedSize)
        image.draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage!
    }
    
    /* 受信データが階層化されてない場合
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
    }*/

    func SetResultLabel(view:UIView, x:Int, y:Int, width:Int, height:Int, result:String)
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
