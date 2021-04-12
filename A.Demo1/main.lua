-- MARK: 生命週期
-- 一開始載入的時候
function love.load()
    initSetting()
end

-- 繪製畫面的時候
function love.draw()
    drawPicture()
    drawFont(40)
end

-- 定時更新 (60fps => 0.016664166999817 (1/60))
function love.update(deltaTime)
    -- print(deltaTime)
end

-- 滑鼠按下去的時候
function love.mousepressed(x, y, button)
    
    -- button == 1 (左鍵)
    if (button == 1) then
        love.audio.play(music.error)
    end

    -- button == 2 (右鍵)
    if button == 2 then
        love.audio.play(music.bgm)
    end

    --
    print(button)
end

-- 按下鍵盤的時候
function love.keypressed(key)
    print(key)    
end

-- MARK: 小工具
-- 初始設定 (自定義的function)
function initSetting()
    screenSize()
    soundInfo()
    initTitle()
end

-- 設定標題文字
function initTitle()
    love.window.setTitle('Hello World')
end

-- 繪圖
function drawPicture()
    local imageName = 'image/love2d.png'        -- 區域變數
    image = love.graphics.newImage(imageName)   -- 全域變數
    love.graphics.draw(image, 300, 200)
end

-- 繪字
function drawFont(size)
    font = love.graphics.newFont('font/jf-openhuninn-1.1.ttf', size)                -- 產生字型 + 大小
    love.graphics.setFont(font)                                                     -- 設定字型
    love.graphics.printf('滑鼠左鍵音效 / 右鍵音樂', 0, 480, screen.width, 'center')     -- 繪出文字
end

-- 取得畫面大小
function screenSize()

    screen = {
        width = love.graphics.getWidth(),
        height = love.graphics.getHeight(),
    }
end

-- 設定音樂曲目
function soundInfo()
    
    music = {
        bgm = love.audio.newSource("sound/bgm.mp3", "stream"),          -- 一直播 => stream
        error = love.audio.newSource("sound/error.wav", "static")       -- 短聲音 => static
    }

    music.bgm:setLooping(true)  -- 一直播放
    music.bgm:setVolume(0.5)    -- 音量50%
end