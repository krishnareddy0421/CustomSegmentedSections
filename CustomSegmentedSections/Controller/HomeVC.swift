//
//  ViewController.swift
//  CustomSegmentedSections
//
//  Created by vamsi krishna reddy kamjula on 10/19/17.
//  Copyright © 2017 kvkr. All rights reserved.
//

import UIKit
import TwicketSegmentedControl

class HomeVC: UIViewController, TwicketSegmentedControlDelegate {

    // MARK: - Outlets
    @IBOutlet weak var customSegmentCntrl: TwicketSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customSegmentCntrl.delegate = self
        customSegmentCntrl.setSegmentItems(["New", "Top", "Fun"])
        DataService.instance.getArticleData(urlString: BUSINESS_URL) { (success) in
            if success {
                // ui update
            } else {
                // error handling
            }
        }
    }

    func didSelect(_ segmentIndex: Int) {
        print(segmentIndex)
    }
}

