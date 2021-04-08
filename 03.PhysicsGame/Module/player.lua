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

-- 繪出會動的Player
function PlayerDraw()
    
    local x, y = Player:getPosition()
    Player.animation:draw(Sprite.playerSheet, x, y, nil, 0.25 * Player.direction, 0.25, 130, 300)  -- 0.25是Player的大小比例
end