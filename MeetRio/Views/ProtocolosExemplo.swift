//
//  ProtocolosExemplo.swift
//  MeetRio
//
//  Created by Luiz Seibel on 28/11/24.
//

import Foundation

// MARK: Estão fora pois são reutilizados
protocol Storage {
    func get(key: String) -> Any?
    func set(key: String, value: Any)
}

class FirebaseStorage: Storage {
    func get(key: String) -> Any? {
        print("Puxando valor: \(key) do Firebase")
        return nil
    }
    
    func set(key: String, value: Any) {
        print("Salvando valor: \(key) no Firebase")
    }
}

// MARK: Primeira forma de fzr (Injeção de Dependencia)

class Events {
    private let storage: Storage
    
    init(storage: Storage) {
        self.storage = storage
    }
    
    func setEvent(name: String, param: [String: Any]) {
        storage.set(key: "event(\(name))", value: param)
        print("Evento: \(name) com parâmetros: \(param)")
    }
}

let firebaseStorage = FirebaseStorage()
let testeEvents = Events(storage: firebaseStorage)
//Ex: testeEvents.logEvent(name: "user_signup", parameters: ["user_id": 123, "method": "email"])


// MARK: Segunda forma de fzr (Uso do static)

// Protocolo é o mesmo e o FirebaseStorage tmb

class BDService {
    static var storage: Storage = FirebaseStorage()
    
    static func setStorage(_ newStorage: Storage) {
        storage = newStorage
    }
    
    static func getStorage() -> Storage {
        return storage
    }
}

class Events1 {
    
    func setEvent(name: String, param: [String: Any]) {
        let storage = BDService.getStorage()
        storage.set(key: "event(\(name))", value: param)
        print("Evento: \(name) com parâmetros: \(param)")
    }
}

let testeEvents1 = Events1()
//Ex: testeEvents1.logEvent(name: "user_signup", parameters: ["user_id": 123, "method": "email"])

// MARK: Terceira forma (Factory)

class StorageFactory {
    static func createStorage() -> Storage {
        return FirebaseStorage()
    }
}

class Events2 {
    private let storage: Storage
    
    init() {
        self.storage = StorageFactory.createStorage()
    }
    
    func setEvent(name: String, param: [String: Any]) {
        storage.set(key: "event(\(name))", value: param)
        print("Evento: \(name) com parâmetros: \(param)")
    }
}

let testeEvents2 = Events2()
//testeEvents2.logEvent(name: "user_signup", parameters: ["user_id": 123, "method": "email"])

// MARK: Ultima pq já deu (Provedor de Dependencia)

class DependencyProvider{
    static var shared: DependencyProvider = DependencyProvider()
    
    private init(){}
    
    func provideStorage() -> Storage{
        return FirebaseStorage()
    }
    
    // daria p/ colocar outros servicos. Problema que é singleton.
}

class Events3{
    private let storage: Storage
    
    init(storageProvider: DependencyProvider = DependencyProvider.shared) {
        self.storage = storageProvider.provideStorage()
    }
    
    // Ou
    
    init(){
        self.storage = DependencyProvider.shared.provideStorage()
    }
    
    func setEvent(name: String, param: [String: Any]) {
        storage.set(key: "event(\(name))", value: param)
        print("Evento: \(name) com parâmetros: \(param)")
    }
}

let testeEvents3 = Events3()
//testeEvents3.logEvent(name: "user_signup", parameters: ["user_id": 123, "method": "email"])


//MARK: Conclusão

/*
 
 Pensei tmb em criar um servicesFactory, e matar o storageFactory, já que poderiamos utilizar sem o
 singleton. Porém, não sei até que ponto isso iria ferir o (s) do Solid já que teriamos um "God Object"
 e tmb querendo ou não, dessa forma não iriamos resolver muito bem a questão do acoplamento, já que
 teríamos um acoplamento meio que indireto.
 
 Acho que a forma mais alinhada com o SOLID é a de injeção de dependencia (Primeira). O problema seria a
 necessidade de passar manualmente. PORÉM, descobri o swinject talvez seja a boa, já que ele gerencia
 automáticamente essa questão de passar as dependencias.
 
 import Swinject

 let container = Container()
 container.register(Storage.self) { _ in
     FirebaseStorage()
 }
 container.register(Events.self) { resolver in
     let storage = resolver.resolve(Storage.self)!
     return Events(storage: storage)
 }
 
 let events = container.resolve(Events.self)!
 events.setEvent(name: "user_signup", param: ["user_id": 123, "method": "email"])
 
 */
