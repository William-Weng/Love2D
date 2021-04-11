-- 初始化Sprite
function InitSprite()
    
    Sprite = {}
    Sprite.background = love.graphics.newImage('Sprite/background.png')
    Sprite.playerSheet = love.graphics.newImage('Sprite/playerSheet.png')
    Sprite.enemySheet = love.graphics.newImage('Sprite/enemySheet.png')
end