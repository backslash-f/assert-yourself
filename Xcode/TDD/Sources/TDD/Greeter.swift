import Foundation

struct Greeter {
    init(name: String) {}

    func greet(time: Date) -> String {
        let theHour = hour(for: time)

        if 0 <= theHour && theHour < 5 {
            return "Good evening."
        }

        if 5 <= theHour && theHour < 12 {
            return "Good morning."
        }

        if 12 <= theHour && theHour < 17 {
            return "Good afternoon."
        }

        if 17 <= theHour && theHour < 24 {
            return "Good evening."
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
