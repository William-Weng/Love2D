-- LÖVE 11.3 / macOS 11.2.3
-- [love.physics.newWorld](https://love2d.org/wiki/love.physics.newWorld)
-- [Animation library for LÖVE](https://love2d.org/wiki/anim8)
-- [Tiled | Flexible level editor](https://www.mapeditor.org/)
-- [](https://love2d-community.github.io/love-api/)
-- 65. Transitioning Between Levels

-- MARK: - 生命週期
function love.load()
    love.window.setMode(1024, 768)  -- 設定桌布大小
    InitSetting()
end

function love.update(deltaTime)
    World:update(deltaTime)
    GameMap:update(deltaTime)
    PlayerMove(deltaTime)
    EnemiesUpdate(deltaTime)

    local x, y = Player:getPosition()
    Camera:lookAt(x, love.graphics.getHeight() / 2)

    ChangeLevel()
end

function love.draw()

    love.graphics.draw(Sprite.background, 0, 0)

    Camera:attach()
        GameMap:drawLayer(GameMap.layers['Tile Layer 1'])   -- 載入地圖
        
        -- 不顯示外框
        -- World:draw()
        PlayerDraw()
        EnemiesDraw()
    Camera:detach()
end

function love.keypressed(key)

    if key == 'up' then

        -- 不讓Player連續跳 (限制)
        if Player.isOnGround then
            Player:applyLinearImpulse(0, Player.speed.jump)
            love.audio.play(Sound.jump)
        end
    end
end

function love.mousepressed(x, y, button)
end

-- MARK: 小工具
-- 初始化設定
function InitSetting()

    ImportModule()

    InitSprite()
    InitWindField()
    InitAnim8()
    InitPlayer()
    InitPlatform()
    InitSimpleTiledImplementation()
    InitHumpCamera()

    FlagX = 0
    FlagY = 0

    SaveData = {}
    SaveData.currentLevel = 'level1'
    SaveData.filename = 'save.lua'

    LoadGame()
    LoadMapObjects(SaveData.currentLevel)

    PlaySound()
end

-- 載入模組
function ImportModule()
    require('Library.show')
    require('Module.module')
    require('Module.player')
    require('Module.sprite')
    require('Module.platform')
    require('Module.dangerZone')
    require('Module.enemy')
end

-- [記錄遊戲 => 寫入檔案](https://love2d.org/wiki/love.filesystem.write)
-- macOS: /Users/<user>/Library/Application Support/LOVE/lovegame
function SaveGame(level)
    SaveData.currentLevel = level
    love.filesystem.write(SaveData.filename, table.show(SaveData, "SaveData"))
end

-- [載入遊戲 => 讀出檔案](https://love2d.org/wiki/love.filesystem.write)
function LoadGame()

    if love.filesystem.getInfo(SaveData.filename) then
        local data = love.filesystem.load(SaveData.filename)
        data()
    end
end

-- 載入地圖相關物件
function LoadMapObjects(level)

    MapDestroyAll()
    PlayerRestart()

    SaveGame(level)
    GameMap = SimpleTiledImplementation('Map/'..SaveData.currentLevel..'.lua')

    -- 載入地板物件
    for index, object in pairs(GameMap.layers["Platforms"].objects) do
        PlatformSpawn(object.x, object.y, object.width, object.height)
    end

    -- 載入敵人物件
    for index, object in pairs(GameMap.layers["Enemies"].objects) do
        EnemySpwan(object.x, object.y, object.width, object.height)
    end

    -- 載入旗子物件
    for index, object in pairs(GameMap.layers["Flag"].objects) do
        FlagX = object.x
        FlagY = object.y
    end
end

-- 清除地圖上的所有物件
function MapDestroyAll()

    local index = #Platforms

    while index > -1 do
        if Platforms[index] ~= nil then
            Platforms[index]:destroy()
        end

        table.remove(Platforms, index)
        index = index - 1
    end

    index = #Enemies

    while index > -1 do
        if Enemies[index] ~= nil then
            Enemies[index]:destroy()
        end

        table.remove(Enemies, index)
        index = index - 1
    end
end

-- 切換關卡
function ChangeLevel()

    local colliders = World:queryCircleArea(FlagX, FlagY, 10, { 'Player' })

    if #colliders > 0 then
        if SaveData.currentLevel == 'level1' then
            LoadMapObjects('level2')
        else
            LoadMapObjects('level1')
        end
    end
end

-- 放音樂
function PlaySound()
    
    Sound = {}
    Sound.music = love.audio.newSource("Sound/music.mp3", "stream")
    Sound.jump = love.audio.newSource("Sound/jump.wav", "static")

    -- 播放背景音樂
    Sound.music:setLooping(true)
    Sound.music:setVolume(0.5)
    love.audio.play(Sound.music)
end