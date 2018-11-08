//
//  RNUINSwiftViewController.swift
//  RNUINativeExamples
//
//  Created by Hank Brekke on 11/5/18.
//  Copyright © 2018 HouseRater. All rights reserved.
//

import UIKit

class RNUINSwiftEventViewController: UIViewController {
    var rootView: RCTRootView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        if let rootView = RCTRootView(bridge: delegate.bridge, moduleName: "SwiftEventView", initialProperties: nil) {
            rootView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: self.view.frame.size)
            rootView.autoresizingMask = [ .flexibleHeight, .flexibleWidth ]
            
            self.view.addSubview(rootView)
            self.rootView = rootView
        }
        
        RNUINativeManager.addEventListener("SwiftEvent.buttonTapped", eventBlock: { [unowned self] (data) in
            guard let response = data as? [String: Int] else {
                return;
            }
            
            let alert = UIAlertController(title: "Button Tapped", message: "Current JS time: \(response["time"]!)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }, withController: self)
    }
}
