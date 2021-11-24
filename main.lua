package.path = "/usr/local/share/lua/5.4/?.lua;" .. package.path

local composer = require("composer")

display.setStatusBar(display.HiddenStatusBar)

composer.gotoScene("Scenes.menu", {})

print(composer.getSceneName("current"))
