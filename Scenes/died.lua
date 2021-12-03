local widget = require("widget")
local composer = require("composer")
local json = require("json")

local scene = composer.newScene()

local menu_bt_sfx

-- This is persistent
local path = system.pathForFile("data.json", system.DocumentsDirectory)

local function getHighScore()
  local filebuf = io.open(path, "r")
  if filebuf then
    local lines = filebuf:read("*a")
    filebuf:close()
    return lines and json.decode(lines)["highscore"] or 0
  end
  return 0
end

local function setHighScore(n)
  local p_highscore = getHighScore()
  if n > p_highscore then
    local filebuf = io.open(path, "w")
    if filebuf then
      filebuf:write(json.encode({
        highscore = n,
      }))
      filebuf:close()
    end
  end
end

function scene:create(event)
  local sceneGroup = self.view

  local background = display.newRect(
    sceneGroup,
    0,
    0,
    display.actualContentWidth,
    display.actualContentHeight
  )

  background.x, background.y = display.contentCenterX, display.contentCenterY
  background:setFillColor(0.2)

  setHighScore(composer.getVariable("score"))

  local score = display.newText(
    sceneGroup,
    tostring(composer.getVariable("score")):gsub("0", "O"),
    display.contentCenterX,
    display.contentCenterY - 100 + 35,
    "Menlo",
    50
  )

  local score_heading = display.newText(
    sceneGroup,
    "score",
    -- (display.actualContentWidth - score.width) / 2,
    display.contentCenterX,
    score.y - 35,
    "Menlo",
    20
  )

  -- score_heading.x = score_heading.x + score_heading.width / 2

  local highscore = display.newText(
    sceneGroup,
    tostring(getHighScore()):gsub("0", "O"),
    display.contentCenterX,
    score.y + 100,
    "Menlo",
    50
  )

  local highscore_heading = display.newText(
    sceneGroup,
    "highscore",
    -- (display.actualContentWidth - highscore.width) / 2,
    display.contentCenterX,
    highscore.y - 35,
    "Menlo",
    20
  )

  -- highscore_heading.x = highscore_heading.x + highscore_heading.width / 2

  local menu_bt = widget.newButton({
    width = 200,
    height = 40,
    emboss = true,
    shape = "roundedRect",
    cornerRadius = 2,
    labelColor = {
      default = { 1, 1, 1, 1 },
      over = { 1, 1, 1, 0.8 },
    },
    fillColor = {
      default = { 205 / 255, 153 / 255, 69 / 255, 1 },
      over = { 205 / 255, 153 / 255, 69 / 255, 0.8 },
    },
    strokeColor = {
      default = { 154 / 255, 105 / 255, 38 / 255, 1 },
      over = { 154 / 255, 105 / 255, 38 / 255, 0.8 },
    },
    strokeWidth = 4,
    id = "menu_bt",
    label = "Main Menu",
    font = "Menlo",
    onEvent = function(event)
      if event.phase == "ended" then
        audio.play(menu_bt_sfx, { channel = 1 })
        composer.gotoScene("Scenes.menu", {
          effect = "slideDown",
          time = 1000,
        })
      end
    end,
  })

  menu_bt.x, menu_bt.y = display.contentCenterX, highscore.y + 100
  sceneGroup:insert(menu_bt)

  menu_bt_sfx = audio.loadSound("Assets/Sounds/menu_bt.mp3")
end

function scene:show(event)
  local sceneGroup = self.view
  local phase = event.phase

  if phase == "will" then
  elseif phase == "did" then
  end
end

function scene:hide(event)
  local sceneGroup = self.view
  local phase = event.phase

  if phase == "will" then
  elseif phase == "did" then
    composer.removeScene("Scenes.died")
  end
end

function scene:destroy(event)
  local sceneGroup = self.view
  audio.dispose(menu_bt_sfx)
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
