//
//  Cache.swift
//  MeetRio
//
//  Created by Luiz Seibel on 30/09/24.
//

import Foundation

class EventCache {
    static let shared = EventCache() // Singleton para acesso global
    
    private let cache = NSCache<NSString, NSArray>()
    
    private init() {
        
        // Inicializa o cache com o evento fictício de MockData
        let mockEvent = MockData.eventDetails
        let category = mockEvent.eventCategory
        setEvents([mockEvent], forCategory: category)

        
        
        // Opcional: Definir limites de cache se necessário
//        cache.countLimit = 100 // Número máximo de categorias armazenadas
//        cache.totalCostLimit = 50 * 1024 * 1024 // 50 MB, por exemplo
    }
    
    // Recupera eventos para uma categoria específica
    func getEvents(forCategory category: String) -> [EventDetails]? {
        if let cachedArray = cache.object(forKey: category as NSString) as? [EventDetails] {
            return cachedArray
        }
        return nil
    }
    
    // Armazena eventos para uma categoria específica
    func setEvents(_ events: [EventDetails], forCategory category: String) {
        cache.setObject(events as NSArray, forKey: category as NSString)
    }
    
    // Limpa o cache
    func clearCache() {
        cache.removeAllObjects()
    }
}

class EventManager {
    static let shared = EventManager()
    
    private let cache = EventCache.shared
    
    private init() {}
    
    // Função assíncrona para buscar eventos com cache
    func fetchEvents(forCategory category: String) async throws -> [EventDetails] {
        // Verifica se os eventos estão no cache
        if let cachedEvents = cache.getEvents(forCategory: category) {
            print("Eventos carregados do cache para a categoria: \(category)")
            return cachedEvents
        }
        
        // Se não estiver no cache, busca no Firebase
        print("Buscando eventos do Firebase para a categoria: \(category)")
        let fetchedEvents = try await FirestoreManager.shared.getLabeledEvents(category)
        
        // Armazena os eventos no cache
        cache.setEvents(fetchedEvents, forCategory: category)
        
        return fetchedEvents
    }
    
    // Opcional: Função para invalidar cache de uma categoria específica
    func invalidateCache(forCategory category: String) {
        cache.setEvents([], forCategory: category)
    }
}
