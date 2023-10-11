//
//  SampleSelectionHelper.swift
//  DailymotionPlayerSample
//
//  Created by Florin-Daniel DOBJENSCHI on 30.08.2023.
//

import Foundation

struct ScreenSelectionDatasourceModel {
    let sections: [ScreenSelectionSection]
}

struct ScreenSelectionSection {
    let name: String
    let cells: [ScreenSelectionCell]
}

struct ScreenSelectionCell {
    let name: String
    let type: CellType
}

enum CellType: Int {
    case basic
    case advertising
    case vertical
    case live
    case eventsAndState
    case methods
}

struct SampleSelectionHelper {
    static func createDatasource() -> ScreenSelectionDatasourceModel {
        let integrationCells = [ScreenSelectionCell(name: NSLocalizedString("Basic Player Embed", comment: ""), type: .basic),
                                ScreenSelectionCell(name: NSLocalizedString("Advertising Player", comment: ""), type: .advertising),
                                ScreenSelectionCell(name: NSLocalizedString("Vertical Player", comment: ""), type: .vertical),
                                ScreenSelectionCell(name: NSLocalizedString("Live Player", comment: ""), type: .live)]
        let integrationSection = ScreenSelectionSection(name: NSLocalizedString("Integration types", comment: ""), cells: integrationCells)
        let apiCells = [ScreenSelectionCell(name: NSLocalizedString("Events & State", comment: ""), type: .eventsAndState),
                        ScreenSelectionCell(name: NSLocalizedString("Methods", comment: ""), type: .methods)]
        let apiSection = ScreenSelectionSection(name: NSLocalizedString("Player API", comment: ""), cells: apiCells)
        return ScreenSelectionDatasourceModel(sections: [integrationSection,apiSection])
    }
}
