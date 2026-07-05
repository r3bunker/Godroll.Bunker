#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QFontDatabase>
#include <QSharedMemory>
#include <QMessageBox>
#include "weaponsearchmodel.h"
#include "globalhotkey.h"
#include "weaponloader.h"
#include "trayicon.h"
#include "updatechecker.h"
#include "manifestchecker.h"

// Version from CMake
#ifndef APP_VERSION
#define APP_VERSION "1.0.0"
#endif

int main(int argc, char *argv[])
{
    qDebug() << "Starting Godroll.Bunker v" << APP_VERSION;
    
    QApplication app(argc, argv);
    app.setApplicationName("Godroll.Bunker");
    app.setApplicationDisplayName("Godroll.Bunker");
    app.setApplicationVersion(APP_VERSION);
    app.setOrganizationName("Godroll.Bunker");
    app.setQuitOnLastWindowClosed(false); // Keep running in background

    // Single instance check using shared memory
    QSharedMemory sharedMemory("GodrollBunkerSingleInstance");
    if (!sharedMemory.create(1)) {
        // Another instance is already running
        qDebug() << "Another instance is already running. Exiting.";
        return 0;
    }

    // Check if started with --hidden flag (for auto-start)
    bool startHidden = false;
    for (int i = 1; i < argc; ++i) {
        if (QString(argv[i]) == "--hidden" || QString(argv[i]) == "-h") {
            startHidden = true;
            break;
        }
    }
    qDebug() << "Start hidden:" << startHidden;

    // Load custom font
    int fontId = QFontDatabase::addApplicationFont(":/qt/qml/GodrollBunker/resources/fonts/SpaceGrotesk.ttf");
    if (fontId != -1) {
        QStringList fontFamilies = QFontDatabase::applicationFontFamilies(fontId);
        qDebug() << "Loaded font families:" << fontFamilies;
    } else {
        qDebug() << "Failed to load Space Grotesk font";
    }

    qDebug() << "App initialized";

    // Initialize components
    WeaponLoader weaponLoader;
    WeaponSearchModel searchModel;
    GlobalHotkey hotkey;
    TrayIcon trayIcon;
    UpdateChecker updateChecker;
    ManifestChecker manifestChecker;
    
    // Show tray icon
    trayIcon.show();
    
    // Connect tray icon exit signal
    QObject::connect(&trayIcon, &TrayIcon::exitRequested, &app, &QApplication::quit);
    
    qDebug() << "Components created";

    // Load weapons from API
    weaponLoader.loadWeapons([&searchModel](const QJsonArray& weapons) {
        searchModel.setWeapons(weapons);
    });
    
    // Connect reload signal to update search model
    QObject::connect(&weaponLoader, &WeaponLoader::weaponsLoaded, 
                     &searchModel, &WeaponSearchModel::setWeapons);

    // Manifest checker: reload weapons when manifest version changes
    QObject::connect(&manifestChecker, &ManifestChecker::manifestChanged,
                     &weaponLoader, &WeaponLoader::reload);

    // Tray icon auto-refresh toggle syncs with manifest checker
    QObject::connect(&trayIcon, &TrayIcon::autoRefreshToggled,
                     &manifestChecker, &ManifestChecker::setAutoRefresh);

    // Initial manifest check after weapons are first loaded
    QObject::connect(&searchModel, &WeaponSearchModel::weaponsLoaded,
                     &manifestChecker, [&manifestChecker]() {
        static bool firstLoad = true;
        if (firstLoad) {
            firstLoad = false;
            manifestChecker.checkNow();
        }
    });

    QQmlApplicationEngine engine;
    
    // Expose C++ objects to QML
    engine.rootContext()->setContextProperty("searchModel", &searchModel);
    engine.rootContext()->setContextProperty("hotkey", &hotkey);
    engine.rootContext()->setContextProperty("trayIcon", &trayIcon);
    engine.rootContext()->setContextProperty("weaponLoader", &weaponLoader);
    engine.rootContext()->setContextProperty("updateChecker", &updateChecker);
    engine.rootContext()->setContextProperty("manifestChecker", &manifestChecker);
    engine.rootContext()->setContextProperty("startHidden", startHidden);
    engine.rootContext()->setContextProperty("appVersion", APP_VERSION);

    const QUrl url(QStringLiteral("qrc:/qt/qml/GodrollBunker/qml/main.qml"));
    
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl) {
            qDebug() << "Failed to load QML!";
            QCoreApplication::exit(-1);
        } else {
            qDebug() << "QML loaded successfully!";
        }
    }, Qt::QueuedConnection);

    qDebug() << "Loading QML from:" << url;
    engine.load(url);

    return app.exec();
}
