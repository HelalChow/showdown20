//
//  DetailsViewController.swift
//  productDevelopment
//
//  Created by Helal Chowdhury on 1/4/20.
//  Copyright © 2020 Helal. All rights reserved.
//

import UIKit
import EventKit
import MapKit

class DetailsViewController: UIViewController, MKMapViewDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func buttonClicked(_ sender: Any) {
        let eventStore:EKEventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event) {(granted, error) in
            if (granted) && (error) == nil
            {
                print("granted \(granted)")
                print("error \(error)")
                
                let event:EKEvent = EKEvent(eventStore: eventStore)
                event.title = "Therapy Meeting with Dr. Suraya Ahmed"
                event.startDate = Date()
                event.endDate = Date()
                event.notes = ""
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let error as NSError{
                    print("error : \(error)")
                }
                print("Save Event")
            } else{
                print("error : \(error)")
            }
            
        }
    }
    
}
