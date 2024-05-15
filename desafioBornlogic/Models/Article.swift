//
//  Article.swift
//  desafioBornlogic
//
//  Created by Marcos Henrique Rossi Paes on 13/05/24.
//

import Foundation

// Modelo que representa a resposta da API contendo uma lista de artigos
struct ArticlesResponse: Decodable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

// Modelo que representa um artigo
struct Article: Decodable {
    let source: Source?  // Fonte do artigo
    let author: String?  // Autor do artigo
    let title: String?  // Título do artigo
    let description: String?  // Descrição do artigo
    let url: String?  // URL do artigo
    let urlToImage: String?  // URL da imagem do artigo
    let publishedAt: String?  // Data de publicação do artigo
    let content: String?  // Conteúdo do artigo
}

// Modelo que representa a fonte de um artigo
struct Source: Decodable {
    let id: String?  // ID da fonte
    let name: String?  // Nome da fonte
}
