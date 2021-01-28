//
//  JokeViewController.swift
//  Chucknorsis
//
//  Created by Lee McCormick on 1/27/21.
//

import UIKit

class JokeViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var valueJokeLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoriesPickerView: UIPickerView!
    
    // MARK: - Properties
    var categories: [String] = []
    var pickData: [String] = [String]()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCategories()
        self.categoriesPickerView.delegate = self
        self.categoriesPickerView.dataSource = self
    }
    
    // MARK: - Actions
    @IBAction func newJokeButtonTapped(_ sender: Any) {
        guard let catagory = categories.randomElement() else { return }
        fetchJoke(catagory: catagory)
    }
    
    // MARK: - Helper Fuctions
    func fetchJoke(catagory: String) {
        JokeController.fetchJoke(catagory: catagory) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let joke):
                    self.fetchIconAndUpdateViews(joke: joke)
                case .failure(let error):
                    self.presentErrorToUser(localizedError: error)
                }
            }
        }
    }
    
    func fetchCategories() {
        JokeController.fetchCategories { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let categories):
                    self.categories = categories
                    self.categoriesPickerView.reloadAllComponents()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        }
    }
    
    func fetchIconAndUpdateViews(joke: Joke) {
        JokeController.fetchIcon(for: joke) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let imageIcon):
                    self.iconImageView.image = imageIcon
                    self.valueJokeLabel.text = joke.value
                    self.categoryLabel.text = joke.categories[0]
                case .failure(let error):
                    self.presentErrorToUser(localizedError: error)
                }
            }
        }
    }
}

// MARK: - Extensions UIPickerViewDelegate, UIPickerViewDataSource 
extension JokeViewController: UIPickerViewDelegate, UIPickerViewDataSource  {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let category = categories[row]
        fetchJoke(catagory: category)
    }
}
