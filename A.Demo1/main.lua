-- MARK: 生命週期
function love.load()
    initSetting()
end

function love.draw()
    _drawBackground(sprite.sky)
    
    printTimer()
    printScore()
    printStartTitle()
    
    drawTarget()
    drawCrosshairs()
end

function love.update(deltaTime)
    updateTimer(deltaTime)
end

function love.mousepressed(x, y, button)

    -- button: 1 => 左鍵
    if button == 1 then

        if not game.isOver then
    
            local distance, targetRadius  = _distanceBetween(x, y, target.x, target.y), _getImageSize(sprite.target).height / 2
            
            love.audio.play(sound.shoot)

            -- 假如點在圓圓內的話 => 點到加分 + 換位置
            if distance < targetRadius then
                game.score = game.score + 1
                targetRandomPosition()
                return
            end
        end
    
        if game.isOver then
            restart()
        end
    end
end

-- MARK: 小工具
-- 初始化設定
function initSetting()
    importSource()
    initParameter()
    initSprite()
    initSound()
    initBackgroundColor()
    initFont('font/jf-openhuninn-1.1.ttf', 40)
    _setScreen(1024, 600)
    _setTitle('射擊遊戲')
end

-- 設定背景色
function initBackgroundColor()
    local color = _colorMaker(255, 255, 255, 255)
    _setBackgroundColor(color)
end

-- 載入其它位置的檔案 => 容易維護
function importSource()
    require('source.utility')
    require('source.setting')
end

-- 畫準心 => 跟著滑鼠移動，一定要最後畫，不然會不見
function drawCrosshairs()
    local position, size = _getMousePosition(), _getImageSize(sprite.crosshairs)
    _draw(sprite.crosshairs, position.x - size.width / 2, position.y - size.height / 2)
end

-- 畫標靶
function drawTarget()

    if not game.isOver then
        local size = _getImageSize(sprite.target)
        _draw(sprite.target, target.x - size.width / 2, target.y - size.height / 2)
    end
end

-- 更新倒數計時的值
function updateTimer(deltaTime)

    if not game.isOver then
        timer.value = _timerCountDown(timer.value, deltaTime)
    end

    if timer.value == 0 then
        game.isOver = true
    end
end

-- 繪出倒數計時的值
function printTimer()
    local time, size = '時間: '..math.ceil(timer.value), _getScreenSize()
    _print(time, size.width / 2 - font.size / 2 - 40, 5)
end

function printStartTitle()
    -- 印出開始的一開始的標題
    if game.isOver then
        local size = _getScreenSize()
        _printf('點這裡就開始了喲!', 0, 250, size.width, 'center')
    end
end

-- 繪出分數
function printScore()
    local text = '分數: '..game.score
    _print(text, 5, 5)
end

-- 標靶隨機位置
function targetRandomPosition()
    
    local screenSize, targetSize = _getScreenSize(), _getImageSize(sprite.target)

    target.x = _random(targetSize.width / 2, screenSize.width - targetSize.width / 2)
    target.y = _random(targetSize.height / 2, screenSize.height - targetSize.height / 2)
end