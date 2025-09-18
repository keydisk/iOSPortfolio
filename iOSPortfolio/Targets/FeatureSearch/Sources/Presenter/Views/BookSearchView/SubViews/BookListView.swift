import SwiftUI
import DesignSystem

struct BookListView<ViewModel: BookSearchViewModel>: View {

    @ObservedObject var viewModel: ViewModel
    @Environment(\.coordinator) var coordinator

    private var documents: [BookData] {
        if case .list(let data) = viewModel.state {
            return data.documents
        }
        return []
    }

    var body: some View {

        List(documents) { document in
            Button(action: {
                // 버튼이 눌렸을 때 실행될 액션 (기존 onTapGesture 내용)
                coordinator.push(.detail(url: document.url))
            }) {
                // 버튼의 '내용'으로 기존의 BookListItemView를 그대로 사용합니다.
                BookListItemView(document: document, viewModel: viewModel)
            }
            // ✅ 2. 버튼의 기본 스타일(파란색 텍스트 등)을 없애서 원래 모양을 유지합니다.
            .buttonStyle(.plain)
            // ✅ 3. 이제 accessibilityIdentifier는 Button에 붙습니다.
            .accessibilityIdentifier("bookListCell")
            .listRowInsets(EdgeInsets())
            .listRowSeparator(.hidden)
        }
        .refreshable {
            viewModel.refresh()
        }
        .scrollDismissesKeyboard(.automatic)
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
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            // "삭제" 버튼
            Button(role: .cancel) {

                viewModel.setFavorite(document)
            } label: {

                Label("즐겨찾기", systemImage: document.favoriteIcon)
                    .symbolRenderingMode(.palette)
            }
            .tint(.blue)
        }
        .padding(.vertical, 8)
        .onAppear(perform: {

            viewModel.nextPage(document)
        })
    }
}
