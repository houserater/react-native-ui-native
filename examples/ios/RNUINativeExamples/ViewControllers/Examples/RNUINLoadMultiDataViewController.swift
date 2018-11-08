//
//  RNUINLoadDataCrashViewController.swift
//  RNUINativeExamples
//
//  Created by Hank Brekke on 11/8/18.
//  Copyright © 2018 HouseRater. All rights reserved.
//

import UIKit

class RNUINLoadMultiDataViewController: UIViewController, RNUINExampleControllerDelegate {
    func setExample(_ example: [AnyHashable : Any]) {
        // Discard example (as input arguments are not needed by this example)
    }
    
    @IBOutlet var dataOneLabel: UILabel!
    @IBOutlet var dataTwoLabel: UILabel!
    @IBAction func attemptMultiLoad(_ sender: Any) {
        RNUINativeManager.loadData(withHandler: "MultiLoadDataController.emitEvent()", arguments: nil, completionBlock: nil)
        RNUINativeManager.loadData(withHandler: "MultiLoadDataController.loadDataOne()", arguments: nil) { (data, error) in
            self.dataOneLabel.text = "Done"
        }
        RNUINativeManager.loadData(withHandler: "MultiLoadDataController.emitEvent()", arguments: nil, completionBlock: nil)
        RNUINativeManager.loadData(withHandler: "MultiLoadDataController.loadDataTwo()", arguments: nil) { (data, error) in
            self.dataTwoLabel.text = "Done"
        }
    }
    
}
