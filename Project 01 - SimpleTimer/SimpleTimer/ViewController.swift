//
//  ViewController.swift
//  SimpleTimer
//
//  Created by Andy Meng on 2019/7/25.
//  Copyright © 2019 Andy Meng. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    let DEBUG = false                               //!< 调试开关
    var timerLabel = UILabel()                      //!< 计时
    var leftButton = UIButton(type: .custom)        //!< 左边的按钮：计次、复位
    var rightButton = UIButton(type: .custom)       //!< 右边的按钮：启动、停止
    var consoleTopLineView = UIView()               //!< 底部控制台 顶部分割线
    var consoleTextView = UITextView()              //!< 底部控制台
    var timer = Timer()                             //!< 计时器
    var counterNum = 0                              //!< 计数次序
    var counter : Float = 0.0 {
        didSet {
            timerLabel.text = String(format: "%02d:%02.02f", Int(counter/60), counter.truncatingRemainder(dividingBy: 60));
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "简单计时器";
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white];
        navigationController?.navigationBar.barTintColor = UIColor(red:0.09, green:0.09, blue:0.10, alpha:1.00);
        navigationController?.navigationBar.tintColor = UIColor.white;
        navigationController?.navigationBar.isTranslucent = false
        view.backgroundColor = UIColor(red:0.05, green:0.05, blue:0.05, alpha:1.00);
        
        // 计时器Label
        timerLabel.text = "00:00.00"
        timerLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 90, weight:.thin)
        timerLabel.adjustsFontSizeToFitWidth = true
        timerLabel.textColor = UIColor.white
        timerLabel.textAlignment = .center
        timerLabel.debugEnable(DEBUG);
        view.addSubview(timerLabel)
        timerLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(280)
        }
        
        // 左边的按钮
        leftButton.layer.cornerRadius = 35
        leftButton.layer.masksToBounds = true
        leftButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        leftButton.setBackgroundImage(UIImage.from(color: UIColor(red:0.24, green:0.24, blue:0.24, alpha:1.00)), for: .normal)
        leftButton.setTitleColor(.white, for: .normal)
        leftButton.setTitle("计次", for: .normal)
        leftButton.setTitle("复位", for: .selected)
        leftButton.isEnabled = false
        leftButton.addTarget(self, action: #selector(didClickLeftButton), for: .touchUpInside)
        leftButton.debugEnable(DEBUG);
        view.addSubview(leftButton)
        leftButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(leftButton.layer.cornerRadius*2)
            make.top.equalTo(timerLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
        }
        
        // 左边的按钮
        rightButton.layer.cornerRadius = 35
        rightButton.layer.masksToBounds = true
        rightButton.setTitle("启动", for: .normal)
        rightButton.setTitle("停止", for: .selected)
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        rightButton.setTitleColor(UIColor(red:0.45, green:0.83, blue:0.44, alpha:1.00), for: .normal)
        rightButton.setTitleColor(UIColor(red:0.93, green:0.31, blue:0.24, alpha:1.00), for: .selected)
        rightButton.setBackgroundImage(UIImage.from(color: UIColor(red:0.12, green:0.21, blue:0.13, alpha:1.00)), for: .normal)
        rightButton.setBackgroundImage(UIImage.from(color: UIColor(red:0.22, green:0.09, blue:0.09, alpha:1.00)), for: .selected)
        rightButton.addTarget(self, action: #selector(didClickRightButton), for: .touchUpInside)
        rightButton.debugEnable(DEBUG);
        view.addSubview(rightButton)
        rightButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(rightButton.layer.cornerRadius*2)
            make.top.equalTo(timerLabel.snp.bottom).offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        // 底部控制台
        view.addSubview(consoleTextView)
        consoleTextView.textColor = UIColor.white
        consoleTextView.font = UIFont.monospacedDigitSystemFont(ofSize: 18, weight:.thin)
        consoleTextView.backgroundColor = .clear
        consoleTextView.debugEnable(DEBUG);
        consoleTextView.snp.makeConstraints { (make) in
            make.top.equalTo(rightButton.snp.bottom).offset(20)
            make.left.equalTo(view.snp.left).offset(20)
            make.right.equalTo(view.snp.right).offset(-20)
            make.height.equalTo(200)
        }
        
        // 底部控制台 顶部分割线
        view.addSubview(consoleTopLineView)
        consoleTopLineView.backgroundColor = UIColor.lightGray
        consoleTopLineView.snp.makeConstraints { (make) in
            make.top.equalTo(consoleTextView)
            make.left.equalTo(consoleTextView)
            make.right.equalTo(consoleTextView)
            make.height.equalTo(1 / UIScreen.main.scale)
        }
        
    }
    
    @objc func didClickLeftButton(_ button : UIButton) {
        // 复位
        if leftButton.isSelected {
            counter = 0
            counterNum = 0
            consoleTextView.text = nil
        }
        // 计次
        else {
            counterNum += 1
            let timeString = timerLabel.text ?? "00:00:00"
            let string = "计次 \(counterNum)\t\t\t\(timeString)"
            print(string)
            consoleTextView.text = "\(string)\n\n".appending(consoleTextView.text);// consoleTextView.text.appendingFormat("%@\n\n", string)
        }
    }
    
    @objc func didClickRightButton(_ button : UIButton) {
        // 未启动计时器
        if !rightButton.isSelected {
            // 开始计时
            timer = Timer.scheduledTimer(timeInterval: 0.01, target:self, selector: #selector(didHandleTimer), userInfo: nil, repeats: true)
            // 左边按钮可点计次
            leftButton.isEnabled = true
            leftButton.isSelected = false
        }
        // 正在计时
        else {
            // 停止计时
            timer.invalidate()
            // 若有时间，则左边按钮可点复位
            if counter > 0 {
                leftButton.isSelected = true
            }
        }
        // 右边按钮状态取反
        rightButton.isSelected = !rightButton.isSelected
    }
    
    @objc func didHandleTimer(_ timer : Timer) {
        counter = counter + Float(timer.timeInterval);
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default;
    }
    
}


/// 扩展：UI调试
extension UIView {
    
    func debugEnable(_ debug:Bool) {
        layer.borderColor = debug ? debugBorderColor().cgColor : nil
        layer.borderWidth = debug ? 1 / UIScreen.main.scale : 0
    }
    
    func debugBorderColor() -> UIColor {
        if self is UILabel {
            let label = self as! UILabel
            return label.textColor
        }
        return tintColor
    }
}

extension UIImage {
    static func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
}
