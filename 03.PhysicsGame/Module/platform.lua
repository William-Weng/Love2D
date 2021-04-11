-- 初始化Platform的外框 (碰撞)
function InitPlatform()
    Platforms = {}
end

function PlatformSpawn(x, y, width, height)
    
    local platform = World:newRectangleCollider(x, y, width, height, { collision_class = 'Platform'})
    platform:setType('static')

    table.insert(Platforms, platform)
end