//
//  APIManager.swift
//  desafioBornlogic
//
//  Created by Marcos Henrique Rossi Paes on 13/05/24.
//

import Foundation

// Protocolo para definir a interface de fetchArticles
protocol APIManagerProtocol {
    func fetchArticles(completion: @escaping ([Article]?, Error?) -> Void)
}

// Classe para gerenciar chamadas à NewsAPI e decodificação de dados
class APIManager: APIManagerProtocol {
    static let shared = APIManager()  // Instância compartilhada (singleton)

    // Função para buscar artigos da API
    func fetchArticles(completion: @escaping ([Article]?, Error?) -> Void) {
        // Atualiza a URL com uma palavra-chave mais genérica e sem limitar a data
        let urlString = "https://newsapi.org/v2/everything?q=notícias&sortBy=publishedAt&language=pt&apiKey=cfaa4da92aa047de899b534987ae07c6"
        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "APIManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "URL inválida"]))
            return
        }

        // Cria uma tarefa de URLSession para buscar os dados da API
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }

            guard let data = data else {
                completion(nil, NSError(domain: "APIManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Dados inválidos"]))
                return
            }

            // Para fins de depuração: imprime os dados recebidos como string
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Dados recebidos: \(jsonString)")
            }

            // Tenta decodificar os dados recebidos para o modelo ArticlesResponse
            do {
                let articlesResponse = try JSONDecoder().decode(ArticlesResponse.self, from: data)
                completion(articlesResponse.articles, nil)
            } catch {
                // Para fins de depuração: imprime o erro de decodificação
                print("Erro ao decodificar dados: \(error)")
                completion(nil, error)
            }
        }

        task.resume()  // Inicia a tarefa
    }
}
