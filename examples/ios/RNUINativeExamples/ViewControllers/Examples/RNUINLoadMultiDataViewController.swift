//
//  RNUINLoadDataCrashViewController.swift
//  RNUINativeExamples
//
//  Created by Hank Brekke on 11/8/18.
//  Copyright © 2018 HouseRater. All rights reserved.
//

import UIKit

class RNUINLoadMultiDataViewController: UIViewController {
    @IBOutlet var dataOneLabel: UILabel!
    @IBOutlet var dataTwoLabel: UILabel!
    @IBAction func attemptMultiLoad(_ sender: Any) {
        RNUINativeManager.loadData(withHandler: "LoadMultiData.emitEvent()", arguments: nil, completionBlock: nil)
        RNUINativeManager.loadData(withHandler: "LoadMultiData.loadDataOne()", arguments: nil) { (data, error) in
            self.dataOneLabel.text = "Done"
        }
        RNUINativeManager.loadData(withHandler: "LoadMultiData.emitEvent()", arguments: nil, completionBlock: nil)
        RNUINativeManager.loadData(withHandler: "LoadMultiData.loadDataTwo()", arguments: nil) { (data, error) in
            self.dataTwoLabel.text = "Done"
        }
    }
    
}
