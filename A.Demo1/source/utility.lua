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

-- 取得畫面大小
function _getScreenSize()
    return { width = love.graphics.getWidth(), height = love.graphics.getHeight() }
end