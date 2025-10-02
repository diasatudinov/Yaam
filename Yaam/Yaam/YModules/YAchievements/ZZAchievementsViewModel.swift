//
//  ZZAchievementsViewModel.swift
//  Yaam
//
//


import SwiftUI

class ZZAchievementsViewModel: ObservableObject {
    
    @Published var achievements: [NEGAchievement] = [
        NEGAchievement(image: "achieve1ImageY", title: "upgrade all\nspells", isAchieved: false),
        NEGAchievement(image: "achieve2ImageY", title: "buy all\nspells per\nlevel ", isAchieved: false),
        NEGAchievement(image: "achieve3ImageY", title: "Defeat 50\nenemies", isAchieved: false),
        NEGAchievement(image: "achieve4ImageY", title: "Complete the\nlevel on hard\ndifficulty", isAchieved: false),
        NEGAchievement(image: "achieve5ImageY", title: "upgrade\ntower health", isAchieved: false),

    ] {
        didSet {
            saveAchievementsItem()
        }
    }
        
    init() {
        loadAchievementsItem()
        
    }
    
    private let userDefaultsAchievementsKey = "achievementsKeyY"
    
    func achieveToggle(_ achive: NEGAchievement) {
        guard let index = achievements.firstIndex(where: { $0.id == achive.id })
        else {
            return
        }
        achievements[index].isAchieved.toggle()
        
    }
   
    
    
    func saveAchievementsItem() {
        if let encodedData = try? JSONEncoder().encode(achievements) {
            UserDefaults.standard.set(encodedData, forKey: userDefaultsAchievementsKey)
        }
        
    }
    
    func loadAchievementsItem() {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsAchievementsKey),
           let loadedItem = try? JSONDecoder().decode([NEGAchievement].self, from: savedData) {
            achievements = loadedItem
        } else {
            print("No saved data found")
        }
    }
}

struct NEGAchievement: Codable, Hashable, Identifiable {
    var id = UUID()
    var image: String
    var title: String
    var isAchieved: Bool
}
