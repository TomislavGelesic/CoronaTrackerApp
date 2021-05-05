
import Foundation

class UserDefaultsService {
    
    static func update(_ item: UserDefaultsDomainItem) {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(item.usecase, forKey: "usecase")
        do { try userDefaults.setCustomObject(item.details, forKey: "usecaseDetails") }
        catch (let error) { print(error.localizedDescription) }
    }
    
    static func getSavedData() -> UserDefaultsDomainItem? {
        var result = UserDefaultsDomainItem()
        let userDefaults = UserDefaults.standard
        guard let usecase = userDefaults.value(forKey: "usecase") as? String else { return nil }
        result.usecase = usecase
        do {
            let details: [String] = try userDefaults.getCustomObject(forKey: "usecaseDetails")
            result.details = details
        }
        catch (_) { }
        return result
    }
    
    static func getUsecase() -> UseCaseSelection {
        if let data = UserDefaultsService.getSavedData() {
            switch data.usecase {
            case "worldwide":
                return .worldwide
            default:
                return .country(data.usecase)
            }
        }
        return .country("croatia")
    }
}
