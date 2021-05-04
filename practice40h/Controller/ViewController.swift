//
//  ViewController.swift
//  practice40h
//
//  Created by 刘昊嵋 on 2021/4/27.
//

import UIKit
import FSCalendar

class ViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

    var calender: FSCalendar!
    var formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        calender = FSCalendar(frame: CGRect(x: 0.0, y: 40.0, width: self.view.frame.size.width, height: 300.0))
        //calender.scope = .week
        //calender.locale = Locale(identifier: "ch")
        calender.scrollDirection = .vertical
        self.view.addSubview(calender)
        
        calender.delegate = self
        calender.dataSource = self
        calender.allowsMultipleSelection = true
    }
    
    //Delegate
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        formatter.dateFormat = "dd-MMM-yyyy"
        print("\(formatter.string(from: date))")
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        formatter.dateFormat = "dd-MM-yyyy"
        guard let excludedDate = formatter.date(from: "23-07-2020")
        else{
            return true
        }
        if date.compare(excludedDate) == .orderedSame{
            return false
        }
        return true
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 0
    }
    
    //Delegate Appearance
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        //Same as shouldSelect
        return nil
    }
    
    //Data Source
//    func minimumDate(for calendar: FSCalendar) -> Date {
//        return Date()
//    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
//        return Date().addingTimeInterval((24*60*60)*5)
        return Date()
    }
    


}


