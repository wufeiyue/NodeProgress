//
//  NodeProgress.swift
//  NodeProgress
//
//  Created by 武飞跃 on 2017/7/10.
//  Copyright © 2017年 BMKP. All rights reserved.
//

import UIKit

typealias NodeProgressComletion = (_ value: Float) -> Void

class NodeProgress: NSObject {
    
    private var totalProgress:Float!
    private(set) dynamic var progress:Float = 0
    private var node:Float?
    private var timer:Timer?
    private var counter:(() -> Float)?
    private var pointer:Int = 0
    private var maxPointer:Int = 0
    private var beforeCompletion:NodeProgressComletion?
    
    let queues:Array<Float>
    let duration:Float
    
    
    /// 初始化方法
    ///
    /// - Parameters:
    ///   - queues: 完成队列 
    ///         例如:queues = [0.3, 0.5, 0.4] //表示有三个任务, 完成任务耗时时间分别为 timeout * 3/12 和 timout * 5/12 和 timout * 4/12
    ///   - timeout: 超时时间
    public init(queues:Array<Float>, timeout:TimeInterval) {
        self.queues = queues
        self.duration = 1/Float(timeout * 100)
        self.totalProgress = queues.reduce(0, +)
    }
    
    public func completion(index:Int){
        
        if index < 0 || index >= queues.count || maxPointer > index{ return }
        
        var target:Float = 0
        
        for i in 0 ..< index + 1 {
            let value = transformProgress(fromQueuesIndex: i)
            target += value
        }
        
        maxPointer = index
        node = target
    }
    
    public func alreadyCompletion(closure:@escaping NodeProgressComletion) {
        self.beforeCompletion = closure
    }
    
    public func start() {
        invalidate()
        pointer = 0
        progress = 0
        addCounter(forQueuesIndex: pointer)
        addTimer()
    }
    
    //关闭定时器
    public func stop(){
        invalidate()
        removeCounter()
        maxPointer = 0
    }
    
    private func createCounter(start: Float) -> () -> Float {
        var startCount = start
        return {
            startCount -= self.duration
            self.progress += self.duration
            return startCount
        }
    }
    
    private func addCounter(forQueuesIndex index:Int) {
        let value = transformProgress(fromQueuesIndex: index)
        counter = createCounter(start: value)
    }
    
    private func removeCounter() {
        counter = nil
    }
    
    private func transformProgress(fromQueuesIndex index:Int) -> Float{
        return queues[index] / totalProgress
    }
    
    private func next() {
        if pointer == queues.count - 1 {
            invalidate()
            removeCounter()
        }
        else{
            pointer += 1
        }
        
        addCounter(forQueuesIndex: pointer)
    }
    
    //MARK: - 定时器
    
    private func addTimer(){
        if timer == nil {
            let timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
            RunLoop.main.add(timer, forMode: .commonModes)
            self.timer = timer
        }
    }
    
    private func invalidate() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func timerElapsed(){
        
        if let target = node, target >= progress{
            beforeCompletion?(target)
            progress = target
            node = nil
            next()
            return
        }
        
        if let unwrappedCounter = counter, unwrappedCounter() < 0 {
            next()
            return
        }
    }
}

