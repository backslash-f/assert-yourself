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

    var session: URLSessionProtocol = URLSession.shared

    let hardcodedSearchTerm = "out from boneville"
}

// MARK: - Interface

extension ViewController {
    func searchForBook(terms: String) async {
        if let encodedTerms = terms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: "https://itunes.apple.com/search?" + "media=ebook&term=\(encodedTerms)") {

            let request = URLRequest(url: url)

            await updateButton(isEnable: false)

            do {
                let (data, response) = try await session.data(for: request, delegate: nil)

                let decoded = String(data: data, encoding: .utf8)

                print(">> response: \(String(describing: response))")
                print(">> data: \(String(describing: decoded))")
            } catch {
                print(">> error: \(String(describing: error))")
            }

            await nullifyDataTask()
            await updateButton(isEnable: true)
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
}
