//
//  CustomTextField.swift
//  View
//
//  Created by JuYoung choi on 7/21/25.
//

import SwiftUI

/// 텍스트 필드 옵션
public enum TextFieldOption {
    case search
    case normal
}

/// 커스텀 텍스트 필드
public struct CustomTextField: View {

    private struct TextFieldViewDecoration: ViewModifier {
        
        private let horizontalPadding: CGFloat  = 12
        private let verticalPadding: CGFloat    = 8
        
        func body(content: Content) -> some View {
            
            content
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, verticalPadding)
                .background(
                    
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.gray, lineWidth: 1)
                )
        }
    }
    
    @Binding var searchText: String
    /// 텍스트 내용 지우기
    @State private var showAllDeleteBtn = false
    
    var option: TextFieldOption = .normal
    var placeholder: String?

    public init(searchText: Binding<String>, showAllDeleteBtn: Bool = false, option: TextFieldOption = .normal, placeholder: String? = nil) {

        self._searchText = searchText
        self.showAllDeleteBtn = showAllDeleteBtn
        self.option = option
        self.placeholder = placeholder
    }

    var drawTextField: some View {
        TextField("", text: $searchText, prompt: Text(placeholder ?? ""))
            .accentColor(.blue)
            .disabled(false)
            .disableAutocorrection(false)
    }
    
    public var body: some View {

        if option == .normal {
            drawTextField
                .modifier(TextFieldViewDecoration() )
            
        } else {
            HStack {

                Image(name: "icn_search_up")
                    .foregroundColor(.gray)
                
                drawTextField
                
                Image(name: "icn_delete")
                    .accessibilityIdentifier("textfieldCloseCustomButton")
                    .accessibilityElement()
                    .accessibilityHidden(false)
                    .foregroundColor(.gray)
                    .onTapGesture {
                        
                        searchText = ""
                    }
                    .opacity(showAllDeleteBtn ? 1 : 0)
                    .animation(.easeIn(duration: UIConstNo.shortAnimationTime), value: showAllDeleteBtn)
                
            }
            .modifier(TextFieldViewDecoration() )
            .onChange(of: searchText) { text in
                
                showAllDeleteBtn = !text.isEmpty
            }
        }
        
    }
}
