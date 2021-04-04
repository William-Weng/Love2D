-- LÖVE 11.3 / macOS 11.2.3
-- [皮卡丘打排球](https://gorisanson.github.io/pikachu-volleyball/zh/)
-- MARK: - 生命週期
function love.load()

    InitParameter()
    InitSprite()
    InitPlayer()
    SoundSetting()
end

function love.draw()

    SpriteDraw()
    PlayerMouseAction()
    ZombiesRotationAction()
    BulletShoot()
end

function love.update(deltaTime)
    
    PlayerKeyboardAction(deltaTime)
    ZombiesAutoMove(deltaTime)
    BulletUpdateShoot(deltaTime)
    BulletRemove()

    ZombieDead()
    ZombieClear()
    BulletClear()

    ZombieAutoSpawn(deltaTime)
end

function love.keypressed(key)

    if key == 'space' then
        ZombieSpawn()
    end
end

function love.mousepressed(x, y, button)

    if button == 1 then
        MousePressAction()
    end
end

-- MARK: - 設定相關
-- 產生遊戲需要的物件
function InitSprite()

    Sprite = {}
    Sprite.background = love.graphics.newImage('Sprite/background.png')
    Sprite.bullet = love.graphics.newImage('Sprite/bullet.png')
    Sprite.player = love.graphics.newImage('Sprite/player.png')
    Sprite.zombie = love.graphics.newImage('Sprite/zombie.png')
end

-- 產生主角的相關參數
function InitPlayer()

    Player = {}

    Player.x = love.graphics.getWidth() / 2
    Player.y = love.graphics.getHeight() / 2
    Player.speed = 200
    Player.rotationRadians = 0

    -- 主角物件的中心點
    Player.center = {}
    Player.center.x = Sprite.player:getWidth() / 2
    Player.center.y = Sprite.player:getHeight() / 2
end

-- 產生遊戲需要的變數
function InitParameter()

    GameOver = true
    Score = 0
    DefaultCountDownTimer = 2
    MaxCountDownTimer = DefaultCountDownTimer
    CountDownTimer = MaxCountDownTimer
    GameFont = love.graphics.newFont('Font/jf-openhuninn-1.1.ttf', 40)

    Zombies = {}
    Bullets = {}

    Screen = {
        width = love.graphics.getWidth(),
        height = love.graphics.getHeight(),
    }

    -- 產生隨機種子
    math.randomseed(os.time())

    love.window.setTitle('Zombie Game')
end

-- 遊戲聲音相關設定
function SoundSetting()

    Music = {
        bgm = love.audio.newSource("Sound/bgm.mp3", "stream"),
        shoot = love.audio.newSource("Sound/shoot.wav", "static")
    }

    Music.bgm:setLooping(true)
    Music.bgm:setVolume(0.5)
    
    love.audio.play(Music.bgm)
end

-- 畫Sprite
function SpriteDraw()

    -- 畫背景
    love.graphics.draw(Sprite.background, 0, 0)

    -- 將主角畫在(x, y)上，並以中心點旋轉
    love.graphics.draw(Sprite.player, Player.x, Player.y, Player.rotationRadians, nil, nil, Player.center.x, Player.center.y)

    love.graphics.setFont(GameFont)

    if GameOver then
        love.graphics.printf('滑鼠點一下就開始了喲!', 0, 480, Screen.width, 'center')
    end

    love.graphics.printf('分數: '..Score, 0, 20, Screen.width, 'center')
end

-- MARK: - 主角相關
-- 主角按下鍵盤的動作 (上下左右)
function PlayerKeyboardAction(deltaTime)
    
    if GameOver then
        return
    end

    if love.keyboard.isDown('d') and Player.x < Screen.width then
        Player.x = Player.x + Player.speed * deltaTime
    end

    if love.keyboard.isDown('a') and Player.x > 0 then
        Player.x = Player.x - Player.speed * deltaTime
    end

    if love.keyboard.isDown('w') and Player.y > 0 then
        Player.y = Player.y - Player.speed * deltaTime
    end

    if love.keyboard.isDown('s') and Player.y < Screen.height then
        Player.y = Player.y + Player.speed * deltaTime
    end
end

-- 主角置中
function PlayerInitSetting()
    Player.x = Screen.width / 2
    Player.y = Screen.height / 2
    Player.rotationRadians = 0
end

-- 主角使用滑鼠的動作 (旋轉角度)
function PlayerMouseAction()

    if GameOver then
        return
    end

    local radians = math.atan2(Player.y - love.mouse.getY(), Player.x - love.mouse.getX()) + math.pi
    Player.rotationRadians = radians
end

-- MARK: - 敵人相關
-- 敵人向主角移動
function ZombiesAutoMove(deltaTime)

    for index, zombie in ipairs(Zombies) do
        zombie.x = zombie.x + math.cos(ZombieRotationAngle(zombie)) * zombie.speed * deltaTime
        zombie.y = zombie.y + math.sin(ZombieRotationAngle(zombie)) * zombie.speed * deltaTime
        ZombieState(zombie)
    end
end

-- 敵人的狀態 (碰到主角會消失)
function ZombieState(zombie)

    if DistanceBetween(zombie.x, zombie.y, Player.x, Player.y) < 30 then
        for index, zombie in ipairs(Zombies) do
            Zombies[index] = nil
            GameOver = true
            PlayerInitSetting()
        end
    end
end

-- 產生敵人 (加到table裡面)
function ZombieSpawn()
    
    local zombie = {}
    zombie.x = math.random(0, love.graphics.getWidth())
    zombie.y = math.random(0, love.graphics.getHeight())
    zombie.speed = Player.speed / 2
    zombie.dead = false

    -- 主角物件的中心點
    zombie.center = {}
    zombie.center.x = Sprite.zombie:getWidth() / 2
    zombie.center.y = Sprite.zombie:getHeight() / 2

    ZombieRandomPosition(zombie)
    table.insert(Zombies, zombie)
end

-- 敵人隨機位置 (從畫面外出現)
function ZombieRandomPosition(zombie)
    
    local sideDistance = 30
    local PositionInformation = {
        left = { x = -sideDistance, y = math.random(0, love.graphics.getHeight()) },
        right = { x = love.graphics.getWidth() + sideDistance, y = math.random(0, love.graphics.getHeight()) },
        up = { x = math.random(0, love.graphics.getWidth()), y = -sideDistance },
        down = { x = math.random(0, love.graphics.getWidth()), y = love.graphics.getWidth() + sideDistance },
    }

    local randomNumber = math.random(1, 4)
    local position = PositionInformation['right']

    -- Lua好像沒有Swith case
    if randomNumber == 2 then
        position = PositionInformation['left']
    end

    if randomNumber == 3 then
        position = PositionInformation['up']
    end

    if randomNumber == 4 then
        position = PositionInformation['down']
    end

    zombie.x = position.x
    zombie.y = position.y
end

-- 讓敵人們畫在畫面上，並以中心點旋轉
function ZombiesRotationAction()
    
    for index, zombie in ipairs(Zombies) do
        love.graphics.draw(Sprite.zombie, zombie.x, zombie.y, ZombieRotationAngle(zombie), nil, nil, zombie.center.x, zombie.center.y)
    end
end

-- 敵人的旋轉角度 (依照主角的位置做改變 => 面向主角)
function ZombieRotationAngle(enemy)
    local radians = math.atan2(Player.y - enemy.y, Player.x - enemy.x)
    return radians
end

-- 敵人被子彈打到了
function ZombieDead()

    for indexZombie, zombie in ipairs(Zombies) do
        for indexBullet, bullet in ipairs(Bullets) do
            if DistanceBetween(zombie.x, zombie.y, bullet.x, bullet.y) < 20 then
                zombie.isDead = true
                bullet.isDead = true
                Score = Score + 1
            end
        end
    end
end

-- 清除敵人 (敵人dead的時候)
function ZombieClear()

    for index = #Zombies, 1, -1 do

        local zombie = Zombies[index]

        if zombie.isDead == true then
            table.remove(Zombies, index)
        end
    end
end

-- 自動產生敵人 (定時產生)
function ZombieAutoSpawn(deltaTime)
    
    if GameOver then
        return
    end

    CountDownTimer = CountDownTimer - deltaTime

    if CountDownTimer <= 0 then
        ZombieSpawn()
        MaxCountDownTimerFast(0.95)
        CountDownTimer = MaxCountDownTimer
    end
end

-- MARK: - 子彈相關
-- 產生子彈 (跟著主角跑)
function BulletSpawn()

    local bullet = {}
    bullet.x = Player.x
    bullet.y = Player.y
    bullet.speed = Player.speed * 3
    bullet.direction = Player.rotationRadians
    bullet.scale = 0.5
    bullet.isDead = false

    bullet.center = {}
    bullet.center.x = Sprite.bullet:getWidth() / 2
    bullet.center.y = Sprite.bullet:getHeight() / 2

    table.insert(Bullets, bullet)
end

-- 移除子彈 (跑到畫面外的)
function BulletRemove()

    for index = #Bullets, 1, -1 do

        local bullet = Bullets[index]

        if bullet.x < 0 or bullet.y < 0 or bullet.x > love.graphics.getWidth() or bullet.y > love.graphics.getHeight() then
            table.remove(Bullets, index)
        end
    end
end

-- 發射子彈 (畫上去)
function BulletShoot()

    for index, bullet in ipairs(Bullets) do
        love.graphics.draw(Sprite.bullet, bullet.x, bullet.y, nil, bullet.scale, nil, bullet.center.x, bullet.center.y)
    end
end

-- 更新子彈位置 (讓子彈飛)
function BulletUpdateShoot(deltaTime)

    for index, bullet in ipairs(Bullets) do
        bullet.x = bullet.x + math.cos(bullet.direction) * bullet.speed * deltaTime
        bullet.y = bullet.y + math.sin(bullet.direction) * bullet.speed * deltaTime
    end
end

-- 清除子彈 (子彈打到敵人的時候)
function BulletClear()

    for index = #Bullets, 1, -1 do
        
        local bullet = Bullets[index]

        if bullet.isDead == true then
            table.remove(Bullets, index)
        end
    end
end

-- MARK: - 小工具
-- [計算兩點間的距離](https://priori.moe.gov.tw/download/textbook/math/grade8/book3/math-8-3-4-3.pdf)
function DistanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

-- 改變倒數計數的大小 (讓敵人出現越來越快 => multiple < 1.0)
function MaxCountDownTimerFast(multiple)
    MaxCountDownTimer = multiple * MaxCountDownTimer
end

-- 滑鼠點擊的動作 (啟動遊戲)
function MousePressAction()

    if not GameOver then
        BulletSpawn()
        love.audio.play(Music.shoot)
        return
    end

    Bullets = {}
    MaxCountDownTimer = DefaultCountDownTimer
    GameOver = false
    Score = 0
end