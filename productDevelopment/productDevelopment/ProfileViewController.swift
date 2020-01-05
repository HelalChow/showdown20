//
//  ViewController.swift
//  productDevelopment
//
//  Created by Helal Chowdhury on 1/3/20.
//  Copyright © 2020 Helal. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    
    

    @IBOutlet weak var beginButton: UIButton!
    @IBOutlet weak var beginButton2: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beginButton.addTarget(self, action: "tapBegin", for: .touchUpInside)
        beginButton2.addTarget(self, action: "tapBegin2", for: .touchUpInside)
        

    }
    

    @IBAction func tapBegin(_ sender: Any) {
//        UIApplication.shared.openURL(NSURL(string: "https://hangouts.google.com/call/coYtJmhhuN5CMkLkdxlIAEEE")! as URL)
        
        if let url = NSURL(string: "https://hangouts.google.com/call/coYtJmhhuN5CMkLkdxlIAEEE") {
            UIApplication.shared.openURL(url as URL)
        }
    }
    
    @IBAction func tapBegin2(_ sender: Any) {
        //        UIApplication.shared.openURL(NSURL(string: "https://hangouts.google.com/call/coYtJmhhuN5CMkLkdxlIAEEE")! as URL)
        
        if let url = NSURL(string: "https://hangouts.google.com/call/coYtJmhhuN5CMkLkdxlIAEEE") {
            UIApplication.shared.openURL(url as URL)
        }
    }
    
}
