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


class MapViewController: UIViewController, MKMapViewDelegate, SFSpeechRecognizerDelegate {
    
    var userInputLocation = FlyoverAwesomePlace.newYork
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale.init(identifier: "en-us"))
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()

    override func viewDidLoad() {
            super.viewDidLoad()
            
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
            self.mapView.mapType = .hybridFlyover
            self.mapView.showsBuildings = true
            self.mapView.isZoomEnabled = true
            self.mapView.isScrollEnabled = true
            
            let camera = FlyoverCamera(mapView: self.mapView, configuration: FlyoverCamera.Configuration(duration: 4.0, altitude: 6000, pitch: 45.0, headingStep: 20.0))
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

