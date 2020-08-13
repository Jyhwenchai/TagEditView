//
//  TagEditTextView.swift
//  Luobo
//
//  Created by 蔡志文 on 2020/8/12.
//  Copyright © 2020 didong. All rights reserved.
//

import UIKit

class TagEditView: UITextView {
    
    let tagStorage = TagEditStorage()
    let tagLayoutManager = NSLayoutManager()
    let tagContainer = TagEditContainer()
    
    var tagButtons: [UIButton] = []
    private var originTextContainerInset: UIEdgeInsets = .zero  // set once
    private let tagHeight: CGFloat = 22.0
    
    
    init() {
        tagStorage.addLayoutManager(tagLayoutManager)
        tagLayoutManager.addTextContainer(tagContainer)
        super.init(frame: CGRect.zero, textContainer: tagContainer)
        originTextContainerInset = self.textContainerInset
        delegate = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tagContainer.size = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func caretRect(for position: UITextPosition) -> CGRect {
        var rect = super.caretRect(for: position)
       
        var lineCount = 0
        
        tagLayoutManager.enumerateLineFragments(forGlyphRange: NSRange(location: 0, length: text.count)) { (rect, usedRect, textContainer, range, stopPointer) in
            lineCount += 1
        }
        
//        rect.origin.y =  max(tagContainer.lineFragmentRect.origin.y, textContainerInset.top)
        rect.origin.y =  lineCount >= 2 ? tagContainer.lineFragmentRect.origin.y : textContainerInset.top
        rect.size.height = 22.0
        return rect
    }
    
}

// MARK: - UITextViewDelegate
extension TagEditView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let deleteText = textView.text ?? ""
        
        if text.isEmpty, deleteText.isEmpty {
            deleteTagButton()
            updateAllButtonsFrame()
            updateExclusionPath()
        }
        
        if [",", "，"].contains(text) {
            addTagButton()
            updateExclusionPath()
            textView.text = ""
            return false
        }
        return true
    }
}

// MARK: - TextView exclusion path operator
extension TagEditView {
    
    func updateExclusionPath() {
        // 除了最后一行外的上半部分区域
        var blockExclusionRect: CGRect = CGRect(x: self.textContainerInset.left, y: originTextContainerInset.top, width: bounds.width, height: 0)
        // 最后一行即将输入的文本左侧区域
        var lineExclusionRect: CGRect = .zero
        
        let spacing: CGSize = CGSize(width: 15, height: 18)
        let remainSpacing: CGFloat = 12.0
        var lineCount = 0
        var wrapLine = false
        
        tagButtons.forEach { item in
            // 如果上次计算的结果是换行那么当前项的 x 位置重置为 0
            let x = wrapLine ? 0 : lineExclusionRect.maxX
            wrapLine = x + spacing.width + item.frame.width + originTextContainerInset.left + originTextContainerInset.right + remainSpacing >= bounds.width
            let height = wrapLine ? lineExclusionRect.height + blockExclusionRect.height + spacing.height : blockExclusionRect.height
            if wrapLine {
                blockExclusionRect.size.height = height
                lineCount += 1
            }
                
            lineExclusionRect = CGRect(x: originTextContainerInset.left, y: blockExclusionRect.height, width: item.frame.maxX + spacing.width, height: item.frame.height)
            
        }
        
        let blockExclusionPath = UIBezierPath(rect: blockExclusionRect)
        let lineExclusionPath = UIBezierPath(rect: lineExclusionRect)
    
        let marginTop = CGFloat(lineCount) * (spacing.height + tagHeight)
        textContainerInset.top = marginTop + originTextContainerInset.top
        tagContainer.exclusionPaths = [blockExclusionPath, lineExclusionPath]
    }
    
}

// MARK: - Tag button operation
extension TagEditView {
    func addTagButton() {
        let button = createTagButton(with: text)
        tagButtons.append(button)
        updateButtonFrame(button, at: tagButtons.count-1)
        addSubview(button)
    }
    
    func deleteTagButton() {
        if tagButtons.count == 0 {
            return
        }
        let deleteBeforeItemCount = tagButtons.count
        tagButtons.removeAll { button -> Bool in
            if button.isSelected {
                button.removeFromSuperview()
            }
            return button.isSelected
        }
        if deleteBeforeItemCount == tagButtons.count {
            let deleteButton = tagButtons.removeLast()
            deleteButton.removeFromSuperview()
        }
    }
    
    func updateAllButtonsFrame() {
        for (index, button) in tagButtons.enumerated() {
           updateButtonFrame(button, at: index)
        }
    }
    
    func updateButtonFrame(_ button: UIButton, at index: Int) {
        let spacing: CGSize = CGSize(width: 15, height: 18)
        if index > 0 {
            let lastButton = tagButtons[index - 1]
            let wrapLine = lastButton.frame.maxX + spacing.width + button.bounds.width + originTextContainerInset.left + originTextContainerInset.right > bounds.width
            let x = wrapLine ? textContainerInset.left : lastButton.frame.maxX + spacing.width
            let y = wrapLine ? lastButton.frame.maxY + spacing.height : lastButton.frame.minY
            
            let origin = CGPoint(x: x, y: y)
            button.frame.origin = origin
        } else {
            button.frame.origin = CGPoint(x: originTextContainerInset.left, y: originTextContainerInset.top - 2)
        }
    }
    
    func createTagButton(with text: String) -> UIButton {
        let button = TagEditButton()
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.systemYellow, for: .selected)
        button.layer.cornerRadius = tagHeight / 2.0
        button.layer.borderWidth = 1.0
        button.borderColor = UIColor.white
        button.selectedBorderColor = UIColor.systemYellow
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        button.sizeToFit()
        button.frame = CGRect(x: 0, y: 0, width: button.bounds.width, height: tagHeight)
        button.addTarget(self, action: #selector(tagButtonAction(sender:)), for: .touchUpInside)
        return button
    }
    
}


extension TagEditView {
    @objc func tagButtonAction(sender: UIButton) {
        sender.isSelected.toggle()
    }
}


class TagEditButton: UIButton {
    
    var borderColor: UIColor = .white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    var selectedBorderColor: UIColor = .white
    
    override var isSelected: Bool {
        didSet {
            layer.borderColor = isSelected ? selectedBorderColor.cgColor : borderColor.cgColor
        }
    }
}
