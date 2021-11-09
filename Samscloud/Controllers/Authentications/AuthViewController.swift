//
//  AuthViewController.swift
//  Samscloud
//
//  Created by An Phan on 1/16/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var individualButton: UIButton!
    @IBOutlet weak var responderButton: UIButton!
    
    
    // MARK: - INIT

    override func viewDidLoad() {
        super.viewDidLoad()
        individualButton.roundRadius()
        responderButton.roundRadius()
        
        
    
         let refreshToken =  DefaultManager().getRefreshToken()  ?? ""
     
         if(!refreshToken.isEmpty){
        
         let param = ["refresh":refreshToken]
    
            PSApi.apiRequestWithEndPointSome(.refreshToken, params: param as [String : AnyObject], isShowAlert: true, controller: self, isNeedToken: false) { (response) in
               
                let statusCode = response.response?.statusCode
                if  statusCode == 200 {
                    
                    let refreshData = Refresh.init(dictUserData: response.value?.dictionary ?? [:])
                   
                } else {
                    Utility.SubmitAlertView(viewController: self, title: "Alert!", message: "Opp! Something event wrong")
                }
            }
        }
 
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) 
        navigationController?.isNavigationBarHidden = true
    }
    
    
    // MARK: - IBACTIONS
    
    @IBAction func closeButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func individualButtonAction(_ sender: Any) {
        print("INDIVIDUAL BUTTON ACTION PRESSED")
        userType = "Individual"
    
        let vc = LoginViewController.instanse()
        vc.isToShowBack = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func responderButtonAction(_ sender: Any) {
         userType = "Responder"
         print("Responder BUTTON ACTION PRESSED")
        let dispatchHomeVC = StoryboardManager.dispatchStoryBoard().getController(identifier: "DispatchHomeVC")
        navigationController?.pushViewController(dispatchHomeVC, animated: true)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLoginPageSegue" {
            let navigation = segue.destination as? UINavigationController
            let vc = navigation?.viewControllers.first as? LoginViewController
            vc?.isToShowBack = true
        }
    }
    
}
