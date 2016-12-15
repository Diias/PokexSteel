local config = {
	id = 'AutoLoot', --Não pode conter espaços
	name = 'Ati/Des Auto Loot', --Nome que aparecerá quando passar o mouse por cima do botão
	img = 'button', --ícone do botão [no caso, pega a imagem button.png localizada na pasta do mod]
	options = { --opções que aparecem ao clicar no botão
		--[texto] = comando,
		['Ativar Auto Loot'] = '!autoloot on',
		['Desativar Auto Loot'] = '!autoloot off',
	}
}

function init()  
   connect(g_game, { onGameStart = reload, onGameEnd = reload})
   TopButton = modules.client_topmenu.addCustomRightButton(config.id, tr(config.name), config.img, toggle, true)
   TopButton:setOn(true)
   reload()
end

function toggle()
  local menu = g_ui.createWidget('PopupMenu')
  for _name, _command in pairs(config.options) do
	menu:addOption(_name, function() g_game.talk(_command) end)
  end
  menu:display()
end

function reload()
	TopButton:setVisible(g_game.isOnline())
end