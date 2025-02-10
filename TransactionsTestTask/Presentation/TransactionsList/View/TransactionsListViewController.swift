//
//  TransactionsListViewController.swift
//  TransactionsTestTask
//
//  Created by Kostiantyn Antoniuk on 05.02.2025.
//

import UIKit
import Combine

final class TransactionsListViewController: UIViewController {
    
    private let viewModel: TransactionsListViewModel
    private var subcriptions = Set<AnyCancellable>()

    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let totalAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "Balance: 0 BTC"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let topUpBalanceButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Top up balance", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let addTransactionButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Add Transaction", for: .normal)
        button.contentMode = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    init(viewModel: TransactionsListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configureUI()
        setupActions()
        initializeBindings()
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension TransactionsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as? TransactionCell else { return .init() }
        let transaction = viewModel.cellForRowAt(indexPath)
        cell.configure(with: transaction)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}

// MARK: - Private methods
private extension TransactionsListViewController {
    func setupUI() {
        view.addSubview(headerView)
        headerView.addSubview(totalAmountLabel)
        headerView.addSubview(topUpBalanceButton)
        headerView.addSubview(addTransactionButton)
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            totalAmountLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8),
            totalAmountLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 8),
            totalAmountLabel.trailingAnchor.constraint(equalTo: topUpBalanceButton.leadingAnchor, constant: -8),
            
            topUpBalanceButton.leadingAnchor.constraint(equalTo: totalAmountLabel.trailingAnchor, constant: 8),
            topUpBalanceButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -8),
            topUpBalanceButton.centerYAnchor.constraint(equalTo: totalAmountLabel.centerYAnchor),
            topUpBalanceButton.heightAnchor.constraint(equalTo: totalAmountLabel.heightAnchor),
            
            addTransactionButton.topAnchor.constraint(equalTo: totalAmountLabel.bottomAnchor),
            addTransactionButton.leadingAnchor.constraint(equalTo: totalAmountLabel.leadingAnchor),
            addTransactionButton.trailingAnchor.constraint(equalTo: totalAmountLabel.trailingAnchor),
            addTransactionButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8),
            
            
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func configureUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)

        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TransactionCell.self, forCellReuseIdentifier: "TransactionCell")
    }
    
    func initializeBindings() {
        viewModel.reloadDataPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak tableView] _ in tableView?.reloadData() }
            .store(in: &subcriptions)
    }
    
    func setupActions() {
        addTransactionButton.addTarget(self, action: #selector(addTransactionTapped), for: .touchUpInside)
        topUpBalanceButton.addTarget(self, action: #selector(topUpBalanceTapped), for: .touchUpInside)
    }
    
    @objc func addTransactionTapped() {
        viewModel.addTransactionAction()
    }
    
    @objc func topUpBalanceTapped() {
        viewModel.topUpBalanceAction()
    }
}

import SwiftUI
#Preview {
    let coordinator = TransactionsListCoordinator(navigationController: UINavigationController())
    let model = TransactionsListModelImpl()
    let viewModel = TransactionsListViewModelImpl(model: model, navigationHandler: coordinator)
    TransactionsListViewController(viewModel: viewModel)
}
