//
//  ViewController.swift
//  NodeProgress
//
//  Created by 武飞跃 on 2017/7/10.
//  Copyright © 2017年 BMKP. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var manager:NodeProgress!
    var progressView:UIProgressView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createView()
        
        let queue:Array<Float> = [0.3, 0.6, 0.9, 0.4]
        manager = NodeProgress(queues: queue, timeout:20)
        manager.start()
        
        manager.alreadyCompletion { [weak self] value in
            print("已完成:\(value)")
            self?.progressView.setProgress(value, animated: true)
        }
        
        manager.addObserver(self, forKeyPath: #keyPath(NodeProgress.progress), options: .new, context:nil)
    }
    
    func createView(){
        progressView = UIProgressView(frame: CGRect(x: 10, y: 80, width: 300, height: 10))
        progressView.progressTintColor = UIColor.red
        progressView.trackTintColor = .blue
        view.addSubview(progressView)
        
        downloadBtn.frame.origin.x = 10
        view.addSubview(downloadBtn)
        
        readBtn.frame.origin.x = 70
        view.addSubview(readBtn)
        
        showBtn.frame.origin.x = 130
        view.addSubview(showBtn)
        
        writeBtn.frame.origin.x = 190
        view.addSubview(writeBtn)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        self.progressView.progress = change?[.newKey] as! Float
        
    }
    
    func btnDidTapped1(){
        manager.completion(index: 0)
    }
    
    func btnDidTapped2(){
        manager.completion(index: 1)
    }
    
    func btnDidTapped3(){
        manager.completion(index: 2)
    }
    
    func btnDidTapped4(){
        manager.completion(index: 3)
    }
    
    lazy var downloadBtn:UIButton = {
        let btn = UIButton(type: .custom)
        btn.addTarget(self, action: #selector(btnDidTapped1), for: .touchUpInside)
        btn.backgroundColor = .black
        btn.setTitle("下载", for: .normal)
        btn.frame.origin.y = 100
        btn.frame.size = CGSize(width: 50, height: 38)
        return btn
    }()
    lazy var readBtn:UIButton = {
        let btn = UIButton(type: .custom)
        btn.addTarget(self, action: #selector(btnDidTapped2), for: .touchUpInside)
        btn.backgroundColor = .green
        btn.setTitle("读取", for: .normal)
        btn.frame.origin.y = 100
        btn.frame.size = CGSize(width: 50, height: 38)
        return btn
    }()
    lazy var showBtn:UIButton = {
        let btn = UIButton(type: .custom)
        btn.addTarget(self, action: #selector(btnDidTapped3), for: .touchUpInside)
        btn.backgroundColor = .blue
        btn.setTitle("显示", for: .normal)
        btn.frame.origin.y = 100
        btn.frame.size = CGSize(width: 50, height: 38)
        return btn
    }()
    lazy var writeBtn:UIButton = {
        let btn = UIButton(type: .custom)
        btn.addTarget(self, action: #selector(btnDidTapped4), for: .touchUpInside)
        btn.backgroundColor = .gray
        btn.setTitle("写入", for: .normal)
        btn.frame.origin.y = 100
        btn.frame.size = CGSize(width: 50, height: 38)
        return btn
    }()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

