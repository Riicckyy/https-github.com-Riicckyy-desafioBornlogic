//
//  ArticleTableViewCell.swift
//  desafioBornlogic
//
//  Created by Marcos Henrique Rossi Paes on 14/05/24.
//

import UIKit

// Célula personalizada para exibir detalhes do artigo no UITableView
class ArticleTableViewCell: UITableViewCell {
    let articleImageView = UIImageView() // Imagem do artigo
    let titleLabel = UILabel() // Título do artigo
    let descriptionLabel = UILabel() // Descrição do artigo
    let authorLabel = UILabel() // Autor do artigo
    let textStackView = UIStackView() // Stack view para os textos
    let mainStackView = UIStackView() // Stack view principal
    let containerView = UIView() // View para adicionar sombra e borda

    private var traitChangeRegistration: (any UITraitChangeRegistration)? // Registro para mudanças de traits

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout() // Configura o layout inicial da célula
        applyShadowAndBorder() // Aplica sombra e borda
        
        // Remove o efeito de seleção da célula
        selectionStyle = .none

        // Registra para mudanças de trait
        let traits: [UITrait] = [UITraitUserInterfaceStyle.self]
        traitChangeRegistration = registerForTraitChanges(traits) { [weak self] (cell: ArticleTableViewCell, previousTraitCollection: UITraitCollection) in
            self?.applyShadowAndBorder()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Configura o layout da célula
    private func setupLayout() {
        setupContainerView()
        setupImageView()
        setupLabels()
        setupStackViews()
    }

    // Configura a containerView para adicionar sombra e borda
    private func setupContainerView() {
        containerView.backgroundColor = UIColor.systemBackground // Ajusta para modo claro/escuro
        containerView.layer.cornerRadius = 8
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = traitCollection.userInterfaceStyle == .dark ? 0.7 : 0.2
        containerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        containerView.layer.shadowRadius = traitCollection.userInterfaceStyle == .dark ? 10 : 5
        containerView.layer.borderWidth = 0.6
        containerView.layer.borderColor = traitCollection.userInterfaceStyle == .dark ? UIColor.lightGray.cgColor : UIColor.clear.cgColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }

    // Configura a articleImageView
    private func setupImageView() {
        articleImageView.contentMode = .scaleAspectFill
        articleImageView.clipsToBounds = true
        articleImageView.layer.cornerRadius = 8
        articleImageView.layer.masksToBounds = true
        articleImageView.translatesAutoresizingMaskIntoConstraints = false
    }

    // Configura os labels para título, descrição e autor
    private func setupLabels() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.label // Ajusta para modo claro/escuro

        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.textColor = UIColor.label // Ajusta para modo claro/escuro

        authorLabel.font = UIFont.systemFont(ofSize: 12)
        authorLabel.textColor = UIColor.secondaryLabel // Ajusta para modo claro/escuro
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    // Configura os stack views
    private func setupStackViews() {
        // Stack view para os textos (título, descrição e autor)
        textStackView.axis = .vertical
        textStackView.spacing = 4
        textStackView.distribution = .fill
        textStackView.alignment = .leading
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(descriptionLabel)
        textStackView.addArrangedSubview(authorLabel)

        // Stack view principal para organizar imagem e textos horizontalmente
        mainStackView.axis = .horizontal
        mainStackView.spacing = 10
        mainStackView.alignment = .top
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.addArrangedSubview(articleImageView)
        mainStackView.addArrangedSubview(textStackView)

        // Adiciona o stack view principal à containerView
        containerView.addSubview(mainStackView)

        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            mainStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            mainStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            mainStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            articleImageView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.3),
            articleImageView.heightAnchor.constraint(equalToConstant: 100) // Ajuste a altura conforme necessário
        ])
    }

    // Configura a célula com os dados de um artigo
    func configure(with article: Article) {
        titleLabel.text = article.title
        descriptionLabel.text = article.description
        authorLabel.text = article.author ?? "Desconhecido"
        if let imageUrl = article.urlToImage, let url = URL(string: imageUrl) {
            loadImage(from: url)
        } else {
            articleImageView.image = nil // Limpa a imagem se não houver URL
        }
    }

    // Carrega a imagem do URL e atualiza a articleImageView
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.articleImageView.image = image
            }
        }.resume()
    }

    // Aplica a sombra e borda de acordo com o modo claro/escuro
    private func applyShadowAndBorder() {
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = traitCollection.userInterfaceStyle == .dark ? 0.7 : 0.2
        containerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        containerView.layer.shadowRadius = traitCollection.userInterfaceStyle == .dark ? 10 : 5
        containerView.layer.borderColor = traitCollection.userInterfaceStyle == .dark ? UIColor.lightGray.cgColor : UIColor.clear.cgColor
    }
}
