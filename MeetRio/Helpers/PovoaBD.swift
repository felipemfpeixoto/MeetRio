//
//  PovoaBD.swift
//  MeetRio
//
//  Created by Felipe on 30/08/24.
//

import Foundation
import SwiftUI

let eventsBD: [EventDetails] = [
    EventDetails(
        name: "Barzin Ipanema",
        photo: UIImage(named: "AlbaBotafogo_2")?.pngData(),
        description: "Lounge + Nightclub at Barzin Ipanema. Parties, DJs, and shows. Corporate events.",
        dateDetails: "Every Thursday",
        address: AddressDetails(
            street: "R. Vinícius de Moraes",
            number: "75",
            details: nil,
            referencePoint: nil,
            neighborhood: ""
        ),
        location: LocationDetails(latitude: -22.984491723078044, longitude: -43.20298671705616),
        eventCategory: "bemBrazil",
        safetyRate: 5,
        tags: ["#party", "#drinks", "#club", "#OpenVibes"],
        tips: "Try the local drinks and bring ID: The Barzin is known for its well-crafted cocktails, so make sure to order a caipirinha or explore other typical Brazilian drinks like a caipiroska or batida de coco. Also, remember to bring a photo ID, as it's common for bars in Rio to check identification at the entrance—carrying your passport or a copy will ensure you avoid any issues.",
        url: "https://maps.apple.com/?address=Rua Vinícius de Moraes, 75, Ipanema, Rio de Janeiro - RJ, 22411-010, Brazil&ll=-22.984619,-43.202950&q=Rua Vinícius de Moraes, 75",
        buyURL: "https://www.bembrasilrio.net/event-details/barzin-ipanema-2024-09-05-23-00"
    ),
    EventDetails(
        name: "Barzin Ipanema",
        photo: UIImage(named: "BarzinIpanema")?.pngData(),
        description: "Lounge + Nightclub at Barzin Ipanema. Parties, DJs, and shows. Corporate events.",
        dateDetails: "Every Friday",
        address: AddressDetails(
            street: "R. Vinícius de Moraes",
            number: "75",
            details: nil,
            referencePoint: nil,
            neighborhood: ""
        ),
        location: LocationDetails(latitude: -22.984491723078044, longitude: -43.20298671705616),
        eventCategory: "bemBrazil",
        safetyRate: 5,
        tags: ["#party", "#drinks", "#club", "#OpenVibes"],
        tips: nil,
        url: "https://maps.apple.com/?address=Rua Vinícius de Moraes, 75, Ipanema, Rio de Janeiro - RJ, 22411-010, Brazil&ll=-22.984619,-43.202950&q=Rua Vinícius de Moraes, 75",
        buyURL: "https://www.bembrasilrio.net/event-details/barzin-ipanema-2024-09-07-23-00"
    ),
    EventDetails(
        name: "Boat Party",
        photo: UIImage(named: "BoatParty")?.pngData(),
        description: "Rio’s best boat party since 2008 Embarque (Boarding): 00h Saida (Departure): 00:30h Retorno (Return): 04AM",
        dateDetails: "Every Tuesday",
        address: AddressDetails(
            street: "Marina da Glória",
            number: "Av. Infante Dom Henrique",
            details: nil,
            referencePoint: nil,
            neighborhood: ""
        ),
        location: LocationDetails(latitude: -22.91959324576121, longitude: -43.1699556539722),
        eventCategory: "bemBrazil",
        safetyRate: 5,
        tags: ["#NightTour", "#boat", "#drinks"],
        tips: "Dress comfortably and be prepared: Rio’s weather is typically warm, so opt for light, comfortable clothing. However, it’s wise to bring a light jacket as the sea breeze can get cooler in the evening. Also, be sure to carry some cash, as not all boats may accept credit or debit cards.",
        url: "https://maps.apple.com/?address=Avenida Infante Dom Henrique, s/n, Glória, Rio de Janeiro - RJ, 20021-140, Brazil&auid=9182745026652784348&ll=-22.919599,-43.168900&lsp=9902&q=Marina da Gloria",
        buyURL: "https://www.bembrasilrio.net/venda-de-ingressos"
    )
]



//let eventsBD: [EventDetails] = [
//    EventDetails(
//        name: "Sambinha do Bosque",
//        photo: UIImage(named: "SambinhaDoBosque")?.pngData(),
//        description: "The best samba in Rio! With each edition, tickets sell out earlier and earlier. TudoJunto and Mulatto alternate Sunday programming, bringing special guests to play the best samba and pagode from all eras.",
//        dateDetails: "Every Sunday",
//        address: AddressDetails(
//            street: "Av. Bartolomeu Mitre",
//            number: "1314",
//            details: nil,
//            referencePoint: nil,
//            neighborhood: ""
//        ),
//        location: LocationDetails(latitude: -22.97515, longitude: -43.22532),
//        eventCategory: "nightLife",
//        safetyRate: 5,
//        tags: ["#party", "#samba", "#fun"],
//        tips: "At Sundays, Bosque expects an older public to enjoy and dance to some old good Samba!",
//        url: "https://maps.apple.com/?address=Avenida Bartolomeu Mitre, 1314, Lagoa, Rio de Janeiro - RJ, 22431-008, Brazil&auid=13905749566815366442&ll=-22.975689,-43.225407&lsp=9902&q=Bosque Bar"
//    ),
//    EventDetails(
//        name: "BSQNT",
//        photo: UIImage(named: "BSQNT")?.pngData(),
//        description: "The perfect place to gather friends, eat, have some drinks, and enjoy good music outdoors, in a location full of the wonders and charms of Rio's nature.",
//        dateDetails: "Every Thursday",
//        address: AddressDetails(
//            street: "Av. Bartolomeu Mitre",
//            number: "1314",
//            details: nil,
//            referencePoint: nil,
//            neighborhood: ""
//        ),
//        location: LocationDetails(latitude: -22.97515, longitude: -43.22532),
//        eventCategory: "nightLife",
//        safetyRate: 5,
//        tags: ["#party", "#liveMusic", "#Drinks"],
//        tips: "Bosque often hosts a lot of international tourists and at Thursdays and Fridays it’s the best time to go out and meet new people at Bosque!",
//        url: "https://maps.apple.com/?address=Avenida Bartolomeu Mitre, 1314, Lagoa, Rio de Janeiro - RJ, 22431-008, Brazil&auid=13905749566815366442&ll=-22.975689,-43.225407&lsp=9902&q=Bosque Bar"
//    ),
//    EventDetails(
//        name: "PARQUE BAR - nosso domingo",
//        photo: UIImage(named: "ParqueBarNossoDomingo")?.pngData(),
//        description: "The venue features a modern setting, a spacious outdoor dance floor, a food truck area, and an eclectic lineup from Thursdays to Sundays.",
//        dateDetails: "Every Sunday",
//        address: AddressDetails(
//            street: "Av. Borges de Medeiros",
//            number: "1518",
//            details: "https://maps.app.goo.gl/tfc277YXS9Ashbos7",
//            referencePoint: nil,
//            neighborhood: ""
//        ),
//        location: LocationDetails(latitude: -22.97354, longitude: -43.21637),
//        eventCategory: "nightLife",
//        safetyRate: 5,
//        tags: ["#Party", "#pagode", "#sunday"],
//        tips: "Looking for a good samba that ends no too early at Sundays? Parque Bar is your go-to spot, to go out and have a good time! Don't forget to bring your ID, to enter in the party :)",
//        url: "https://maps.apple.com/?address=Parque dos Patins, Lagoa, Rio de Janeiro - RJ, 22470-003, Brazil&auid=6232464701044326968&ll=-22.972441,-43.217002&lsp=9902&q=Parque Bar"
//    ),
//    EventDetails(
//        name: "Roda de samba pedra do sal",
//        photo: UIImage(named: "RodaDeSambaPedraDoSul")?.pngData(),
//        description: "With the aim of preserving the memory of genuine 19th-century samba—introduced to the port area by the Bahian diaspora—a group of seven musician friends has been gathering for eight years at the historic Pedra do Sal, every Monday, to respectfully honor the ancestry of this Brazilian rhythm that enchants the world.",
//        dateDetails: "Every Monday",
//        address: AddressDetails(
//            street: "R. Tia Ciata - Saúde",
//            number: "",
//            details: nil,
//            referencePoint: nil,
//            neighborhood: ""
//        ),
//        location: LocationDetails(latitude: -22.89788521089983, longitude: -43.1853326726121),
//        eventCategory: "nightLife",
//        safetyRate: 3,
//        tags: ["#Samba", "#caipirinha", "#tourism"],
//        tips: "If you want to truly dive deep into Rio de Janeiro’s nightlife culture. You can’t miss out on Pedra do Sal, one of the most traditional spots for a good samba and a lot of delicious Caipirinhas for a cheap price. Stay alert with your belongings, theft can always happen.",
//        url: "https://maps.apple.com/?address=Rua Argemiro Bulcão, 33, Saude, Rio de Janeiro - RJ, 20081-040, Brazil&auid=11045998102923796350&ll=-22.897929,-43.185507&lsp=9902&q=Pedra do Sal"
//    ),
//    EventDetails(
//        name: "Samba Independente dos bons costumes",
//        photo: UIImage(named: "SambaIndependenteDosBonsCostumes")?.pngData(),
//        description: "Samba Independente dos Bons Costumes brings the best of samba to Fundição every week for people to celebrate and have fun. Now in a new format, at the Fundição Arena.",
//        dateDetails: "Every Thursday",
//        address: AddressDetails(
//            street: "R. dos Arcos",
//            number: "24 - a 50",
//            details: nil,
//            referencePoint: nil,
//            neighborhood: ""
//        ),
//        location: LocationDetails(latitude: -22.912258261679103, longitude: -43.18057985938668),
//        eventCategory: "nightLife",
//        safetyRate: 3,
//        tags: ["#Samba", "#SIBC", "#LiveMusic"],
//        tips: "Thursdays, you can’t go wrong with one of the best sambas circle in Rio de Janeiro, SIBC! Always packed and ready for a good night, with cheap beers and good music! Be aware when you’re leaving, at night, the surroundings can be very scary.",
//        url: "https://maps.apple.com/?address=Rua dos Arcos, 24, Centro, Rio de Janeiro - RJ, 20230-060, Brazil&auid=299325728896675314&ll=-22.912315,-43.180636&lsp=9902&q=Fundição Progresso"
//    ),
//    EventDetails(
//        name: "Samba do Redentor",
//        photo: UIImage(named: "SambaDoRedentor")?.pngData(),
//        description: "Samba do Redentor brings that cozy samba circle vibe to Calçada Bar, on the shores of Lagoa Rodrigo de Freitas.",
//        dateDetails: "Every Saturday",
//        address: AddressDetails(
//            street: "Av. Borges de Medeiros",
//            number: "",
//            details: nil,
//            referencePoint: nil,
//            neighborhood: ""
//        ),
//        location: LocationDetails(latitude: -22.973079898965636, longitude: -43.21624868822087),
//        eventCategory: "nightLife",
//        safetyRate: 5,
//        tags: ["#Samba", "#Party", "#partner"],
//        tips: "A new spot for a good samba during your weekend. Samba do Redentor is a good safe spot for young and your friends have a good time.",
//        url: "https://maps.apple.com/?address=Avenida Borges de Medeiros, 1996, Lagoa, Rio de Janeiro - RJ, 22470-003, Brazil&auid=3927509957144614424&ll=-22.973398,-43.216291&lsp=9902&q=Calçada Bar"
//    ),
//    EventDetails(
//        name: "Mundo lingo",
//        photo: UIImage(named: "MundoLingo_Humaita")?.pngData(),
//        description: "Locals and expats meet every week to chat, meet new people and share ideas. It's free and everyone is welcome.",
//        dateDetails: "Every Tuesday",
//        address: AddressDetails(
//            street: "R. Martins Ferreira",
//            number: "48 - Humaitá",
//            details: nil,
//            referencePoint: nil,
//            neighborhood: ""
//        ),
//        location: LocationDetails(latitude: -22.9535623049712, longitude: -43.19545722883566),
//        eventCategory: "nightLife",
//        safetyRate: 4,
//        tags: ["#party", "#drinks", "#Tourism", "#Connections"],
//        tips: "Looking for new worldwide connections? Mundo Lingo is the right place to find people looking for the same things. Meet new people from different countries and make unique memories!",
//        url: "https://maps.apple.com/?address=Rua Martins Ferreira, 48, Botafogo, Rio de Janeiro - RJ, 22271-010, Brazil&ll=-22.953609,-43.195247&q=Rua Martins Ferreira, 48"
//    ),
//    EventDetails(
//        name: "Mundo lingo",
//        photo: UIImage(named: "MundoLingo_Botafogo")?.pngData(),
//        description: "Locals and expats meet every week to chat, meet new people and share ideas. It's free and everyone is welcome.",
//        dateDetails: "Every Thursday",
//        address: AddressDetails(
//            street: "Rua Álvaro Ramos",
//            number: "270 - Botafogo",
//            details: nil,
//            referencePoint: nil,
//            neighborhood: ""
//        ),
//        location: LocationDetails(latitude: -22.956699283668275, longitude: -43.18290476308449),
//        eventCategory: "nightLife",
//        safetyRate: 4,
//        tags: ["#party", "#drinks", "#Tourism", "#Connections"],
//        tips: "Looking for new worldwide connections? Mundo Lingo is the right place to find people looking for the same things. Go out with a clear mindset to connect yourself with new people.",
//        url: "https://maps.apple.com/?address=Rua Álvaro Ramos, 270, Botafogo, Rio de Janeiro - RJ, 22280-110, Brazil&ll=-22.956757,-43.182697&q=Rua Álvaro Ramos, 270"
//    ),
//    EventDetails(
//        name: "Samba dos Guimarães",
//        photo: UIImage(named: "SambaDosGuimaraes")?.pngData(),
//        description: "Samba that happens every Saturday at Santa Teresa!",
//        dateDetails: "Every Saturday",
//        address: AddressDetails(
//            street: "Rua Almirante Alexandrino",
//            number: "501",
//            details: nil,
//            referencePoint: nil,
//            neighborhood: ""
//        ),
//        location: LocationDetails(latitude: -22.92160793417288, longitude: -43.18573528465741),
//        eventCategory: "nightLife",
//        safetyRate: 4,
//        tags: ["#Samba", "#Party", "#frozenbeer", "#Variety"],
//        tips: "Being a little further away from the South Side, this samba provides a good gateway for these people, with good music and a big space to hit the Dance floor. When the event’s over try to not stay for a long time in front of the party, the neighborhood can turn out to be scary.",
//        url: "https://maps.apple.com/?address=Rua Almirante Alexandrino, 501, Santa Teresa, Rio de Janeiro - RJ, 20241-260, Brazil&ll=-22.921681,-43.185845&q=Rua Almirante Alexandrino, 501"
//    ),
//    EventDetails(
//        name: "Pagode da Garagem",
//        photo: UIImage(named: "PagodeDaGaragem")?.pngData(),
//        description: "Every Tuesday, don’t forget!",
//        dateDetails: "Every Tuesday",
//        address: AddressDetails(
//            street: "Praça Tiradentes",
//            number: "81",
//            details: nil,
//            referencePoint: nil,
//            neighborhood: ""
//        ),
//        location: LocationDetails(latitude: -22.90687964847266, longitude: -43.183887928835645),
//        eventCategory: "nightLife",
//        safetyRate: 4,
//        tags: ["#Samba", "#Pagode", "#LiveMusic"],
//        tips: "Pagode da garagem is situated at the Center of the city, which at night it’s not a great place to hang out at the streets.",
//        url: "https://maps.apple.com/?address=Praça Tiradentes, 81, Centro, Rio de Janeiro - RJ, 20060-070, Brazil&ll=-22.907055,-43.183843&q=Praça Tiradentes, 81"
//    ),
//    EventDetails(
//        name: "Fuska Bar",
//        photo: UIImage(named: "FuskaBar")?.pngData(),
//        description: "Since 1991, a bar that blends culture with cold beer, authentic snacks, and good people!",
//        dateDetails: "Every Friday",
//        address: AddressDetails(
//            street: "Capitão Salomão",
//            number: "52",
//            details: nil,
//            referencePoint: nil,
//            neighborhood: ""
//        ),
//        location: LocationDetails(latitude: -22.957167776888166, longitude: -43.196394532399474),
//        eventCategory: "nightLife",
//        safetyRate: 5,
//        tags: ["#bar", "#drinks", "#fun", "#Beers"],
//        tips: "Fuska Bar is a great option if you want to chill out with your friends, listen to some music, drink a good cold beer, and take advantage of the delicious food menu from the bar.",
//        url: "https://maps.apple.com/?address=Rua Capitão Salomão, 52, Humaita, Rio de Janeiro - RJ, 22271-040, Brazil&ll=-22.957291,-43.196210&q=Rua Capitão Salomão, 52"
//    ),
//    EventDetails(
//        name: "Aldeia",
//        photo: UIImage(named: "Aldeia")?.pngData(),
//        description: "Aldeia Lagoa é o seu mais novo espaço de entretenimento à beira da Lagoa Rodrigo de Freitas, em frente ao Parque dos Patins. O lugar onde perfeito para ouvir uma boa música, tomar bons drinks, e claro, um lugar de conexões e encontros para todas as tribos. Se você quer começar bem o final de semana, rodeado de amigos e muita gente bonita, ouvindo os melhores DJs da cidade, te convido a conhecer o Aldeia.",
//        dateDetails: "Every Friday",
//        address: AddressDetails(
//            street: "Av. Borges de Medeiros",
//            number: "1994",
//            details: nil,
//            referencePoint: nil,
//            neighborhood: ""
//        ),
//        location: LocationDetails(latitude: -22.97205, longitude: -43.21626),
//        eventCategory: "nightLife",
//        safetyRate: 5,
//        tags: ["#Party", "#OpenSpace", "#View"],
//        tips: "Aldeia recently tuned out to be the most loved nightlife spot for the Cariocas, and one of the best. Aldeia is an open space with beautiful views for you to enjoy and party all night long! If the spot doesn’t do your vibe, you can also check out other parties at the same square.",
//        url: "https://maps.apple.com/?address=Avenida Borges de Medeiros, 1994, Lagoa, Rio de Janeiro - RJ, 22470-003, Brazil&auid=799993033840714157&ll=-22.972205,-43.216156&lsp=9902&q=Aldeia Lagoa"
//    ),
//    EventDetails(
//        name: "Aldeia",
//        photo: UIImage(named: "Aldeia_2")?.pngData(),
//        description: "Aldeia Lagoa é o seu mais novo espaço de entretenimento à beira da Lagoa Rodrigo de Freitas, em frente ao Parque dos Patins. O lugar onde perfeito para ouvir uma boa música, tomar bons drinks, e claro, um lugar de conexões e encontros para todas as tribos. Se você quer começar bem o final de semana, rodeado de amigos e muita gente bonita, ouvindo os melhores DJs da cidade, te convido a conhecer o Aldeia.",
//        dateDetails: "Every Saturday",
//        address: AddressDetails(
//            street: "Av. Borges de Medeiros",
//            number: "1994",
//            details: nil,
//            referencePoint: nil,
//            neighborhood: ""
//        ),
//        location: LocationDetails(latitude: -22.97205, longitude: -43.21626),
//        eventCategory: "nightLife",
//        safetyRate: 5,
//        tags: ["#Party", "#OpenSpace", "#View"],
//        tips: "Saturdays at Aldeia is always special. With a 20+ age restriction, on Saturdays, Aldeia often expects a quite older public, but still keeping the same good vibes brought by the awesome DJ’s.",
//        url: "https://maps.apple.com/?address=Avenida Borges de Medeiros, 1994, Lagoa, Rio de Janeiro - RJ, 22470-003, Brazil&auid=799993033840714157&ll=-22.972205,-43.216156&lsp=9902&q=Aldeia Lagoa"
//    ),
//    EventDetails(
//        name: "Bar do Molejão",
//        photo: UIImage(named: "BarDoMolejao")?.pngData(),
//        description: "Bar do Molejão is a simple, cozy, family-friendly, and extremely pleasant place for a great leisure time.",
//        dateDetails: "Every Wednesday",
//        address: AddressDetails(
//            street: "Rua Carlos Gomes",
//            number: "74",
//            details: nil,
//            referencePoint: nil,
//            neighborhood: ""
//        ),
//        location: LocationDetails(latitude: -22.9042388779844, longitude: -43.2043165),
//        eventCategory: "nightLife",
//        safetyRate: 4,
//        tags: ["#Bar", "#foods", "#openSpace"],
//        tips: "Bar do Molejão is a traditional spot in the Carioca culture, bringing the best of the Samba, inside a cool, cozy, and pleasant restaurant. The party is located at a not very pleasant neighborhood, but you can always find a safe way out, with the help of the people there.",
//        url: "https://maps.apple.com/?address=Rua Carlos Gomes, 74, Santo Cristo, Rio de Janeiro - RJ, 20220-050, Brazil&ll=-22.904241,-43.204303&q=Rua Carlos Gomes, 74"
//    ),
//    EventDetails(
//        name: "ClubStation",
//        photo: UIImage(named: "ClubStation")?.pngData(),
//        description: "Bringing together music, dance, culture, diversity, and fun.",
//        dateDetails: "Every Wednesday",
//        address: AddressDetails(
//            street: "Rua Siqueira Campos",
//            number: "143",
//            details: nil,
//            referencePoint: nil,
//            neighborhood: ""
//        ),
//        location: LocationDetails(latitude: -22.96621632937529, longitude: -43.18793135901729),
//        eventCategory: "nightLife",
//        safetyRate: 4,
//        tags: ["#party", "#Club", "#SafeSpace"],
//        tips: "ClubStation is a traditional Club like everywhere else in the World. With good music, drinks and people to meet. The club is considered a GayFriendly location, so you can always feel safe at all times.",
//        url: "https://maps.apple.com/?address=Rua Siqueira Campos, 143, Copacabana, Rio de Janeiro - RJ, 22031-071, Brazil&ll=-22.966342,-43.187543&q=Rua Siqueira Campos, 143"
//    ),
//    EventDetails(
//        name: "Alba Botafogo",
//        photo: UIImage(named: "AlbaBotafogo")?.pngData(),
//        description: "Gastronomy, mixology, and music in a historic mansion in Botafogo!",
//        dateDetails: "Every Sunday",
//        address: AddressDetails(
//            street: "R. Martins Ferreira",
//            number: "60",
//            details: nil,
//            referencePoint: nil,
//            neighborhood: ""
//        ),
//        location: LocationDetails(latitude: -22.953856351600574, longitude: -43.1951185747282),
//        eventCategory: "bemBrazil",
//        safetyRate: 5,
//        tags: ["#party", "#Club", "#openVibes"],
//        tips: "Come on through to enjoy a good afternoon Samba at one of the most pleasant spots in Rio de Janeiro, Casarão Alba. At Sundays, Samba often keeps the Carioca’s afternoon going.",
//        url: "https://maps.apple.com/?address=Rua Martins Ferreira, 60, Botafogo, Rio de Janeiro - RJ, 22271-010, Brazil&ll=-22.954050,-43.195081&q=Rua Martins Ferreira, 60"
//    ),
//    EventDetails(
//        name: "Alba Botafogo",
//        photo: UIImage(named: "AlbaBotafogo_2")?.pngData(),
//        description: "Gastronomy, mixology, and music in a historic mansion in Botafogo!",
//        dateDetails: "Every Friday",
//        address: AddressDetails(
//            street: "R. Martins Ferreira",
//            number: "60",
//            details: nil,
//            referencePoint: nil,
//            neighborhood: ""
//        ),
//        location: LocationDetails(latitude: -22.953856351600574, longitude: -43.1951185747282),
//        eventCategory: "bemBrazil",
//        safetyRate: 5,
//        tags: ["#party", "#Club", "#openVibes"],
//        tips: "Looking for a good Friday party, Alba will not let you down, with awesome disco and funk music to light up your Friday night!",
//        url: "https://maps.apple.com/?address=Rua Martins Ferreira, 60, Botafogo, Rio de Janeiro - RJ, 22271-010, Brazil&ll=-22.954050,-43.195081&q=Rua Martins Ferreira, 60"
//    ),
//    EventDetails(
//        name: "Barzin Ipanema",
//        photo: UIImage(named: "AlbaBotafogo_2")?.pngData(),
//        description: "Lounge + Nightclub at Barzin Ipanema. Parties, DJs, and shows. Corporate events.",
//        dateDetails: "Every Thursday",
//        address: AddressDetails(
//            street: "R. Vinícius de Moraes",
//            number: "75",
//            details: nil,
//            referencePoint: nil,
//            neighborhood: ""
//        ),
//        location: LocationDetails(latitude: -22.984491723078044, longitude: -43.20298671705616),
//        eventCategory: "bemBrazil",
//        safetyRate: 5,
//        tags: ["#party", "#drinks", "#club", "#OpenVibes"],
//        tips: "Try the local drinks and bring ID: The Barzin is known for its well-crafted cocktails, so make sure to order a caipirinha or explore other typical Brazilian drinks like a caipiroska or batida de coco. Also, remember to bring a photo ID, as it's common for bars in Rio to check identification at the entrance—carrying your passport or a copy will ensure you avoid any issues.",
//        url: "https://maps.apple.com/?address=Rua Vinícius de Moraes, 75, Ipanema, Rio de Janeiro - RJ, 22411-010, Brazil&ll=-22.984619,-43.202950&q=Rua Vinícius de Moraes, 75"
//    ),
//    EventDetails(
//        name: "Barzin Ipanema",
//        photo: UIImage(named: "BarzinIpanema")?.pngData(),
//        description: "Lounge + Nightclub at Barzin Ipanema. Parties, DJs, and shows. Corporate events.",
//        dateDetails: "Every Friday",
//        address: AddressDetails(
//            street: "R. Vinícius de Moraes",
//            number: "75",
//            details: nil,
//            referencePoint: nil,
//            neighborhood: ""
//        ),
//        location: LocationDetails(latitude: -22.984491723078044, longitude: -43.20298671705616),
//        eventCategory: "bemBrazil",
//        safetyRate: 5,
//        tags: ["#party", "#drinks", "#club", "#OpenVibes"],
//        tips: nil,
//        url: "https://maps.apple.com/?address=Rua Vinícius de Moraes, 75, Ipanema, Rio de Janeiro - RJ, 22411-010, Brazil&ll=-22.984619,-43.202950&q=Rua Vinícius de Moraes, 75"
//    ),
//    EventDetails(
//        name: "Bar do Cardosão",
//        photo: UIImage(named: "BarDoCardosao")?.pngData(),
//        description: "Lunch, snacks, beer, and samba in a cozy space with subtle decor and outdoor tables.",
//        dateDetails: "Every Weekend",
//        address: AddressDetails(
//            street: "R. Cardoso Júnior",
//            number: "312",
//            details: nil,
//            referencePoint: nil,
//            neighborhood: ""
//        ),
//        location: LocationDetails(latitude: -22.93791679160588, longitude: -43.18847504589314),
//        eventCategory: "bemBrazil",
//        safetyRate: 5,
//        tags: ["#Bar", "#drinks", "#Samba", "#party"],
//        tips: "Come hungry and enjoy an ice-cold beer: Bar do Molejão is famous for its generous portions of food, especially the feijoada and traditional boteco dishes. Come with an appetite to fully savor the delicious offerings, and don’t miss out on their perfectly chilled beer, ideal for Rio’s warm climate.",
//        url: "https://maps.apple.com/?address=Rua Cardoso Júnior, 312, Laranjeiras, Rio de Janeiro - RJ, 22245-000, Brazil&ll=-22.938105,-43.188573&q=Rua Cardoso Júnior, 312"
//    ),
//    EventDetails(
//        name: "Boat Party",
//        photo: UIImage(named: "BoatParty")?.pngData(),
//        description: "Rio’s best boat party since 2008 Embarque (Boarding): 00h Saida (Departure): 00:30h Retorno (Return): 04AM",
//        dateDetails: "Every Tuesday",
//        address: AddressDetails(
//            street: "Marina da Glória",
//            number: "Av. Infante Dom Henrique",
//            details: nil,
//            referencePoint: nil,
//            neighborhood: ""
//        ),
//        location: LocationDetails(latitude: -22.91959324576121, longitude: -43.1699556539722),
//        eventCategory: "bemBrazil",
//        safetyRate: 5,
//        tags: ["#NightTour", "#boat", "#drinks"],
//        tips: "Dress comfortably and be prepared: Rio’s weather is typically warm, so opt for light, comfortable clothing. However, it’s wise to bring a light jacket as the sea breeze can get cooler in the evening. Also, be sure to carry some cash, as not all boats may accept credit or debit cards.",
//        url: "https://maps.apple.com/?address=Avenida Infante Dom Henrique, s/n, Glória, Rio de Janeiro - RJ, 20021-140, Brazil&auid=9182745026652784348&ll=-22.919599,-43.168900&lsp=9902&q=Marina da Gloria"
//    ),
//    EventDetails(
//        name: "Samba do Trabalhador",
//        photo: UIImage(named: "SambaDoTrabalhador")?.pngData(),
//        description: "Alô, rapaziada! Estamos todas as segundas-feiras, ás 16:30; no Renascença Clube, Andaraí.",
//        dateDetails: "Every Monday",
//        address: AddressDetails(
//            street: "Rua Barão de São Francisco",
//            number: "54",
//            details: nil,
//            referencePoint: nil,
//            neighborhood: ""
//        ),
//        location: LocationDetails(latitude: -22.92421105185997, longitude: -43.2489491),
//        eventCategory: "nightLife",
//        safetyRate: 3,
//        tags: ["#samba", "#pagode", "#beers", "#tradition"],
//        tips: "Looking for something to do after a Monday shift? Samba do trabalhador gets you sorted. Although, sometimes the space can feel a bit too tight, but the vibes are amazing!",
//        url: "https://maps.apple.com/?address=Rua Barão de São Francisco, 54, Vila Isabel, Rio de Janeiro - RJ, 20560-032, Brazil&ll=-22.914254,-43.251951&q=Rua Barão de São Francisco, 54"
//    )
//]
