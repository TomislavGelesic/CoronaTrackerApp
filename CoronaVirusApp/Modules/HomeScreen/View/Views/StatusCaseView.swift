
import UIKit
import SnapKit

class StatusCaseView: UIView {
    
    let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        return stackView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = label.font.withSize(14)
        return label
    }()
    
    let totalCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(28)
        label.textColor = .gray
        return label
    }()
    
    let differenceContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let differenceCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(16)
        label.textColor = .gray
        return label
    }()
    
    let differenceArrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "arrow.down"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let graphImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    init(contentColor color: UIColor) {
        super.init(frame: .zero)
        setupAppearance(contentColor: color)
        differenceContainer.addSubviews([differenceArrowImageView, differenceCountLabel])
        horizontalStackView.addArrangedSubviews([totalCountLabel, differenceContainer])
        verticalStackView.addArrangedSubviews([titleLabel, horizontalStackView, graphImageView])
        addSubview(verticalStackView)
        setConstraints()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupAppearance(contentColor color: UIColor) {
        totalCountLabel.textColor = color
        differenceCountLabel.textColor = color
        differenceArrowImageView.tintColor = color
        graphImageView.tintColor = color
        backgroundColor = .backgroundColorSecond
    }
    
    func configure(with item: StatsData) {
        var arrowImage: UIImage? = .init()
        var graphImage: UIImage? = .init()
        switch item.delta {
        case 0:
            graphImage = .graphNeutralSlope
            arrowImage = .arrowRight
        case 1...17:
            graphImage = .graphPositiveSlope1
            arrowImage = .arrowUp
        case 17...Int.max:
            graphImage = .graphPositiveSlope2
            arrowImage = .arrowUp
        default:
            graphImage = .graphNegativeSlope
            arrowImage = .arrowDown
        }
        differenceCountLabel.text = "\(NumberUtils.getPositiveNumberWithMetricPrefixSymbol(item.delta))"
        totalCountLabel.text = "\(NumberUtils.getPositiveNumberWithMetricPrefixSymbol(item.value))"
        differenceArrowImageView.image = arrowImage
        graphImageView.image = graphImage?.withRenderingMode(.alwaysTemplate)
    }
    
    func setConstraints() {
        verticalStackView.snp.makeConstraints { (make) in make.edges.equalToSuperview().inset(10) }
        titleLabel.snp.makeConstraints { make in make.height.equalTo(30)}
        totalCountLabel.snp.makeConstraints { make in make.height.equalTo(30) }
        differenceArrowImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(differenceCountLabel.font.pointSize)
            make.leading.equalTo(differenceContainer)
        }
        differenceCountLabel.snp.makeConstraints { make in
            make.leading.equalTo(differenceArrowImageView.snp.trailing)
            make.trailing.equalTo(differenceContainer)
            make.centerY.equalToSuperview()
        }
        graphImageView.snp.makeConstraints { make in make.height.equalTo(44) }
    }
}
