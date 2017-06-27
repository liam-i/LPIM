//
//  LPKTimerHolder.swift
//  LPIM
//
//  Created by lipeng on 2017/6/23.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import Foundation
/// M80TimerHolder，管理某个Timer，功能为
/// 1.隐藏NSTimer,使得NSTimer只能retain M80TimerHolder
/// 2.对于非repeats的Timer,执行一次后自动释放Timer
/// 3.对于repeats的Timer,需要持有M80TimerHolder的对象在析构时调用[M80TimerHolder stopTimer]

protocol LPKTimerHolderDelegate: NSObjectProtocol {
    func onLPKTimerFired(holder: LPKTimerHolder) -> Void
}

class LPKTimerHolder {
    weak var delegate: LPKTimerHolderDelegate?
    
    private var timer: Timer?
    private var repeats: Bool = false
    
    func startTimer(seconds: TimeInterval, delegate: LPKTimerHolderDelegate?, repeats: Bool) {
        self.delegate = delegate
        self.repeats = repeats
        
        if let timer = timer {
            timer.invalidate()
            self.timer = nil
        }
        timer = Timer.scheduledTimer(timeInterval: seconds, target: self, selector: #selector(onTimer), userInfo: nil, repeats: repeats)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        delegate = nil
    }
    
    deinit {
        log.warning("release memory.")
        stopTimer()
    }
    
    @objc private func onTimer() {
        if !repeats {
            timer?.invalidate()
            timer = nil
        }
        delegate?.onLPKTimerFired(holder: self)
    }
}
