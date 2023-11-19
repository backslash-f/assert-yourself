import Foundation

struct Greeter {
    private let name: String

    private let greetingTimes: [(from: Int, greeting: String)] = [
        (0, "Good evening"),
        (5, "Good morning"),
        (12, "Good afternoon"),
        (17, "Good evening"),
        (24, "SENTINEL")
    ]

    // MARK: - Lifecycle

    init(name: String) {
        self.name = name
    }
}

// MARK: - Interface

extension Greeter {
    func greet(time: Date) -> String {
        let hello = greeting(for: time)
        return name.isEmpty ?
        "\(hello)." :
        "\(hello), \(name)."
    }
}

// MARK: - Private

private extension Greeter {
    func greeting(for time: Date) -> String {
        let theHour = hour(for: time)
        for (index, greetingTime) in greetingTimes.enumerated() {
            if greetingTime.from <= theHour &&
                theHour < greetingTimes[index + 1].from {
                return greetingTime.greeting }
        }
        return ""
    }

    func hour(for time: Date) -> Int {
        let components = Calendar.current.dateComponents([.hour], from: time)
        return components.hour ?? 0
    }
}
