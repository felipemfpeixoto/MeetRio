//
//  SheetViewModel.swift
//  MeetRio
//
//  Created by Luiz Seibel on 21/08/24.
//

import Foundation

class SheetViewModelLIXO: ObservableObject {
    @Published var isShowing: Bool = false
    @Published var selectedSafetyRating: Int = 0
}

let events: [EventDetails] = []

//let events = [EventDetails(
//        name: "Cristo Redentor",
//        description: "Uma das novas sete maravilhas do mundo, o Cristo Redentor oferece uma vista panorâmica incrível do Rio de Janeiro.",
//        dateDetails: DateDetails(startDate: Date(), endDate: Date(), isRecurring: false),
//        address: AddressDetails(street: "Parque Nacional da Tijuca", number: "S/N", neighborhood: "Alto da Boa Vista", postalCode: "22240903"),
//        location: LocationDetails(latitude: -22.9519, longitude: -43.2105),
//        safetyRate: 5
//    ), EventDetails(
//        name: "Pão de Açúcar",
//        description: "Um dos cartões-postais mais famosos do Rio de Janeiro, oferecendo uma vista deslumbrante da cidade e do litoral.",
//        dateDetails: DateDetails(startDate: Date(), endDate: Date(), isRecurring: false),
//        address: AddressDetails(street: "Avenida Pasteur", number: "520", neighborhood: "Urca", postalCode: "22290240"),
//        location: LocationDetails(latitude: -22.9485, longitude: -43.1564),
//        safetyRate: 5
//    ), EventDetails(
//        name: "Maracanã",
//        description: "O icônico estádio de futebol que já sediou duas finais de Copa do Mundo, é um dos maiores do mundo.",
//        dateDetails: DateDetails(startDate: Date(), endDate: Date(), isRecurring: false),
//        address: AddressDetails(street: "Avenida Presidente Castelo Branco", number: "S/N", neighborhood: "Maracanã", postalCode: "20271130"),
//        location: LocationDetails(latitude: -22.9121, longitude: -43.2302),
//        safetyRate: 2
//    ), EventDetails(
//        name: "Museu do Amanhã",
//        description: "Um museu de ciências inovador que explora as possibilidades de construção do futuro e os desafios da humanidade.",
//        dateDetails: DateDetails(startDate: Date(), endDate: Date(), isRecurring: false),
//        address: AddressDetails(street: "Praça Mauá", number: "1", neighborhood: "Centro", postalCode: "20081262"),
//        location: LocationDetails(latitude: -22.8945, longitude: -43.1800),
//        safetyRate: 5
//    ), EventDetails(
//        name: "Lapa",
//        description: "Conhecida por seus arcos e pela vida noturna vibrante, a Lapa é o coração cultural e boêmio do Rio.",
//        dateDetails: DateDetails(startDate: Date(), endDate: Date(), isRecurring: false),
//        address: AddressDetails(street: "Rua dos Arcos", number: "S/N", neighborhood: "Lapa", postalCode: "20230060"),
//        location: LocationDetails(latitude: -22.9132, longitude: -43.1796),
//        safetyRate: 4
//    ), EventDetails(
//        name: "Jardim Botânico",
//        description: "Um dos mais belos jardins botânicos do mundo, fundado em 1808, com uma vasta coleção de plantas tropicais e subtropicais.",
//        dateDetails: DateDetails(startDate: Date(), endDate: Date(), isRecurring: false),
//        address: AddressDetails(street: "Rua Jardim Botânico", number: "1008", neighborhood: "Jardim Botânico", postalCode: "22470000"),
//        location: LocationDetails(latitude: -22.9696, longitude: -43.1882),
//        safetyRate: 5
//    ), EventDetails(
//        name: "Copacabana",
//        description: "A famosa praia de Copacabana, conhecida pelo seu calçadão em ondas e o Réveillon, uma das maiores festas de Ano Novo do mundo.",
//        dateDetails: DateDetails(startDate: Date(), endDate: Date(), isRecurring: false),
//        address: AddressDetails(street: "Avenida Atlântica", number: "S/N", neighborhood: "Copacabana", postalCode: "22070000"),
//        location: LocationDetails(latitude: -22.9711, longitude: -43.1822),
//        safetyRate: 4
//    ), EventDetails(
//        name: "Ipanema",
//        description: "Outra praia icônica do Rio, Ipanema é conhecida pela famosa canção 'Garota de Ipanema' e seu estilo de vida descontraído.",
//        dateDetails: DateDetails(startDate: Date(), endDate: Date(), isRecurring: false),
//        address: AddressDetails(street: "Avenida Vieira Souto", number: "S/N", neighborhood: "Ipanema", postalCode: "22420000"),
//        location: LocationDetails(latitude: -22.9834, longitude: -43.2048),
//        safetyRate: 4
//    )]
