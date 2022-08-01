import UIKit

protocol MainViewDelegate: AnyObject {
    func updateUI(with model: CovidData)
    func showAlert(title: String)
    func fillTableView(with model: CovidData)
    
}

class MainViewController: UIViewController {
    
    let presenter: MainPresenter
    
    let tableView = UITableView()
    var countries: [CovidData] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    let firstScreenView = UIView()
    let secondScreenView = UIView()
    let thirdScreenView = UIView()
    let chooseCountryTextField = UITextField()
    let picker = UIPickerView()
    let stackViewWithImages = UIStackView()
    let stackViewWithDescription = UIStackView()
    
    let headerView = UIView()
    let bottomBar = UIView()
    let topLabel = UILabel()
    let homeIcon = UIImage(systemName: "globe.europe.africa", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .semibold, scale: .default))
    let favouriteIcon = UIImage(systemName: "allergens", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .semibold, scale: .default))
    let settingsIcon = UIImage(systemName: "gear", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .semibold, scale: .default))
    let firstButton = UIButton()
    let secondButton = UIButton()
    let thirdButton = UIButton()
    
    let capitalImageView = UIImageView()
    let populationImageView = UIImageView()
    let confirmedImageView = UIImageView()
    let deathsImageView = UIImageView()
    let capitalLabel = UILabel()
    let populationLabel = UILabel()
    let confirmedLabel = UILabel()
    let deathsLabel = UILabel()
    
    lazy var loadActivityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.color = .black
        indicator.style = .large
        return indicator
    }()
    // MARK: - Lifecycle
       
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpHeaderView()
        setUpBottomBar()
        setUpMainScreens()
        configureFirstScreenView()
        configureSecondScreenView()
        configureThirdScreenView()
        presenter.getDataForTableView(endpoind: CovidAPI.Belarus)
        loadActivityIndicator.startAnimating()
    }
    // MARK: - Initialization
    
    init(presenter: MainPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Private methods
    
    func configureSecondScreenView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CustomCell.self, forCellReuseIdentifier: "CustomCell")
        tableView.backgroundColor = .white
        tableView.backgroundView?.backgroundColor = .white
        tableView.sectionHeaderHeight = .zero
        secondScreenView.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: secondScreenView.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: secondScreenView.trailingAnchor, constant: -10),
            tableView.topAnchor.constraint(equalTo: secondScreenView.topAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: secondScreenView.bottomAnchor, constant: -20),
        ])
    }
    
    func configureThirdScreenView() {
        let thirdScreenLabel = UILabel()
        thirdScreenView.addSubview(thirdScreenLabel)
        thirdScreenLabel.text = "UNFORTUNATTELY, THERE IS NO CONTENT ON THIS SCREEN RIGHT NOW. CHECK IT AFTER UPCOMING UPDATE."
        thirdScreenLabel.textColor = .black
        thirdScreenLabel.numberOfLines = 10
        thirdScreenLabel.textAlignment = .center
        thirdScreenLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            thirdScreenLabel.centerXAnchor.constraint(equalTo: thirdScreenView.centerXAnchor),
            thirdScreenLabel.centerYAnchor.constraint(equalTo: thirdScreenView.centerYAnchor),
            thirdScreenLabel.heightAnchor.constraint(equalTo: thirdScreenView.heightAnchor),
            thirdScreenLabel.widthAnchor.constraint(equalTo: thirdScreenView.widthAnchor, multiplier: 0.8)])
    }
    
    func configureFirstScreenView() {
        capitalImageView.image = UIImage(systemName: "building.2.crop.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 100, weight: .semibold, scale: .default))
        populationImageView.image = UIImage(systemName: "person.2.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 100, weight: .semibold, scale: .default))
        confirmedImageView.image = UIImage(systemName: "stethoscope.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 100, weight: .semibold, scale: .default))
        deathsImageView.image = UIImage(systemName: "cross.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 100, weight: .semibold, scale: .default))
        
        [stackViewWithImages,stackViewWithDescription].forEach {
            firstScreenView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .white
            $0.tintColor = .black
            $0.axis = .vertical
            $0.distribution = .fillEqually
            $0.spacing = 10
            
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: chooseCountryTextField.bottomAnchor),
                $0.bottomAnchor.constraint(equalTo: bottomBar.topAnchor, constant: -40)
            ])
        }
        
        [capitalLabel, populationLabel, confirmedLabel, deathsLabel].forEach {
            stackViewWithDescription.addArrangedSubview($0)
            $0.numberOfLines = 2
            $0.text = "Please, select country to get data"
            $0.textColor = .black
        }
        
        [capitalImageView, populationImageView, confirmedImageView, deathsImageView].forEach {
            stackViewWithImages.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            stackViewWithImages.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackViewWithImages.widthAnchor.constraint(equalTo: stackViewWithImages.heightAnchor, multiplier: 0.24),
            stackViewWithDescription.leadingAnchor.constraint(equalTo: stackViewWithImages.trailingAnchor),
            stackViewWithDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    func setUpMainScreens() {
        [firstScreenView, secondScreenView, thirdScreenView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: headerView.bottomAnchor),
                $0.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                $0.bottomAnchor.constraint(equalTo: bottomBar.topAnchor)
            ])
        }
        secondScreenView.isHidden = true
        thirdScreenView.isHidden = true
        view.addSubview(loadActivityIndicator)
        firstScreenView.addSubview(chooseCountryTextField)
        chooseCountryTextField.translatesAutoresizingMaskIntoConstraints = false
        chooseCountryTextField.inputView = picker
        chooseCountryTextField.backgroundColor = .secondarySystemFill
        chooseCountryTextField.borderStyle = .roundedRect
        chooseCountryTextField.font = .systemFont(ofSize: 26)
        chooseCountryTextField.attributedPlaceholder = NSAttributedString(
            string: "Select country...",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        chooseCountryTextField.textAlignment = .center
        chooseCountryTextField.textColor = .black
        
        picker.delegate = self
        picker.dataSource = self
    
        NSLayoutConstraint.activate([
            chooseCountryTextField.topAnchor.constraint(equalTo: firstScreenView.topAnchor, constant: 20),
            chooseCountryTextField.leadingAnchor.constraint(equalTo: firstScreenView.leadingAnchor),
            chooseCountryTextField.trailingAnchor.constraint(equalTo: firstScreenView.trailingAnchor),
            chooseCountryTextField.heightAnchor.constraint(equalTo: firstScreenView.heightAnchor, multiplier: 0.07),
            loadActivityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadActivityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func setUpHeaderView() {
        view.backgroundColor = .white
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = UIColor(red: 0.25, green: 0.88, blue: 0.82, alpha: 1.00)
        headerView.clipsToBounds = false
        headerView.layer.cornerRadius = 25
        headerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        headerView.layer.shadowRadius = 7
        headerView.layer.shadowOpacity = 0.3
        headerView.addSubview(topLabel)
        topLabel.text = "COVID-19 in Europe"
        topLabel.textColor = .black
        topLabel.adjustsFontSizeToFitWidth = true
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topLabel.textAlignment = .center
        topLabel.font = .monospacedSystemFont(ofSize: 30, weight: .medium)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor, constant: -25),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.18),
            
            topLabel.heightAnchor.constraint(equalTo: headerView.heightAnchor, multiplier: 0.3),
            topLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -20),
            topLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 5),
            topLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -5)
        ])
    }
    
//    MARK - BOTTOM BAR
    
    func setUpBottomBar() {
        view.addSubview(bottomBar)
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.backgroundColor = UIColor(red: 0.25, green: 0.88, blue: 0.82, alpha: 1.00)
        bottomBar.layer.shadowOffset = CGSize(width: 0, height: -3)
        bottomBar.layer.shadowRadius = 7
        bottomBar.layer.shadowOpacity = 0.3
        firstButton.setImage(homeIcon, for: .normal)
        secondButton.setImage(favouriteIcon, for: .normal)
        thirdButton.setImage(settingsIcon, for: .normal)
        firstButton.addTarget(self, action: #selector(buttonOneTapped), for: .touchUpInside)
        secondButton.addTarget(self, action: #selector(buttonTwoTapped), for: .touchUpInside)
        thirdButton.addTarget(self, action: #selector(buttonThreeTapped), for: .touchUpInside)
        
        [firstButton, secondButton, thirdButton].forEach {
            bottomBar.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.tintColor = .darkGray
            
            NSLayoutConstraint.activate([
                $0.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor),
                $0.heightAnchor.constraint(equalTo: bottomBar.heightAnchor, multiplier: 0.5),
                $0.widthAnchor.constraint(equalTo: $0.heightAnchor)
            ])
        }
        
        NSLayoutConstraint.activate([
            bottomBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomBar.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.08),
            secondButton.centerXAnchor.constraint(equalTo: bottomBar.centerXAnchor),
            firstButton.leadingAnchor.constraint(equalTo: bottomBar.leadingAnchor, constant: 30),
            thirdButton.trailingAnchor.constraint(equalTo: bottomBar.trailingAnchor, constant: -30)
        ])
    }
    
    @objc func buttonOneTapped() {
        firstScreenView.isHidden = false
        secondScreenView.isHidden = true
        thirdScreenView.isHidden = true
    }
    
    @objc func buttonTwoTapped() {
        firstScreenView.isHidden = true
        secondScreenView.isHidden = false
        thirdScreenView.isHidden = true
    }
    
    @objc func buttonThreeTapped() {
        firstScreenView.isHidden = true
        secondScreenView.isHidden = true
        thirdScreenView.isHidden = false
    }
}
