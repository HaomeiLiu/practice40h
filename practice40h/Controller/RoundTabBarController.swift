//
//  RoundTabBarController.swift
//  practice40h
//
//  Created by 刘昊嵋 on 2021/5/4.
//

import UIKit
import RealmSwift

class RoundTabBarController: UITabBarController, UITabBarControllerDelegate {

    //Realm
    var userRealm: Realm?
    //var notificationToken: NotificationToken?
    var userData: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let usersInRealm = userRealm!.objects(User.self)
        
        let v3 = self.viewControllers![2] as! UserViewController
        v3.userRealm = userRealm

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
