local composer = require("composer")
local physics = require("physics")

physics.start()
physics.setGravity(0, 9.8)

local scene = composer.newScene()

local backGroup
local mainGroup
local uiGroup

local lives_display
local score_display
local next_buf_one
local next_buf_two
local next_buf_three

local GameState = {
  score = 0,
  lives = 3,
  next_bufs = { "L3", "R2", "L2" },
  crates_store = {},
  first_spawnY = display.actualContentHeight - 140,
  spawnY_level = 0,
}

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

local function parse_move_buf(buf)
  return buf:gsub("L", "<< "):gsub("R", ">> ")
end

local function spawn_layer(y, tone)
  local layer = display.newRect(
    backGroup,
    display.contentCenterX,
    y,
    display.actualContentWidth,
    59.25
  )

  layer:setFillColor(tone)
end

local function render_ui()
  lives_display.text = GameState.lives == 3 and "❤️ ❤️ ❤️"
    or GameState.lives == 2 and "❤️ ❤️"
    or GameState.lives == 1 and "❤️"
    or "❌"
  
  score_display.text = GameState.score
  next_buf_one.text = parse_move_buf(GameState.next_bufs[1])
  next_buf_two.text = parse_move_buf(GameState.next_bufs[2])
  next_buf_three.text = parse_move_buf(GameState.next_bufs[3])
end

-- local function instantiate_crate(buf)
--   local crate = display.newImageRect(
--     mainGroup,
--     "Assets/Crate.png",
--     59.25,
--     59.25
--   )

--   local dir = buf:sub(1, 1)

--   local spawnX_pos = dir == "L" and display.actualContentWidth
--     or dir == "R" and 0
--     or nil
--   local spawnY_pos = GameState.first_spawnY - 59.25 * GameState.spawnY_level
--   crate.x, crate.y = spawnX_pos, spawnY_pos

--   crate.alpha = 0.1

--   transition.to(crate, {
--     alpha = 1,
--     time = 1000,
--     x = dir == "L" and display.actualContentWidth - 75
--       or dir == "R" and 75
--       or nil,
--   })

--   local linear_transform

--   local function drop()
--     transition.cancel(linear_transform)
--     physics.addBody(crate, "dynamic", {})
--     Runtime:removeEventListener("tap", drop)

--   end

--   timer.performWithDelay(1000, function()
--     Runtime:addEventListener("tap", drop)
--     linear_transform = transition.to(crate, {
--       time = 4000,
--       x = dir == "L" and 0 or dir == "R" and display.actualContentWidth or nil,
--     })
--   end)

--   table.insert(GameState.crates_store, crate)
-- end

local function spawn_buf(buf)
  local function instantiate_crate(buf, ct)
  local crate = display.newImageRect(
    mainGroup,
    "Assets/Crate.png",
    59.25,
    59.25
  )

  local dir = buf:sub(1, 1)

  local spawnX_pos = dir == "L" and display.actualContentWidth
    or dir == "R" and 0
    or nil
  local spawnY_pos = GameState.first_spawnY - 59.25 * GameState.spawnY_level
  crate.x, crate.y = spawnX_pos, spawnY_pos

  crate.alpha = 0.1

  transition.to(crate, {
    alpha = 1,
    time = 1000,
    x = dir == "L" and display.actualContentWidth - 75
      or dir == "R" and 75
      or nil,
  })

  local linear_transform

  local function drop()
    transition.cancel(linear_transform)
    physics.addBody(crate, "dynamic", {})
    Runtime:removeEventListener("tap", drop)

    ct = ct - 1
    if ct > 0 then
      timer.performWithDelay(500, function()
        instantiate_crate(buf, ct)
      end)
    else
      -- TODO: Check if the spawnY_level is at the max, then set it back to 0
      GameState.spawnY_level = GameState.spawnY_level + 1
    end
  end

  timer.performWithDelay(1000, function()
    Runtime:addEventListener("tap", drop)
    linear_transform = transition.to(crate, {
      time = 4000,
      x = dir == "L" and 0 or dir == "R" and display.actualContentWidth or nil,
    })
  end)

  table.insert(GameState.crates_store, crate)
end

  local curr_buf = GameState.next_bufs[1]
  local dir, ct = curr_buf:sub(1, 1), tonumber(curr_buf:sub(2, 2), 10)

  instantiate_crate(curr_buf, ct)

  local new_buf = (math.random() > 0.5 and "L" or "R") .. math.random(1, 3)

  GameState.next_bufs[1] = GameState.next_bufs[2]
  GameState.next_bufs[2] = GameState.next_bufs[3]
  GameState.next_bufs[3] = new_buf

  render_ui()
end

local function loop()
  --TODO: asdf
end

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

  spawn_layer(GameState.first_spawnY, 0.25)
  spawn_layer(GameState.first_spawnY - 59.25, 0.275)
  spawn_layer(GameState.first_spawnY - 59.25 * 2, 0.25)
  spawn_layer(GameState.first_spawnY - 59.25 * 3, 0.275)
  spawn_layer(GameState.first_spawnY - 59.25 * 4, 0.25)
  spawn_layer(GameState.first_spawnY - 59.25 * 5, 0.275)
  spawn_layer(GameState.first_spawnY - 59.25 * 6, 0.25)

  local platform = display.newRect(
    mainGroup,
    display.contentCenterX,
    display.actualContentHeight - 40,
    display.actualContentWidth - 100,
    20
  )

  platform:setFillColor(0.5)
  physics.addBody(platform, "static")

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

  -- local tnt_crate = display.newSprite(
  --   mainGroup,
  --   sheet_tnt_crate,
  --   sequence_tnt_crate
  -- )
  -- tnt_crate.x, tnt_crate.y = display.contentCenterX, display.contentCenterY

  -- physics.addBody(tnt_crate, "dynamic", {})

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

  physics.addBody(side_spikes_l, "static", { isSensor = true })
  physics.addBody(side_spikes_r, "static", { isSensor = true })

  local ui_overlay = display.newRect(
    uiGroup,
    display.contentCenterX,
    -10,
    display.actualContentWidth + 50,
    display.actualContentHeight / 6
  )

  ui_overlay:setFillColor(0.2)
  ui_overlay.strokeWidth = 5
  ui_overlay:setStrokeColor(0.6)

  lives_display = display.newText(
    uiGroup,
    "",
    55,
    ui_overlay.y + 20,
    "Menlo",
    15
  )

  score_display = display.newText(
    uiGroup,
    "",
    55,
    ui_overlay.y - 10,
    "Menlo",
    25
  )

  local moves_display_container = display.newRect(
    uiGroup,
    display.actualContentWidth - 105,
    ui_overlay.y + 5,
    200,
    ui_overlay.height - 30
  )

  moves_display_container:setFillColor(0.2)
  moves_display_container.strokeWidth = 5
  moves_display_container:setStrokeColor(0.5)

  local bufs_divider = display.newRect(
    uiGroup,
    moves_display_container.x,
    moves_display_container.y,
    moves_display_container.width / 3,
    ui_overlay.height - 30
  )

  bufs_divider:setFillColor(0.2)
  bufs_divider.strokeWidth = 5
  bufs_divider:setStrokeColor(0.5)

  -- UI Move Bufs

  next_buf_one = display.newText(
    uiGroup,
    "",
    moves_display_container.x - moves_display_container.width / 3,
    moves_display_container.y,
    "Menlo",
    20
  )

  next_buf_two = display.newText(
    uiGroup,
    "",
    moves_display_container.x,
    moves_display_container.y,
    "Menlo",
    20
  )

  next_buf_three = display.newText(
    uiGroup,
    "",
    moves_display_container.x + moves_display_container.width / 3,
    moves_display_container.y,
    "Menlo",
    20
  )

  render_ui()

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
    physics.start()
    -- timer.performWithDelay(1000, function()
    --   -- instantiate_crate(GameState.next_bufs[1])
    --   spawn_buf(GameState.next_bufs[1])
    --   -- Fix timing bug
    --   -- spawn_buf(GameState.next_bufs[2])
    -- end)
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
