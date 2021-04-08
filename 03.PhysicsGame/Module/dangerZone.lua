-- 初始化DangerZone的外框 (碰撞)
function InitDangerZone()
    DangerZone = World:newRectangleCollider(0, 550, 800, 50, { collision_class = 'DangerZone'})
    DangerZone:setType('static')
end