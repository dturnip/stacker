package.path = "/usr/local/share/lua/5.4/?.lua;/usr/local/share/lua/5.4/?/init.lua;" .. package.path

require("fplua")({ override = true })

local composer = require("composer")

display.setStatusBar(display.HiddenStatusBar)

math.randomseed(os.time())
composer.gotoScene("Scenes.game", {})
