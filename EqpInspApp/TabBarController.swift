//
//  TabBarController.swift
//  EqpInspApp
//
//  Created by Hidetatsu Miyamoto on 2021/04/07.
//

import UIKit
// UITabTBarControllerでのタブの切り替え、UINavigationControllerを用いた画面遷移
// https://love-and-geek.caraquri.com/ios-tab-and-nav-screen-transition/

// tabBarControllerとUINavigationControllerを同時に使いたい！
// https://grandbig.github.io/blog/2016/01/17/tabbarcontroller/

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // 【Swift】UITabBarControllerでアプリ起動時に指定したタブを表示する
        // https://qiita.com/6bar10/items/14f88679bea2a1fe7cdf
        selectedIndex = 1
        
        tabBar.items![0].title = "マスタ"
        tabBar.items![1].title = "履歴"
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
