Held = {}
Held.options = {}
-- Private Variables
local optionsWindow
local optionsButton
local playerCount = nil
local playerCount2 = nil
local playerCount3 = nil

-- Private Functions
local function getDistanceBetween(fromPosition, toPosition)
  if fromPosition.z ~= toPosition.z then return 999999 end
  local x, y = math.abs(fromPosition.x - toPosition.x), math.abs(fromPosition.y - toPosition.y)
  local diff = math.sqrt(x*x + y*y)
  return diff
end

-- Public functions
function Held.init()
  optionsWindow = g_ui.displayUI('held.otui')
  optionsWindow:setVisible(false)
  optionsButton = modules.client_topmenu.addCustomRightButton('heldButton', 'Held', '/held_items/held.png', Held.toggle, true)
  optionsButton:setVisible(false)
  connect(g_game, { onGameStart = Held.online,
    onGameEnd = Held.offline})

   playerCount = optionsWindow:recursiveGetChildById("playerCount")
   playerCount2 = optionsWindow:recursiveGetChildById("playerCount2")
   playerCount3 = optionsWindow:recursiveGetChildById("playerCount3")
  Held.options = g_settings.getNode('Held') or {}
  if g_game.isOnline() then
    Held.online()
  end
end

function Held.terminate()
  disconnect(g_game, { onGameStart = Held.online,
   onGameEnd = Held.offline})

  if g_game.isOnline() then
    Held.offline()
  end

  optionsWindow:destroy()
  optionsWindow = nil
  optionsButton:destroy()
  optionsButton = nil

  g_settings.setNode('Held', Held.options)
end

function Held.toggle()
  if optionsWindow:isVisible() then
    Held.hide()
  else
    Held.show()
    Held.sendMsg()
  end
end

function Held.sendMsg()
if g_game.isOnline() then
end
end

function onHeldCount(mode, text)
if not g_game.isOnline() then return end
   if mode == MessageModes.Failure then 
      if string.find(text, '#held#,') then
         local t = text:explode(',')
         playerCount:setText(tonumber(t[2]))
         playerCount2:setText(tonumber(t[3]))
         playerCount3:setText(tonumber(t[4]))
      end
   end
end 
function Held.show()
  if g_game.isOnline() then
    optionsWindow:show()
    g_game.talk('#heldCount#')
    connect(g_game, 'onTextMessage', onHeldCount)
    -- optionsWindow:lock()
  end
end

function Held.hide()
  -- optionsWindow:unlock()
  optionsWindow:hide()
end

function Held.online()
  optionsButton:setVisible(true)
  
end

function Held.offline()
  optionsWindow:hide()
  optionsButton:setVisible(false)
  
end