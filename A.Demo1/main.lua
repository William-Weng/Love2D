-- MARK: 生命週期
function love.load()
    importSource()
    initSprite()
    initSound()
    _setTitle('射擊遊戲')
    _setScreen(1024, 600)
end

function love.draw()
    _drawBackground(sprite.sky)
    local size = _getScreenSize()
    print(size.width, size.height)
end

-- 載入其它位置的檔案 => 容易維護
function importSource()
    require('source.utility')
    require('source.setting')
end