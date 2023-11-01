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

    @IBOutlet private(set) var searchForButton: UIButton!

    @IBOutlet private(set) var tapsButton: UIButton!

    @IBOutlet private(set) var alertButton: UIButton!

    // MARK: Navigation tests
    @IBOutlet private(set) var codePushButton: UIButton!
    @IBOutlet private(set) var codeModalButton: UIButton!
    @IBOutlet private(set) var seguePushButton: UIButton!
    @IBOutlet private(set) var segueModalButton: UIButton!

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

    deinit {
        print(">> ViewController.deinit")
    }
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

// MARK: - Segue

extension ViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "pushNext"?:
            guard let nextVC = segue.destination as? SegueNextViewController else { return }
            nextVC.labelText = "Pushed from segue"
        case "modalNext"?:
            guard let nextVC = segue.destination as? SegueNextViewController else { return }
            nextVC.labelText = "Modal from segue"
        default: return
        }
    }
}

// MARK: - Private

private extension ViewController {

    @IBAction func searchForButtonTapped() {
        Task {
            await searchForBook(terms: hardcodedSearchTerm)
        }
    }

    @IBAction func tapsButtonTapped() {
        print(">> Button was tapped")
    }

    @IBAction func alertButtonTapped() {
        let alert = UIAlertController(
            title: "Do the Thing?",
            message: "Let us know if you want to do the thing.",
            preferredStyle: .alert
        )

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print(">> Cancel")
        }

        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            print(">> OK")
        }

        alert.addAction(cancelAction)
        alert.addAction(okAction)
        alert.preferredAction = okAction

        present(alert, animated: true)
    }

    @IBAction private func pushNextViewController() {
        let nextVC = CodeNextViewController(labelText: "Pushed from code")
        self.navigationController?.pushViewController(nextVC, animated: true)
    }

    @IBAction private func presentModalNextViewController() {
        let nextVC = CodeNextViewController(labelText: "Modal from code")
        self.present(nextVC, animated: true)
    }

    @MainActor
    func updateButton(isEnable: Bool) async {
        searchForButton.isEnabled = isEnable
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
