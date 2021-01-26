//
//  ViewController.swift
//  CryptoVault_189E
//
//  Created by utkarsh opalkar on Jan/12/21.
//

import UIKit
import PhoneNumberKit

class ViewController: UIViewController {

    @IBOutlet weak var countryCodeTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var phoneNumberTextField: PhoneNumberTextField!
    
    var tapOut = UITapGestureRecognizer()
    let phoneNumberKit = PhoneNumberKit()
    
    var phoneNumber: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapOut = UITapGestureRecognizer(target:self, action: #selector(dismissKeypad))
        self.view.addGestureRecognizer(tapOut)
    }

    @objc func dismissKeypad(){
        phoneNumberTextField.resignFirstResponder()
    }
    

    @IBAction func sendOtpTapped(_ sender: Any) {
        let phoneNumber = phoneNumberTextField.text?.filter { $0 >= "0" && $0 <= "9" } ?? ""
        if phoneNumber.count == 10 {
            
            do {
                let parsedPhoneNumber = try phoneNumberKit.parse(phoneNumberTextField.text ?? "") //, withRegion: "US"
                let areaCode = parsedPhoneNumber.regionID ?? ""
                print("\n\n\nareaCode: ",areaCode)
                print("\n\n\nparsedPhoneNumber: ",parsedPhoneNumber)
                
                if(areaCode == "US") {
                    self.phoneNumber = phoneNumberKit.format(parsedPhoneNumber, toType: .e164)
                    print("\n\n phone number e164: ",self.phoneNumber)
                }
                else{
                    errorLabel.text = "Area Code issue!"
                    errorLabel.textColor = .red
                    errorLabel.isHidden = false
                }
                
                dismissKeypad()
                
                //send out an OTP to self.phoneNumber
                sendOtpApiCall()
            }
            catch {
                errorLabel.text = "Please enter a valid phone number"
                errorLabel.textColor = .red
            }
            
        }
        else if phoneNumber.count == 0 {
            
            errorLabel.text = "Please enter your phone number first!"
            errorLabel.textColor = .red
            
        }
        else if phoneNumber.count != 10 {
            
            errorLabel.text = "Phone number must be 10 digits!"
            errorLabel.textColor = .red
            
        }
        
        errorLabel.isHidden = false
    }
    
    func sendOtpApiCall(){
        self.view.isUserInteractionEnabled = false
        //make API call
        print("\n\n\nself.phoneNumber: ",self.phoneNumber)
        Api.sendVerificationCode(phoneNumber: self.phoneNumber) { (response, error) in
            self.view.isUserInteractionEnabled = true
            
            //if error exists, display in error label
            if let error = error {
                print("Error: \(error)")
                self.errorLabel.text = error.message
                self.errorLabel.textColor = .red
                return
            } else {
                
                //if no error, display success msg in error label
                print("Response: \(String(describing: response))")
                self.errorLabel.text = "Verification code has been sent to \(self.phoneNumber))"
                self.errorLabel.textColor = .green
                
                //programatically creating the verify OTP VC
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let verifyOTPVC = storyboard.instantiateViewController(identifier: "VerifyOTPViewController") as! VerifyOTPViewController
                
                //need to pass the phone number from Login VC to Verify OTP VC so it can be used to resend from there directly
                verifyOTPVC.phoneNumber = self.phoneNumber
                
                //push Verify OTP VC onto the view-stack with an animation
                self.navigationController?.pushViewController(verifyOTPVC, animated: true)
            }
        }
        
    }
    
}

