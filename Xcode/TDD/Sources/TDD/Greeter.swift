import Foundation

struct Greeter {
    init(name: String) {
    }

    func greet(time: Date) -> String {
        let theHour = hour(for: time)
        if 12 <= theHour && theHour <= 16 {
            return "Good afternoon."
        }
        return "Good morning."
    }
}

// MARK: - Private

private extension Greeter {
    func hour(for time: Date) -> Int {
        let components = Calendar.current.dateComponents([.hour], from: time)
        return components.hour ?? 0
    }
}
