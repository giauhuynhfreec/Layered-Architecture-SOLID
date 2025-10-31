// CompositionRoot/AppContainer.swift
import UIKit
//import Domain

public struct AppContainer {
    public let getArticlesUseCase: GetArticlesUseCase
    public let getArticleDetailUseCase: GetArticleDetailUseCase
    public let createArticleUseCase: CreateArticleUseCase
    public let updateArticleUseCase: UpdateArticleUseCase
    public let deleteArticleUseCase: DeleteArticleUseCase

    init(remote: ArticleRemoteDataSource, local: ArticleLocalDataSource) {
        let repo = ArticleRepositoryImpl(remote: remote, local: local)
        self.getArticlesUseCase = GetArticlesUseCaseImpl(repo: repo)
        self.getArticleDetailUseCase = GetArticleDetailUseCaseImpl(repo: repo)
        self.createArticleUseCase = CreateArticleUseCaseImpl(repo: repo)
        self.updateArticleUseCase = UpdateArticleUseCaseImpl(repo: repo)
        self.deleteArticleUseCase = DeleteArticleUseCaseImpl(repo: repo)
    }

    public init(simulateNetworkFailure: Bool = false, useFirebase: Bool = true) {
        let local = ArticleLocalDataSourceImpl()
        if simulateNetworkFailure {
            let http = BundleHTTPClient(simulateNetworkFailure: simulateNetworkFailure)
            let remote = ArticleRemoteDataSourceImpl(http: http)
            self.init(remote: remote, local: local)
            return
        }

        if useFirebase {
            #if canImport(FirebaseFirestore)
            let remote = FirebaseArticleRemoteDataSource()
            self.init(remote: remote, local: local)
            #else
            let http = BundleHTTPClient(simulateNetworkFailure: simulateNetworkFailure)
            let remote = ArticleRemoteDataSourceImpl(http: http)
            self.init(remote: remote, local: local)
            #endif
        } else {
            let http = BundleHTTPClient(simulateNetworkFailure: simulateNetworkFailure)
            let remote = ArticleRemoteDataSourceImpl(http: http)
            self.init(remote: remote, local: local)
        }
    }
}
