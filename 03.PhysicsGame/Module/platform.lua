-- 初始化Platform的外框 (碰撞)
function InitPlatform()
    Platform = World:newRectangleCollider(250, 400, 300, 100, { collision_class = 'Platform'})
    Platform:setType('static')
end