//
//  WelcomeViewController.swift
//  practice40h
//
//  Created by 刘昊嵋 on 2021/5/5.
//

import UIKit
import RealmSwift

class WelcomeViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    
    var email: String? {
        get {
            return emailField.text
        }
    }

    var password: String? {
        get {
            return passwordField.text
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true

        // Do any additional setup after loading the view.
    }
    
    @IBAction func userDidLoggedIn(_ sender: UIButton) {
        print("Log in as user: \(email!)")
        setLoading(true)

        app.login(credentials: Credentials.emailPassword(email: email!, password: password!)) { [weak self](result) in
            DispatchQueue.main.async {
                self!.setLoading(false)
                switch result {
                case .failure(let error):
                    // Auth error: user already exists? Try logging in as that user.
                    print("Login failed: \(error)")
                    self!.errorLabel.isHidden = false
                    self!.errorLabel.text = "Login failed: \(error.localizedDescription)"
                    return
                case .success(let user):
                    print("Login succeeded!")

                    // Load again while we open the realm.
                    self!.setLoading(true)
                    // Get a configuration to open the synced realm.
                    var configuration = user.configuration(partitionValue: "user=\(user.id)")
                    // Only allow User objects in this partition.
                    configuration.objectTypes = [User.self]
                    // Open the realm asynchronously so that it downloads the remote copy before
                    // opening the local copy.
                    Realm.asyncOpen(configuration: configuration) { [weak self](result) in
                        DispatchQueue.main.async {
                            self!.setLoading(false)
                            switch result {
                            case .failure(let error):
                                fatalError("Failed to open realm: \(error)")
                            case .success(let userRealm):
                                print("Log in success")
//                                self!.present(RoundTabBarController(userRealm: userRealm), animated: true)
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let rc = storyboard.instantiateViewController(identifier: "RoundTabBarController") as! RoundTabBarController
                                rc.userRealm = userRealm
                                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(rc)

                            }
                        }
                    }
                }
            }
        }
    }

    @IBAction func userDidSignedUp(_ sender: UIButton) {
        setLoading(true)
        app.emailPasswordAuth.registerUser(email: email!, password: password!, completion: { [weak self](error) in

            DispatchQueue.main.async {
                self!.setLoading(false)
                guard error == nil else {
                    print("Signup failed: \(error!)")
                    self!.errorLabel.text = "Signup failed: \(error!.localizedDescription)"
                    return
                }
                print("Signup successful!")

                // Registering just registers. Now we need to sign in, but we can reuse the existing email and password.
                self!.errorLabel.text = "Signup successful! Signing in..."
                self!.signInButton.sendActions(for: .touchUpInside)
            }
        })
    }
    
    func setLoading(_ loading: Bool) {
        activityIndicator.isHidden = false
        if loading {
            activityIndicator.startAnimating()
            errorLabel.text = ""
        } else {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
        }
        emailField.isEnabled = !loading
        passwordField.isEnabled = !loading
        signInButton.isEnabled = !loading
        signUpButton.isEnabled = !loading
    }
    
}
