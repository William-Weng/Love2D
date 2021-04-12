-- MARK: - 公用工具
-- 設定遊戲的Title
function _setTitle(text)
    love.window.setTitle(text)
end

-- 畫背景 => 一定要最先畫，不然會蓋過其它的東西
function _drawBackground(image)
    love.graphics.draw(image, 0, 0)
end

-- 設定畫面大小
function _setScreen(width, height)
    love.window.setMode(width, height)
end

-- 取得畫面大小 => width, height
function _getScreenSize()
    return  { width = love.graphics.getWidth(), height = love.graphics.getHeight() }
end

-- 設定字型
function _setFont(font)
    local newFont = love.graphics.newFont(font.path, font.size)
    love.graphics.setFont(newFont)
end

-- 設定背景色
function _setBackgroundColor(color)
    love.graphics.setColor(color.red, color.green, color.blue, color.alpha)
end

-- 產生font的相關資訊 => { 字型位置, 字體大小 }
function _fontMaker(path, size)
    return { path = path, size = size }
end

-- 產生font的相關資訊 0~255 => { red, green, blue, alpha }
function _colorMaker(red, green, blue, alpha)
    return { red = red / 255, green = green / 255, blue = blue / 255, alpha = alpha / 255 }
end

-- [繪出文字](https://love2d.org/wiki/love.graphics.print)
function _print(text, x, y)
    love.graphics.print(text, x, y)
end

-- [繪出文字](https://love2d.org/wiki/love.graphics.printf)
function _printf(text, x, y, limit, align)
    love.graphics.printf(text, x, y, limit, align)
end

-- [繪出圖型物件](https://love2d.org/wiki/love.graphics.draw)
function _draw(sprite, x, y)
    love.graphics.draw(sprite, x, y)
end

-- [滑鼠的位置](https://love2d.org/wiki/love.mouse.getPosition)
function _getMousePosition()
    local x,y = love.mouse.getPosition()
    return { x = x, y = y }
end

-- 取得Image的寬高
function _getImageSize(image)
    return { width = image:getWidth(), height = image:getHeight() }
end

-- 時間倒數 => -0現象
function _timerCountDown(timer, deltaTime)

    local newTimer = timer - deltaTime

    if newTimer > 0 then
        return newTimer
    end

    return 0
end

-- 計算兩點間的距離
function _distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

-- 隨機數
function _random(from, to)
    return math.random(from, to)
end