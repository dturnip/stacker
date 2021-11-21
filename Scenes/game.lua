local composer = require("composer")

local scene = composer.newScene()

-- create()
function scene:create(event)
  local sceneGroup = self.view

  local background = display.newRect(
    0,
    0,
    display.actualContentWidth,
    display.actualContentHeight
  )

  background.x, background.y = display.contentCenterX, display.contentCenterY
  background:setFillColor(1, 1, 1)

  local frames_tnt_crate = {
    frames = {
      -- Frame 1: TNT Crate
      { x = 35, y = 58, width = 79, height = 79 },
      -- Frame 2: Explode 1
      { x = 178, y = 55, width = 80, height = 80 },
      -- Frame 3: Explode 2
      { x = 325, y = 52, width = 87, height = 87 },
      -- Frame 4: Explode 3
      { x = 474, y = 48, width = 88, height = 88 },
      -- Frame 5: Explode 4
      { x = 32, y = 245, width = 92, height = 92 },
      -- Frame 6: Explode 5
      { x = 168, y = 243, width = 99, height = 94 },
      -- Frame 7: Explode 6
      { x = 314, y = 232, width = 105, height = 118 },
      -- Frame 8: Explode 7
      { x = 464, y = 240, width = 109, height = 117 },
      -- Frame 9: Explode 8
      { x = 33, y = 423, width = 122, height = 139 },
      -- Frame 10: Explode 9
      { x = 224, y = 439, width = 90, height = 95 },
      -- Frame 11: Explode 10
      { x = 367, y = 453, width = 84, height = 87 },
      -- Frame 12: Explode 11
      { x = 513, y = 489, width = 21, height = 21 },
      -- Frame 13: Explode 12
      { x = 0, y = 0, width = 0, height = 0 },
    },
  }

  local sequence_tnt_crate = {
    {
      name = "explode",
      start = 1,
      count = 13,
      time = 1000,
      loopCount = 1,
      loopDirection = "forward",
    },
  }

  local sheet_tnt_crate = graphics.newImageSheet(
    "Assets/TNTCrateSheet.png",
    frames_tnt_crate
  )

  local crate = display.newImageRect("Assets/Crate.png", 80, 80)
  crate.x, crate.y = display.contentCenterX, display.actualContentHeight - 150

  local tnt_crate = display.newSprite(sheet_tnt_crate, sequence_tnt_crate)
  tnt_crate.x, tnt_crate.y = display.contentCenterX, display.contentCenterY

  tnt_crate:addEventListener("tap", function(event)
    event.target:play()
    timer.performWithDelay(1200, function()
      event.target:setFrame(1)
    end)
    return true
  end)
end

-- show()
function scene:show(event)
  local sceneGroup = self.view
  local phase = event.phase

  if phase == "will" then
    -- Code here runs when the scene is still off screen (but is about to come on screen)
  elseif phase == "did" then
    -- Code here runs when the scene is entirely on screen
  end
end

-- hide()
function scene:hide(event)
  local sceneGroup = self.view
  local phase = event.phase

  if phase == "will" then
    -- Code here runs when the scene is on screen (but is about to go off screen)
  elseif phase == "did" then
    -- Code here runs immediately after the scene goes entirely off screen
  end
end

-- destroy()
function scene:destroy(event)
  local sceneGroup = self.view
  -- Code here runs prior to the removal of scene's view
end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)
-- -----------------------------------------------------------------------------------

return scene
