package.path = "/usr/local/share/lua/5.4/?.lua;/usr/local/share/lua/5.4/?/init.lua;"
  .. package.path

require("fplua")({ override = true })
table.unpack = table.unpack or unpack

local composer = require("composer")

display.setStatusBar(display.HiddenStatusBar)

math.randomseed(os.time())

audio.reserveChannels(2)
audio.setVolume(0.5, { channel = 1 })
audio.setVolume(0.35, { channel = 2 })

composer.gotoScene("Scenes.menu", {})
