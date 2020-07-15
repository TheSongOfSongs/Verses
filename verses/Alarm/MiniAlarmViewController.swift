//
//  MiniAlarmViewController.swift
//  verses
//
//  Created by Jinhyang on 2020/07/02.
//  Copyright © 2020 Jinhyang. All rights reserved.
//

import UIKit

class MiniAlarmViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        let width = self.view.frame.width
        let height = CGFloat(200)
        
        self.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
    }
    
    @IBAction func setTime(_ sender: UIButton) {
        
        
    }
    
}
