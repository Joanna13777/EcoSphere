import UIKit

struct OnboardingStrings {
    let title: String
    let description: String
}

struct OnboardingPageModel {
    let pageIndex: Int
    let imageName: String
    let translations: [String: OnboardingStrings] // Ключи: "ru", "uz", "en"
}

let onboardingData: [OnboardingPageModel] = [
    OnboardingPageModel(
        pageIndex: 0,
        imageName: "rotate_materials_onb",
        translations: [
            "ru": OnboardingStrings(title: "Вращай вторсырьё по кругу", description: "Дай «вторую жизнь» старым предметам!\nСортируй мусор и отправляй на переработку, тем самым можешь обеспечить их повторное использование в народном хозяйстве, а также снизить загрязнение воздуха, воды и почвы."),
            "uz": OnboardingStrings(title: "Ikkilamchi xomashyoni aylantiring", description: "Eski buyumlarga «ikkinchi hayot» bering!\nChiqindilarni saralang va qayta ishlashga yuboring, shu bilan ulardan xalq xo'jaligida qayta foydalanishni ta'minlang va atrof-muhit ifloslanishini kamaytiring."),
            "en": OnboardingStrings(title: "Rotate Recyclables in a Circle", description: "Give a \"second life\" to old items!\nSort trash and send it for recycling, thereby ensuring its reuse in the national economy and reducing air, water, and soil pollution.")
        ]
    ),
    OnboardingPageModel(
        pageIndex: 1,
        imageName: "sortings_onb",
        translations: [
            "ru": OnboardingStrings(title: "Виды вторсырья", description: "Узнай, какое бывает вторсырьё\nи как его подготовить к переработке"),
            "uz": OnboardingStrings(title: "Xomashyo turlari", description: "Ikkilamchi xomashyoning qanday turlari borligini\nva ularni qayta ishlashga qanday tayyorlashni bilib oling"),
            "en": OnboardingStrings(title: "Types of Recyclables", description: "Find out what types of recyclables exist\nand how to prepare them for recycling")
        ]
    ),
    OnboardingPageModel(
        pageIndex: 2,
        imageName: "map_onb",
        translations: [
            "ru": OnboardingStrings(title: "Куда можно сдать вторсырье?", description: "Посмотри, где находятся пункты переработки\nотходов и как до них добраться"),
            "uz": OnboardingStrings(title: "Xomashyoni qayerga topshirish mumkin?", description: "Chiqindilarni qayta ishlash punktlari qayerda joylashganini\nva unga qanday yetib borishni ko'ring"),
            "en": OnboardingStrings(title: "Where to Return Recyclables?", description: "See where the waste recycling points are located\nand how to get there")
        ]
    ),
    OnboardingPageModel(
        pageIndex: 3,
        imageName: "removal_of_recyclable_onb",
        translations: [
            "ru": OnboardingStrings(title: "Вывоз вторсырья", description: "Мы сами приедем забрать накопившееся\nвторсырье из вашего дома (офиса)"),
            "uz": OnboardingStrings(title: "Xomashyoni olib ketish", description: "Uyingizda (ofisingizda) to'plangan ikkilamchi xomashyoni\no'zimiz kelib olib ketamiz"),
            "en": OnboardingStrings(title: "Recyclables Collection", description: "We will come to pick up the accumulated recyclables\nfrom your home (office) ourselves")
        ]
    )
]
