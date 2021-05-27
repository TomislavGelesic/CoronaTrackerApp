
import Foundation

struct HomeScreenDomainItemDetail {
    
    var title: String = ""
    var confirmed: Int = -1
    var active: Int = -1
    var recovered: Int = -1
    var deaths: Int = -1
    
    init(title: String = "", confirmed: Int = -1, active: Int = -1, recovered: Int = -1, deaths: Int = -1) {
        self.title = title
        self.confirmed = confirmed
        self.active = active
        self.recovered = recovered
        self.deaths = deaths
    }
    
    init(_ item: CountryResponseItem) {
        self.title = item.country
        self.confirmed = item.confirmed
        self.active = item.active
        self.recovered = item.recovered
        self.deaths = item.deaths
    }
    
}
