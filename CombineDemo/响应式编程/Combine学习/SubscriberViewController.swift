//
//  SubscriberViewController.swift
//  CombineDemo
//
//  Created by HS-jianxin on 2023/9/8.
//

import UIKit
import Combine

//MARK: 订阅消息者 Subscriber
class SubscriberViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        
        combineAdd()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
//        subscriberFunc() //测试发送一次数值更新
//        sinktestFunc()
        
        assignTestFunc()
    }
    
    
    
    //MARK: - Sink
    func subscriberFunc() {
        let oncePublisher = Just(100)
        let subscriber = Subscribers.Sink<Int, Never> {
            print("completed: \($0)")
        } receiveValue: { input in
            print("receive: \(input)")
        }
        oncePublisher.receive(subscriber: subscriber)
    }
    
    func sinktestFunc() {
        let _ = Just(100).sink {
            print("comp: \($0)")
        } receiveValue: {
            print("receive: \($0)")
        }
    }
    
    
    
    //MARK: - Assign
    class People {
        let name: String
        var age: Int
        
        init(name: String, age: Int) {
            self.name = name
            self.age = age
        }
    }
    func assignTestFunc() {
        let p = People(name: "allien", age: 19)
        print("I'm \(p.name), I'm \(p.age) years old.")
        let subscriber = Subscribers.Assign(object: p, keyPath: \People.age)
        let publisher = PassthroughSubject<Int, Never>()
        publisher.subscribe(subscriber)
        publisher.send(20)
        print("I'm \(p.name), I'm \(p.age) years old.")
        publisher.send(22)
        print("I'm \(p.name), I'm \(p.age) years old.")
    }

}



//MARK: - 事件
extension SubscriberViewController {
    
    func combineAdd() {
        themePubliser.sink { themeColor in
            print("Thread: \(Thread.current)")
            DispatchQueue.main.async {
                self.view.backgroundColor = themeColor
            }
        }.store(in: &subscribes)
    }
}
