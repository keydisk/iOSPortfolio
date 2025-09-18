//
//  StringExtension.swift
//  Common
//
//  Created by JuYoung choi on 7/22/25.
//
import Foundation

public extension String {
    
    var htmlStripped: String {
        guard let data = self.data(using: .utf8) else {
            return self
        }
        
        do {
            let attributed = try NSAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil)
            
            return attributed.string
        } catch {
            print("HTML 파싱 실패:", error.localizedDescription)
            return self
        }
    }
}
