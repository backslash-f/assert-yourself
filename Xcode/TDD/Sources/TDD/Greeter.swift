import Foundation

struct Greeter {
    init(name: String) {}
    
    func greet(time: Date) -> String {
        let theHour = hour(for: time)
        if 12 <= theHour && theHour <= 16 {
            return "Good afternoon."
        }
        if 0 <= theHour && theHour <= 4
            || 17 <= theHour && theHour <= 23 {
            return "Good evening."
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
