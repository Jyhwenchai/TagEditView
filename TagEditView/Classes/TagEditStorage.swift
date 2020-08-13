//
//  TagEditStorage.swift
//  Luobo
//
//  Created by 蔡志文 on 2020/8/12.
//  Copyright © 2020 didong. All rights reserved.
//

import UIKit

class TagEditStorage: NSTextStorage {
    var storeAttributedString: NSMutableAttributedString = NSMutableAttributedString()
}

extension TagEditStorage {
    override var string: String {
        return storeAttributedString.string
    }

    override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [NSAttributedString.Key : Any] {
        return storeAttributedString.attributes(at: location, effectiveRange: range)
    }
    
    override func replaceCharacters(in range: NSRange, with str: String) {
        beginEditing()
        storeAttributedString.replaceCharacters(in: range, with: str)
        edited(.editedCharacters, range: range, changeInLength: str.count - range.length)
        endEditing()
    }
    
    override func replaceCharacters(in range: NSRange, with attrString: NSAttributedString) {
        beginEditing()
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 18.0
        let mutAttrString = NSMutableAttributedString(attributedString: attrString)
        mutAttrString.addAttributes([NSAttributedString.Key.paragraphStyle: style], range: NSRange(location: 0, length: attrString.length))
        
        storeAttributedString.replaceCharacters(in: range, with: mutAttrString)
        edited(.editedCharacters, range: range, changeInLength: mutAttrString.length - range.length)
        endEditing()
    }
    
    override func setAttributes(_ attrs: [NSAttributedString.Key : Any]?, range: NSRange) {
        beginEditing()
        storeAttributedString.setAttributes(attrs, range: range)
        edited(.editedAttributes, range: range, changeInLength: 0)
        endEditing()
    }
    

    
}
