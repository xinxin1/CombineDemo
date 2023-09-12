//
//  PublisherViewController.swift
//  CombineDemo
//
//  Created by HS-jianxin on 2023/9/7.
//

import UIKit
import Combine

//MARK: Publisher发布者 测试
class PublisherViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .cyan
        
        combineAdd()
    }
    

    //MARK: - Just
    func justFunc() {
        // 只发送一次消息
        let justPublisher = Just("一次消息")
        
        // 延迟2秒发布消息
        let delyPublisher = justPublisher.delay(for: 2, scheduler: DispatchQueue.main)
    }
    
    
    
    //MARK: - Empty
    func emptyFunc() {
        // 只发送一次消息，不带任何信息
        let emptyPublisher = Empty(completeImmediately: true, outputType: (Any).self, failureType: Never.self)
        let emptyPublisher2 = Empty<Any, Never>(completeImmediately: false)
    }
    
    
    //MARK: - Once
    func onceFunc() {
        // 没找到对应API，可能已经消失🫤
    }
    
    
    //MARK: - Fail
    func failFunc() {
        let failPublisher = Fail(outputType: Any.self, failure: NetWorkError.message("我是错误", nil))
    }
    
    
    //MARK: - Sequence
    func sequenceFunc() {
        // 将给定的序列按序通知
        let sequencePublisher = [1, 2, 3].publisher
    }
    
    
    //MARK: - Future
    func FutureFunc() {
        // 可以异步返回
        let future = Future<Data?, Never> { promise in
            URLSession.shared.dataTask(with: URL(string: "https://api")!) { data, response, error in
                promise(.success(data))
            }.resume()
        }
    }
    
    
    //MARK: Deferred
    // deferred初始化需要提供一个closure，只有在Subscriber订阅的时候才会生成指定的Publisher，并且每个Subscriber获取到的Publisher都是全新的
    func deferredFunc() {
        let deferredPublisher = Deferred {
            return Just(arc4random())
        }
    }

}



//MARK: - 事件
extension PublisherViewController {
    
    func combineAdd() {
        themePubliser.sink { themeColor in
            print("Thread: \(Thread.current)")
            DispatchQueue.main.async {
                self.view.backgroundColor = themeColor
            }
        }.store(in: &subscribes)
    }
}



//MARK: 定义错误
enum NetWorkError: Error, Equatable {
    case message(String, Any?)
    case noNetWork
    
    static func == (lhs: NetWorkError, rhs: NetWorkError) -> Bool {
        lhs.errorDescription == rhs.errorDescription
    }
}
extension NetWorkError: LocalizedError {
    var errorDescription: String? {
        return "\(self)"
    }
}

        

