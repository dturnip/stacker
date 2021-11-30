local widget = require("widget")
local composer = require("composer")

local scene = composer.newScene()

function scene:create(event)
  local sceneGroup = self.view

  composer.setVariable("score", 69420)

  local background = display.newRect(
    sceneGroup,
    0,
    0,
    display.actualContentWidth,
    display.actualContentHeight
  )

  background.x, background.y = display.contentCenterX, display.contentCenterY
  background:setFillColor(0.2)

  local score = display.newText(
    sceneGroup,
    composer.getVariable("score"),
    display.contentCenterX,
    display.contentCenterY,
    "Menlo",
    50
  )

  local menu_bt = widget.newButton({
    width = 200,
    height = 40,
    emboss = true,
    shape = "roundedRect",
    cornerRadius = 2,
    labelColor = { default = { 1, 1, 1, 1 }, over = { 0, 1, 0, 1 } },
    fillColor = { default = { 1, 0, 0, 1 }, over = { 1, 0.1, 0.7, 0.4 } },
    strokeColor = { default = { 1, 0.4, 0, 1 }, over = { 0.8, 0.8, 1, 1 } },
    strokeWidth = 4,
    id = "menu_bt",
    label = "Main Menu",
    font = "Menlo",
    onEvent = function(event)
      if event.phase == "ended" then
        composer.gotoScene("Scenes.menu", {
          effect = "crossFade",
          time = 1000,
        })
      end
    end,
  })

  menu_bt.x, menu_bt.y = display.contentCenterX, display.contentCenterY + 100
  sceneGroup:insert(menu_bt)
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
