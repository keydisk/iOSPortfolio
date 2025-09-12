//
//  DateExtension.swift
//  Common
//
//  Created by JuYoung choi on 7/21/25.
//

import Foundation

/// Date 확장
public extension Date {
    
    /// 문자열로 데이트 객체 생성
    /// - Parameters:
    ///   - string: 날짜 문자열
    ///   - format: 문자열 포맷
    init?(fromString string: String, format: String) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale.current
                
        if let date = formatter.date(from: string) {
            self = date
        } else {
            return nil
        }
    }
    
    func toString(format: String) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale.current
        
        return formatter.string(from: self)
    }
}
