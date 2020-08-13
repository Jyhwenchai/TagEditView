//
//  ViewController.swift
//  TagEditView
//
//  Created by 蔡志文 on 2020/8/13.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func pushAction(_ sender: UIButton) {
        let controller = TagEditViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
}

