//
//  TagTextContainer.swift
//  Luobo
//
//  Created by 蔡志文 on 2020/8/13.
//  Copyright © 2020 didong. All rights reserved.
//

import UIKit

class TagEditContainer: NSTextContainer {

    var lineFragmentRect: CGRect = .zero
    
    override func lineFragmentRect(forProposedRect proposedRect: CGRect, at characterIndex: Int, writingDirection baseWritingDirection: NSWritingDirection, remaining remainingRect: UnsafeMutablePointer<CGRect>?) -> CGRect {

        let result = super.lineFragmentRect(forProposedRect: proposedRect, at: characterIndex, writingDirection: baseWritingDirection, remaining: remainingRect)
        lineFragmentRect = result
        return result
    }
}
