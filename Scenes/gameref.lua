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
  lives = 3,
  score = 0,
  next_bufs = { "L3", "R2", "L2" },
  crates_store = {},
  first_spawnY = display.actualContentHeight - 140,
  spawnY_level = 0,
  curr_crate = nil,
  curr_buf = nil,
}

local function parse_move_buf(buf)
  return buf:gsub("L", "<— "):gsub("R", "—> ")
end

local function spawn_layer(y, tone)
  local layer = display.newRect(
    backGroup,
    display.contentCenterX,
    y,
    display.actualContentWidth,
    59.25
  )

  if type(tone) == "table" then
    layer:setFillColor(unpack(tone))
  else
    layer:setFillColor(tone)
  end

  return layer
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

-- Game logic

local function instantiate_crate(buf, ct)
  local crate = display.newImageRect(
    mainGroup,
    "Assets/crate.png",
    59.25,
    59.25
  )

  crate.name = "crate"

  local direction = buf:sub(1, 1) -- Either "L" or "R"

  local spawnX_pos = direction == "L" and display.actualContentWidth
    or direction == "R" and 0
    or nil

  local spawnY_pos = GameState.first_spawnY - 59.25 * GameState.spawnY_level

  crate.x = spawnX_pos
  crate.y = spawnY_pos
  crate.alpha = 0.1

  local phase_transform
  local linear_transform

  phase_transform = transition.to(crate, {
    alpha = 1,
    time = 1000,
    x = direction == "L" and display.actualContentWidth - 60
      or direction == "R" and 60
      or nil,
    onComplete = function()
      physics.addBody(crate, "dynamic", { isSensor = true })
      crate.gravityScale = 0
      GameState.curr_crate = crate
      table.insert(GameState.crates_store, crate)
    end,
  })

  timer.performWithDelay(1000, function()
    linear_transform = transition.to(crate, {
      time = 4000,
      x = direction == "L" and 0
        or direction == "R" and display.actualContentWidth
        or nil,
    })
  end)
end

local function drop(crate, buf) end

local function spawn_buf(buf) end

local function next_layer() end

local function handleTap() end

local function handleCollision() end

local function go()
  instantiate_crate(GameState.next_bufs[1], 3)
end

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

  background.x = display.contentCenterX
  background.y = display.contentCenterY

  background:setFillColor(0.2)

  local layer0 = spawn_layer(GameState.first_spawnY - 59.25 * 0, 0.25)
  local layer1 = spawn_layer(GameState.first_spawnY - 59.25 * 1, 0.275)
  local layer2 = spawn_layer(GameState.first_spawnY - 59.25 * 2, 0.25)
  local layer3 = spawn_layer(GameState.first_spawnY - 59.25 * 3, 0.275)
  local layer4 = spawn_layer(GameState.first_spawnY - 59.25 * 4, 0.25)
  local layer5 = spawn_layer(GameState.first_spawnY - 59.25 * 5, 0.275)
  local layer6 = spawn_layer(GameState.first_spawnY - 59.25 * 6, 0.25)

  local platform = display.newRect(
    mainGroup,
    display.contentCenterX,
    display.actualContentHeight - 40,
    display.actualContentWidth - 100,
    20
  )

  platform:setFillColor(0.5)
  physics.addBody(platform, "static")

  local side_spikes_l = display.newImageRect(
    mainGroup,
    "Assets/SideSpikesRep506.png",
    30,
    display.actualContentHeight
  )

  side_spikes_l.x = 6
  side_spikes_l.y = display.contentCenterY
  side_spikes_l.name = "spike"

  local side_spikes_r = display.newImageRect(
    mainGroup,
    "Assets/SideSpikesRep506.png",
    30,
    display.actualContentHeight
  )

  side_spikes_r:scale(-1, 1)
  side_spikes_r.x = display.actualContentWidth - 6
  side_spikes_r.y = display.contentCenterY
  side_spikes_r.name = "spike"

  physics.addBody(side_spikes_l, "kinematic", { isSensor = true })
  physics.addBody(side_spikes_r, "kinematic", { isSensor = true })

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
end

function scene:show(event)
  local sceneGroup = self.view
  local phase = event.phase

  if phase == "will" then
    -- About to come onto the screen
  elseif phase == "did" then
    -- Scene is on the screen
    physics.start()
    -- Start looping and running game logic
    go()
  end
end

function scene:hide(event)
  local sceneGroup = self.view
  local phase = event.phase

  if phase == "will" then
    -- About to come off the screen
  elseif phase == "did" then
    -- Scene is off the screen
  end
end

function scene:destroy(event)
  local sceneGroup = self.view
  -- About to remove the scene
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
