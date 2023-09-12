//
//  UIZJLAnimationLab.swift
//  CombineDemo
//
//  Created by HS-jianxin on 2023/9/5.
//

import UIKit

class UIZJLAnimationLab: UILabel {

    //计时器
    var timer: CADisplayLink!
    
    var progress: TimeInterval!
    
    var lastupdate: TimeInterval!
    
    var totalupdate: TimeInterval!
    
    
    var startValue: Float!
    var endValue: Float!
    
    // 增长类型
    var type: ZJLAnimationType!
    
    var newText: String {
        get {
            return updateNewinfo()
        }
    }
    
    init(frame: CGRect, type: ZJLAnimationType) {
        super.init(frame: frame)
        self.type = type
    }
    
    func initCadisplayLink() {
        progress = 0
        timer = CADisplayLink(target: self, selector: #selector(UIZJLAnimationLab.timerclick(sender:)))
        timer.add(to: .current, forMode: .default)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    @objc func timerclick(sender: CADisplayLink) {
        let now: TimeInterval = Date.timeIntervalSinceReferenceDate
        progress = now - lastupdate
        if (now - lastupdate) >= totalupdate {
            progress = totalupdate
            stopLoop()
        }
        let text = newText
        self.text = text
    }
    
    func updateNewinfo() -> String {
        let timebi: Float = Float(progress) / Float(totalupdate)
        let updateValue = startValue + (timebi * (self.endValue - self.startValue))
        if type == .FLOAT {
            return String(format: "%.2f", updateValue)
        }
        return String(format: "%.0f", updateValue)
    }
    
    func countFrom(start: Float, to: Float, duration: TimeInterval) {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        initCadisplayLink()
        
        //记录时间戳
        lastupdate = Date.timeIntervalSinceReferenceDate
        //耗时
        totalupdate = duration
        
        startValue = start
        endValue = to
    }
    
    // 销毁
    func stopLoop() {
        timer.invalidate()
        timer = nil
    }
}

enum ZJLAnimationType {
    case INT
    case FLOAT
}
