//
//  RNUINSwiftViewController.swift
//  RNUINativeExamples
//
//  Created by Hank Brekke on 11/5/18.
//  Copyright © 2018 HouseRater. All rights reserved.
//

import UIKit

class RNUINSwiftViewController: UIViewController, RNUINExampleControllerDelegate {
    func setExample(_ example: [AnyHashable : Any]) {
        self.example = example
    }
    
    var example: [AnyHashable : Any]? = nil
    @IBOutlet var dataButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func getJSDate(_ sender: Any) {
        RNUINativeManager.loadData(withHandler: "SwiftController.getDate()") { (data, error) in
            if let err = error {
                return;
            }
            guard let date = data as? Int else {
                return;
            }
            
            self.dataButton.setTitle("Get Time \(date)", for: .normal)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
