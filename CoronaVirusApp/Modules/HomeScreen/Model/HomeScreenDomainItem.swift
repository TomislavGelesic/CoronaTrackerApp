
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
        stats = createStats(confirmedTotalCount: totalStatsLast.confirmed,
                            confirmedDifferenceCount: totalStatsLast.confirmed - totalStatsSecondToLast.confirmed,
                            activeTotalCount: totalStatsLast.active,
                            activeDifferenceCount: totalStatsLast.active - totalStatsSecondToLast.active,
                            recoveredTotalCount: totalStatsLast.recovered,
                            recoveredDifferenceCount: totalStatsLast.recovered - totalStatsSecondToLast.recovered,
                            deathsTotalCount: totalStatsLast.deaths,
                            deathsDifferenceCount: totalStatsLast.deaths - totalStatsSecondToLast.deaths)
        details = createCountryDetails(from: dayOneStatsResponse)
        lastUpdateDate = Date()
    }
    
    init(_ item: WorldwideResponseItem) {
        title = "Worldwide"
        stats = createStats(confirmedTotalCount: item.global.totalConfirmed,
                            confirmedDifferenceCount:  item.global.newConfirmed,
                            activeTotalCount: item.global.totalConfirmed - item.global.totalRecovered,
                            activeDifferenceCount: item.global.newConfirmed - item.global.newRecovered,
                            recoveredTotalCount: item.global.totalRecovered,
                            recoveredDifferenceCount: item.global.newRecovered,
                            deathsTotalCount: item.global.totalDeaths,
                            deathsDifferenceCount: item.global.newDeaths)
        details = createWorldwideDetails(from: item.countries)
        lastUpdateDate = Date()
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
