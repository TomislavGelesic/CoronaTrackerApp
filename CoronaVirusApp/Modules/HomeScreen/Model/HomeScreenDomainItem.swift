
import Foundation

struct HomeScreenDomainItem {
    
    var title: String = ""
    var stats: [StatsData] = .init()
    var details: [HomeScreenDomainItemDetail] = [HomeScreenDomainItemDetail]()
    var lastUpdateDate: Date = .init()
    
    
    init(title: String = "", stats: [StatsData] = .init(), details: [HomeScreenDomainItemDetail] = [HomeScreenDomainItemDetail](), lastUpdateDate: Date = .init()) {
        self.title = title
        self.stats = stats
        self.details = details
        self.lastUpdateDate = lastUpdateDate
    }
    
    init(totalStatsResponse: [CountryResponseItem], dayOneStatsResponse: [CountryResponseItem]) {
        let lastTwoTotalStats = totalStatsResponse.suffix(2) as Array
        let totalStatsSecondToLast = lastTwoTotalStats[0]
        let totalStatsLast = lastTwoTotalStats[1]
        title = totalStatsLast.country
        stats = createStats(from: totalStatsLast, and: totalStatsSecondToLast)
        details = createCountryDetails(from: dayOneStatsResponse)
        lastUpdateDate = Date()
    }
    
    init(_ item: WorldwideResponseItem) {
        title = "Worldwide"
        stats = createStats(from: item)
        details = createWorldwideDetails(from: item.countries)
        lastUpdateDate = Date()
    }
    
    private func createStats(from last: CountryResponseItem, and secondToLast: CountryResponseItem) -> [StatsData] {
        var newStats = [StatsData]()
        newStats.append(StatsData(type: .confirmed, value: last.confirmed,
                                  delta: last.confirmed - secondToLast.confirmed))
        newStats.append(StatsData(type: .active, value: last.active,
                                  delta: last.active - secondToLast.active))
        newStats.append(StatsData(type: .recovered, value: last.recovered,
                                  delta: last.recovered - secondToLast.recovered))
        newStats.append(StatsData(type: .deaths, value: last.deaths,
                                  delta: last.deaths - secondToLast.deaths))
        return newStats
    }
    
    private func createStats(from item: WorldwideResponseItem) -> [StatsData] {
        var newStats = [StatsData]()
        newStats.append(StatsData(type: .confirmed, value: item.global.totalConfirmed,
                                  delta: item.global.newConfirmed))
        newStats.append(StatsData(type: .active, value: item.global.totalConfirmed - item.global.totalRecovered,
                                  delta: item.global.newConfirmed - item.global.newRecovered))
        newStats.append(StatsData(type: .recovered, value: item.global.totalRecovered,
                                  delta: item.global.newRecovered))
        newStats.append(StatsData(type: .deaths, value: item.global.totalDeaths,
                                  delta: item.global.newDeaths))
        return newStats
    }
    
    private func createStats(confirmedTotalCount: Int, confirmedDifferenceCount: Int, activeTotalCount: Int, activeDifferenceCount: Int, recoveredTotalCount: Int, recoveredDifferenceCount: Int, deathsTotalCount: Int, deathsDifferenceCount: Int) -> [StatsData] {
        var newStats = [StatsData]()
        newStats.append(StatsData(type: .confirmed, value: confirmedTotalCount, delta: confirmedDifferenceCount))
        newStats.append(StatsData(type: .active, value: activeTotalCount, delta: activeDifferenceCount))
        newStats.append(StatsData(type: .recovered, value: recoveredTotalCount, delta: recoveredDifferenceCount))
        newStats.append(StatsData(type: .deaths, value: deathsTotalCount, delta: deathsDifferenceCount))
        return newStats
    }
    
    private func createCountryDetails(from responseItems: [CountryResponseItem]) -> [HomeScreenDomainItemDetail] {
        var newDetails = [HomeScreenDomainItemDetail]()
        let filteredResponseItems = responseItems.filter({ $0.province == "" })
        for (index, currentItem) in filteredResponseItems.enumerated() {
            if index == 0 {
                var newItem = HomeScreenDomainItemDetail()
                newItem.title = DateUtils.getDomainDetailItemDate(from: currentItem.date) ?? ""
                newItem.confirmed = currentItem.confirmed
                newItem.recovered = currentItem.recovered
                newItem.deaths = currentItem.deaths
                newItem.active = currentItem.active
                newDetails.append(newItem)
            }
            else {
                let previousItem = filteredResponseItems[index - 1]
                var newItem = HomeScreenDomainItemDetail()
                newItem.title = DateUtils.getDomainDetailItemDate(from: currentItem.date) ?? ""
                newItem.confirmed = currentItem.confirmed - previousItem.confirmed
                newItem.recovered = currentItem.recovered - previousItem.recovered
                newItem.deaths = currentItem.deaths - previousItem.deaths
                newItem.active = currentItem.active - previousItem.active
                newDetails.append(newItem)
            }
        }
        return newDetails.reversed() as Array
    }
    
    private func createWorldwideDetails(from responseItems: [CountryStatus]) -> [HomeScreenDomainItemDetail] {
        var newDetails = [HomeScreenDomainItemDetail]()
        for responseItem in responseItems {
            var item = HomeScreenDomainItemDetail()
            item.title = responseItem.countryName
            item.confirmed = responseItem.totalConfirmed
            item.recovered = responseItem.totalRecovered
            item.deaths = responseItem.totalDeaths
            item.active = responseItem.totalConfirmed - responseItem.totalRecovered
            newDetails.append(item)
        }
        return newDetails.sorted { $0.confirmed > $1.confirmed }
    }
}
