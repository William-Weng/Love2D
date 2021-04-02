-- [LÖVE API](https://love2d.org/wiki/Main_Page)
-- [[Lua] 程式設計教學：使用運算子 (Operator) | Michael Chen 的技術文件](https://michaelchen.tech/lua-programming/operator/)

-- LÖVE 11.3 / macOS 11.2.3
-- 執行 => love ./
-- [jf open 粉圓字型](https://justfont.com/huninn/)
-- 遊戲進入點
function love.load()

    FonSize = 40
    FontName = 'Font/jf-openhuninn-1.1.ttf'
    GameFont = love.graphics.newFont(FontName, FonSize)

    Score = 0
    Timer = 0
    CountDownSecond = 10
    GameOver = true

    Target = { mode = 'fill', x = 300, y = 300, radius = 50 }

    -- 把圖當元件畫出來
    Sprite = {}
    Sprite.sky = love.graphics.newImage('Sprite/sky.png')
    Sprite.target = love.graphics.newImage('Sprite/target.png')
    Sprite.crosshairs = love.graphics.newImage('Sprite/crosshairs.png')

    Sound = {}
    Sound.music = love.audio.newSource("Sound/music.mp3", "stream")
    Sound.jump = love.audio.newSource("Sound/jump.wav", "static")

    -- 播放背景音樂
    Sound.music:setLooping(true)
    Sound.music:setVolume(0.5)
    love.audio.play(Sound.music)

    RandomTargetPostion()
end

-- 遊戲畫面更新 => 60fps
function love.update(deltaTime)

    Timer = TimerCountDown(Timer, deltaTime)

    if (Timer <= 0) then
        GameOver = true
    end

    print('會印在Termail上 => '..deltaTime)
end

-- 繪製遊戲畫面
function love.draw()

    -- 畫背景 => 一定要最先畫，不然會蓋過其它的東西
    love.graphics.draw(Sprite.sky, 0, 0)

    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(GameFont)

    -- 印出分數
    love.graphics.print('分數: '..Score, 5, 5)

    -- 印時間 => 整數
    love.graphics.print('時間: '..math.ceil(Timer), love.graphics.getWidth() / 2 - FonSize / 2 - 80, 0)

    -- 印出開始的一開始的標題
    if GameOver then
        love.graphics.printf('點這裡就開始了喲!', 0, 250, love.graphics.getWidth(), 'center')
    end

    -- 畫標靶 => 跟著Target移動
    if not GameOver then
        love.graphics.draw(Sprite.target, Target.x - Target.radius, Target.y - Target.radius)
    end

    -- 畫準心 => 跟著滑鼠移動，一定要最後畫，不然會不見
    love.graphics.draw(Sprite.crosshairs, love.mouse.getX() - 20, love.mouse.getY() - 20)
end

-- [love.mousepressed - 滑鼠點擊](https://love2d.org/wiki/love.mousepressed)
function love.mousepressed(x, y, button, isTouch, presses)
    
    -- button: 1 => 左鍵
    if button == 1 then

        if not GameOver then

            local mouseToTarget = DistanceBetween(x, y, Target.x, Target.y)
            if mouseToTarget < Target.radius then

                -- 點到加分 + 換位置
                Score = Score + 1
                RandomTargetPostion()
                return
            end
        end

        if GameOver then
            RestartGame()
        end
    end
end

-- 計算兩點間的距離
function DistanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

-- 時間倒數 => -0現象
function TimerCountDown(timer, deltaTime)

    local newTimer = timer - deltaTime

    if newTimer > 0 then
        return newTimer
    end

    return 0
end

-- 標靶隨機位置 => 有聲音
function RandomTargetPostion()
    
    Target.x = math.random(Target.radius, love.graphics.getWidth() - Target.radius)
    Target.y = math.random(Target.radius, love.graphics.getHeight() - Target.radius)

    if not GameOver then
        love.audio.play(Sound.jump)
    end
end

-- 遊戲重新開始
function RestartGame()
    GameOver = false
    Timer = CountDownSecond
    Score = 0
end