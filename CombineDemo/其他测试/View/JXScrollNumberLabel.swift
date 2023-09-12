//
//  JXScrollNumberLabel.swift
//  CombineDemo
//
//  Created by HS-jianxin on 2023/9/5.
//

import UIKit

/// 滚动方向
enum ScrollAnimationDirection: Int {
    case Up = 0
    case Down = 1
    case Number = 2
}

class JXScrollNumberLabel: UIView {

    public var displayerNumber : Int32 = 0
    
    /*tip:* 通用1-4：是动态frame，无需设置frame，动态创建位数;* 通用5-7：是限定位数，是以位数限定数值最大值;* 通用8-9：是更新数值，设定动画时间等;*/
    /** 以下动态设置位数 **/
    /**通用1
     @param originNumber 数值
     @param size 字体大小
     @return return value description*/
    public init(originNumber : Int32 , fontSize : CGFloat) {
        super.init(frame: CGRect.zero)
        self.initData(originNumber, fontSize, .mainColorBlack(), 0)
    }
    
    /**通用2
     @param originNumber 数值
     @param size 字体大小
     @param color 字体颜色
     @return return value description*/
    public init(originNumber : Int32 , fontSize : CGFloat , textColor : UIColor) {
        super.init(frame: CGRect.zero)
        self.initData(originNumber, fontSize, textColor, 0)
    }
    
    /**通用3
     @param originNumber 数值
     @param font 字体font
     @return return value description*/
    public init(originNumber : Int32,font : UIFont) {
        super.init(frame: CGRect.zero)
        self.initData(originNumber, font, .mainColorBlack(), 0)
    }
    
    /**通用4
     @param originNumber 数值
     @param font 字体font
     @param color 字体颜色
     @return return value description*/
    public init(originNumber : Int32,font : UIFont,textColor : UIColor) {
        super.init(frame: CGRect.zero)
        self.initData(originNumber, font, textColor, 0)
    }
    
    /** 以下限定位数 **/
    /**通用5
     @param originNumber 数值
     @param size 字体大小
     @param rowNumber 位数
     @return return value description*/
    public init(originNumber : Int32 , fontSize : CGFloat , rowNumber : Int) {
        super.init(frame: CGRect.zero)
        self.initData(originNumber, fontSize, .mainColorBlack(), rowNumber)
    }
    
    /**通用6
     @param originNumber 数值
     @param size 字体大小
     @param color 字体颜色
     @param rowNumber 位数
     @return return value description*/
    public init(originNumber : Int32 , fontSize : CGFloat ,textColor : UIColor , rowNumber : Int) {
        super.init(frame: CGRect.zero)
        self.initData(originNumber, fontSize, textColor, 0)
    }
    
    /**通用7
     @param originNumber 数值
     @param font 字体设置
     @param color 字体颜色
     @param rowNumber 位数
     @return return value description*/
    public init(originNumber : Int32 , font : UIFont ,textColor : UIColor , rowNumber : Int) {
        super.init(frame: CGRect.zero)
        self.initData(originNumber, font, textColor, rowNumber)
    }
    
    /** 以下是更新数值 **/
    /**通用8
     @param number 数值+、-量
     @param animated animated description*/
    public func changeToNumber(number : Int32 , animated : Bool) -> Void {
        self.changeToNumber(number, 0, animated)
    }
    
    /**通用9
     @param number 数值+、-量
     @param interval 动画时间设置
     @param animated animated description*/
    public func changeToNumber(number : Int32 , interval : CGFloat , animated : Bool) -> Void {
        self.changeToNumber(number, interval, animated)
    }
    
    // Attribute Key
    private let keyRepeatCount : String = "repeatCount"
    private let keyStartDuration : String = "startDuration"
    private let keyCycleDuration : String = "cycleDuration"
    private let keyEndDuration : String = "endDuration"
    private let keyScrollCell : String = "scrollCell"
    private let keyDisplayNumber : String = "displayNumber"
    private let keyStartDelay : String = "startDelay"
    // Task Key
    private let keyTaskDisplayNumber : String = "displayNumber"
    private let keyTaskChangeNumber : String = "changeNumber"
    private let keyTaskInterval : String = "interval"
    private let normalModulus : CGFloat = 0.3
    private let bufferModulus : CGFloat = 0.7
    private var cellArray : [UILabel] = Array.init()
    private var fontSize : CGFloat = 0.0
    private var rowNumber : Int = 0
    private var taskArray : [Dictionary<String,CGFloat>] = Array.init()
    private var isAnimation : Bool = true
    private var cellWidth : CGFloat = 0.0
    private var cellHeight : CGFloat = 0.0
    private var finishedAnimationCount : Int = 1
    private var maxRowNumber : Int = 0
    private var textColor : UIColor = UIColor.mainColorBlack()
    private var font : UIFont = UIFont.systemFont(ofSize: 16, weight: .bold)
    
    private func initData(_ originNumber : Int32 , _ fontSize : CGFloat , _ textColor : UIColor , _ rowNumber : Int) -> Void {
        self.displayerNumber = originNumber
        self.font = UIFont.systemFont(ofSize: fontSize)
        self.textColor = textColor
        self.isAnimation = false
        self.finishedAnimationCount = 0
        self.rowNumber = (rowNumber > 0 && rowNumber <= 15) ? rowNumber : 0
        self.maxRowNumber = (self.rowNumber == 0) ? 15 : rowNumber
        self.commonInit()
    }
    
    private func initData(_ originNumber : Int32 , _ font : UIFont , _ textColor : UIColor , _ rowNumber : Int) -> Void {
        self.displayerNumber = originNumber
        self.font = font
        self.textColor = textColor
        self.isAnimation = false
        finishedAnimationCount = 0
        self.rowNumber = (rowNumber > 0 && rowNumber <= 15) ? rowNumber : 0
        self.maxRowNumber = (
        self.rowNumber == 0) ? 15 : rowNumber
        self.commonInit()
    }
    
    private func commonInit() -> Void {
        self.initCell()
        self.initParent()
        
    }
    
    private func initCell() -> Void {
        let originNumber = Int(
        self.displayerNumber)
        if self.rowNumber == 0 {
            self.rowNumber =
            self.calculateRowNumber(originNumber)
        }
        let text : String = "0\n1\n2\n3\n4\n5\n6\n7\n8\n9\n0"
        let rect = text.boundingRect(with: CGSize.zero, options: .usesLineFragmentOrigin, attributes: [.font : self.font], context: nil)
        self.cellWidth = rect.size.width
        self.cellHeight = rect.size.height
            let displayNumberArray : [Int32] =
        self.getCellDisplayNumberWithNumber(self.displayerNumber)
        for (index , temp) in displayNumberArray.enumerated() {
            let scrollCell : UILabel = self.makeScrollCell()
            scrollCell.frame = CGRectMake(CGFloat((self.rowNumber - 1 - index)) * self.cellWidth, 0, self.cellWidth, self.cellHeight)
            scrollCell.text = text
            self.setScollCell(scrollCell, Int(temp))
            self.cellArray.append(scrollCell)
        }
    }
    
    private func reInitCell(_ rowNumber : Int) -> Void {
        let text : String = "0\n1\n2\n3\n4\n5\n6\n7\n8\n9\n0"
        if rowNumber > self.rowNumber {
            for i in self.rowNumber..<rowNumber {
                let scrollCell = self.makeScrollCell()
                scrollCell.frame = CGRect.init(x: CGFloat((self.rowNumber - 1 - i)) * self.cellWidth, y: 0, width: self.cellWidth, height: self.cellHeight)
                scrollCell.text = text
                self.cellArray.append(scrollCell)
            }
        } else {
            for _ in rowNumber..<self.rowNumber {
                self.cellArray.removeLast()
                
            }
            
        }
        
    }
    
    private func initParent() -> Void {
        self.bounds = CGRect(x: 0, y: 0, width: CGFloat(self.rowNumber) * self.cellWidth, height: self.cellHeight / 11)
        self.backgroundColor = .clear
        self.layer.masksToBounds = true
        self.layoutCell(self.rowNumber, true)
        
    }
    
    private func calculateRowNumber(_ number : Int) -> Int {
        var rowNumber : Int = 1
        var chagneNumber : Int = number
        while (chagneNumber / 10) != 0 {
            chagneNumber = chagneNumber / 10
            rowNumber += 1
        }
        return rowNumber
        
    }
    
    private func getCellDisplayNumberWithNumber(_ number : Int32) -> Array<Int32> {
        var displayCellNumbers : [Int32] = Array.init()
        var tmpNumber : Int = 0
        var displayNumber = number
        for _ in 0..<self.rowNumber {
            tmpNumber = Int(displayNumber % 10)
            displayCellNumbers.append(Int32(tmpNumber))
            displayNumber = displayNumber / 10
            
        }
        return displayCellNumbers
        
    }
    
    private func setScollCell(_ cell : UILabel , _ number : Int) -> Void {
        var originX : CGFloat = cell.frame.origin.x
        var floatNumber : CGFloat = CGFloat(number)
        let y : CGFloat = -(CGFloat(floatNumber) / 11) * self.cellHeight
        cell.frame = CGRectMake(originX, y, self.cellWidth, self.cellHeight)
        
    }
    
    private func layoutCell(_ roWNumber : Int , _ animated : Bool) -> Void {
        self.subviews.forEach{
            $0.removeFromSuperview()
            
        }
        self.cellArray.forEach{
            self.addSubview($0)
            
        }
        guard roWNumber != self.rowNumber else {
            return
            
        }
        
        UIView.animate(withDuration: 0.2 * Double((roWNumber - self.rowNumber))) {
            for (index , temp) in self.cellArray.enumerated() {
                temp.frame = CGRect.init(x: CGFloat((roWNumber - 1 - index)) * self.cellWidth, y: temp.frame.origin.y, width: self.cellWidth, height: self.cellHeight)
                
            }
            self.frame = CGRect.init(x: self.frame.origin.x, y: self.frame.origin.y, width: CGFloat(roWNumber) * self.cellWidth, height: self.cellHeight / 11)
            
        }
        
    }
    
    private func makeScrollCell() -> UILabel {
        let cell : UILabel = UILabel.init()
        cell.font = self.font
        cell.numberOfLines = 11
        cell.textColor = self.textColor
        cell.textAlignment = .center
        return cell
        
    }
    
    private func changeToNumber(_ number : Int32 , _ interval : CGFloat , _ animated : Bool) -> Void {
        guard number >= 0 else {return}
        guard self.calculateRowNumber(Int(number)) <= self.maxRowNumber else {return}
        guard number != self.displayerNumber else {return}
        if self.isAnimation == true {
            let dict : Dictionary<String,CGFloat> = [self.keyTaskDisplayNumber : CGFloat(number) , self.keyTaskChangeNumber : CGFloat(number - self.displayerNumber) , self.keyTaskInterval : interval]
            self.taskArray.append(dict)} else {
                if animated == true {
                    self.playAnimationWithChange(Int(number - self.displayerNumber), number, interval)
                    self.isAnimation = true
                    
                } else {
                        let displayNumbers = self.getCellDisplayNumberWithNumber(number)
                        for i in 0..<displayNumbers.count {
                            self.setScollCell(self.cellArray[i], Int(displayNumbers[i]))
                            
                        }
                    
                }
                
            }
        self.displayerNumber = number
        
    }
    
    private func playAnimationWithChange(_ changeNumber : Int , _ displayNumber : Int32 , _ interval : CGFloat) -> Void {
        let nextRowNumber = self.calculateRowNumber(Int(displayNumber))
        var curInterval : CGFloat = interval
        if nextRowNumber > self.rowNumber {
            self.reInitCell(nextRowNumber)
            self.layoutCell(nextRowNumber, true)
            self.rowNumber = nextRowNumber
            
        }
        let repeatCountArray = self.getRepeatTimesWithChangeNumber(changeNumber, Int(displayNumber))
        let willDisplayNums = self.getCellDisplayNumberWithNumber(displayNumber)
        if interval == 0 {
            curInterval = self.getIntervalWithOriginalNumber(Int(displayNumber) - changeNumber, Int(displayNumber))
            
        }
        let direction : ScrollAnimationDirection = (changeNumber > 0) ? .Up : .Down
        var delay : CGFloat = 0.0
        if repeatCountArray.count != 0 {
            for (index , temp) in repeatCountArray.enumerated() {
                let result = temp
                let resultCount = Int(result)
                let willDisplayNum : Int = Int(willDisplayNums[index])
                let cell : UILabel = self.cellArray[index]
                var statrDuration : CGFloat = 0.0
                if resultCount == 0 {
                    self.makeSingleAnimationWithCell(cell, curInterval, delay, repeatCountArray.count, willDisplayNum)
                    
                } else {
                        if direction == .Up {statrDuration = curInterval * CGFloat(10 - self.getDisplayNumberOfCell(cell)) / CGFloat(ceilf(fabsf(Float(changeNumber) / powf(10, Float(index)))))
                            var cycleDuration : CGFloat = curInterval * 10 / CGFloat(fabsf(Float(changeNumber) / powf(10, Float(index))))
                            if resultCount == 1 {
                                cycleDuration = 0
                            }
                            let endDuration : CGFloat = self.bufferModulus * CGFloat(powf(Float(willDisplayNum), 0.3) / Float((index + 1)))
                            let dict : Dictionary<String,CGFloat> = [self.keyStartDuration : statrDuration,self.keyStartDelay : delay ,self.keyCycleDuration : cycleDuration ,self.keyEndDuration : endDuration ,self.keyRepeatCount : CGFloat(resultCount - 1) ,self.keyDisplayNumber : CGFloat(willDisplayNum)]
                            self.makeMultiAnimationWithCell(cell, direction, repeatCountArray.count, dict)
                            
                        } else if direction == .Down {statrDuration = curInterval * CGFloat(self.getDisplayNumberOfCell(cell) - 0) / CGFloat(ceilf(fabsf(Float(changeNumber) / powf(10, Float(index)))))
                            var cycleDuration : CGFloat = curInterval * 10 / CGFloat(fabsf(Float(changeNumber) / powf(10, Float(index))))
                            if resultCount == 1 {
                                cycleDuration = 0
                            }
                            let endDuration : CGFloat = self.bufferModulus * CGFloat(powf(10 - Float(willDisplayNum), 0.3) / Float((index + 1)))
                            let dict : Dictionary<String,CGFloat> = [self.keyStartDuration : statrDuration,self.keyStartDelay : delay ,self.keyCycleDuration : cycleDuration ,self.keyEndDuration : endDuration ,self.keyRepeatCount : CGFloat(resultCount - 1) ,self.keyDisplayNumber : CGFloat(willDisplayNum)]
                            self.makeMultiAnimationWithCell(cell, direction, repeatCountArray.count, dict)
                            
                        }
                    
                }
                delay = delay + statrDuration
            }
            
        }
        
    }
    
    private func getRepeatTimesWithChangeNumber(_ change : Int , _ number : Int) -> Array<Int> {
        var repeatTimesArray = Array<Int>.init()
        var originNumber : Int = number - change
        var curNumber = number
        if change > 0 {
            repeat {
                curNumber = (curNumber / 10) * 10
                originNumber = (originNumber / 10) * 10
                let result = (curNumber - originNumber) / 10
                repeatTimesArray.append(result)
                curNumber = curNumber / 10
                originNumber = originNumber / 10
                
            }
            while((curNumber - originNumber) != 0)
                    
        } else {
            repeat {
                curNumber = (curNumber / 10) * 10
                originNumber = (originNumber / 10) * 10
                let result = (originNumber - number) / 10
                repeatTimesArray.append(result)
                curNumber = curNumber / 10
                originNumber = originNumber / 10
                
            }
            while((originNumber - number) != 0)
                    
        }
        return repeatTimesArray
        
    }
    
    private func getDisplayNumberOfCell(_ cell : UILabel) -> Int {
        let y : CGFloat = cell.frame.origin.y
        let tmpNumber : CGFloat = (-(y * 11 / self.cellHeight))
        let displayNumber : Int = Int(roundf(Float(tmpNumber)))
        return displayNumber
        
    }
    
    private func getIntervalWithOriginalNumber(_ number : Int , _ displayNumber : Int) -> CGFloat {
        let repeatTimesArray = self.getRepeatTimesWithChangeNumber(displayNumber - number, displayNumber)
        let count = repeatTimesArray.count
        let aaa : Int = Int(powf(Float(10), Float(count - 1)))
        let tmp1 : Int = displayNumber / aaa
        let tmp2 : Int = number / aaa
        let maxChangeNum = labs(tmp1 % 10 - tmp2 % 10)
        return self.normalModulus * CGFloat(count) * CGFloat(maxChangeNum)
        
    }
    
    private func makeSingleAnimationWithCell(_ cell : UILabel,_ duration : CGFloat,_ delay : CGFloat,_ count : Int,_ displayNumber : Int) -> Void {
        UIView.animate(withDuration: duration) {
            self.setScollCell(cell, displayNumber)
            
        } completion: { finish in
            self.checkTaskArrayWithAnimationCount(count)
            print("single animation finish")
            
        }
        
    }
    
    private func checkTaskArrayWithAnimationCount(_ count : Int) -> Void {
        self.finishedAnimationCount += 1
        if self.finishedAnimationCount == count {
            self.finishedAnimationCount = 0
            if self.taskArray.count != 0 {
                let task = self.taskArray.first
                self.taskArray.removeFirst()
                if let task = task {
                    guard let displayNumber = task[self.keyTaskDisplayNumber] else { return }
                    guard let changeNumber = task[self.keyTaskChangeNumber] else { return }
                    guard let interval = task[self.keyTaskInterval] else { return }
                    self.playAnimationWithChange(Int(changeNumber), Int32(displayNumber), interval)
                    
                }
                
            } else {
                self.isAnimation = false
                
            }
            
        }
        
    }
    
    private func makeMultiAnimationWithCell(_ cell : UILabel,_ direction : ScrollAnimationDirection , _ count : Int,_ attribute : Dictionary<String,CGFloat>) -> Void {
        let startDuration = attribute[self.keyStartDuration] ?? 0.0
        let cycleDuration = attribute[self.keyCycleDuration] ?? 0.0
        let endDuration = attribute[self.keyEndDuration] ?? 0.0
        let repeatCount = attribute[self.keyRepeatCount] ?? 0.0
        let willDisplayNum = attribute[self.keyDisplayNumber] ?? 0.0
        let startDelay = attribute[self.keyStartDelay]
        UIView.animate(withDuration: startDuration) {
            self.setScollCell(cell, direction == .Up ? 10 : 0)
            
        } completion: { finish in
            self.setScollCell(cell, direction == .Up ? 0 : 10)
            if cycleDuration == 0 {
                UIView.animate(withDuration: endDuration, delay: 0, options: .curveEaseOut) {
                    self.setScollCell(cell, Int(willDisplayNum))} completion: { complete in
                        self.checkTaskArrayWithAnimationCount(count)
                        
                    }
                
            } else {
                UIView.animate(withDuration: cycleDuration, delay: 0, options: [.repeat,.curveLinear]) {
                    UIView.setAnimationRepeatCount(Float(repeatCount))
                    switch direction {
                        case .Up:
                        self.setScollCell(cell, 10)
                        case .Down:
                        self.setScollCell(cell, 0)
                        case .Number:break
                        
                    }
                    
                } completion: { _ in
                    self.setScollCell(cell, direction == .Up ? 0 : 10)
                    UIView.animate(withDuration: endDuration, delay: 0, options: .curveEaseOut) {
                        self.setScollCell(cell, Int(willDisplayNum))
                        
                    } completion: { _ in
                        self.checkTaskArrayWithAnimationCount(count)
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
}




extension UIColor {
    static func mainColorBlack() -> UIColor {
        return UIColor.black
    }
}


//private lazy var scrollLab : JXScrollNumberLabel = {
//    let temp = JXScrollNumberLabel.init(originNumber: 0, font: UIFont.systemFont(ofSize: 20, weight: .bold), textColor: .mainColorBlack())
//    temp.frame = CGRect.init(x: CGRectGetMaxX(self.coinImage.frame), y: CGRectGetMinY(self.coinImage.frame) - 3, width: temp.frame.size.width, height: 24)
//    return temp
//
//}()
//self.addSubview(self.scrollLab)
////数字改变
//public func changeNumber(_ addNum : Int32) -> Void {
//    var tmp = self.scrollLab.displayerNumber
//    self.scrollLab.changeToNumber(number: tmp + addNum, animated: true)
//}
