//
//  TextFiledViewController.swift
//  CombineDemo
//
//  Created by HS-jianxin on 2023/9/4.
//

import UIKit
import Combine

//MARK:  输入框响应式编程
// - 实现功能：当输入框文案内容改变时，label文本跟随变化
class TextFiledViewController: UIViewController {
    
    var cancelLabels = Set<AnyCancellable>()
    var publisher = PassthroughSubject<String?, Never>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldInput()
        
        combineAdd()
    }

    
    func textFieldInput() {
        view.backgroundColor = .cyan
        
        let tf = UITextField(frame: CGRectMake(10, 100, 200, 40))
        tf.placeholder = "请输入"
        tf.delegate = self
        view.addSubview(tf)
        
        let label = UILabel(frame: CGRectMake(10, 150, 200, 40))
        label.textColor = .red
        label.text = "here"
        view.addSubview(label)
        
        // 创建一个订阅者，打印文本输入内容
        let tfSubscriber = Subscribers.Assign(object: label, keyPath: \.text)
        
        // 文本变化时发布消息
        publisher.receive(subscriber: tfSubscriber)
        
    }
    
    
    
}


//MARK: - 事件
extension TextFiledViewController {
    
    func combineAdd() {
        themePubliser.sink { themeColor in
            print("Thread: \(Thread.current)")
            DispatchQueue.main.async {
                self.view.backgroundColor = themeColor
            }
        }.store(in: &subscribes)
    }
}


extension TextFiledViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        publisher.send(textField.text ?? "")
        
        return true
    }
    
}
