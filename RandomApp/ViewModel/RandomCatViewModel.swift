//
//  RandomCatViewModel.swift
//  RandomApp
//
//  Created by Tokio Marine on 28/07/23.
//

import Foundation

final class RandomCatViewModel: ObservableObject {
    @Published var catFact: CatFact?
    @Published var isLoading = false
    
    func fetchCat() {
        isLoading = true
        let url = URL(string: "https://catfact.ninja/fact")!
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
                self.isLoading = false
                return
            }
            
            guard let data = data else {
                print("Error: Empty data")
                self.isLoading = false
                return
            }
            
            do {
                let catFact = try JSONDecoder().decode(CatFact.self, from: data)
                
                DispatchQueue.main.async {
                    self.catFact = catFact
                    self.isLoading = false
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
}
