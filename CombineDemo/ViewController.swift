//
//  ViewController.swift
//  CombineDemo
//
//  Created by HS-jianxin on 2023/9/4.
//

import UIKit
import Combine

var subscribes = Set<AnyCancellable>()
class ViewController: UIViewController {
    
    var headerArr = ["Combine学习", "UI响应练习"]
    var titleArr = [["Publisher学习", "Subscriber学习", "Subject学习", "Erase学习", "Cancellable学习"],
                    ["TextField响应", "主题更改响应"]]
    var vcNameArr = [["PublisherViewController", "SubscriberViewController", "SubjectViewController", "JX_EraseToAnyViewController", "JX_CancellableViewController"],
                 ["TextFiledViewController", "ThemeViewController"]]
//    var vcArr = [[PublisherViewController(), SubscriberViewController(), SubjectViewController(), JX_EraseToAnyViewController()],
//                 [TextFiledViewController()]]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let table = UITableView(frame: view.bounds, style: .plain)
        table.dataSource = self
        table.delegate = self
        view.addSubview(table)
        table.backgroundColor = .clear
        
        
//        let label = UIZJLAnimationLab(frame: CGRect(x: 10, y: 100, width: 50, height: 30), type: .FLOAT)
//        label.tag = 10
//        view.addSubview(label)
//        label.countFrom(start: 0.99, to: 0.15, duration: 0.3)
        
        combineAdd()
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let label = view.viewWithTag(10) as! UIZJLAnimationLab
//        label.countFrom(start: 0.99, to: 0.15, duration: 1)
//    }
    


}



//MARK: - 事件
extension ViewController {
    
    func combineAdd() {
        themePubliser.sink { themeColor in
            print("Thread: \(Thread.current)")
            DispatchQueue.main.async {
                self.view.backgroundColor = themeColor
            }
        }.store(in: &subscribes)
    }
}







extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return vcNameArr.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (titleArr[section]).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellid")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cellid")
        }
        cell?.textLabel?.text = titleArr[indexPath.section][indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerArr[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = vcArr[indexPath.section][indexPath.row]
//        let nav = UINavigationController(rootViewController: vc)
        
        
        let className = vcNameArr[indexPath.section][indexPath.row]
        let c = NSClassFromString("CombineDemo."+className)! as! UIViewController.Type
        let vc = c.init()
        vc.title = titleArr[indexPath.section][indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}



