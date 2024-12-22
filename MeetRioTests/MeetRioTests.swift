//
//  MeetRioTests.swift
//  MeetRioTests
//
//  Created by Felipe on 27/09/24.
//

import Testing
@testable import MeetRio

struct MeetRioTests {

    @Test func authenticationTests() async throws {
        
        // Cria um user fixo no banco explicito que é para testes
        // Documenta aqui os dados esperados
        // pega o hospede a partir do User do banco
        // compara os dados do hospede esperado com os dados que vieram do banco
        
        // MARK: Começando com um sign out para garantir que não terá usuários logados no início dos testes
        await #expect(throws: Never.self) {
            try await Hospede.signOut()
        }
        
        // MARK: Teste de getAuthenticatedUser sem nenhum usuário autenticado
        await #expect(throws: AuthError.noUserAuthenticated) {
            var authenticatedHospede = try await Hospede()
        }
        
        // MARK: Teste de criação de nova conta
        await #expect(throws: Never.self) {
            var newUser = try await Hospede(email: "teste@gmail.com", password: "123456", isNewUser: true)
            
            newUser.name = "teste"
            newUser.country = CountryDetails(name: "Brasil", flag: "🇧🇷")
            try await newUser.create()
        }
        
        // MARK: Teste de get do user que está autenticado
        await #expect(throws: Never.self) {
            var authenticatedHospede = try await Hospede()
            
            #expect(authenticatedHospede.email == "teste@gmail.com" && authenticatedHospede.name == "teste")
            
            try await Hospede.signOut()
        }
        
        // MARK: Teste de login
        await #expect(throws: Never.self) {
            let authenticatedHospede = try await Hospede(email: "teste@gmail.com", password: "123456")
            
            #expect(authenticatedHospede.email == "teste@gmail.com" && authenticatedHospede.name == "teste")
            try await Hospede.signOut()
        }
        
        // MARK: Teste de exclusão de conta
        await #expect(throws: Never.self) {
            var authenticatedHospede = try await Hospede(email: "teste@gmail.com", password: "123456")
            
            try await authenticatedHospede.deleteUser()
        }
        
        // MARK: Teste de login anonimo
        await #expect(throws: Never.self) {
            let authenticatedHospede = try await Hospede(isAnonymous: true)
            #expect(Hospede.loggedCase == .anonymous)
            try await Hospede.signOut()
        }
    }
    
    @Test func eventsTests() async throws {
        var id: String = ""
        
        // MARK: Teste de criação de um evento
        await #expect(throws: Never.self) {
            let newEvent = EventDetails(
                eventCategory: EventCategory(eventType: .nightlife),
                description: "Evento de teste",
                name: "Teste Event"
            )
            
            id = newEvent.id
            
            try await newEvent.create()
        }
        
        // MARK: Teste de get de um evento (init)
        await #expect(throws: Never.self) {
            let gottedEvent = try await EventDetails(id: id)
            
            #expect(gottedEvent.name == "Teste Event")
        }
        
        // MARK: Teste de update de um evento
        await #expect(throws: Never.self) {
            let gottedEvent = try await EventDetails(id: id)
            gottedEvent.name = "Teste Event Updated"
            try await gottedEvent.updateItem()
            
            let gottedUpdatedEvent = try await EventDetails(id: id)
            #expect(gottedUpdatedEvent.name == "Teste Event Updated")
        }
        
        // MARK: Teste de exclusão de um evento
        await #expect(throws: Never.self) {
            let gottedEvent = try await EventDetails(id: id)
            try await gottedEvent.deleteItem()
        }
        
        // MARK: Tentando fazer o get do evento excluído anteriormente, esperando um erro
        await #expect(throws: Error.self) {
            let gottedEvent = try await EventDetails(id: id)
            try await gottedEvent.deleteItem()
        }
    }
    
    // MARK: Bateria de testes de hostel (Como User)
    @Test func hostelTestsUser() async throws {
        
        // MARK: Começando com um sign out para garantir que não terá usuários logados no início dos testes
        await #expect(throws: Never.self) {
            try await Hostel.signOut()
        }
        
        // MARK: Teste de getAuthenticatedUser sem nenhum usuário autenticado
        await #expect(throws: AuthError.noUserAuthenticated) {
            var authenticatedHostel = try await Hostel()
        }
        
        // MARK: Teste de criação de nova conta
        await #expect(throws: Never.self) {
            var newUser = try await Hostel(email: "testehostel@gmail.com", password: "123456", isNewUser: true)
            
            
            try await newUser.create()
        }
        
        // MARK: Teste de get do user que está autenticado
        await #expect(throws: Never.self) {
            var authenticatedHostel = try await Hostel()
            
            print("************* AuthenticatedHostel: ", authenticatedHostel.email)
            
            #expect(authenticatedHostel.email == "testehostel@gmail.com")
            
            try await Hostel.signOut()
        }
        
        // MARK: Teste de login
        await #expect(throws: Never.self) {
            let authenticatedHostel = try await Hostel(email: "testehostel@gmail.com", password: "123456")
            
            #expect(authenticatedHostel.email == "testehostel@gmail.com")
            try await Hostel.signOut()
        }
        
        // MARK: Teste de exclusão de conta
        await #expect(throws: Never.self) {
            var authenticatedHostel = try await Hostel(email: "testeHostel@gmail.com", password: "123456")

            try await authenticatedHostel.deleteUser()
        }
    }
    
    // MARK: Bateria de testes de hostel (Como CRUDItem)
    @Test func hostelTestsCRUDItem() async throws {
        
        
        
    }
}
