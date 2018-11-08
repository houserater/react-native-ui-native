//
//  RNUINAsyncDataViewController.swift
//  RNUINativeExamples
//
//  Created by Hank Brekke on 11/8/18.
//  Copyright © 2018 HouseRater. All rights reserved.
//

import UIKit

class RNUINAsyncDataViewController: UIViewController {
    @IBAction func sendEvent(_ sender: Any) {
        RNUINativeManager.loadData(withHandler: "AsyncData.performDelay()", arguments: nil) { (data, error) in
            let alert = UIAlertController(title: "Delayed Response", message: "Received response from JS bridge", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
