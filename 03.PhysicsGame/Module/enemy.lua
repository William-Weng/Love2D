Enemies = {}

-- 產生敵人物件
function EnemySpwan(x, y)
    
    local enemy = World:newRectangleCollider(x, y, 70, 90, { collision_class = 'DangerZone' })
    enemy.direction = 1
    enemy.speed = 200
    enemy.animation = Animation.enemy

    table.insert(Enemies, enemy)
end

-- 定時更新敵人動作
function EnemiesUpdate(deltaTime)
    
    for index, enemy in ipairs(Enemies) do

        enemy.animation:update(deltaTime)

        local x, y = enemy: getPosition()
        local colliders = World:queryRectangleArea(x + 40 * enemy.direction, y + 40, 10, 10, { 'Platform' })

        if #colliders == 0 then
            enemy.direction = enemy.direction * -1
        end

        enemy:setX(x + enemy.speed * deltaTime * enemy.direction)
    end
end

-- 畫出敵人們
function EnemiesDraw()
    
    for index, enemy in ipairs(Enemies) do
        local x, y = enemy:getPosition()
        enemy.animation:draw(Sprite.enemySheet, x, y, nil, enemy.direction, 1, 50, 65)
    end
end