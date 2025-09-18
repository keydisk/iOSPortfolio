# iOS 최주영 포트 폴리오

## 아키텍쳐 : MVVM-C (클린아키텍쳐 적용)

App -> AppCoordinator(텝에 의존성 주입)
Coordinator(* 의존성 주입) -> Presenter(View -> ViewModel) -> Domain(UseCase, Entity)
                                                   Data -> Domain

## 사용 라이브러리 : 
### - Tuist : 프로젝트 관리를 위해 사용.
### - RxSwift : UIKit에서 상태 관리하기 위해 사용
### - Kingfisher : 이미지 캐싱을 위해 사용
### - RealmSwift : 내부 데이터 관리를 위해 사용
### - Snapkit : UIKit에서 오토레이아웃 쉽게 적용하기 위해 사용
### - Alamofire : Http 통신을 위해 사용

## 주요 기능
### - Kakao Library를 이용해 책 검색 (SwiftUI)
###    - 오른쪽에서 왼쪽으의 스와이프로 북마크 설정 가능
### - Kakao Library를 이미지 검색 (SwiftUI)
###    - 섬네일 텝시 이미지 상세로 이동
###    - 섬네일 아래를 텝하면 뷰가 화전하면서 북마크 설정 가능
### - 뷱마크 리스트 조회

### UITest code 작성.
