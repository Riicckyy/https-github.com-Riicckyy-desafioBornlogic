//
//  ArticlesViewController.swift
//  desafioBornlogic
//
//  Created by Marcos Henrique Rossi Paes on 13/05/24.
//

import UIKit

// Controlador que gerencia a exibição da lista de artigos
class ArticlesViewController: UIViewController {
    var articles: [Article] = [] // Lista de artigos
    var tableView: UITableView! // Tabela para exibir os artigos
    var noResultsLabel: UILabel! // Label para quando não houver resultados
    var titleLabel: UILabel! // Label para o título

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground // Ajusta para modo claro/escuro
        setupTitleLabel()  // Configura o UILabel para o título
        setupTableView()  // Configura o UITableView
        setupNoResultsLabel()  // Configura o label de "nenhum resultado"
        fetchArticles()  // Busca artigos da API
    }

    // Configura o UILabel para o título
    private func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.text = "Notícias"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 32) // Fonte adequada para um título
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.label // Ajusta para modo claro/escuro
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    // Configura o UITableView
    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: "ArticleCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.separatorStyle = .none // Remove a linha entre as células
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    // Configura o label de "nenhum resultado"
    private func setupNoResultsLabel() {
        noResultsLabel = UILabel()
        noResultsLabel.text = "Nenhum resultado encontrado"
        noResultsLabel.textAlignment = .center
        noResultsLabel.textColor = UIColor.label // Ajusta para modo claro/escuro
        noResultsLabel.translatesAutoresizingMaskIntoConstraints = false
        noResultsLabel.isHidden = true
        view.addSubview(noResultsLabel)

        NSLayoutConstraint.activate([
            noResultsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noResultsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    // Busca artigos da API
    private func fetchArticles() {
        APIManager.shared.fetchArticles { [weak self] (articles, error) in
            DispatchQueue.main.async {
                if let articles = articles {
                    // Ordena os artigos pela data de publicação mais recente
                    self?.articles = articles.sorted(by: { $0.publishedAt ?? "" > $1.publishedAt ?? "" })
                    self?.tableView.reloadData()
                    self?.noResultsLabel.isHidden = !articles.isEmpty
                } else if let error = error {
                    print("Erro ao carregar artigos: \(error.localizedDescription)")
                    self?.noResultsLabel.text = "Erro ao carregar artigos"
                    self?.noResultsLabel.isHidden = false
                }
            }
        }
    }
}

// Extensão para gerenciar dados e interações do UITableView
extension ArticlesViewController: UITableViewDelegate, UITableViewDataSource {
    // Retorna o número de linhas na seção
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    // Configura cada célula com os dados do artigo correspondente
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as? ArticleTableViewCell else {
            fatalError("Não foi possível desempacotar a célula como ArticleTableViewCell")
        }
        let article = articles[indexPath.row]
        cell.configure(with: article)
        return cell
    }

    // Trata a seleção de uma célula
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articles[indexPath.row]
        let detailVC = ArticleDetailViewController(article: article)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
