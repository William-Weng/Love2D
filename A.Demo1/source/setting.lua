-- MARK: - 初始設定
-- 初始化圖形物件 => Table
function initSprite()
    sprite = {}
    sprite.sky = love.graphics.newImage('sprite/sky.png')
    sprite.target = love.graphics.newImage('sprite/target.png')
    sprite.crosshairs = love.graphics.newImage('sprite/crosshairs.png')
end

-- 初始化音效 => Table
function initSound()
    sound = {
        bgm = love.audio.newSource("sound/bgm.mp3", "stream"),
        shoot = love.audio.newSource("sound/shoot.wav", "static")
    }

    sound.bgm:setLooping(true)
    sound.bgm:setVolume(0.5)

    love.audio.play(sound.bgm)
end