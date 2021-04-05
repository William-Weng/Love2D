-- LÖVE 11.3 / macOS 11.2.3
-- [love.physics.newWorld](https://love2d.org/wiki/love.physics.newWorld)
-- [Animation library for LÖVE](https://love2d.org/wiki/anim8)

-- 57. Player Direction (Flipping the Animation)

-- MARK: - 生命週期
function love.load()
    InitSetting()
end

function love.draw()
    World:draw()

    local x, y = Player:getPosition()
    Player.animation:draw(Sprite.playerSheet, x, y, nil, 0.25 * Player.direction, 0.25, 130, 300)  -- 0.25是Player的大小比例
end

function love.update(deltaTime)
    World:update(deltaTime)
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
    InitSprite()
    InitWindField()
    InitAnim8()
    InitPlayer()
    InitPlatform()
    InitDangerZone()
end

-- [使用WindField套件](https://github.com/William-Weng/windfield)
function InitWindField()

    local WindField = require('Library.WindField')
    World = WindField.newWorld(0, 800, false)
    World:setQueryDebugDrawing(true)

    World:addCollisionClass('Platform')     -- 碰撞 => 對應 collision_class = 'Platform'
    World:addCollisionClass('Player')       -- 碰撞 => 對應 collision_class = 'Player'
    World:addCollisionClass('DangerZone')   -- 碰撞 => 對應 collision_class = 'DangerZone'
end

-- [使用Anim8套件](https://github.com/kikito/anim8)
function InitAnim8()
    
    local Anim8 = require('Library.Anim8.anim8')

    -- playerSheet.png => 9210 / 15列 x 1692 / 3行
    local grid = Anim8.newGrid(614, 564, Sprite.playerSheet:getWidth(), Sprite.playerSheet:getHeight())

    Animation = {}
    Animation.idle = Anim8.newAnimation(grid('1-15', 1), 0.05) -- 1~15張 + 第一行
    Animation.jump = Anim8.newAnimation(grid('1-7', 2), 0.05)
    Animation.run = Anim8.newAnimation(grid('1-15', 3), 0.05)
end

-- 初始化Sprite
function InitSprite()
    
    Sprite = {}
    Sprite.playerSheet = love.graphics.newImage('Sprite/playerSheet.png')
end

-- 初始化Player的外框 (碰撞)
function InitPlayer()
 
    Player = World:newRectangleCollider(360, 100, 40, 100, { collision_class = 'Player'})
    Player:setFixedRotation(true)                   -- 不要讓Player碰到東西會旋轉

    Player.speed = { move = 240, jump = -4000 }
    Player.animation = Animation.idle
    Player.isMoving = false
    Player.direction = 1                            -- 1是面向右邊 / -1是面向左邊
    Player.isOnGround = false                       -- 在不在地板上
end

-- 初始化Platform的外框 (碰撞)
function InitPlatform()
    Platform = World:newRectangleCollider(250, 400, 300, 100, { collision_class = 'Platform'})
    Platform:setType('static')
end

-- 初始化DangerZone的外框 (碰撞)
function InitDangerZone()
    DangerZone = World:newRectangleCollider(0, 550, 800, 50, { collision_class = 'DangerZone'})
    DangerZone:setType('static')
end

-- Player移動
function PlayerMove(deltaTime)

    if Player.body then

        local colliders = World:queryRectangleArea(Player:getX() - 20, Player:getY() + 50, 40, 2, { 'Platform' })
        local x, y = Player:getPosition()

        if #colliders > 0 then
            Player.isOnGround = true
        else
            Player.isOnGround = false
        end

        Player.isMoving = false

        if love.keyboard.isDown('right') then
            Player:setX(x + Player.speed.move * deltaTime)
            Player.isMoving = true
            Player.direction = 1
        end

        if love.keyboard.isDown('left') then
            Player:setX(x - Player.speed.move * deltaTime)
            Player.isMoving = true
            Player.direction = -1
        end

        if Player:enter('DangerZone') then
            Player:destroy()
        end

        PlayerAnimation(deltaTime)
    end
end

-- Player的動畫 (走 / 跳)
function PlayerAnimation(deltaTime)

    if not Player.isOnGround then
        Player.animation = Animation.jump
        Player.animation:update(deltaTime)
        return
    end

    if Player.isMoving then
        Player.animation = Animation.run
    else
        Player.animation = Animation.idle
    end

    Player.animation:update(deltaTime)
end