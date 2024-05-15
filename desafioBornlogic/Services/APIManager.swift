//
//  APIManager.swift
//  desafioBornlogic
//
//  Created by Marcos Henrique Rossi Paes on 13/05/24.
//

import Foundation

// Gerencia chamadas à NewsAPI e decodificação de dados
class APIManager {
    static let shared = APIManager()

    func fetchArticles(completion: @escaping ([Article]?, Error?) -> Void) {
        let urlString = "https://newsapi.org/v2/everything?q=tesla&from=2024-04-13&sortBy=publishedAt&apiKey=cfaa4da92aa047de899b534987ae07c6"
        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "APIManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "URL inválida"]))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }

            guard let data = data, let articles = try? JSONDecoder().decode(ArticlesResponse.self, from: data) else {
                completion(nil, NSError(domain: "APIManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Falha ao decodificar dados"]))
                return
            }

            completion(articles.articles, nil)
        }

        task.resume()
    }
}

// Estrutura auxiliar para decodificar a resposta
struct ArticlesResponse: Decodable {
    let articles: [Article]
}
    