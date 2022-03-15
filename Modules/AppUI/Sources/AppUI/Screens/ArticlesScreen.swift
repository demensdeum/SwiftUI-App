//
//  CityWeatherScreen.swift
//  SwiftUI-App
//
//  Created by ILIYA on 19.09.2021.
//

import SwiftUI
import Networking
import Core
import LogicTools

struct ArticlesScreen: View {
    @State var selectedArticle: Article?
    @State var selectedArticleFrame: CGRect?
    @State var currentY: CGFloat = 0
    @ObservedObject var viewModel: ArticlesScreenViewModel
    
    var body: some View {
        ZStack {
            List(viewModel.items) { article in
                let articleTitle = article.title ?? "-"
                GeometryReader { geom in
                    Text(articleTitle)
                        .lineLimit(1)
                        .onAppear{
                            if viewModel.items.isLast(article) {
                                viewModel.loadPage()
                            }
                        }
                        .font(.system(size: 22))
#if os(iOS)
                        .onTapGesture {
                            if selectedArticle == nil {
                                let fontAttribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22)]
                                let size = articleTitle.size(withAttributes: fontAttribute)
                                let frame = geom.frame(in: .global)
                                let x = min(size.width, UIScreen.main.bounds.width) / 2 + frame.origin.x
                                let newFrame = CGRect(
                                    x: x,
                                    y: frame.minY,
                                    width: frame.width,
                                    height: frame.height
                                )
                                selectedArticle = article
                                selectedArticleFrame = newFrame
                                currentY = frame.minY
                            }
                        }
#endif
                }
            }
            if let selectedArticle = selectedArticle,
                let selectedArticleFrame = selectedArticleFrame {
                Text(selectedArticle.title ?? "-")
                    .lineLimit(1)
                    .font(.system(size: 22))
                    .frame(
                        alignment: .center
                    )
                    .animatePosition(
                        x: selectedArticleFrame.origin.x,
                        endY: UIScreen.main.bounds.height,
                        currentY: currentY
                    ) {
                        self.selectedArticle = nil
                    }
                    .onAppear{
                        withAnimation(.easeIn(duration: 0.5)) {
                            currentY = UIScreen.main.bounds.height
                            var newFrame = selectedArticleFrame
                            newFrame.origin.y = UIScreen.main.bounds.height
                            self.selectedArticleFrame = newFrame
                        }
                    }
            }
            if viewModel.isPageLoading {
                if #available(iOS 14.0, *) {
                    ProgressView()
                        .scaleEffect(4)
                }
            }
        }
    }
}

private extension View {
    func animatePosition(
        x: CGFloat,
        endY: CGFloat,
        currentY: CGFloat,
        onCompletion: (() -> Void)?
    ) -> some View {
        self
            .modifier(
                PositionYAnimation(
                    x: x,
                    endY: endY,
                    currentY: currentY,
                    onCompletion: onCompletion
                )
            )
    }
}

private struct PositionYAnimation: AnimatableModifier {
    
    var x: CGFloat
    var endY: CGFloat
    var currentY: CGFloat
    var onCompletion: (() -> Void)?
    
    init(
        x: CGFloat,
        endY: CGFloat,
        currentY: CGFloat,
        onCompletion: (() -> Void)? = nil
    ) {
        animatableData = currentY
        self.x = x
        self.endY = endY
        self.currentY = currentY
        self.onCompletion = onCompletion
    }
    
    var animatableData: CGFloat {
        didSet {
            currentY = animatableData
            checkIfFinished()
        }
    }
    
    func checkIfFinished() -> () {
        if let onCompletion = onCompletion, currentY == endY {
            DispatchQueue.main.async {
                onCompletion()
            }
        }
    }
    
    func body(content: Content) -> some View {
        content.position(x: x + cos(currentY / 40) * 100, y: currentY)
    }
}

struct ArticlesScreen_Previews: PreviewProvider {
    static var previews: some View {
        ArticlesScreen(
            viewModel: ArticlesScreenViewModel.empty
        )
    }
}

public class ArticlesScreenViewModel: ObservableObject {
    public var name: String
    
    @Published public var isPageLoading = false
    @Published public var page = 0 {
        didSet {
            storage?.create(StorageValueWrapper(id: pageKey, value: page))
        }
    }
    @Published public var items: [Article] = [] {
        didSet {
            storage?.create(StorageValueWrapper(id: itemsKey, value: items))
        }
    }
    
    @Injected private var articlesService: DataFetcherService<Article>?
    @Injected private var storage: StorageService?
    
    private var pageKey: String { "\(Self.self)_\(name)_page" }
    private var itemsKey: String { "\(Self.self)_\(name)_items" }
    
    public init(name: String) {
        self.name = name
        
        let savedPage: StorageValueWrapper<Int>? = storage?.read(id: pageKey)
        self.page = savedPage?.value ?? 0
        
        let savedItems: StorageValueWrapper<[Article]>? = storage?.read(id: itemsKey)
        self.items = savedItems?.value ?? []
    }
    
    public static var empty: ArticlesScreenViewModel = ArticlesScreenViewModel.empty
    
    public func loadPage(ifEmpty: Bool = false) {
        if ifEmpty && items.count > 0 {
            return
        }
        guard isPageLoading == false else { return }
        page += 1
        isPageLoading = true
        articlesService?.fetch(
            query: name,
            page: page
        ) { [weak self] articles, error in
            self?.items.append(contentsOf: articles)
            self?.isPageLoading = false
        }
    }
}

extension ArticlesScreenViewModel: Hashable {
    public static func == (lhs: ArticlesScreenViewModel, rhs: ArticlesScreenViewModel) -> Bool {
        return lhs.name == rhs.name
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
