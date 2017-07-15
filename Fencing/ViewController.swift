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
    let interval = 0.01
    var timer = Timer()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isDeviceAvailable() {
            print("Jeff: Core Motion Launched")
            myDeviceMotion()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        motionManager.stopDeviceMotionUpdates()
        timer.invalidate()
    }
    func isDeviceAvailable() -> Bool {
//        let gyroAvailable = motionManager.isGyroAvailable
//        let accelAvailable = motionManager.isAccelerometerAvailable
        if !motionManager.isAccelerometerAvailable {
            let alert = UIAlertController(title: "Fencing", message: "Your device does not have the necessary sensors. You migt want to try another device", preferredStyle: .alert)
            present(alert, animated: true, completion: nil)
            print("JEFF: Device not detected")
        }
        return motionManager.isDeviceMotionAvailable
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: { (timer) in
            if let deviceMotion = self.motionManager.deviceMotion {
                let accel = deviceMotion.userAcceleration
                print(String(format: "X: %7.4 Y: %7.4f", accel.y))
                if accel.y >= 2.0 {
                    print("*********Thrust***********")
                } else {
                    if accel.x <= -1.0 || accel.x >= 1.0 {
                        print("===========Parry==========")
                    }
                }
            }
        })
    }
    
    func myDeviceMotion() {
        motionManager.deviceMotionUpdateInterval = interval
        // pull
        motionManager.startDeviceMotionUpdates()
        startTimer()
        /*
        // normally don't use main for motion
        // push
        motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { (deviceMotion, error) in
            if let deviceMotion = deviceMotion {
                print("JEFF: \(deviceMotion.userAcceleration.x) \(Date())")
            }
        }
        */
    }
}

