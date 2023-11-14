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

protocol UserDefaultsProtocol {
    func set(_ value: Int, forKey defaultName: String)
    func integer(forKey defaultName: String) -> Int
}

extension UserDefaults: UserDefaultsProtocol {}

class ViewController: UIViewController {

    @IBOutlet private(set) var searchForButton: UIButton!

    @IBOutlet private(set) var tapsButton: UIButton!

    @IBOutlet private(set) var alertButton: UIButton!

    // MARK: Navigation tests
    @IBOutlet private(set) var codePushButton: UIButton!
    @IBOutlet private(set) var codeModalButton: UIButton!
    @IBOutlet private(set) var seguePushButton: UIButton!
    @IBOutlet private(set) var segueModalButton: UIButton!

    // MARK: UserDefaults tests
    @IBOutlet private(set) var counterLabel: UILabel!
    @IBOutlet private(set) var incrementButton: UIButton!

    // MARK: TextField tests
    @IBOutlet private(set) var usernameField: UITextField!
    @IBOutlet private(set) var passwordField: UITextField!

    private var dataTask: URLSessionDataTask?

    private(set) var results: [SearchResult] = [] {
        didSet {
            print(">> Number of results: \(results.count)")
            print(">> Results: \(results)")
        }
    }

    private var count = 0 {
        didSet {
            counterLabel.text = "\(count)"
            userDefaults.set(count, forKey: "count")
        }
    }

    var session: URLSessionProtocol = {
        URLSession(configuration: .ephemeral) // Disable caching.
    }()

    var userDefaults: UserDefaultsProtocol = UserDefaults.standard

    let hardcodedSearchTerm = "out from boneville"

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Assert Yourself"
        count = userDefaults.integer(forKey: "count")
    }

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
            if let nextVC = segue.destination as? SegueNextViewController {
                nextVC.labelText = "Pushed from segue"
            }
        case "modalNext"?:
            if let nextVC = segue.destination as? SegueNextViewController {
                nextVC.labelText = "Modal from segue"
            }
        case "changePassword"?:
            (segue.destination as? ChangePasswordViewController)?
                .securityToken = "TOKEN"
        default: return
        }
    }
}

// MARK: - Text Field Delegate

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if textField === usernameField {
            return !string.contains(" ") } else {
                return true
            }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === usernameField {
            passwordField.becomeFirstResponder()
        } else {
            guard let username = usernameField.text,
                  let password = passwordField.text else {
                return false
            }
            passwordField.resignFirstResponder()
            performLogin(username: username, password: password)
        }
        return false
    }

    private func performLogin(username: String, password: String) {
        print(">> Username: \(username)")
        print(">> Password: \(password)")
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

    @IBAction private func incrementButtonTapped() {
        count += 1
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
