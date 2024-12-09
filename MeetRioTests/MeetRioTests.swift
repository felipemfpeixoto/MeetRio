//
//  MeetRioTests.swift
//  MeetRioTests
//
//  Created by Felipe on 27/09/24.
//

import Testing
@testable import MeetRio

struct MeetRioTests {

    @Test func example() async throws {
        
        // Cria um user fixo no banco explicito que é para testes
        // Documenta aqui os dados esperados
        // pega o hospede a partir do User do banco
        // compara os dados do hospede esperado com os dados que vieram do banco
        print("oi")
        #expect(10 == 100)
        #expect(10 == 10)
//        await #expect(throws: AuthError.noUserAuthenticated) {
//            var authenticatedHospede = try await Hospede()
//        }
        
//        
//        await #expect(throws: Never.self) {
//            var expectedHospede = Hospede(
//                id: "YGJPEBRIDCQRvCaU6cjUVVq6WBy2",
//                name: "teste",
//                email: "teste@gmail.com",
//                imageURL: "https://firebasestorage.googleapis.com:443/v0/b/meetrio.appspot.com/o/profilePics%2FYGJPEBRIDCQRvCaU6cjUVVq6WBy2%2Fprofile.jpg?alt=media&token=71e809af-140a-44b8-8d96-88ccfb170c18",
//                loggedCase: .registered,
//                country: CountryDetails(name: "", flag: ""),
//                hostel: nil
//            )
//            let retrievedHospede = try await Hospede(email: "teste@gmail.com", password: "1234")
//            
//            #expect(expectedHospede.id == retrievedHospede.id && expectedHospede.email == retrievedHospede.email)
//        }
    }

}
