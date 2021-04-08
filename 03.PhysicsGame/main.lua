-- LÖVE 11.3 / macOS 11.2.3
-- [love.physics.newWorld](https://love2d.org/wiki/love.physics.newWorld)
-- [Animation library for LÖVE](https://love2d.org/wiki/anim8)
-- [Tiled | Flexible level editor](https://www.mapeditor.org/)

-- 59. Multiple Lua Files

-- MARK: - 生命週期
function love.load()

    love.window.setMode(1000, 768)

    InitSetting()
end

function love.draw()
    GameMap:drawLayer(GameMap.layers['Tile Layer 1'])
    World:draw()
    PlayerDraw()
end

function love.update(deltaTime)
    World:update(deltaTime)
    GameMap:update(deltaTime)
    PlayerMove(deltaTime)
end

function love.keypressed(key)

    if key == 'up' then

        -- 不讓Player連續跳 (限制)
        if Player.isOnGround then
            Player:applyLinearImpulse(0, Player.speed.jump)
        end
    end
end

function love.mousepressed(x, y, button)

    if button == 1 then

        local colliders = World:queryCircleArea(x, y, 200, { 'Platform', 'DangerZone' })

        for index, collider in ipairs(colliders) do
            collider:destroy()
        end
    end
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
    InitDangerZone()
    InitSimpleTiledImplementation()
    
    LoadMap()
end

-- 載入模組
function ImportModule()
    require('Module.module')
    require('Module.player')
    require('Module.sprite')
    require('Module.platform')
    require('Module.dangerZone')
end

-- 讀入地圖
function LoadMap()
    GameMap = SimpleTiledImplementation('Map/level1.lua')
end