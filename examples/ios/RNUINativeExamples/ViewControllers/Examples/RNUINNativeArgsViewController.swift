//
//  RNUINNativeArgsViewController.swift
//  RNUINativeExamples
//
//  Created by Hank Brekke on 11/8/18.
//  Copyright © 2018 HouseRater. All rights reserved.
//

import UIKit

class RNUINNativeArgsViewController: UIViewController {
    @IBAction func sendEvent(_ sender: Any) {
        let uuid = UUID().uuidString
        RNUINativeManager.loadData(withHandler: "NativeArgs.submitUUID()", arguments: [uuid]) { (data, error) in
            if let err = error {
                let message = "JS error: \(err.localizedDescription)"
                let alert = UIAlertController(title: "JS Error", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return;
            }
            guard let uuid = data as? String else {
                let alert = UIAlertController(title: "Casting Error", message: "Unable to parse JS data", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return;
            }
            
            let alert = UIAlertController(title: "UUID Response", message: "Received \(uuid)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
