//
//  UserViewController.swift
//  practice40h
//
//  Created by 刘昊嵋 on 2021/5/5.
//

import UIKit
import RealmSwift

class UserViewController: UIViewController {
    var userRealm: Realm?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(userRealm!.objects(User.self))
        let user = app.currentUser!
        print(user)
    }
    
    @IBAction func userDidLoggedOut(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Log Out", message: "", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Yes, Log Out", style: .destructive, handler: {
                _ -> Void in
                print("Logging out...")
                app.currentUser?.logOut { (_) in
                    DispatchQueue.main.async {
                        print("Logged out!")
                        //Switch
                    }
                }
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
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
