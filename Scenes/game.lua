local composer = require("composer")
local physics = require("physics")

physics.start()
physics.setGravity(0, 9.8)

local scene = composer.newScene()

local livelost_sfx
local explode_sfx

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
  speed = 1,
  crates_store = {},
  first_spawnY = display.actualContentHeight - 140,
  spawnY_level = 0,
  died = false,
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
  "Assets/TNTCrateSheet075.png",
  frames_tnt_crate
)

local function parse_move_buf(buf)
  return buf:gsub("L", "<< "):gsub("R", ">> ")
end

local function parse_score(score)
  local str_score = tostring(score)
  local str_buf = ""

  if #str_score < 6 then
    -- https://github.com/dturnip/fplua/blob/main/gens/range.lua
    for _ in range(6 - #str_score + 1) do
      str_buf = str_buf .. "0"
    end
  end

  return (str_buf .. str_score):gsub("0", "O")
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
  if GameState.lives <= 0 then
    physics.pause()
    GameState.died = true

    composer.setVariable("score", GameState.score)
    -- Free memory
    -- https://github.com/dturnip/fplua/wiki/Iterator-Class
    Iterator.from(GameState.crates_store):foreach(function(crate)
      display.remove(crate)
      crate = nil
    end)

    -- TODO: Add dying sfx
    composer.gotoScene("Scenes.died", {
      effect = "crossFade",
      time = 1500,
    })

    return
  end

  lives_display.text = GameState.lives == 3 and "❤️ ❤️ ❤️"
    or GameState.lives == 2 and "❤️ ❤️"
    or GameState.lives == 1 and "❤️"
    or "❌"

  score_display.text = parse_score(GameState.score)
  next_buf_one.text = parse_move_buf(GameState.next_bufs[1])
  next_buf_two.text = parse_move_buf(GameState.next_bufs[2])
  next_buf_three.text = parse_move_buf(GameState.next_bufs[3])
end

-- Game logic

local instantiate_crate = function(buf, ct) end
local drop = function(crate, buf) end
local spawn_buf = function(buf) end
local next_layer = function() end

function next_layer()
  if GameState.spawnY_level > 5 then
    GameState.spawnY_level = 0
    GameState.score = GameState.score + 300
    -- 6 buffers complete
    -- TODO: Play epic sound

    Iterator.from(GameState.crates_store):foreach(function(crate)
      transition.to(crate, {
        alpha = 0,
        time = 500 * GameState.speed,
        onComplete = function()
          display.remove(crate)
          crate = nil
        end,
      })
    end)

    -- 20% faster
    GameState.speed = GameState.speed * 0.8
    return
  end
  GameState.spawnY_level = GameState.spawnY_level + 1

  local tmp_layer = spawn_layer(
    GameState.first_spawnY - GameState.spawnY_level * 59.25,
    { 1, 0, 0 }
  )

  tmp_layer.alpha = 0.0

  timer.performWithDelay(500, function()
    timer.performWithDelay(250, function()
      tmp_layer.alpha = 0.2
    end)
    timer.performWithDelay(500, function()
      tmp_layer.alpha = 0
    end)
  end, 4)

  -- stylua: ignore
  local new_buf = (math.random() > 0.5 and "L" or "R") .. math.random(1, 3)

  GameState.next_bufs[1] = GameState.next_bufs[2]
  GameState.next_bufs[2] = GameState.next_bufs[3]
  GameState.next_bufs[3] = new_buf

  render_ui()
end

function drop(crate, buf)
  GameState.ct = GameState.ct - 1

  crate.bodyType = "dynamic"
  crate.alpha = 1
  crate.gravityScale = 1
  crate.isSensor = false
  crate.isFixedRotation = true
  crate.bounce = 0

  if GameState.ct > 0 then
    timer.performWithDelay(1000, function()
      instantiate_crate(buf, GameState.ct)
    end)
  else
    timer.performWithDelay(1000, function()
      next_layer()
      spawn_buf(GameState.next_bufs[1])
    end)
  end
end

function instantiate_crate(buf, ct)
  -- TODO: Add a third type of crate: Crate with spike on top

  GameState.ct = ct

  if not GameState.died then
    GameState.score = GameState.score + 100
    render_ui()
  end

  if GameState.lives > 0 then
    local rand = math.random(1, 5)

    local crate = rand < 5
        and display.newImageRect(
          mainGroup,
          "Assets/Crate.png",
          59.25,
          59.25
        )
      or display.newSprite(mainGroup, sheet_tnt_crate, sequence_tnt_crate)

    crate.isTNT = rand == 5
    crate.name = "crate"

    local dir = buf:sub(1, 1)

    local spawnX_pos = dir == "L" and display.actualContentWidth
      or dir == "R" and 0
      or nil
    local spawnY_pos = GameState.first_spawnY - 59.25 * GameState.spawnY_level
    crate.x, crate.y = spawnX_pos, spawnY_pos

    crate.alpha = 0.1

    local phase_transform
    local linear_transform

    phase_transform = transition.to(crate, {
      alpha = 1,
      time = 1000 * GameState.speed,
      x = dir == "L" and display.actualContentWidth - 55
        or dir == "R" and 55
        or nil,
      onComplete = function()
        physics.addBody(crate, "dynamic", { isSensor = true })
        crate.gravityScale = 0
        GameState.curr_crate = crate
        GameState.crates_collided = false
        GameState.spike_collided = false
        table.insert(GameState.crates_store, crate)
      end,
    })

    timer.performWithDelay(1000 * GameState.speed, function()
      linear_transform = transition.to(crate, {
        time = 4000 * GameState.speed,
        x = dir == "L" and 0 or dir == "R" and display.actualContentWidth or nil,
      })
    end)
  end
end

local function tapEvent()
  if GameState.curr_crate ~= nil then
    transition.cancel()
    drop(GameState.curr_crate, GameState.curr_buf)
    GameState.curr_crate = nil
  end
end

function spawn_buf(buf)
  local curr_buf = GameState.next_bufs[1]
  local dir, ct = curr_buf:sub(1, 1), tonumber(curr_buf:sub(2, 2), 10)
  GameState.curr_buf = curr_buf
  GameState.ct = ct
  ct = nil

  instantiate_crate(curr_buf, GameState.ct)

  -- Runtime:addEventListener("tap", tapEvent)
end

local function onCollision(event)
  local phase = event.phase

  if phase == "began" then
    local acol, bcol = event.object1, event.object2

    if
      acol.name == "crate" and bcol.name == "spike"
      or acol.name == "spike" and bcol.name == "crate"
    then
      -- Crate collided with a spike
      local crate = acol.name == "crate" and acol or bcol
      GameState.spike_collided = true

      if crate.isTNT == false then
        -- Regular crate
        GameState.lives = GameState.lives - 1
        if GameState.crates_collided == false then
          audio.play(livelost_sfx, { channel = 2 })
          tapEvent()
          timer.performWithDelay(150, function()
            display.remove(crate)
          end)
          render_ui()
        end
      else
        -- TNT Crate
        audio.play(explode_sfx, { channel = 2 })
        transition.cancel()
        GameState.lives = 0
        crate:play()
        timer.performWithDelay(1200, function()
          render_ui()
        end)
      end
    elseif acol.name == "crate" and bcol.name == "crate" then
      if
        acol.y - acol.height / 2 < bcol.y
        and bcol.y + bcol.height / 2 > acol.y
        and GameState.curr_crate ~= nil
      then
        -- Stop both crates
        if GameState.spike_collided == false then
          transition.cancel()
          GameState.curr_crate.bodyType = "dynamic"
          GameState.curr_crate.alpha = 1
          GameState.curr_crate.gravityScale = 1
          GameState.curr_crate.isSensor = true
          GameState.curr_crate.isFixedRotation = true
          GameState.curr_crate.bounce = 0

          timer.performWithDelay(200, function()
            if GameState.curr_crate then
              GameState.curr_crate.isSensor = false
            end
            GameState.crates_collided = true
            tapEvent()
          end)
        end
      end
    end
  end
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

  -- Just too used to writing 0-based code lmao
  local layer0 = spawn_layer(GameState.first_spawnY, 0.25)
  local layer1 = spawn_layer(GameState.first_spawnY - 59.25, 0.275)
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

  livelost_sfx = audio.loadSound("Assets/Sounds/livelost.mp3")
  explode_sfx = audio.loadSound("Assets/Sounds/explode.mp3")
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
    timer.performWithDelay(1000, function()
      spawn_buf(GameState.next_bufs[1])
      -- Fix timing bug
    end)

    Runtime:addEventListener("collision", onCollision)
    Runtime:addEventListener("tap", tapEvent)
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
    Runtime:removeEventListener("collision", onCollision)
    Runtime:removeEventListener("tap", tapEvent)
    physics.pause()
    composer.removeScene("Scenes.game")
  end
end

-- destroy()
function scene:destroy(event)
  local sceneGroup = self.view
  -- Code here runs prior to the removal of scene's view
  audio.dispose(live_lost_sfx)
  audio.dispose(explode_sfx)
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
