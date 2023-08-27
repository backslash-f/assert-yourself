//
//  ViewController.swift
//  AssertYourself
//
//  Created by Fernando Fernandes on 03.08.23.
//

import UIKit

protocol URLSessionProtocol {
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

class ViewController: UIViewController {

    @IBOutlet private(set) var button: UIButton!

    private var dataTask: URLSessionDataTask?

    private(set) var results: [SearchResult] = [] {
        didSet {
            print(">> Number of results: \(results.count)")
            print(">> Results: \(results)")
        }
    }

    var session: URLSessionProtocol = {
        URLSession(configuration: .ephemeral) // Disable caching.
    }()

    let hardcodedSearchTerm = "out from boneville"
}

// MARK: - Interface

extension ViewController {
    func searchForBook(terms: String) async {
        if let encodedTerms = terms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: "https://itunes.apple.com/search?" + "media=ebook&term=\(encodedTerms)") {

            let request = URLRequest(url: url)

            await updateButton(isEnable: false)

            var statusCode: String?

            do {
                let (data, response) = try await session.data(for: request, delegate: nil)

                if let httpURLResponse = response as? HTTPURLResponse {
                    statusCode = "\(HTTPURLResponse.localizedString(forStatusCode: httpURLResponse.statusCode))"
                }

                await parseSearch(from: data)

            } catch {
                let errorMessage = error.localizedDescription
                if let statusCode {
                    showError("\(statusCode + " " + errorMessage)")
                } else {
                    showError("\(errorMessage)")
                }
            }

            await nullifyDataTask()
            await updateButton(isEnable: true)
        }
    }

    func parseSearch(from data: Data) async {
        do {
            let search = try JSONDecoder().decode(Search.self, from: data)
            await MainActor.run {
                results = search.results
            }
        } catch {
            showError(error.localizedDescription)
        }
    }
}

// MARK: - Private

private extension ViewController {

    @IBAction func buttonTapped() {
        Task {
            await searchForBook(terms: hardcodedSearchTerm)
        }
    }

    @MainActor
    func updateButton(isEnable: Bool) async {
        button.isEnabled = isEnable
    }

    @MainActor
    func nullifyDataTask() async {
        dataTask = nil
    }

    func showError(_ message: String) {
        let title = "Network problem"
        print(">> \(title): \(message)")
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(
            title: "OK",
            style: .default
        )

        alert.addAction(okAction)
        alert.preferredAction = okAction
        present(alert, animated: true)
    }
}

// MARK: - Response

struct Search: Decodable {
    let results: [SearchResult]
}

struct SearchResult: Decodable, Equatable {
    let artistName: String
    let trackName: String
    let averageUserRating: Float
    let genres: [String]
}
