//
//  VerifyOTPViewController.swift
//  CryptoVault_189E
//
//  Created by utkarsh opalkar on Jan/20/21.
//

import UIKit

class VerifyOTPViewController: UIViewController {
    
    @IBOutlet weak var code6: UITextField!
    @IBOutlet weak var code5: UITextField!
    @IBOutlet weak var code4: UITextField!
    @IBOutlet weak var code3: UITextField!
    @IBOutlet weak var code2: UITextField!
    @IBOutlet weak var code1: UITextField!
    
    @IBOutlet weak var resendCode: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    
    var phoneNumber: String = ""
    var fullCode: [UITextField] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        fullCode = [code1, code2, code3, code4, code5, code6]
        
        code1.addTarget(self, action: #selector(self.valueDidChange(textField:)), for:.editingChanged)
        code2.addTarget(self, action: #selector(self.valueDidChange(textField:)), for:.editingChanged)
        code3.addTarget(self, action: #selector(self.valueDidChange(textField:)), for:.editingChanged)
        code4.addTarget(self, action: #selector(self.valueDidChange(textField:)), for:.editingChanged)
        code5.addTarget(self, action: #selector(self.valueDidChange(textField:)), for:.editingChanged)
        code6.addTarget(self, action: #selector(self.valueDidChange(textField:)), for:.editingChanged)
        
    }
    
    func initUI(){
        print("\nYour phone number is: ", self.phoneNumber)
        code1.becomeFirstResponder()
    }
    
    
    
    @objc func valueDidChange(textField: UITextField){
        let codeTextCount = textField.text?.count ?? 0
        if codeTextCount == 1{
            switch textField{
            case code1:
                currentKeyBoard(currTextField: code2)
            case code2:
                currentKeyBoard(currTextField: code3)
            case code3:
                currentKeyBoard(currTextField: code4)
            case code4:
                currentKeyBoard(currTextField: code5)
            case code5:
                currentKeyBoard(currTextField: code6)
            case code6:
                code6.resignFirstResponder()
                code1.isUserInteractionEnabled = true

                let codeEntered = fullCode.compactMap {$0.text}.joined()
                
                //verify if codeEntered and the one sent by the api are the same
                Api.verifyCode(phoneNumber: self.phoneNumber, code: codeEntered){ (response, error) in
                    
                    //proceed to Home controller if no error
                    if (error == nil){
                        self.errorLabel.text = "Code is correct. HW2 conpleted successfully!!!"
                        self.errorLabel.textColor = .green
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let homeVC = storyboard.instantiateViewController(identifier: "HomeViewController") as! HomeViewController

                        self.navigationController?.pushViewController(homeVC, animated: true)
                    }
                    
                    //display error if error exists
                    else{
                        self.errorLabel.text = "Incorrect code.. re-enter correct OTP code or tap on 'Resend Code' to re-send a new one!"
                        self.errorLabel.textColor = .red
                        self.clearAllCodes()
                    }
                    self.errorLabel.isHidden = false
                }
            default:
                break
            }
        }
    }
  
    
    @IBAction func resendOTPCode(_ sender: Any) {
        Api.sendVerificationCode(phoneNumber: self.phoneNumber){ (response, error) in
            if let error = error {
                print("Error sending OTP code: \(error).")
                self.errorLabel.text = error.message
                self.errorLabel.textColor = .red
                return
            } else {

                //if no error, display success msg in error label
                print("Response: \(String(describing: response))")
                self.errorLabel.text = "Verification code has been re-sent to \(self.phoneNumber))"
                self.errorLabel.textColor = .green
                self.clearAllCodes()
            }
        }
    }
    
    
    func clearAllCodes() {
        code1.text = ""
        code2.text = ""
        code3.text = ""
        code4.text = ""
        code5.text = ""
        code6.text = ""
        code1.isUserInteractionEnabled = true
        code1.becomeFirstResponder()
    }
    
    
    @IBAction func clearOTPtextfields(_ sender: Any) {
        clearAllCodes()
    }
    
    func currentKeyBoard(currTextField: UITextField){
        currTextField.isUserInteractionEnabled = true
        currTextField.becomeFirstResponder()
        for tf in fullCode {
            if currTextField != tf {
                tf.isUserInteractionEnabled = false
            }
        }
        
    }
    
}


