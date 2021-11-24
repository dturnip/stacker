local composer = require("composer")
local physics = require("physics")

physics.start()

local scene = composer.newScene()

local backGroup
local mainGroup
local uiGroup

-- create()
function scene:create(event)
  local sceneGroup = self.view

  physics.pause()

  backGroup = display.newGroup()
  mainGroup = display.newGroup()
  uiGroup = display.newGroup()

  sceneGroup:insert(backGroup)
  sceneGroup:insert(mainGroup)
  sceneGroup:insert(uiGroup)

  local background = display.newRect(
    backGroup,
    0,
    0,
    display.actualContentWidth,
    display.actualContentHeight
  )

  background.x, background.y = display.contentCenterX, display.contentCenterY
  background:setFillColor(0.2)

  local platform = display.newRect(
    mainGroup,
    display.contentCenterX,
    display.actualContentHeight - 50,
    display.actualContentWidth - 100,
    20
  )

  platform:setFillColor(0.5)

  -- local frames_tnt_crate = {
  --   frames = {
  --     -- Frame 1: TNT Crate
  --     { x = 35, y = 58, width = 79, height = 79 },
  --     -- Frame 2: Explode 1
  --     { x = 178, y = 55, width = 80, height = 80 },
  --     -- Frame 3: Explode 2
  --     { x = 325, y = 52, width = 87, height = 87 },
  --     -- Frame 4: Explode 3
  --     { x = 474, y = 48, width = 88, height = 88 },
  --     -- Frame 5: Explode 4
  --     { x = 32, y = 245, width = 92, height = 92 },
  --     -- Frame 6: Explode 5
  --     { x = 168, y = 243, width = 99, height = 94 },
  --     -- Frame 7: Explode 6
  --     { x = 314, y = 232, width = 105, height = 118 },
  --     -- Frame 8: Explode 7
  --     { x = 464, y = 240, width = 109, height = 117 },
  --     -- Frame 9: Explode 8
  --     { x = 33, y = 423, width = 122, height = 139 },
  --     -- Frame 10: Explode 9
  --     { x = 224, y = 439, width = 90, height = 95 },
  --     -- Frame 11: Explode 10
  --     { x = 367, y = 453, width = 84, height = 87 },
  --     -- Frame 12: Explode 11
  --     { x = 513, y = 489, width = 21, height = 21 },
  --     -- Frame 13: Explode 12
  --     { x = 0, y = 0, width = 0, height = 0 },
  --   },
  -- }

  local frames_tnt_crate = {
    frames = {
      { x = 26.25, y = 43.5, width = 59.25, height = 59.25 },
      { x = 133.5, y = 41.25, width = 60.0, height = 60.0 },
      { x = 243.75, y = 39.0, width = 65.25, height = 65.25 },
      { x = 355.5, y = 36.0, width = 66.0, height = 66.0 },
      { x = 24.0, y = 183.75, width = 69.0, height = 69.0 },
      { x = 126.0, y = 182.25, width = 74.25, height = 70.5 },
      { x = 235.5, y = 174.0, width = 78.75, height = 88.5 },
      { x = 348.0, y = 180.0, width = 81.75, height = 87.75 },
      { x = 24.75, y = 317.25, width = 91.5, height = 104.25 },
      { x = 168.0, y = 329.25, width = 67.5, height = 71.25 },
      { x = 275.25, y = 339.75, width = 63.0, height = 65.25 },
      { x = 384.75, y = 366.75, width = 15.75, height = 15.75 },
    },
  }

  local sequence_tnt_crate = {
    {
      name = "explode",
      start = 1,
      count = 12,
      time = 1000,
      loopCount = 1,
      loopDirection = "forward",
    },
  }

  local sheet_tnt_crate = graphics.newImageSheet(
    "Assets/TNTCrateSheet075.png",
    frames_tnt_crate
  )

  local crate = display.newImageRect(
    mainGroup,
    "Assets/Crate.png",
    59.25,
    59.25
  )
  crate.x, crate.y = display.contentCenterX, display.actualContentHeight - 150

  local tnt_crate = display.newSprite(
    mainGroup,
    sheet_tnt_crate,
    sequence_tnt_crate
  )
  tnt_crate.x, tnt_crate.y = display.contentCenterX, display.contentCenterY

  local side_spikes_l = display.newImageRect(
    mainGroup,
    "Assets/SideSpikesRep506.png",
    30,
    display.actualContentHeight
  )

  side_spikes_l.x = 6
  side_spikes_l.y = display.contentCenterY

  local side_spikes_r = display.newImageRect(
    mainGroup,
    "Assets/SideSpikesRep506.png",
    30,
    display.actualContentHeight
  )

  side_spikes_r:scale(-1, 1)
  side_spikes_r.x = display.actualContentWidth - 6
  side_spikes_r.y = display.contentCenterY

  -- tnt_crate:addEventListener("tap", function(event)
  --   event.target:play()
  --   timer.performWithDelay(1200, function()
  --     event.target:setFrame(1)
  --   end)
  --   return true
  -- end)

  -- local function tapped()
  --   print("tapped")
  --   Runtime:removeEventListener("tap", tapped)
  --   timer.performWithDelay(3000, function()
  --     print("done")
  --     Runtime:addEventListener("tap", tapped)
  --   end)
  -- end
  -- Runtime:addEventListener("tap", tapped)
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
