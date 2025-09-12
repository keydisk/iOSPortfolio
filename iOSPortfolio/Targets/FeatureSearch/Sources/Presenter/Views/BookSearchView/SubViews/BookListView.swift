import SwiftUI
import DesignSystem

struct BookListView<ViewModel: BookSearchViewModel>: View {

    @ObservedObject var viewModel: ViewModel
    @Environment(\.coordinator) var coordinator
    let documents: [BookData]

    var body: some View {

        List(documents) { document in
            BookListItemView(document: document, viewModel: viewModel)
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
                .onTapGesture {
                    print("tap")

                    coordinator.push(.detail(url: document.url))
                }
        }
        .listStyle(.plain)
        .padding(.horizontal, 8)
    }
}

struct BookListItemView<ViewModel: BookSearchViewModel>: View {

    let document: BookData
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Thumbnail Image
            AsyncImage(url: URL(string: document.thumbnail)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100)
            } placeholder: {
                ProgressView()
                    .frame(width: 100, height: 150)
            }
            .maskingCornerRadius(8)

            VStack(alignment: .leading, spacing: 8) {
                // Title
                Text(document.title)
                    .font(.headline)
                    .lineLimit(2)

                // Contents
                Text(document.contents)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineLimit(2)

                Spacer()

                // Price and Sale Price
                HStack {
                    if document.salePrice > 0 && document.price != document.salePrice {
                        Text("\(document.price)")
                            .font(.caption)
                            .strikethrough()
                            .foregroundColor(.gray)
                        Text("\(document.salePrice)원")
                            .font(.headline)
                            .foregroundColor(.red)
                    } else {
                        Text("\(document.price)원")
                            .font(.headline)
                    }
                    Spacer()
                }
            }
        }
        .padding(.vertical, 8)
    }
}

#if DEBUG

//#Preview {
//    let sampleDoc = BookDocument(
//        authors: ["남궁성"],
//        contents: "자바의 정석의 저자 남궁성씨의 신작! C언어의 기본부터 객체지향 프로그래밍까지, 이 책 한 권이면 C언어 마스터! C언어의 정석으로 프로그래밍의 기초를 다지세요. 프로그래밍 초보자도 쉽게 따라할 수 있는 예제와 설명.",
//        datetime: "2024-01-01T00:00:00.000+09:00",
//        isbn: "9791162245492",
//        price: 35000,
//        publisher: "도우출판",
//        salePrice: 31500,
//        status: "정상판매",
//        thumbnail: "https://search1.kakaocdn.net/thumb/R120x174.q85/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flbook%2Fimage%2F6468355%3Ftimestamp%3D20231226170350",
//        title: "C언어의 정석",
//        translators: [],
//        url: "https://search.daum.net/search?w=bookpage&bookId=6468355&q=C%EC%96%B8%EC%96%B4%EC%9D%98+%EC%A0%95%EC%84%9D"
//    )
//
//    let sampleDoc2 = BookDocument(
//        authors: ["J.K. 롤링"],
//        contents: "해리 포터와 마법사의 돌, 전 세계를 사로잡은 판타지 시리즈의 시작. 11살 소년 해리가 호그와트 마법학교에 입학하면서 벌어지는 놀라운 모험 이야기.",
//        datetime: "2001-11-16T00:00:00.000+09:00",
//        isbn: "9780747532743",
//        price: 20000,
//        publisher: "Bloomsbury",
//        salePrice: -1,
//        status: "정상판매",
//        thumbnail: "https://search1.kakaocdn.net/thumb/R120x174.q85/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flbook%2Fimage%2F1022828%3Ftimestamp%3D20230321110301",
//        title: "해리 포터와 마법사의 돌",
//        translators: ["김혜원"],
//        url: "https://search.daum.net/search?w=bookpage&bookId=1022828&q=%ED%95%B4%EB%A6%AC+%ED%8F%AC%ED%84%B0%EC%99%80+%EB%A7%88%EB%B2%95%EC%82%AC%EC%9D%98+%EB%8F%8C"
//    )
//
//    NavigationView {
//        BookListView(documents: [sampleDoc, sampleDoc2, sampleDoc, sampleDoc2])
//    }
//}
#endif
