//
//  UILabelWrapper.swift
//  View
//
//  Created by JuYoung choi on 7/22/25.
//

import UIKit
import SwiftUI

/// text에 포커싱할때
struct UILabelFocusingWrapper: UIViewRepresentable {
    
    var text: String
    var focusing: String
    
    var textColor: UIColor = .black
    
    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .gray
        label.numberOfLines = 1
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingTail
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        label.text = text
        
        setFocusingText(label: label)
        
        return label
    }
    
    /// 텍스트 포커싱
    private func setFocusingText(label: UILabel) {
        
        let attributedString = NSMutableAttributedString(string: text)
        let attribute: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 15),
            .foregroundColor: UIColor.darkGray
        ]
        
        let baseText = text as NSString
        var searchRange = NSRange(location: 0, length: baseText.length)
        
        while true {
            
            let range = baseText.range(of: focusing, options: [], range: searchRange)
            if range.location == NSNotFound {
                break
            }
            
            attributedString.addAttributes(attribute, range: range)
            
            let nextLoc = range.location + range.length
            
            if nextLoc >= baseText.length {
                break
            }
            searchRange = NSRange(location: nextLoc, length: baseText.length - nextLoc)
        }
        
        label.attributedText = attributedString
    }
    
    func updateUIView(_ uiView: UILabel, context: Context) {
        
        uiView.text = text
        setFocusingText(label: uiView)
    }
}
