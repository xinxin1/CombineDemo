//
//  ScrollNumberViewController.swift
//  CombineDemo
//
//  Created by HS-jianxin on 2023/9/5.
//

import UIKit

class ScrollNumberViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        view.addSubview(self.scrollLab)
    }
    

    
    private lazy var scrollLab : JXScrollNumberLabel = {
        let temp = JXScrollNumberLabel.init(originNumber: 0, font: UIFont.systemFont(ofSize: 14, weight: .bold), textColor: .mainColorBlack())
        temp.frame = CGRect(x: 10, y: 100, width: 40, height: 30)
        return temp
    
    }()
    
    ////数字改变
    public func changeNumber(_ addNum : Int32) -> Void {
        self.scrollLab.displayerNumber = 28
        self.scrollLab.changeToNumber(number: 14, interval: 0.5, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        changeNumber(16)
    }

}
