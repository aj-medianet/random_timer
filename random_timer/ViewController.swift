//
//  ViewController.swift
//  random_timer
//
//  Created by Andrew Joseph on 11/23/17.
//  Copyright © 2017 AJ Media. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //MARK: Properties
    @IBOutlet weak var minTimePicker: UIPickerView!
    @IBOutlet weak var maxTimePicker: UIPickerView!
    @IBOutlet weak var minTimeTextField: UITextField!
    @IBOutlet weak var maxTimeTextField: UITextField!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var tick: UILabel!
    @IBOutlet weak var tock: UILabel!
    
    
    //get time variables
    var minArray = [String]()
    var maxArray = [String]()
    var minTime = 1
    var maxTime = 5
    var seconds = 10
    //timer variables
    var timer = Timer()
    var isTimerRunning = false
    //haptic feedback
    let selection = UISelectionFeedbackGenerator()
    //audio player
    var player: AVAudioPlayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //set colors
        //view.backgroundColor = UIColor.darkGray
        
        minTimePicker.dataSource = self
        minTimePicker.delegate = self
        maxTimePicker.dataSource = self
        maxTimePicker.delegate = self
        
        minArray = ["1","2","3","4","5","6","7","8","9","10","20","30","40","50","60","90","120"]
        maxArray = ["5","10","20","30","40","50","60","90","120","150","180","210","240","270","300","330","360"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //change color of pickerView text...
    /*
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        if let view = view as? UILabel { label = view }
        else { label = UILabel() }
        
        label.textColor = UIColor.orange
        label.tintColor = UIColor.orange
        
        return label
    }*/
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView == minTimePicker) {
            return minArray[row]
        } else {
            return maxArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView == minTimePicker) {
            return minArray.count
        } else {
            return minArray.count
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView == minTimePicker) {
            minTime = Int(minArray[row])!
        } else {
            maxTime = Int(maxArray[row])!
        }
    }
    
    //MARK: Actions
    @IBAction func startTimer(_ sender: UIButton) {
        if (maxTime > minTime) {
            let maxMin = maxTime - minTime
        
            //convert times into UInt32 for random generation
            let minimumTime:UInt32? = UInt32(minTime)
            let maximumTime:UInt32? = UInt32(maxMin)
            
            //generate random number
            seconds = Int(arc4random_uniform(maximumTime!) + minimumTime!)
            
            selection.selectionChanged()
            if (isTimerRunning == false) {
                runTimer()
            } else {
                timer.invalidate()
                runTimer()
            }
            
        } else {
            timer.invalidate()
            self.startButton.shake()
            self.tick.stopBlinking()
            self.tock.stopBlinking()
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
    
    func runTimer() {
        isTimerRunning = true
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.beep)), userInfo: nil, repeats: true)
    }
    
    @objc func beep() {
        if (seconds < 1) {
            timer.invalidate()
            isTimerRunning = false
            self.tick.stopBlinking()
            self.tock.stopBlinking()
            //playSound()
            AudioServicesPlaySystemSound(SystemSoundID(1023))
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        } else {
            self.tick.startBlinking()
            seconds -= 1
            self.tock.startBlinkingTwo()
            //print(seconds)
        }
    }
    
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "beep", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
}


public extension UIButton {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}

public extension UILabel {
    
    //Tells the label to start blinking
    public func startBlinking() {
        let options : UIViewAnimationOptions = .repeat
        UIView.animate(withDuration: 1, delay:0.0, options:options, animations: {
            self.alpha = 1
        }, completion: nil)
    }
    
    public func startBlinkingTwo() {
        let options : UIViewAnimationOptions = .repeat
        UIView.animate(withDuration: 1, delay:0.5, options:options, animations: {
            self.alpha = 1
        }, completion: nil)
    }
    
    
    //Tells the label to stop blinking.
    public func stopBlinking() {
        alpha = 0
        layer.removeAllAnimations()
    }
}

struct Style {
    
    
    
    
    
    
    
}
