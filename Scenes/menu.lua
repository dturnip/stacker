local widget = require("widget")
local composer = require("composer")

local scene = composer.newScene()

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

  local title = display.newText(
    sceneGroup,
    "Stacker",
    display.contentCenterX,
    display.contentCenterY - 100,
    "Menlo",
    30
  )
  local tableutils = require("fplua.utils.tableutils")

  local start_bt = widget.newButton({
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
    id = "start_bt",
    label = "Start",
    font = "Menlo",
    onEvent = function(event)
      if event.phase == "ended" then
        composer.gotoScene("Scenes.game", {
          effect = "slideLeft",
          time = 1000,
        })
      end
    end,
  })

  start_bt.x, start_bt.y = display.contentCenterX, display.contentCenterY
  sceneGroup:insert(start_bt)

  local lb_bt = widget.newButton({
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
    id = "lb_bt",
    label = "Leaderboard",
    font = "Menlo",
    onEvent = function(event)
      if event.phase == "ended" then
        --
      end
    end,
  })

  lb_bt.x, lb_bt.y = display.contentCenterX, display.contentCenterY + 100
  sceneGroup:insert(lb_bt)
end

function scene:show(event)
  local sceneGroup = self.view
  local phase = event.phase

  if phase == "will" then
    -- Before appear
  elseif phase == "did" then
    -- After appear
  end
end

function scene:hide(event)
  local sceneGroup = self.view
  local phase = event.phase

  if phase == "will" then
    -- Before disappears
  elseif phase == "did" then
    -- After disappears
    composer.removeScene("Scenes.menu")
  end
end

function scene:destroy(event)
  local sceneGroup = self.view
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
