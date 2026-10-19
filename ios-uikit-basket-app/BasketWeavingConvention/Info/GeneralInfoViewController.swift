import UIKit
import MapKit

class GeneralInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties

    private let tableView = UITableView()
    private let mapView = MKMapView()

    // Array of (label, value) tuples for event details
    private let eventInfo = [
        ("Date", "1st - 3rd December 2025"),
        ("Time", "9:00 AM - 5:00 PM"),
        ("Venue", "Ngee Ann Polytechnic Convention Centre"),
        ("Address", "535 Clementi Rd, Singapore 599489")
    ]

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "General Info"
        navigationItem.largeTitleDisplayMode = .always

        setupMapView()
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Setup

    private func setupMapView() {
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false

        // Map takes 30% of screen height at the top
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
        ])

        let coordinate = CLLocationCoordinate2D(latitude: 1.332, longitude: 103.774)
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: false)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Ngee Ann Polytechnic"
        mapView.addAnnotation(annotation)
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        // Table view fills remaining space below the map
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: mapView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "moreInfoCell")
    
        // Empty footer view removes separator lines below last row
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .systemBackground
    }

    // MARK: - UITableViewDataSource

    /// Event detail rows plus one trailing "More info" row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        eventInfo.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < eventInfo.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let info = eventInfo[indexPath.row]

            var content = cell.defaultContentConfiguration()
            content.text = info.0
            content.secondaryText = info.1
            cell.selectionStyle = .none
            cell.accessoryType = .none
            cell.contentConfiguration = content
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.text = "More info"
            content.textProperties.color = view.tintColor
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .default
            cell.contentConfiguration = content
            return cell
        }
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == eventInfo.count {
            tableView.deselectRow(at: indexPath, animated: true)
            navigationController?.pushViewController(MoreInfoViewController(), animated: true)
        }
        else { return }
    }
}


#Preview {
    GeneralInfoViewController()
}
