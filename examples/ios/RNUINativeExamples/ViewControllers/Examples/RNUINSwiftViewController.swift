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
        // Discard example (as input arguments are not needed by this example)
    }
    
    @IBOutlet var dataButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func getJSDate(_ sender: Any) {
        RNUINativeManager.loadData(withHandler: "SwiftController.getDate()", arguments: nil) { (data, error) in
            if let err = error {
                let message = "JS error: \(err.localizedDescription)"
                let alert = UIAlertController(title: "JS Error", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return;
            }
            guard let date = data as? Int else {
                let alert = UIAlertController(title: "Casting Error", message: "Unable to parse JS data", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return;
            }
            
            self.dataButton.setTitle("Get Time \(date)", for: .normal)
        }
    }
}
