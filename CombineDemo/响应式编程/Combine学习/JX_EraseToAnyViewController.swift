//
//  JX_EraseToAnyViewController.swift
//  CombineDemo
//
//  Created by HS-jianxin on 2023/9/12.
//

import UIKit
import Combine

class JX_EraseToAnyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        eraseFunc()
    }
    
    
    // 测试擦除类型
    func eraseFunc() {
//        let publisher = Just("Hello")
//            .delay(for: 2, scheduler: DispatchQueue.main)
//            .eraseToAnyPublisher()
        let publisher = ["1","2","4","8","99","7"].publisher.eraseToAnyPublisher()
        
        let subscriber = Subscribers.Sink<String, Never> { completion in
            print("completion: \(completion)")
        } receiveValue: { input in
            print("receive: \(input)")
            print(input)
        }

        publisher.receive(subscriber: subscriber)
    }
}
