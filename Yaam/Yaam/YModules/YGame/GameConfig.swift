//
//  GameConfig.swift
//  Yaam
//
//  Created by Dias Atudinov on 06.10.2025.
//


import SwiftUI
import SpriteKit

// MARK: - Bridge (связь сцены и SwiftUI)

final class TDBridge: ObservableObject {
    enum Outcome {
        case win, lose
        var title: String { self == .win ? "Победа! 🏆" : "Поражение 💀" }
    }

    @Published var outcome: Outcome? = nil
    @Published var kills: Int = 0
    @Published var towerHP: Int = 0
    @Published var damageMultiplierText: String = "×1.0"

    // Команды в сцену (устанавливаются сценой при инициализации)
    var increaseDamage: (() -> Void)?
    var shockwave: (() -> Void)?
    var restart: (() -> Void)?
}

// MARK: - SwiftUI оболочка c градиентом + прозрачной сценой

struct ContentView: View {
    @StateObject private var bridge = TDBridge()
    @StateObject private var shopVM = CPShopViewModel()
    @Environment(\.presentationMode) var presentationMode

    var scene: TDScene {
        let s = TDScene(size: UIScreen.main.bounds.size)
        s.scaleMode = .resizeFill
        s.backgroundColor = .clear  // фон рисует SwiftUI
        s.bridge = bridge
        return s
    }
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 2)

    
    var body: some View {
        ZStack {
            if let currentBg = shopVM.currentBgItem {
                Image(currentBg.image)
                    .resizable()
                    .ignoresSafeArea()
            }
            

            SpriteView(
                scene: scene,
                options: [.allowsTransparency, .ignoresSiblingOrder]
            )
            .ignoresSafeArea()

            HStack {
                Spacer()
                
                ZStack {
                    Image(.spelsBgY)
                        .resizable()
                        .scaledToFit()
                    
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(Range(1...10)) { num in
                            Button {
                                if num % 2 == 0 {
                                    bridge.shockwave?()
                                }
                                bridge.increaseDamage?()
                            } label: {
                                Image("spelButton\(num)Y")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 50)
                            }
                        }
                    }.frame(width: ZZDeviceManager.shared.deviceType == .pad ? 200:110)
                }
            }
            
            VStack {
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        
                        
                    } label: {
                        Image(.backIconY)
                            .resizable()
                            .scaledToFit()
                            .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:85)
                    }
                    
                    Spacer()
                    
                }.padding()
                Spacer()
                
                
                
            }

            
            
            // Баннер победы/поражения
            if let outcome = bridge.outcome {
                
                if outcome == .win {
                    ZStack {
                        Image(.winBlurY)
                            .resizable()
                            .ignoresSafeArea()
                            .scaledToFill()
                        
                        ZStack {
                            Image(.winBgY)
                                .resizable()
                                .scaledToFit()
                            
                            VStack {
                                Spacer()
                                
                                Button {
                                    presentationMode.wrappedValue.dismiss()
                                } label: {
                                    Image(.homeBtnY)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 50)
                                }
                                
                                Button {
                                    presentationMode.wrappedValue.dismiss()
                                } label: {
                                    Image(.nextBtnY)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 50)
                                }
                            }
                        }.padding(20)
                    }
                } else {
                    ZStack {
                        
                        ZStack {
                            Image(.loseBgY)
                                .resizable()
                                .scaledToFit()
                            
                            VStack {
                                Spacer()
                                
                                Button {
                                    presentationMode.wrappedValue.dismiss()
                                } label: {
                                    Image(.homeBtnY)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 50)
                                }
                                
                                Button {
                                    bridge.restart?()
                                } label: {
                                    Image(.replayBtnY)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 50)
                                }
                            }
                        }.padding(20)
                    }
                }
                
            }
        }
    }

    private var topHUD: some View {
        HStack(spacing: 12) {
            pill(title: "Убито", value: "\(bridge.kills)")
            pill(title: "HP башни", value: "\(bridge.towerHP)")
            pill(title: "Урон", value: bridge.damageMultiplierText)
            Spacer()
        }
    }

    private var bottomButtons: some View {
        HStack {
            Spacer()
            VStack(alignment: .trailing, spacing: 10) {
                Button {
                    bridge.increaseDamage?()
                } label: {
                    Label("+ Урон башни", systemImage: "arrow.up.circle.fill")
                }
                .buttonStyle(.borderedProminent)

                Button {
                    bridge.shockwave?()
                } label: {
                    Label("Импульс у башни", systemImage: "waveform.path.ecg.rectangle")
                }
                .buttonStyle(.bordered)
            }
        }
    }

    private func pill(title: String, value: String) -> some View {
        HStack(spacing: 6) {
            Text(title).bold()
            Text(value)
        }
        .padding(.horizontal, 10).padding(.vertical, 6)
        .background(.thinMaterial, in: Capsule())
    }
}

// MARK: - Константы

struct TDConfig {
    static let towerFireInterval: TimeInterval = 0.6
    static let enemySpawnInterval: TimeInterval = 2.0
    static let mapRadius: CGFloat = 520
    static let towerContactRadius: CGFloat = 40
    static let towerRange: CGFloat = 560

    static let initialTowerHP: CGFloat = 500       // HP башни
    static let baseEnemyHP: CGFloat = 120          // базовый HP врага
    static let enemyDPS: CGFloat = 25              // урон врага по башне / сек

    // Победа при таком количестве убийств
    static let winKills: Int = 20

    // Кнопки SwiftUI
    static let towerDamageStep: CGFloat = 0.2      // +20% к урону башни
    static let shockwaveDamage: CGFloat = 40       // импульсный урон
    static let shockwaveRadius: CGFloat = 140      // радиус импульса
}

// MARK: - Физические категории

struct Category {
    static let enemy: UInt32      = 1 << 0
    static let projectile: UInt32 = 1 << 1
    static let tower: UInt32      = 1 << 2
}

// MARK: - Типы снарядов (3 вида)

enum ProjectileType: CaseIterable {
    case orb, arrow, fireball

    var damage: CGFloat {
        switch self {
        case .orb: return 28
        case .arrow: return 22
        case .fireball: return 36
        }
    }
    var speed: CGFloat {
        switch self {
        case .orb: return 650
        case .arrow: return 780
        case .fireball: return 560
        }
    }
    var textureName: String {
        switch self {
        case .orb: return "proj_orb"
        case .arrow: return "proj_arrow"
        case .fireball: return "proj_arrow"
        }
    }
    var fallbackColor: UIColor {
        switch self {
        case .orb: return .systemTeal
        case .arrow: return .systemIndigo
        case .fireball: return .systemRed
        }
    }
    var size: CGSize {
        switch self {
        case .orb: return CGSize(width: 18, height: 18)
        case .arrow: return CGSize(width: 20, height: 12)
        case .fireball: return CGSize(width: 22, height: 22)
        }
    }
}

// MARK: - Узлы

final class EnemyNode: SKSpriteNode {
    var hp: CGFloat = TDConfig.baseEnemyHP
    var maxHP: CGFloat = TDConfig.baseEnemyHP
    var speedToCenter: CGFloat = 70
    var alive = true

    // Полоска HP
    private(set) var hpBg: SKShapeNode?
    private(set) var hpFg: SKShapeNode?

    func setupHpBar() {
        let w: CGFloat = 40, h: CGFloat = 5
        let bg = SKShapeNode(rectOf: CGSize(width: w, height: h), cornerRadius: 2)
        bg.fillColor = .black.withAlphaComponent(0.5)
        bg.strokeColor = .clear
        bg.zPosition = 20
        bg.position = CGPoint(x: 0, y: self.size.height/2 + 10)

        let fg = SKShapeNode(rectOf: CGSize(width: w - 2, height: h - 2), cornerRadius: 2)
        fg.fillColor = .green
        fg.strokeColor = .clear
        fg.zPosition = 21
        fg.position = .zero

        bg.addChild(fg)
        addChild(bg)

        hpBg = bg
        hpFg = fg
        updateHpBar()
    }

    func updateHpBar() {
        guard let fg = hpFg else { return }
        let ratio = max(0, min(1, hp / maxHP))
        let fullW: CGFloat = 38
        let rect = CGRect(x: -fullW/2, y: -1.5, width: fullW * ratio, height: 3)
        fg.path = CGPath(roundedRect: rect, cornerWidth: 2, cornerHeight: 2, transform: nil)
        fg.fillColor = ratio > 0.5 ? .green : (ratio > 0.25 ? .orange : .red)
    }
}

final class ProjectileNode: SKSpriteNode {
    var damage: CGFloat = 0
}

// MARK: - Сцена

final class TDScene: SKScene, SKPhysicsContactDelegate {

    weak var bridge: TDBridge?
    var shopVM = CPShopViewModel()
    // Узлы
    
    
    private var tower = SKSpriteNode(imageNamed: "tower")
    private var towerHit = SKShapeNode(circleOfRadius: TDConfig.towerContactRadius)

    // Игровые сущности
    private var enemies = Set<EnemyNode>()

    // Тайминги
    private var lastFireTime: TimeInterval = 0
    private var lastSpawnTime: TimeInterval = 0
    private var prevTime: TimeInterval = 0

    // HP башни и метка
    private var towerHP: CGFloat = TDConfig.initialTowerHP
    private let towerMaxHP: CGFloat = TDConfig.initialTowerHP
    private let towerHpLabel = SKLabelNode(fontNamed: "Menlo-Bold")

    // Победа/прогресс
    private var kills: Int = 0

    // Урон башни (множитель, влияет на все типы снарядов)
    private var damageMultiplier: CGFloat = 1.0

    // MARK: - Setup

    override func didMove(to view: SKView) {
        backgroundColor = .clear
        physicsWorld.contactDelegate = self

        // прозрачный SKView чтобы был виден SwiftUI-градиент
        view.allowsTransparency = true
        view.isOpaque = false
        view.backgroundColor = .clear

        setupTower()
        setupTowerHpLabel()
        setupBridgeCallbacks()
        syncBridge()
    }

    private func setupTower() {
        guard let currentSkinItem = shopVM.currentSkinItem else { return }
        tower = SKSpriteNode(imageNamed: currentSkinItem.image)
        if tower.texture == nil || tower.texture?.size() == .zero {
            tower = SKSpriteNode(color: .white, size: CGSize(width: 90, height: 140))
        }
        tower.size = CGSize(width: 90, height: 140)
        tower.zPosition = 4
        tower.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(tower)

        towerHit.strokeColor = .clear
        towerHit.fillColor = .clear
        towerHit.position = tower.position
        towerHit.physicsBody = SKPhysicsBody(circleOfRadius: TDConfig.towerContactRadius)
        towerHit.physicsBody?.isDynamic = false
        towerHit.physicsBody?.categoryBitMask = Category.tower
        towerHit.physicsBody?.contactTestBitMask = Category.enemy
        addChild(towerHit)
    }

    private func setupTowerHpLabel() {
        towerHpLabel.fontSize = 16
        towerHpLabel.horizontalAlignmentMode = .center
        towerHpLabel.verticalAlignmentMode = .top
        towerHpLabel.fontColor = .white
        towerHpLabel.zPosition = 100
        towerHpLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 20)
        addChild(towerHpLabel)
        updateTowerHpLabel()
    }

    private func setupBridgeCallbacks() {
        bridge?.increaseDamage = { [weak self] in
            self?.increaseDamageMultiplier()
        }
        bridge?.shockwave = { [weak self] in
            self?.applyShockwave()
        }
        bridge?.restart = { [weak self] in
            self?.restartGame()
        }
    }

    private func syncBridge() {
        bridge?.kills = kills
        bridge?.towerHP = Int(ceil(towerHP))
        bridge?.damageMultiplierText = String(format: "×%.1f", damageMultiplier)
    }

    private func updateTowerHpLabel() {
        towerHpLabel.text = "Tower HP: \(Int(ceil(towerHP)))/\(Int(towerMaxHP))"
        bridge?.towerHP = Int(ceil(towerHP))
    }

    // MARK: - Game Loop

    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        // держим башню и лейбл HP в правильных местах при поворотах/ресайзе
        tower.position = CGPoint(x: frame.midX, y: frame.midY)
        towerHit.position = tower.position
        towerHpLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 20)
    }

    override func update(_ currentTime: TimeInterval) {
        _ = timeDelta(current: currentTime)

        // спавн врагов
        if currentTime - lastSpawnTime >= TDConfig.enemySpawnInterval {
            lastSpawnTime = currentTime
            spawnEnemy()
        }

        // авто-стрельба башни случайными снарядами
        if currentTime - lastFireTime >= TDConfig.towerFireInterval {
            lastFireTime = currentTime
            autoFireRandom()
        }

        // поражение
        if towerHP <= 0 {
            towerHP = 0
            updateTowerHpLabel()
            showOutcome(.lose)
        }

        enemies = enemies.filter { $0.parent != nil && $0.alive }
    }

    private func timeDelta(current: TimeInterval) -> TimeInterval {
        defer { prevTime = current }
        guard prevTime != 0 else { return 0 }
        return current - prevTime
    }

    // MARK: - Спавн врагов по окружности

    private func spawnEnemy() {
        let enemyTex = SKTexture(imageNamed: "enemy_orc")
        let node: EnemyNode
        if enemyTex.size() != .zero {
            node = EnemyNode(texture: enemyTex, color: .clear, size: CGSize(width: 58, height: 58))
        } else {
            node = EnemyNode(color: .systemGreen, size: CGSize(width: 52, height: 52))
        }

        node.zPosition = 5
        node.maxHP = TDConfig.baseEnemyHP
        node.hp = node.maxHP
        node.speedToCenter = CGFloat.random(in: 80...120)

        // позиция на окружности
        let angle = CGFloat.random(in: 0..<(2 * .pi))
        let start = CGPoint(x: frame.midX + cos(angle) * TDConfig.mapRadius,
                            y: frame.midY + sin(angle) * TDConfig.mapRadius)
        node.position = start

        // физика
        node.physicsBody = SKPhysicsBody(circleOfRadius: max(node.size.width, node.size.height) * 0.45)
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.categoryBitMask = Category.enemy
        node.physicsBody?.contactTestBitMask = Category.projectile | Category.tower
        node.physicsBody?.collisionBitMask = 0

        addChild(node)
        enemies.insert(node)

        node.setupHpBar()

        // движение к центру
        let goal = CGPoint(x: frame.midX, y: frame.midY)
        let dist = hypot(goal.x - start.x, goal.y - start.y)
        let t = dist / node.speedToCenter
        node.run(.move(to: goal, duration: t))
    }

    // MARK: - Авто-стрельба

    private func autoFireRandom() {
        guard bridge?.outcome == nil, let target = closestEnemy(inRange: TDConfig.towerRange) else { return }
        let projType = ProjectileType.allCases.randomElement()!
        fireProjectile(of: projType, from: tower.position, to: target)
    }

    private func closestEnemy(inRange range: CGFloat) -> EnemyNode? {
        let c = tower.position
        return enemies
            .filter { $0.alive && $0.parent != nil }
            .sorted { a, b in
                hypot(a.position.x - c.x, a.position.y - c.y) < hypot(b.position.x - c.x, b.position.y - c.y)
            }
            .first(where: { hypot($0.position.x - c.x, $0.position.y - c.y) <= range })
    }

    private func fireProjectile(of type: ProjectileType, from: CGPoint, to enemy: EnemyNode) {
        let proj: ProjectileNode
        let tex = SKTexture(imageNamed: type.textureName)
        if tex.size() != .zero {
            proj = ProjectileNode(texture: tex, color: .clear, size: type.size)
        } else {
            // запасной спрайт (капсула/кружок)
            proj = ProjectileNode(color: type.fallbackColor, size: type.size)
            proj.cornerRadiusCG(min(type.size.width, type.size.height) / 2)
        }
        proj.damage = type.damage * damageMultiplier
        proj.zPosition = 8
        proj.position = from

        proj.physicsBody = SKPhysicsBody(circleOfRadius: max(proj.size.width, proj.size.height) * 0.45)
        proj.physicsBody?.affectedByGravity = false
        proj.physicsBody?.categoryBitMask = Category.projectile
        proj.physicsBody?.contactTestBitMask = Category.enemy
        proj.physicsBody?.collisionBitMask = 0
        addChild(proj)

        // летим к текущей позиции врага
        let dist = hypot(enemy.position.x - from.x, enemy.position.y - from.y)
        let t = dist / type.speed
        proj.run(.sequence([.move(to: enemy.position, duration: t), .removeFromParent()]))
    }

    // MARK: - Контакты и урон

    func didBegin(_ contact: SKPhysicsContact) {
        let a = contact.bodyA
        let b = contact.bodyB

        // попадание снаряда по врагу
        if let (enemy, proj) = enemyAndProjectile(a, b) {
            enemy.hp -= proj.damage
            enemy.updateHpBar()
            proj.removeFromParent()
            if enemy.hp <= 0 {
                killEnemy(enemy)
            }
        }

        // враг дошёл до башни — начинает наносить урон/сек
        if let enemy = enemyTouchTower(a, b) {
            startEnemyDpsToTower(enemy)
        }
    }

    private func enemyAndProjectile(_ a: SKPhysicsBody, _ b: SKPhysicsBody) -> (EnemyNode, ProjectileNode)? {
        let e = (a.node as? EnemyNode) ?? (b.node as? EnemyNode)
        let p = (a.node as? ProjectileNode) ?? (b.node as? ProjectileNode)
        if let e, let p { return (e, p) }
        return nil
    }

    private func enemyTouchTower(_ a: SKPhysicsBody, _ b: SKPhysicsBody) -> EnemyNode? {
        if a.categoryBitMask == Category.enemy && b.categoryBitMask == Category.tower { return a.node as? EnemyNode }
        if b.categoryBitMask == Category.enemy && a.categoryBitMask == Category.tower { return b.node as? EnemyNode }
        return nil
    }

    private func startEnemyDpsToTower(_ enemy: EnemyNode) {
        // останавливаем движение — «грызёт» башню на месте
        enemy.removeAllActions()

        let key = "dps_\(Unmanaged.passUnretained(enemy).toOpaque())"
        guard enemy.action(forKey: key) == nil else { return }

        let tick = SKAction.run { [weak self, weak enemy] in
            guard let self, let enemy, enemy.parent != nil, enemy.alive else { return }
            self.towerHP -= TDConfig.enemyDPS
            self.updateTowerHpLabel()
            if self.towerHP <= 0 {
                self.towerHP = 0
                self.updateTowerHpLabel()
                self.showOutcome(.lose)
            }
        }
        let wait = SKAction.wait(forDuration: 1.0)
        enemy.run(.repeatForever(.sequence([tick, wait])), withKey: key)
    }

    private func killEnemy(_ enemy: EnemyNode) {
        guard enemy.alive else { return }
        enemy.alive = false
        enemy.removeAllActions()
        enemies.remove(enemy)
        enemy.removeFromParent()

        kills += 1
        bridge?.kills = kills
        if kills >= TDConfig.winKills {
            showOutcome(.win)
            ZZUser.shared.updateUserMoney(for: 100)
        }
    }

    // MARK: - Кнопки SwiftUI → действия в сцене

    private func increaseDamageMultiplier() {
        damageMultiplier += TDConfig.towerDamageStep
        bridge?.damageMultiplierText = String(format: "×%.1f", damageMultiplier)
        // небольшой визуальный эффект на башне
        let pulseUp = SKAction.scale(to: 1.08, duration: 0.08)
        let pulseDown = SKAction.scale(to: 1.0, duration: 0.10)
        tower.run(.sequence([pulseUp, pulseDown]))
    }

    private func applyShockwave() {
        guard bridge?.outcome == nil else { return }
        let center = tower.position
        // визуальный импульс
        let ring = SKShapeNode(circleOfRadius: 8)
        ring.strokeColor = .white
        ring.lineWidth = 2
        ring.alpha = 0.8
        ring.position = center
        ring.zPosition = 50
        addChild(ring)
        ring.run(.sequence([
            .group([
                .scale(to: TDConfig.shockwaveRadius / 8, duration: 0.22),
                .fadeOut(withDuration: 0.22)
            ]),
            .removeFromParent()
        ]))

        // урон врагам в радиусе
        for e in enemies where e.alive && e.parent != nil {
            let d = hypot(e.position.x - center.x, e.position.y - center.y)
            if d <= TDConfig.shockwaveRadius {
                e.hp -= TDConfig.shockwaveDamage
                e.updateHpBar()
                if e.hp <= 0 { killEnemy(e) }
            }
        }
    }

    private func restartGame() {
        // очистка сцены
        removeAllActions()
        enumerateChildNodes(withName: "//*") { node, _ in
            if node !== self.tower && node !== self.towerHit && node !== self.towerHpLabel {
                node.removeAllActions()
                node.removeFromParent()
            }
        }
        enemies.removeAll()

        // сброс значений
        towerHP = TDConfig.initialTowerHP
        updateTowerHpLabel()
        kills = 0
        damageMultiplier = 1.0
        bridge?.outcome = nil
        syncBridge()

        // перезапуск таймеров
        lastFireTime = 0
        lastSpawnTime = 0
        isPaused = false
    }

    // MARK: - Outcome

    private func showOutcome(_ out: TDBridge.Outcome) {
        guard bridge?.outcome == nil else { return }
        isPaused = true
        bridge?.outcome = out
    }
}

// MARK: - Вспомогательная отрисовка «капсулы» для снаряда без текстуры

private extension SKSpriteNode {
    func cornerRadiusCG(_ r: CGFloat) {
        let rect = CGRect(origin: .zero, size: self.size)
        let path = CGPath(roundedRect: rect, cornerWidth: r, cornerHeight: r, transform: nil)

        let shape = SKShapeNode(path: path)
        shape.fillColor = self.color
        shape.strokeColor = .clear

        let view = SKView(frame: CGRect(origin: .zero, size: self.size))
        if let tex = view.texture(from: shape) {
            self.texture = tex
            self.color = .clear
        }
    }
}

#Preview {
    ContentView()
}
