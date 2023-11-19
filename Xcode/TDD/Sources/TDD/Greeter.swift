import Foundation

struct Greeter {
    private let greetingTimes: [(from: Int, greeting: String)] = [
        (0, "Good evening."),
        (5, "Good morning."),
        (12, "Good afternoon."),
        (17, "Good evening."),
        (24, "SENTINEL")
    ]

    init(name: String) {}

    func greet(time: Date) -> String {
        let theHour = hour(for: time)
        for (index, greetingTime) in greetingTimes.enumerated() {
            if greetingTime.from <= theHour
                && theHour < greetingTimes[index + 1].from {
                return greetingTime.greeting
            }
        }
        return ""
    }
}

// MARK: - Private

private extension Greeter {
    func hour(for time: Date) -> Int {
        let components = Calendar.current.dateComponents([.hour], from: time)
        return components.hour ?? 0
    }
}
