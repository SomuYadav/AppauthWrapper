//
//  ViewController.swift
//  AppauthWrapper_Example
//
//  Created by Somendra Yadav on 06/07/20.
//  Copyright © 2020 Somendra Yadav. All rights reserved.
//

import UIKit
import AppauthWrapper
import AppAuth

class AppAuthVC: UIViewController {

    //==============================
    //MARK: @IBOutlet(s)
    //==============================
    @IBOutlet weak var lblToken: UILabel!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnSignOut: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//==============================
//MARK: AppAuthVC Action(s)
//==============================
extension AppAuthVC {
    @IBAction func signInAction(_ sender: Any) {
        appDelegate.app?.signIn(self, { (bool) in
            if bool {
                self.lblToken.text = "Login Sucessfully"
            }
        }, { (session) in
            appDelegate.currentAuthorizationFlow = session
        }, { (statusCode,error) in
            print(statusCode ?? 0,error)
        })
    }
    
    @IBAction func signOutAction(_ sender: Any) {
        appDelegate.app?.signOut({ (bool) in
            if bool {
                self.lblToken.text = "LogOut Sucessfully"
            }
        }, { (statusCode,error) in
              print(statusCode ?? 0,error)
        })
    }
    
    @IBAction func refreshTokenAction(_ sender: Any) {
        //self.lblToken.text = appDelegate.app?.
    }
}

//==============================
//MARK: AppAuthVC func(s)
//==============================
extension AppAuthVC {
    func signInShow() {
        self.btnSignIn.isHidden  = true
        self.btnSignOut.isHidden = false
    }
    
    func signOutShow() {
        self.btnSignIn.isHidden  = false
        self.btnSignOut.isHidden = true
    }
}
