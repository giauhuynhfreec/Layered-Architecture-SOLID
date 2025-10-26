// Presentation/ArticleDetail/ArticleDetailViewController.swift
import UIKit
//import Domain

final class ArticleDetailViewController: UIViewController {
    private let id: String
    private let useCase: GetArticleDetailUseCase

    init(id: String, useCase: GetArticleDetailUseCase) {
        self.id = id
        self.useCase = useCase
        super.init(nibName: nil, bundle: nil)
        title = "Detail"
    }
    required init?(coder: NSCoder) { fatalError() }

    override func loadView() {
        view = UIView()
        view.backgroundColor = .systemBackground
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Task { await load() }
    }

    private func load() async {
        do {
            let article = try await useCase.execute(id: id)
            let label = UILabel()
            label.numberOfLines = 0
            label.text = "\(article.title)\n\n\(article.body)"
            label.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(label)
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
            ])
        } catch {
            // hiển thị lỗi tối giản
        }
    }
}
