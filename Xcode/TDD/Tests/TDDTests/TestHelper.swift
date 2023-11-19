import Foundation

func date(hour: Int, minute: Int) -> Date? {
    DateComponents(
        calendar: Calendar.current,
        hour: hour,
        minute: minute
    ).date
}
