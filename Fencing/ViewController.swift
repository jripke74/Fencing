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
    let altimeter = CMAltimeter()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isDeviceAvailable() {
            print("Jeff: Core Motion Launched")
            //myDeviceMotion()
            myAltimeter()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        motionManager.stopDeviceMotionUpdates()
        timer.invalidate()
        altimeter.stopRelativeAltitudeUpdates()
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
                let rot = deviceMotion.attitude
                if rot.pitch > 1.4 && rot.pitch < 1.57 {
                    print("Salute ---------ON GARDE")
                }
                if accel.y >= 2.0 {
                    var gyro = CMRotationRate()
                    if self.motionManager.isGyroAvailable {
                        gyro = deviceMotion.rotationRate
                        print(String(format: "Rotation Rate Z: %7.4f", gyro.z))
                    } else {
                        print("Gyro not available.")
                    }
                    var slashAxis = gyro.z
                    if abs(rot.roll) > 0.79 {
                        slashAxis = gyro.x
                    }
                    if slashAxis > 4.0 || slashAxis < -4.0 {
                        print("/////////Slash\\\\\\\\\\")
                    } else {
                        print("*********Thrust***********")
                    }
                } else {
                    var parryAxis = accel.x
                    if abs(rot.roll) > 0.79 {
                        parryAxis = accel.z
                    }
                    if parryAxis <= -1.0 || parryAxis >= 1.0 {
                        print("===========Parry==========")
                    }
                }

            }
        })
    }
    
    func myAltimeter() {
        var first = true
        var firstPresure = 0.0
        if CMAltimeter.isRelativeAltitudeAvailable() {
            altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main, withHandler: { (altitude, error) in
                if let altitude = altitude {
                    let pressure = altitude.pressure as! Double
                    let relAltitude = altitude.relativeAltitude as! Double
                    if first {
                        firstPresure = pressure
                        first = false
                    }
                    let presureChange = firstPresure - pressure
                    print("JEFF: Presure \(pressure) Pressure Change \(presureChange)  Altitude Change \(relAltitude)")
                }
            })
        } else {
            print("JEFF: No Altimeter Available")
        }
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

