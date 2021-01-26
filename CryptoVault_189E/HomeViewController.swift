//
//  HomeViewController.swift
//  CryptoVault_189E
//
//  Created by utkarsh opalkar on Jan/25/21.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        // Do any additional setup after loading the view.
    }
    
    func initUI(){
        self.navigationController?.navigationBar.isHidden = true
    }
    
}
