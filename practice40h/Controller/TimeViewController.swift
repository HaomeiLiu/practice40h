//
//  TimeViewController.swift
//  practice40h
//
//  Created by 刘昊嵋 on 2021/5/4.
//

import UIKit
import SwiftUI
import UICircularProgressRing
import RealmSwift

class TimeViewController: UIViewController {
    var duration: Double = 60
    var timer: Timer!
    var timerData: TimerData = TimerData(duration:60, paused: true, done: false)
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var durationLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBSegueAction func addTimerRingView(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: TimerRingExample(data:timerData))
    }
    
    @IBAction func userDidTappedStart(_ sender: UIButton) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(step), userInfo: nil, repeats: true)
        datePicker.isHidden = true
        timerData.duration = duration
        timerData.paused = false
        timerData.done = false
    }
    
    @IBAction func userDidTappedReset(_ sender: UIButton) {
        timer.invalidate()
        datePicker.isHidden = false
        timerData.paused = true
        timerData.done = true
    }
    
    @IBAction func userDidChangedDuration(_ sender: UIDatePicker) {
        duration = datePicker.countDownDuration/60
        print(datePicker.countDownDuration)
    }
    
    @objc func step(){
        if duration > 0{
            duration -= 1
        }
        else{
            timer.invalidate()
            duration = 0
        }
        durationLabel.text = "\(duration)"
    }
    
    

}
