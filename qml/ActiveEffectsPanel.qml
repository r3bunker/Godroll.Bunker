import QtQuick
import QtQuick.Controls.Basic

// Reference list of exotic armor effects that modify weapon stats in PvP.
// Mirrors godroll.tv's PvP "Active Effects" panel, extended with entries
// the site is missing (tagged ADDED).
Item {
    id: panel

    property string filter: ""
    property string fontFamily: "Space Grotesk"

    function scrollBy(dy) {
        var maxY = Math.max(0, effectsList.contentHeight - effectsList.height)
        effectsList.contentY = Math.max(0, Math.min(maxY, effectsList.contentY + dy))
    }

    function classColor(cls) {
        switch (cls) {
            case "Hunter": return "#4dd0e1"
            case "Titan": return "#f87171"
            case "Warlock": return "#fbbf24"
            case "Class Item": return "#a855f7"
            default: return "#888888"
        }
    }

    function effectColor(line) {
        if (line.charAt(0) === "−" || line.charAt(0) === "-") return "#f87171"
        if (line.toLowerCase().indexOf("damage") !== -1) return "#ffd700"
        if (line.charAt(0) === "+" || line.charAt(0) === "x") return "#09d7d0"
        return "#cccccc"
    }

    readonly property var effectsData: [
        { armor: "Actium War Rig", perk: "Auto-Loading Link", cls: "Titan", fx: ["+30 Airborne Effectiveness"], note: "Auto rifles & machine guns steadily reload from reserves", added: false },
        { armor: "Astrocyte Verse", perk: "Move to Survive", cls: "Warlock", fx: ["+100 Handling", "+30 Airborne Effectiveness"], note: "After Blink", added: false },
        { armor: "Boots of the Assembler", perk: "Blessing of Order", cls: "Warlock", fx: ["+30 Airborne Effectiveness", "Damage increased by 15%"], note: "", added: false },
        { armor: "Eternal Warrior", perk: "Resolute", cls: "Titan", fx: ["Stacking Arc weapon damage"], note: "Arc final blows / Super; PvP-scaled surge", added: true },
        { armor: "Eye of Another World", perk: "Cerebral Uplink", cls: "Warlock", fx: ["+15 Airborne Effectiveness"], note: "", added: false },
        { armor: "Foetracer", perk: "Relentless Tracker", cls: "Hunter", fx: ["Weapon damage bonus (matches ability element)"], note: "After hitting with an ability; PvP-scaled surge", added: true },
        { armor: "Fortune's Favor", perk: "Kismet", cls: "", fx: ["+35 Stability", "+35 Handling"], note: "", added: false },
        { armor: "Hallowfire Heart", perk: "Sunfire Furnace", cls: "Titan", fx: ["+20 Airborne Effectiveness"], note: "", added: false },
        { armor: "Knucklehead Radar", perk: "Upgraded Sensor Pack", cls: "Hunter", fx: ["+20 Airborne Effectiveness"], note: "Radar while aiming", added: false },
        { armor: "Lion Rampant", perk: "Jump Jets", cls: "Titan", fx: ["+30 Stability", "+5 Range", "+50 Airborne Effectiveness"], note: "", added: false },
        { armor: "Lucky Pants", perk: "Illegally Modded Holster", cls: "Hunter", fx: ["+20 Airborne Effectiveness", "+100 Handling (ready speed)", "x0.6 Ready Animation Duration", "30% tighter accuracy cone"], note: "Hand Cannons; handling package for 6s on draw", added: false },
        { armor: "Lunafaction Boots", perk: "Alchemical Etchings", cls: "Warlock", fx: ["+30 Stability", "+5 Range", "+100 Reload Speed", "x0.9 Reload Duration"], note: "While standing in your rift", added: false },
        { armor: "Mantle of Battle Harmony", perk: "Absorption Cells", cls: "Warlock", fx: ["Weapon damage bonus (matches Super element)"], note: "While Super is fully charged; PvP-scaled surge", added: true },
        { armor: "Mask of Bakris", perk: "Light Shift", cls: "Hunter", fx: ["Damage increased by ~6%"], note: "Arc & Stasis weapons after shift-dodge (PvE 10/21/33% stacking)", added: true },
        { armor: "Mechaneer's Tricksleeves", perk: "Spring-Loaded Mounting", cls: "Hunter", fx: ["+100 Handling", "+50 Airborne Effectiveness", "+100 Reload Speed", "Damage increased by 10%"], note: "Sidearms; damage bonus while critically wounded", added: false },
        { armor: "Necrotic Grip", perk: "Grasp of the Devourer", cls: "Warlock", fx: ["+30 Airborne Effectiveness"], note: "", added: false },
        { armor: "No Backup Plans", perk: "Force Multiplier", cls: "Titan", fx: ["+30 Airborne Effectiveness", "Damage increased by 10%"], note: "Shotguns", added: false },
        { armor: "Oathkeeper", perk: "Adamantine Brace", cls: "Hunter", fx: ["+10 Draw Time", "+40 Airborne Effectiveness"], note: "Bows; charge can be held indefinitely", added: false },
        { armor: "Ophidian Aspect", perk: "Cobra Totemic", cls: "Warlock", fx: ["+35 Handling", "+10 Airborne Effectiveness", "+35 Reload Speed"], note: "", added: false },
        { armor: "Path of Burning Steps", perk: "Firewalker", cls: "Titan", fx: ["Stacking Solar weapon damage"], note: "On Solar final blows; PvP-scaled surge", added: true },
        { armor: "Peacekeepers", perk: "Mecha Holster", cls: "Titan", fx: ["+50 Handling", "+40 Airborne Effectiveness"], note: "SMGs; stowed SMGs auto-reload, near-instant ready", added: false },
        { armor: "Peregrine Greaves", perk: "Peregrine Strike", cls: "Titan", fx: ["+20 Airborne Effectiveness"], note: "", added: false },
        { armor: "Radiant Dance Machines", perk: "The Dance", cls: "Hunter", fx: ["+30 Stability", "+5 Range", "+20 Airborne Effectiveness"], note: "", added: false },
        { armor: "Rain of Fire", perk: "Soaring Fusilier", cls: "Warlock", fx: ["+30 Airborne Effectiveness"], note: "Icarus Dash reloads weapons", added: false },
        { armor: "Sanguine Alchemy", perk: "Blood Magic", cls: "Warlock", fx: ["Damage increased by 4.5%"], note: "Weapons matching your Super's element while standing in your rift (PvE ~25%)", added: true },
        { armor: "Sealed Ahamkara Grasps", perk: "Nightmare Fuel", cls: "Hunter", fx: ["+50 Airborne Effectiveness", "Damage increased by 20%"], note: "", added: false },
        { armor: "Sect of Force", perk: "Aeon gauntlets", cls: "", fx: ["+40 Handling", "+30 Reload Speed", "x0.85 Reload Duration"], note: "", added: false },
        { armor: "Speedloader Slacks", perk: "Tight Fit", cls: "Hunter", fx: ["+40–55 Handling", "+40–55 Reload Speed", "x1–0.89 Reload Duration"], note: "Stacks on dodge; applies to you and nearby allies", added: false },
        { armor: "Spirit of the Dragon", perk: "Exotic Class Item roll", cls: "Class Item", fx: ["Reloads all weapons", "+Handling for a short time"], note: "On class ability use", added: true },
        { armor: "Spirit of the Ophidian", perk: "Exotic Class Item roll", cls: "Class Item", fx: ["+25 Handling", "Weapons ready very quickly"], note: "", added: true },
        { armor: "St0mp-EE5", perk: "Hydraulic Boosters", cls: "Hunter", fx: ["−50 Airborne Effectiveness"], note: "Penalty while jump boost is active", added: true },
        { armor: "Stronghold", perk: "Clenched Fist", cls: "Titan", fx: ["+100 Guard Resistance", "+100 Guard Endurance"], note: "Swords", added: false },
        { armor: "Synthoceps", perk: "Biotic Enhancements", cls: "Titan", fx: ["+35 Handling", "+35 Reload Speed"], note: "", added: false },
        { armor: "The Dragon's Shadow", perk: "Wraithmetal Mail", cls: "Hunter", fx: ["+10 Stability (passive)", "+Handling & +Stability while active", "Faster ready, stow & reload while active"], note: "Dodge reloads equipped weapon and grants Wraithmetal Mail for 15s", added: false },
        { armor: "Transversive Steps", perk: "Strange Protractor", cls: "Warlock", fx: ["Auto-reloads equipped weapon"], note: "After ~2s of sprinting", added: true },
        { armor: "Triton Vice", perk: "Halberdier's Reach", cls: "Hunter", fx: ["+50 Reload Speed"], note: "Glaives", added: false },
        { armor: "Wings of Sacred Dawn", perk: "Tome of Dawn", cls: "Warlock", fx: ["+50 Airborne Effectiveness", "Flinch resistance while airborne + aiming"], note: "", added: false }
    ]

    property var filteredData: {
        var f = filter.toLowerCase().trim()
        if (f.length === 0) return effectsData
        return effectsData.filter(function(e) {
            if (e.armor.toLowerCase().indexOf(f) !== -1) return true
            if (e.perk && e.perk.toLowerCase().indexOf(f) !== -1) return true
            if (e.cls && e.cls.toLowerCase().indexOf(f) !== -1) return true
            if (e.note && e.note.toLowerCase().indexOf(f) !== -1) return true
            for (var i = 0; i < e.fx.length; i++) {
                if (e.fx[i].toLowerCase().indexOf(f) !== -1) return true
            }
            return false
        })
    }

    ListView {
        id: effectsList
        anchors.fill: parent
        clip: true
        spacing: 6
        model: panel.filteredData

        ScrollBar.vertical: ScrollBar {
            id: effectsScrollBar
            active: effectsList.moving || hovered || pressed
            policy: ScrollBar.AsNeeded
            parent: effectsList
            anchors.top: effectsList.top
            anchors.right: effectsList.right
            anchors.bottom: effectsList.bottom
            anchors.rightMargin: 2
            width: 12

            contentItem: Rectangle {
                implicitWidth: 10
                radius: 5
                color: effectsScrollBar.pressed ? "#09d7d0" : (effectsScrollBar.hovered ? "#888888" : "#555555")
                opacity: effectsScrollBar.active ? 0.8 : 0.0

                Behavior on color { ColorAnimation { duration: 100 } }
                Behavior on opacity { NumberAnimation { duration: 200 } }
            }

            background: Item {}
        }

        delegate: Rectangle {
            id: effectCard
            required property var modelData
            width: effectsList.width
            height: contentCol.implicitHeight + 20
            radius: 10
            color: "#B3232323"
            border.color: "#2d2d2d"
            border.width: 1

            Column {
                id: contentCol
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.leftMargin: 14
                anchors.rightMargin: 14
                anchors.topMargin: 10
                spacing: 4

                Row {
                    spacing: 8

                    Text {
                        text: effectCard.modelData.armor
                        font.family: panel.fontFamily
                        font.pixelSize: 15
                        font.weight: Font.Bold
                        color: "#ffffff"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        visible: effectCard.modelData.perk.length > 0
                        text: "• " + effectCard.modelData.perk
                        font.family: panel.fontFamily
                        font.pixelSize: 12
                        color: "#888888"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Rectangle {
                        visible: effectCard.modelData.cls.length > 0
                        width: clsText.implicitWidth + 12
                        height: 18
                        radius: 4
                        color: "transparent"
                        border.color: panel.classColor(effectCard.modelData.cls)
                        border.width: 1
                        anchors.verticalCenter: parent.verticalCenter

                        Text {
                            id: clsText
                            anchors.centerIn: parent
                            text: effectCard.modelData.cls
                            font.family: panel.fontFamily
                            font.pixelSize: 10
                            font.weight: Font.Medium
                            color: panel.classColor(effectCard.modelData.cls)
                        }
                    }

                    Rectangle {
                        visible: effectCard.modelData.added
                        width: addedText.implicitWidth + 12
                        height: 18
                        radius: 4
                        color: "#2a1a3a"
                        border.color: "#a855f7"
                        border.width: 1
                        anchors.verticalCenter: parent.verticalCenter

                        Text {
                            id: addedText
                            anchors.centerIn: parent
                            text: "ADDED"
                            font.family: panel.fontFamily
                            font.pixelSize: 10
                            font.weight: Font.Bold
                            color: "#a855f7"
                        }
                    }
                }

                Repeater {
                    model: effectCard.modelData.fx

                    Text {
                        required property string modelData
                        text: modelData
                        font.family: panel.fontFamily
                        font.pixelSize: 13
                        font.weight: Font.Medium
                        color: panel.effectColor(modelData)
                    }
                }

                Text {
                    visible: effectCard.modelData.note.length > 0
                    text: effectCard.modelData.note
                    font.family: panel.fontFamily
                    font.pixelSize: 12
                    font.italic: true
                    color: "#888888"
                    wrapMode: Text.WordWrap
                    width: contentCol.width
                }
            }
        }
    }

    Text {
        anchors.centerIn: parent
        visible: effectsList.count === 0
        text: "No effects match \"" + panel.filter + "\""
        font.family: panel.fontFamily
        font.pixelSize: 16
        color: "#888888"
    }
}
