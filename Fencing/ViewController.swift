//
//  ViewController.swift
//  Fencing
//
//  Created by Jeff Ripke on 7/15/17.
//  Copyright © 2017 Jeff Ripke. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    let motionManager = CMMotionManager()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isDeviceAvailable() {
            print("Jeff: Core Motion Launched")
        }
    }
    
    func isDeviceAvailable() -> Bool {
        let gyroAvailable = motionManager.isGyroAvailable
        let accelAvailable = motionManager.isAccelerometerAvailable
        if !motionManager.isAccelerometerAvailable {
            let alert = UIAlertController(title: "Fencing", message: "Your device does not have the necessary sensors. You migt want to try another device", preferredStyle: .alert)
            present(alert, animated: true, completion: nil)
            print("JEFF: Devices not detected")
        }
        return motionManager.isDeviceMotionAvailable
    }
}

