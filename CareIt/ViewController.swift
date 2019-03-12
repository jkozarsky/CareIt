//
//  ViewController.swift
//  CareIt
//
//  Created by Jason Kozarsky (student LM) on 1/3/19.
//  Copyright © 2019 Jason Kozarsky (student LM). All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // hides the navigation bar because there is nowhere to navigate to that does not use the buttons
        navigationController?.navigationBar.isHidden = true
        
        //segues to the home screen view controller if the user is logged in
        if let user = Auth.auth().currentUser{
            self.performSegue(withIdentifier: "toHomeScreen", sender: self)
        }
        
        //THIS CODE IS TO TEST STUFF FOR JASON
//        let databaseReq = DatabaseRequests(barcodeString: "602652247798")
//        databaseReq.request(beforeLoading:{print("Request started")}, afterLoading: {print("Request finished")})
//
//        if let nutrients = databaseReq.result?.nutrients{
//            print("there are nutrients")
//            for n in nutrients{
//                for m in n.measures{
//                    print("There are \(m.value) grams of \(n.name)")
//                }
//            }
//        }
//        else{
//            print("could not get results")
//        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//this extension is for the back buttons on the sign up
//and log in view controllers -Jason
extension ViewController {
    
    @IBAction func backToMainViewController(_ segue: UIStoryboardSegue) {
    }
}
