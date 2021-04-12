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

-- 初始化字體
function initFont(path, size)
    font = _fontMaker(path, size)
    _setFont(font)
end

-- 初始化變數
function initParameter()

    -- 倒數計時用
    timer = {
        max = 10,
        value = 10,
    }

    -- 遊戲分數 + 是否結束
    game = {
        score = 0,
        isOver = true
    }

    -- 標靶的位置
    target = { 
        x = 300,
        y = 300
    }
end

-- 遊戲重新開始
function restart()
    timer.value = timer.max
    game.score = 0
    game.isOver = false
end