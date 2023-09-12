//
//  SubjectViewController.swift
//  CombineDemo
//
//  Created by HS-jianxin on 2023/9/8.
//

import UIKit
import Combine

class SubjectViewController: UIViewController {
    
    let cm2 = CbContentManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        
        
        combineAdd()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // 方式1
//        let cm = ContentManager(delegate: self, content: .red)
//        cm.getContent()
        
        // 方式2
        let _ = cm2.content.sink {
            print("comp: \($0)")
        } receiveValue: {
            print("receive: \($0)")
            self.view.backgroundColor = $0
        }
        cm2.getContent()
        
    }
}

extension SubjectViewController: ContentManagerDelegate {
    func contentDidChange(_ content: UIColor) {
        view.backgroundColor = content
    }
    
    
}




//MARK: - 方式一 代理响应
protocol ContentManagerDelegate {
    func contentDidChange(_ content: UIColor)
}
class ContentManager: NSObject {
    var delegate: ContentManagerDelegate
    
    var content: UIColor {
        didSet {
            delegate.contentDidChange(content)
        }
    }
    
    
    init(delegate: ContentManagerDelegate, content: UIColor) {
        self.delegate = delegate
        self.content = content
    }
    
    
    func getContent() {
        content = UIColor(red: CGFloat(arc4random()%256)/255.0, green: CGFloat(arc4random()%256)/255.0, blue: CGFloat(arc4random()%256)/255.0, alpha: CGFloat(arc4random()%6)/5.0+0.5)
    }
}



//MARK: - 方式2 响应
class CbContentManager {
    var content = CurrentValueSubject<UIColor, NSError>(.orange)
    
    func getContent() {
        content.value = UIColor(red: CGFloat(arc4random()%256)/255.0, green: CGFloat(arc4random()%256)/255.0, blue: CGFloat(arc4random()%256)/255.0, alpha: CGFloat(arc4random()%6)/5.0+0.5)
        content.send(UIColor(red: CGFloat(arc4random()%256)/255.0, green: CGFloat(arc4random()%256)/255.0, blue: CGFloat(arc4random()%256)/255.0, alpha: CGFloat(arc4random()%6)/5.0+0.5))
    }
}



//MARK: - 事件
extension SubjectViewController {
    
    func combineAdd() {
        themePubliser.sink { themeColor in
            print("Thread: \(Thread.current)")
            DispatchQueue.main.async {
                self.view.backgroundColor = themeColor
            }
        }.store(in: &subscribes)
    }
}
