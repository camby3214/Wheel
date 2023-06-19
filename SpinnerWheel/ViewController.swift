//
//  ViewController.swift
//  SpinnerWheel
//
//  Created by 李韋辰 on 2023/6/16.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func onPress(_ sender: Any) {
        let vc = AssetsManager().getViewController(fromMain: "SpinWheelViewController")
        self.present(vc, animated: true)
    }
    
}

