//
//  MapViewController.swift
//  productDevelopment
//
//  Created by Helal Chowdhury on 1/3/20.
//  Copyright © 2020 Helal. All rights reserved.
//

import UIKit
import MapKit
import Speech
import FlyoverKit
import CoreLocation



class MapViewController: UIViewController, SFSpeechRecognizerDelegate {
    
    let locationManager = CLLocationManager()
    var currentCoordinate: CLLocationCoordinate2D?
    
    var userInputLocation = FlyoverAwesomePlace.newYork
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale.init(identifier: "en-us"))
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()

    override func viewDidLoad() {
            super.viewDidLoad()
            
            locationManager.delegate = self
            mapView.delegate = self
            userLocationSetup()
            self.mapSetup()
//
            speechRecognizer?.delegate = self
            SFSpeechRecognizer.requestAuthorization {
                status in
                var buttonState = false
                switch status {
                case .authorized:
                    buttonState = true
                    print("Permission recieved")
                case .denied:
                    buttonState = false
                    print("User did not grant permssion for speech recognition")
                case .notDetermined:
                    buttonState = false
                    print("Speech recofgnition not allowed by user")
                case .restricted:
                    buttonState = false
                    print("Speech recognition is not supported on this device")
                    
                }
                
                DispatchQueue.main.async {
                    self.locationButton.isEnabled = buttonState
                }
            }
            
            self.mapSetup()
            
            
        }
    
//        func mapSetup() {
//            self.mapView.mapType = .hybridFlyover
//            self.mapView.showsBuildings = true
//            self.mapView.isZoomEnabled = true
//            self.mapView.isScrollEnabled = true
//
//            let camera = FlyoverCamera(mapView: self.mapView, configuration: FlyoverCamera.Configuration(duration: 6.0, altitude: 60000, pitch: 45.0, headingStep: 40.0))
//            camera.start(flyover: FlyoverAwesomePlace.parisEiffelTower)
//            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(20), execute:{
//                camera.stop()
//            })
//        }
        
        func userLocationSetup(){
            locationManager.requestAlwaysAuthorization() //we can ask this later
            locationManager.startUpdatingLocation()
            locationManager.distanceFilter = 100
            mapView.showsUserLocation = true
            mapView.mapType = MKMapType.hybrid
        }
    
    
        func addAnnotations(){
            let timesSqaureAnnotation = MKPointAnnotation()
            timesSqaureAnnotation.title = "9/11 Day of Service"
            timesSqaureAnnotation.coordinate = CLLocationCoordinate2D(latitude: 40.6602, longitude: -73.9985)
            
            let empireStateAnnotation = MKPointAnnotation()
            empireStateAnnotation.title = "Hurricane Dorian Clothing Drive"
            empireStateAnnotation.coordinate = CLLocationCoordinate2D(latitude: 40.7484, longitude: -73.9857)
            
            let brooklynBridge = MKPointAnnotation()
            brooklynBridge.title = "Food Pantry Delivery"
            brooklynBridge.coordinate = CLLocationCoordinate2D(latitude: 40.7061, longitude: -73.9969)
            
            let prospectPark = MKPointAnnotation()
            prospectPark.title = "Feed The Homeless Soup Kitchen"
            prospectPark.coordinate = CLLocationCoordinate2D(latitude: 40.6602, longitude: -73.9690)
            
            let jersey = MKPointAnnotation()
            jersey.title = "It's My Park"
            jersey.coordinate = CLLocationCoordinate2D(latitude: 40.7178, longitude: -74.0431)
            
            let col = MKPointAnnotation()
            col.title = "Mental Health Discussion"
            col.coordinate = CLLocationCoordinate2D(latitude: 48.7806, longitude: 2.2376)
            
            let col2 = MKPointAnnotation()
            col2.title = "Mental Health Discussion"
            col2.coordinate = CLLocationCoordinate2D(latitude: 48.8606, longitude: 2.3476)
            
            let col3 = MKPointAnnotation()
            col3.title = "Mental Health Discussion"
            col3.coordinate = CLLocationCoordinate2D(latitude: 48.9030, longitude: 2.3599)
            
            mapView.addAnnotation(timesSqaureAnnotation)
            mapView.addAnnotation(empireStateAnnotation)
            mapView.addAnnotation(brooklynBridge)
            mapView.addAnnotation(prospectPark)
            mapView.addAnnotation(jersey)
            
         

            
            mapView.addAnnotation(col3)
            mapView.addAnnotation(col2)
            mapView.addAnnotation(col)
            
            
        }
        
    
    
    
//    SPEECH RECORDING STUFF
        func startRecording() {
            if recognitionTask != nil {
                recognitionTask?.cancel()
                recognitionTask = nil
            }
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
                try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            } catch {
                print("Dailed to setup audio session")
            }
            
            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            let inputNode = audioEngine.inputNode
            guard let recognitionRequest = recognitionRequest else {
                fatalError("Could not create request instance")
            }
            
            recognitionRequest.shouldReportPartialResults = true
            recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) {
                result, error in
                var isLast = false
                if result != nil {
                    isLast = (result?.isFinal)!
                }
                
                if error != nil || isLast {
                    self.audioEngine.stop()
                    inputNode.removeTap(onBus: 0)
                    
                    self.recognitionRequest = nil
                    self.recognitionTask = nil
                    
                    self.locationButton.isEnabled = true
                    let bestTranscription = result?.bestTranscription.formattedString
                    var inDictionary = self.locationDictionary.contains {$0.key == bestTranscription}
                    
                    if inDictionary {
                        self.placeLabel.text = bestTranscription
                        self.userInputLocation = self.locationDictionary[bestTranscription!]!
                    } else{
                        self.placeLabel.text = "No Location Found"
                        self.userInputLocation = FlyoverAwesomePlace.newYorkStatueOfLiberty
                    }
                    self.mapSetup()
                }
            }
            
            let format = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: format){
                buffer, _ in
                self.recognitionRequest?.append(buffer)
            }
            
            audioEngine.prepare()
            
            do{
                try audioEngine.start()
            } catch {
                print("We were not able to start the engine")
            }
            
        }
        

    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var placeLabel: UILabel!
        
        
        
  
    
    @IBAction func locationButtonClicked(_ sender: Any) {
            if audioEngine.isRunning {
                audioEngine.stop()
                recognitionRequest?.endAudio()
                locationButton.isEnabled = false
                locationButton.setTitle("Record", for: .normal)
            } else {
                startRecording()
                locationButton.setTitle("Stop", for: .normal)
            }
            
            
        
            
    //        let rand = locationDictionary.randomElement()!
    //        let camera = FlyoverCamera(mapView: self.mapView, configuration: FlyoverCamera.Configuration(duration: 6.0, altitude: 300, pitch: 45.0, headingStep: 40.0))
    //        camera.start(flyover: rand.value)
    //        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(6), execute: {
    //            camera.stop()
    //        } )
            
    //        placeLabel.text = "\(rand.key)"
        }
        
        func mapSetup() {
            addAnnotations()
            self.mapView.mapType = .hybridFlyover
            self.mapView.showsBuildings = true
            self.mapView.isZoomEnabled = true
            self.mapView.isScrollEnabled = true
            
            let camera = FlyoverCamera(mapView: self.mapView, configuration: FlyoverCamera.Configuration(duration: 4.0, altitude: 30000, pitch: 45.0, headingStep: 20.0))
            camera.start(flyover: self.userInputLocation)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
                camera.stop()
            })
        }
        
        let locationDictionary = [
            "Statue of Liberty": FlyoverAwesomePlace.newYorkStatueOfLiberty,
            "Midtown": FlyoverAwesomePlace.centralParkNY,
            "California": FlyoverAwesomePlace.sanFranciscoGoldenGateBridge,
            "Miami": FlyoverAwesomePlace.miamiBeach,
            "Rome": FlyoverAwesomePlace.romeColosseum,
            "Big Ben": FlyoverAwesomePlace.londonBigBen,
            "London": FlyoverAwesomePlace.londonEye,
            "Paris": FlyoverAwesomePlace.parisEiffelTower,
            "New York": FlyoverAwesomePlace.newYork,
            "Las Vegas": FlyoverAwesomePlace.luxorResortLasVegas
            
        ]

        
    }

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        else{
            let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            
            pin.canShowCallout = true
            pin.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            return pin
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        

        let annView = view.annotation
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController else {
            print("detals vc not founds")
            return
        }
        
        
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension MapViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        self.mapView.showsUserLocation = true
        guard let latestLocation = locations.first else { return }

        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: latestLocation.coordinate, span: span)
        mapView.setRegion(region, animated: true)

        if currentCoordinate == nil{
//            zoomIn(latestLocation.coordinate)
            addAnnotations()
        }

        currentCoordinate = latestLocation.coordinate

    }
}

