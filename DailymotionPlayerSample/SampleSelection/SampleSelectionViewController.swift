import UIKit
import DailymotionPlayerSDK

class SampleSelectionViewController: DailymotionBaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var appVersionLabel: UILabel!
    @IBOutlet weak var SDKVersionLabel: UILabel!
    
    let datasource: ScreenSelectionDatasourceModel = SampleSelectionHelper.createDatasource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        appDelegate?.isCastControlBarsEnabled = true
    }
    
    func setupView() {
        let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
        appVersionLabel.text = "App v\(buildNumber)"
        SDKVersionLabel.text = "SDK v\(DailymotionPlayer.sdkVersion)"
        overrideUserInterfaceStyle = .light
        title = NSLocalizedString("SampleScreenSelectionTitle", comment: "")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: SampleSelectionHeaderFooterView.headerIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: SampleSelectionHeaderFooterView.headerIdentifier)
        tableView.register(UINib(nibName: SampleSelectionTableViewCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: SampleSelectionTableViewCell.cellIdentifier)
        tableView.separatorStyle = .none
        tableView.reloadData()
    }
  
  
    
}

extension SampleSelectionViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return datasource.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.sections[section].cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let selectionCell = datasource.sections[indexPath.section].cells[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: SampleSelectionTableViewCell.cellIdentifier) as! SampleSelectionTableViewCell
        cell.cellTitleLabel.text = selectionCell.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: SampleSelectionHeaderFooterView.headerIdentifier) as! SampleSelectionHeaderFooterView
        headerView.sectionTitleLabel.text = datasource.sections[section].name
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
}

extension SampleSelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectionCell = datasource.sections[indexPath.section].cells[indexPath.row]
        switch selectionCell.type {
            
        case .basic:
            performSegue(withIdentifier: "BasicEmbed", sender: self)
        case .advertising:
            performSegue(withIdentifier: "AdvertisingEmbed", sender: self)
        case .vertical:
            performSegue(withIdentifier: "VerticalPlayer", sender: self)
        case .live:
            performSegue(withIdentifier: "LivePlayer", sender: self)
        case .eventsAndState:
            performSegue(withIdentifier: "PlayerStateEvents", sender: self)
        case .methods:
            performSegue(withIdentifier: "PlayerMethods", sender: self)
        }
    }
}

