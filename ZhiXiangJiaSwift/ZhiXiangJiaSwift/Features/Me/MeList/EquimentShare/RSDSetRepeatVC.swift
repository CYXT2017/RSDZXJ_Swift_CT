
//
//  RSDSetRepeatVC.swift
//  ZhiXiangJiaSwift
//
//  Created by ios on 2018/9/14.
//  Copyright © 2018年 rsdznjj. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol RSDSetRepeatDeleagte: AnyObject {

    func setRepeatDay(repeatStr: String, currentStateArray: [String])
}

class RSDSetRepeatVC: UIViewController {
    
    weak var delegate: RSDSetRepeatDeleagte?
    
    let titleArray: [String] = ["周一","周二","周三","周四","周五","周六","周日"]
    var stateArray: [String] = Array.init()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setUpUI()
        setupDataForTab()
        if #available(iOS 11.0, *) {
            self.mainTableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        };
    }
    
    //MARK: - Private
    private func setupDataForTab() {
        if self.stateArray.count == 0 {
            for _ in 0..<self.titleArray.count {
                self.stateArray.append("1")
            }
        }
        self.mainTableView.reloadData()
    }
    
    private func setUpUI() {
        view.addSubview(self.mainTableView)
        self.mainTableView.backgroundColor = RSDBGViewColor
        self.mainTableView.tableFooterView = UIView()
        self.mainTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "mySharedCell")

        self.mainTableView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-80)
        }
        view.addSubview(self.saveBtn)
        self.saveBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
    }

    //MARK:保存重复信息
    @objc func saveBtnClick() {
        
        
        var setingString = ""
        var setArray: [String] = Array.init()
        if !self.stateArray.contains("0") {
            setingString = "每天"
        } else if !self.stateArray.contains("1") {
            SVProgressHUD.showError(withStatus: "请确认重复时间")
            return
        } else {
            for (index,item) in self.stateArray.enumerated() {
                if item == "1" {
                    setArray.append(self.titleArray[index])
                }
            }
            
            for i in 0..<setArray.count {
                setingString = setingString + setArray[i]
            }
        }
        self.delegate?.setRepeatDay(repeatStr: setingString, currentStateArray: self.stateArray)
        self.navigationController?.popViewController(animated: true)
    }


    //MARK: - 懒加载
    lazy var saveBtn: UIButton = {
        let btn = UIButton.init()
        btn.setTitle("保存", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = UIColor.navBackGroundColor
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(self.saveBtnClick), for: .touchUpInside)
        return btn
    }()
    
    lazy var mainTableView: UITableView = {
        let tableview = UITableView.init(frame: CGRect(x: 0, y: 0, width: RSDScreenWidth, height: view.height), style: .plain)
        tableview.delegate = self
        tableview.dataSource = self
        return tableview
    }()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension RSDSetRepeatVC: UITableViewDelegate, UITableViewDataSource {
    //MARK: - TableViewDelegate 和 dataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "mySharedCell")
        if (cell == nil) {
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: "mySharedCell")
        }
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell.textLabel?.text = self.titleArray[indexPath.row]
        
        if self.stateArray[indexPath.row] == "1" {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.stateArray[indexPath.row] == "1" {
            self.stateArray[indexPath.row] = "0"
        } else {
            self.stateArray[indexPath.row] = "1"
        }
        self.mainTableView.reloadData()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45 * PROPORTION_Y
    }
}
