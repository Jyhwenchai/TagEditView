//
//  ChooseSkillLabelViewController.swift
//  Luobo
//
//  Created by 蔡志文 on 2020/8/10.
//  Copyright © 2020 didong. All rights reserved.
//

import UIKit

class TagEditViewController: UIViewController {

    let textView = TagEditView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        textView.frame = CGRect(x: 10, y: 100, width: view.bounds.width - 20, height: 200)
        textView.backgroundColor = UIColor.gray
        view.addSubview(textView)
    }
}
