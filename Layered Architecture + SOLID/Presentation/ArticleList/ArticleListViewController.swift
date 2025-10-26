// Presentation/ArticleList/ArticleListViewController.swift
import UIKit
//import Domain

final class ArticleListViewController: UITableViewController {
    private let useCase: GetArticlesUseCase
    private let detailUseCase: GetArticleDetailUseCase
    private var items: [Article] = []

    init(useCase: GetArticlesUseCase, detailUseCase: GetArticleDetailUseCase) {
        self.useCase = useCase
        self.detailUseCase = detailUseCase
        super.init(style: .plain)
        self.title = "Articles"
    }
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(didPull), for: .valueChanged)
        Task { await loadInitial() }
    }

    @objc private func didPull() {
        Task {
            do {
                let fresh = try await useCase.refresh()
                items = fresh
                tableView.reloadData()
            } catch {
                // giữ nguyên items
            }
            refreshControl?.endRefreshing()
        }
    }

    private func showLoading(_ show: Bool) {
        if show { let v = UIActivityIndicatorView(style: .medium); v.startAnimating(); navigationItem.rightBarButtonItem = UIBarButtonItem(customView: v) }
        else { navigationItem.rightBarButtonItem = nil }
    }

    private func loadInitial() async {
        showLoading(true)
        defer { showLoading(false) }
        do {
            let list = try await useCase.execute()
            self.items = list
            self.tableView.reloadData()
        } catch {
            // Nếu cả cache/remote đều fail → hiển thị rỗng
        }
    }

    // UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { items.count }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = items[indexPath.row]
        var cfg = cell.defaultContentConfiguration()
        cfg.text = item.title
        cfg.secondaryText = item.body
        cell.contentConfiguration = cfg
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = items[indexPath.row].id
        let vc = ArticleDetailViewController(id: id, useCase: detailUseCase)
        navigationController?.pushViewController(vc, animated: true)
    }
}
