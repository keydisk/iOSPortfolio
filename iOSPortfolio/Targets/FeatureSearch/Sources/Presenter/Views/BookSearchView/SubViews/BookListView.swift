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
            BookListItemView(document: document, viewModel: viewModel)
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
                .onTapGesture {
                    print("tap")

                    coordinator.push(.detail(url: document.url))
                }
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
        .padding(.vertical, 8)
        .onAppear(perform: {

            viewModel.nextPage(document)
        })
    }
}
