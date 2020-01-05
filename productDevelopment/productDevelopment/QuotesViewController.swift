//
//  QuotesViewController.swift
//  productDevelopment
//
//  Created by Helal Chowdhury on 1/4/20.
//  Copyright © 2020 Helal. All rights reserved.
//

import UIKit

class QuotesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBOutlet weak var quoteTextLabel: UILabel!
    

    var i:Int = 1

    @IBAction func inspiteMeDidTap(_ sender: Any) {
        let newQuote = ["'So remember me; I will remember you' | Al-Baqarah 2:152","'And Allah would not punish them while they seek forgiveness' | Al-Anfal 8:33", "'And He has made me blessed wherever I am' | Maryam 19:31", "'And whoever puts all his trust in Allah (SWT), He will be enough for him' | At-Talaq 65:1-3", "'It may be that you dislike a thing which is good for you and that you like a thing which is bad for you. Allah knows but you do not know' | Al-Baqarah 2:216"]
                   
               
                   quoteTextLabel.text = newQuote[i]
                   if i==newQuote.count-1{
                       i=0
                   }
                   else{i+=1}
           }
    
}
