//
//  ThemeViewController.swift
//  CombineDemo
//
//  Created by HS-jianxin on 2023/9/12.
//

import UIKit
import Combine

let themeColors: [UIColor] = [.red, .green, .blue, .white, .yellow, .cyan]
let themePubliser = CurrentValueSubject<UIColor, Never>(.white)

//MARK: - 主题修改 响应
class ThemeViewController: UIViewController {
    
    let themeNames = ["红色", "绿色", "蓝色", "白色", "黄色", "青色"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        combineAdd()
    }
    
    
    
    

}


//MARK: - UI
extension ThemeViewController {
    
    func setupUI() {
        edgesForExtendedLayout = []
        
        let table = UITableView(frame: view.bounds, style: .plain)
        table.dataSource = self
        table.delegate = self
        view.addSubview(table)
        table.backgroundColor = .clear
    }
}


//MARK: - 事件
extension ThemeViewController {
    
    func combineAdd() {
        themePubliser.sink { themeColor in
            print("Thread: \(Thread.current)")
            DispatchQueue.main.async {
                self.view.backgroundColor = themeColor
            }
        }.store(in: &subscribes)
    }
}




extension ThemeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themeNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellid")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cellid")
        }
        cell?.textLabel?.text = themeNames[indexPath.row]
        cell?.backgroundColor = themeColors[indexPath.row]
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let color = themeColors[indexPath.row]
        
        themePubliser.send(color)
    }
}
