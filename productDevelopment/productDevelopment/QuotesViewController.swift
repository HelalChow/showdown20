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


    var i:Int = 1

    @IBAction func inspireMeDidTab(_ sender: Any) {
        let newQuote = ["Your time is limited. So don't waste it living someone elses life.","No matter how small you start, start somehting that matters.", "Don't waste your life searching for adventures, but rather make the most out of this adventure known as life"]
            
        
            quoteTextLabel.text = newQuote[i]
            if i==newQuote.count-1{
                i=0
            }
            else{i+=1}
    }
}
