
import UIKit

class HomeScreenMiddleView: UIView {
    
    let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        return stackView
    }()
    let firstHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        return stackView
    }()
    
    let secondHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        return stackView
    }()
    
    let confirmedCaseView: StatusCaseView = {
        let view = StatusCaseView(contentColor: .systemRed)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.titleLabel.text = "confirmed".uppercased()
        view.graphImageView.image = UIImage(named: "graph-homescreen")
        return view
    }()
    
    let activeCaseView: StatusCaseView = {
        let view = StatusCaseView(contentColor: .systemBlue)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.titleLabel.text = "active".uppercased()
        view.graphImageView.image = UIImage(named: "graph-homescreen")
        return view
    }()
    
    let recoveredCaseView: StatusCaseView = {
        let view = StatusCaseView(contentColor: .systemGreen)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.titleLabel.text = "recovered".uppercased()
        view.graphImageView.image = UIImage(named: "graph-up-homescreen")
        return view
    }()
    
    let deathsCaseView: StatusCaseView = {
        let view = StatusCaseView(contentColor: .systemGray)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.titleLabel.text = "deceased".uppercased()
        view.graphImageView.image = UIImage(named: "graph-down-homescreen")
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        setViews()
        setConstraints()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension HomeScreenMiddleView {
    
    func update(with data: HomeScreenDomainItem) {
        guard let confirmedData = data.stats.first(where: { $0.type == .confirmed }),
              let activeData = data.stats.first(where: { $0.type == .active }),
              let recoveredData = data.stats.first(where: { $0.type == .recovered }),
              let deathsData = data.stats.first(where: { $0.type == .deaths })
        else { return }
        confirmedCaseView.configure(with: confirmedData)
        activeCaseView.configure(with: activeData)
        recoveredCaseView.configure(with: recoveredData)
        deathsCaseView.configure(with: deathsData)
    }
    
    func setViews() {
        firstHorizontalStackView.addArrangedSubviews([confirmedCaseView, activeCaseView])
        secondHorizontalStackView.addArrangedSubviews([recoveredCaseView, deathsCaseView])
        verticalStackView.addArrangedSubviews([firstHorizontalStackView, secondHorizontalStackView])
        addSubview(verticalStackView)
    }
    
    func addShadows() {
        confirmedCaseView.addShadow(color: .black)
        activeCaseView.addShadow(color: .black)
        recoveredCaseView.addShadow(color: .black)
        deathsCaseView.addShadow(color: .black)
    }
    
    func setConstraints() {
        verticalStackView.snp.makeConstraints { make in make.edges.equalToSuperview() }
    }
}
