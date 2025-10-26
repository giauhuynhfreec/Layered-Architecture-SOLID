// CompositionRoot/AppContainer.swift
import UIKit
//import Domain

public struct AppContainer {
    public let getArticlesUseCase: GetArticlesUseCase
    public let getArticleDetailUseCase: GetArticleDetailUseCase

    public init(simulateNetworkFailure: Bool = false) {
        let http = BundleHTTPClient(simulateNetworkFailure: simulateNetworkFailure)
        let remote = ArticleRemoteDataSourceImpl(http: http)
        let local = ArticleLocalDataSourceImpl()
        let repo = ArticleRepositoryImpl(remote: remote, local: local)

        self.getArticlesUseCase = GetArticlesUseCaseImpl(repo: repo)
        self.getArticleDetailUseCase = GetArticleDetailUseCaseImpl(repo: repo)
    }
}
