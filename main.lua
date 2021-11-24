package.path = "/usr/local/share/lua/5.4/?.lua;" .. package.path

local composer = require("composer")

display.setStatusBar(display.HiddenStatusBar)

math.randomseed(os.time())
composer.gotoScene("Scenes.game", {})
