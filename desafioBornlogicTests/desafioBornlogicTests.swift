//
//  desafioBornlogicTests.swift
//  desafioBornlogicTests
//
//  Created by Marcos Henrique Rossi Paes on 14/05/24.
//

import XCTest
@testable import desafioBornlogic

class desafioBornlogicTests: XCTestCase {

    var viewController: ArticlesViewController!

    override func setUpWithError() throws {
        try super.setUpWithError()
        viewController = ArticlesViewController()
        viewController.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        viewController = nil
        try super.tearDownWithError()
    }

    // MARK: - ArticleTableViewCell Tests

    func testConfigureArticleTableViewCell() throws {
        let expectation = self.expectation(description: "Fetching articles for cell configuration")
        var fetchedArticle: Article?
        
        APIManager.shared.fetchArticles { articles, error in
            XCTAssertNil(error)
            XCTAssertNotNil(articles)
            XCTAssertFalse(articles!.isEmpty)
            fetchedArticle = articles?.first
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        
        guard let article = fetchedArticle else {
            XCTFail("No article fetched")
            return
        }

        let tableView = UITableView()
        tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: "ArticleCell")

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell") as? ArticleTableViewCell else {
            XCTFail("Falha ao desempacotar ArticleTableViewCell")
            return
        }

        cell.configure(with: article)

        XCTAssertEqual(cell.titleLabel.text, article.title)
        XCTAssertEqual(cell.descriptionLabel.text, article.description)
        XCTAssertEqual(cell.authorLabel.text, article.author ?? "Desconhecido")
    }

    // MARK: - ArticlesViewController Tests

    func testArticlesViewControllerTableViewIsNotNilAfterViewDidLoad() throws {
        XCTAssertNotNil(viewController.tableView)
    }

    func testArticlesViewControllerTitleLabelIsNotNilAfterViewDidLoad() throws {
        XCTAssertNotNil(viewController.titleLabel)
    }

    func testArticlesViewControllerNumberOfRowsInSection() throws {
        let expectation = self.expectation(description: "Fetching articles for numberOfRowsInSection")
        
        APIManager.shared.fetchArticles { articles, error in
            XCTAssertNil(error)
            XCTAssertNotNil(articles)
            XCTAssertFalse(articles!.isEmpty)
            self.viewController.articles = articles!
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        viewController.loadViewIfNeeded()

        XCTAssertEqual(viewController.tableView(viewController.tableView, numberOfRowsInSection: 0), viewController.articles.count)
    }

    func testArticlesViewControllerCellForRowAt() throws {
        let expectation = self.expectation(description: "Fetching articles for cellForRowAt")
        
        APIManager.shared.fetchArticles { articles, error in
            XCTAssertNil(error)
            XCTAssertNotNil(articles)
            XCTAssertFalse(articles!.isEmpty)
            self.viewController.articles = articles!
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        viewController.loadViewIfNeeded()

        let cell = viewController.tableView(viewController.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? ArticleTableViewCell
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.titleLabel.text, viewController.articles[0].title)
        XCTAssertEqual(cell?.descriptionLabel.text, viewController.articles[0].description)
        XCTAssertEqual(cell?.authorLabel.text, viewController.articles[0].author ?? "Desconhecido")
    }

    // MARK: - ArticleDetailViewController Tests

    func testArticleDetailViewControllerDisplaysArticle() throws {
        let expectation = self.expectation(description: "Fetching articles for detail view")
        var fetchedArticle: Article?
        
        APIManager.shared.fetchArticles { articles, error in
            XCTAssertNil(error)
            XCTAssertNotNil(articles)
            XCTAssertFalse(articles!.isEmpty)
            fetchedArticle = articles?.first
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        
        guard let article = fetchedArticle else {
            XCTFail("No article fetched")
            return
        }

        let detailVC = ArticleDetailViewController(article: article)
        detailVC.loadViewIfNeeded()

        XCTAssertEqual(detailVC.getTitle(), article.title)
        XCTAssertEqual(detailVC.getDate(), detailVC.formatDate(article.publishedAt))
        XCTAssertEqual(detailVC.getContent(), article.content)
    }

    // MARK: - APIManager Tests

    func testFetchArticles() throws {
        let expectation = self.expectation(description: "Fetching articles from API")

        APIManager.shared.fetchArticles { (articles, error) in
            XCTAssertNotNil(articles)
            XCTAssertNil(error)
            XCTAssertFalse(articles!.isEmpty)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }
}

