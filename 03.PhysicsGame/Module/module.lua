-- [使用WindField套件](https://github.com/a327ex/windfield)
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

-- [使用SimpleTiledImplementation套件](https://github.com/karai17/Simple-Tiled-Implementation)
function InitSimpleTiledImplementation()
    SimpleTiledImplementation = require('Library.Simple-Tiled-Implementation.sti')
end