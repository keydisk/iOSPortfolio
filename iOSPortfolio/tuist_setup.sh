#!/bin/bash

echo "📁 Tuist 프로젝트 구조에 맞춰 디렉터리 생성 중..."

# --- 설정 ---
# 기본 모듈 목록
MODULES=("App" "FeatureSearch" "DesignSystem" "Domain" "Data" "Core" "AppUITest")

# 유닛 테스트 타겟을 만들 모듈
TESTABLE_MODULES=("FeatureSearch" "Domain" "Data" "Core" "AppUITest")

# UI 테스트 타겟을 만들 모듈
UITESTABLE_MODULES=("App")

# 리소스(Assets.xcassets) 폴더를 만들 모듈
RESOURCEFUL_MODULES=("App" "FeatureSearch" "Core" )
# --- 설정 끝 ---

# Targets 최상위 디렉터리 생성
if [ ! -d "Targets" ]; then
    mkdir -p "Targets"
    echo "✅ Targets/ 디렉터리 생성 완료"
fi

for MODULE in "${MODULES[@]}"; do
    echo "--- ${MODULE} 모듈 처리 중 ---"

    BASE_DIR="Targets/${MODULE}"
    SOURCES_DIR="${BASE_DIR}/Sources"
    TESTS_DIR="${BASE_DIR}/Tests"
    UITESTS_DIR="${BASE_DIR}/UITests"
    RESOURCES_DIR="${BASE_DIR}/Resources"

    # 1. Sources 폴더 생성
    if [ ! -d "$SOURCES_DIR" ]; then
        mkdir -p "$SOURCES_DIR"
        # Tuist가 모듈을 인식할 수 있도록 더미 소스 파일 생성
        cat <<EOF > "${SOURCES_DIR}/${MODULE}Source.swift"
//
//  ${MODULE}Source.swift
//
//  Tuist 인식을 위한 더미 파일입니다.
//
import Foundation
EOF
        echo "✅ $SOURCES_DIR 및 더미 소스 파일 생성 완료"
    else
        echo "ℹ️  $SOURCES_DIR 이미 존재함"
    fi

    # 2. 유닛 테스트 폴더 생성
    if [[ " ${TESTABLE_MODULES[@]} " =~ " ${MODULE} " ]]; then
        if [ ! -d "$TESTS_DIR" ]; then
            mkdir -p "$TESTS_DIR"
            # Tuist가 테스트 타겟을 인식할 수 있도록 더미 테스트 파일 생성
            cat <<EOF > "${TESTS_DIR}/${MODULE}Tests.swift"
import XCTest
@testable import ${MODULE}

final class ${MODULE}Tests: XCTestCase {
    func test_example() {
        XCTAssertTrue(true)
    }
}
EOF
            echo "✅ $TESTS_DIR 및 더미 테스트 파일 생성 완료"
        else
            echo "ℹ️  $TESTS_DIR 이미 존재함"
        fi
    else
        echo "⚠️  ${MODULE}은(는) 유닛 테스트 제외 대상입니다."
    fi

    # 3. UI 테스트 폴더 생성
    if [[ " ${UITESTABLE_MODULES[@]} " =~ " ${MODULE} " ]]; then
        if [ ! -d "$UITESTS_DIR" ]; then
            mkdir -p "$UITESTS_DIR"
            # Tuist가 UI 테스트 타겟을 인식할 수 있도록 더미 UI 테스트 파일 생성
            cat <<EOF > "${UITESTS_DIR}/${MODULE}UITests.swift"
import XCTest

final class ${MODULE}UITests: XCTestCase {
    @MainActor
    func test_uiExample() throws {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.buttons.count >= 0)
    }
}
EOF
            echo "✅ $UITESTS_DIR 및 더미 UI 테스트 파일 생성 완료"
        else
            echo "ℹ️  $UITESTS_DIR 이미 존재함"
        fi
    else
        echo "⚠️  ${MODULE}은(는) UI 테스트 제외 대상입니다."
    fi

    # 4. 리소스 폴더 생성
    if [[ " ${RESOURCEFUL_MODULES[@]} " =~ " ${MODULE} " ]]; then
        if [ ! -d "${RESOURCES_DIR}/Assets.xcassets" ]; then
            mkdir -p "${RESOURCES_DIR}/Assets.xcassets"
            # Assets.xcassets 기본 구조 파일 생성
            cat <<EOF > "${RESOURCES_DIR}/Assets.xcassets/Contents.json"
{
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF
            echo "✅ $RESOURCES_DIR/Assets.xcassets 생성 완료"
        else
            echo "ℹ️  $RESOURCES_DIR/Assets.xcassets 이미 존재함"
        fi
    else
        echo "⚠️  ${MODULE}은(는) 리소스 제외 대상입니다."
    fi
done

# 5. SwiftLint 설정 파일 생성
if [ ! -f ".swiftlint.yml" ]; then
    cat <<EOF > ".swiftlint.yml"
# .swiftlint.yml
# 기본적인 SwiftLint 규칙 예시입니다. 프로젝트에 맞게 수정하세요.
disabled_rules:
  - line_length
  - identifier_name
  - type_name
  - empty_count
  - trailing_whitespace
included:
  - Targets
excluded:
  - Carthage
  - Pods
opt_in_rules:
  - empty_count
  - force_cast
  - force_try
  - private_outlet
  - redundant_nil_coalescing
  - vertical_whitespace
EOF
    echo "✅ .swiftlint.yml 생성 완료"
else
    echo "ℹ️  .swiftlint.yml 이미 존재함"
fi


echo ""
echo "✅ 모든 디렉터리 및 기본 파일 생성이 완료되었습니다."
echo "➡️  이제 'tuist generate' 명령어를 실행하여 Xcode 프로젝트를 생성하세요."
