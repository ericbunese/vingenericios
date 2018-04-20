//
//  ViewController.swift
//  vingenericIos
//
//  Created by Eric Bunese on 20/04/2018.
//  Copyright © 2018 Eric Bunese. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate{

  //MARK: Objects
  
  @IBOutlet weak var offsetLabel: UILabel!
  @IBOutlet weak var offsetLabel2: UILabel!
  @IBOutlet weak var offsetStepper: UIStepper!
  @IBOutlet weak var offsetStepper2: UIStepper!
  @IBOutlet weak var textFieldChave: UITextField!
  @IBOutlet weak var textFieldClaro: UITextField!
  @IBOutlet weak var textFieldCifrado: UITextField!
  
  let ving = Vingenere()
  var prod = 3
  var keyboardHeight: CGFloat = 0.0

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    self.textFieldChave.delegate = self
    self.textFieldClaro.delegate = self
    self.textFieldCifrado.delegate = self
    
    self.offsetStepper.maximumValue = Double(self.ving.const.count)
    self.offsetStepper2.maximumValue = Double(self.ving.const.count)
    
    self.offsetLabel.text = "Offset1: \(Int(self.offsetStepper.value))"
    self.offsetLabel2.text = "Offset2: \(Int(self.offsetStepper2.value))"
    self.prod = Int(self.offsetStepper2.value)*Int(self.offsetStepper.value)
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillShow),
      name: NSNotification.Name.UIKeyboardWillShow,
      object: nil
    )
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  //MARK: Actions
  @IBAction func pressedCifrar(_ sender: Any) {
    self.textFieldCifrado.text = self.ving.encode(prod: self.prod)
  }
  
  @IBAction func actionDecifrar(_ sender: Any) {
    self.textFieldClaro.text = self.ving.decode(prod: self.prod)
  }
  
  //MARK: UITextFieldDelegate
  func textFieldDidBeginEditing(_ textField: UITextField) {
    self.animateViewMoving(moveValue: CGFloat.minimum(-(textField.frame.minY-self.keyboardHeight), 0.0))
  }
  
  @IBAction func offsetStepperChanged(_ sender: Any) {
    self.offsetLabel.text = "Offset1: \(Int(self.offsetStepper.value))"
    self.prod = Int(self.offsetStepper2.value)*Int(self.offsetStepper.value)
  }
  
  @IBAction func offsetStepper2Changed(_ sender: Any) {
    self.offsetLabel2.text = "Offset2: \(Int(self.offsetStepper2.value))"
    self.prod = Int(self.offsetStepper2.value)*Int(self.offsetStepper.value)
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    // User finished typing (hit return): hide the keyboard.
    textField.resignFirstResponder()
    self.animateViewMoving(moveValue: nil)
    
    if textField == self.textFieldChave {
      self.ving.key = textField.text!
    }
    else if textField == self.textFieldClaro {
      self.ving.text = textField.text!
    }
    else if textField == self.textFieldCifrado {
      self.ving.cypher = textField.text!
    }
    return true
  }
  
  func animateViewMoving (moveValue :CGFloat?){
    var center: CGPoint
    if moveValue != nil {
      center = CGPoint(x: 0.0, y: moveValue!)
    }
    else {
      center = CGPoint(x: 0.0, y: 0.0)
    }
    let size = CGSize(width: view.frame.size.width, height: view.frame.size.height)
    let resetFrame = CGRect(origin: center, size: size)
    let movementDuration:TimeInterval = 0.3
    //let movement:CGFloat = moveValue
    UIView.beginAnimations( "animateView", context: nil)
    UIView.setAnimationBeginsFromCurrentState(true)
    UIView.setAnimationDuration(movementDuration )
    self.view.frame = resetFrame
    UIView.commitAnimations()
  }
  
  @objc func keyboardWillShow(_ notification: Notification) {
    if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
        let keyboardRectangle = keyboardFrame.cgRectValue
        self.keyboardHeight = keyboardRectangle.height
    }
}
}

