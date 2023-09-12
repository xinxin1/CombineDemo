//
//  JX_CancellableViewController.swift
//  CombineDemo
//
//  Created by HS-jianxin on 2023/9/12.
//

import UIKit
import Combine

class JX_CancellableViewController: UIViewController {
    
    /// combine订阅集合
    var subscriptions = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        cancellableFunc()
    }
    

    func cancellableFunc() {
        let publisher = Future<Any, Never> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                promise(.success("执行成功"))
            }
        }
        
        let cancellable = publisher.sink { completion in
            print("completion: \(completion)")
        } receiveValue: { receive in
            print("receive: \(receive)")
        }
        cancellable.store(in: &subscriptions) //长久持有
            
        
        cancellable.cancel()
    }

}
