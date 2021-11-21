package.path = "/usr/local/share/lua/5.4/?.lua;" .. package.path

local composer = require("composer")

composer.gotoScene("Scenes.game", {})

print(composer.getSceneName("current"))
