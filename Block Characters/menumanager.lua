_G.BlockCharacters = _G.BlockCharacters or {
	save_path = SavePath .. 'BlockCharacters.txt',
	loc_path = ModPath .. 'loc/english.txt',
	options_path = ModPath .. 'menu/options.txt',
	settings = {
		russian = true,
		german = true,
		spanish = true,
		american = true,
		jowi = true,
		old_hoxton = true,
		female_1 = true,
		dragan = true,
		jacket = true,
		bonnie = true,
		sokol = true,
		dragon = true,
		bodhi = true,
		jimmy = true,
		sydney = true,
		wild = true,
		chico = true,
		max = true,
		joy = true,
		myh = true,
		ecp_male = true,
		ecp_female = true
	}
}

function BlockCharacters:load()
	local file = io.open(self.save_path, 'r')
	if file then
		for k, v in pairs(json.decode(file:read('*all'))) do
			self.settings[k] = v
		end
		file:close()
	else
		BlockCharacters:save()
	end
end

function BlockCharacters:save()
	local file = io.open(self.save_path, 'w+')
	if file then
		file:write(json.encode(self.settings))
		file:close()
	end
end

Hooks:Add("LocalizationManagerPostInit", "Block_Characters_LocalizationManagerPostInit", function( loc )
	loc:load_localization_file(BlockCharacters.loc_path)
end)

Hooks:Add( "MenuManagerInitialize", "Block_Characters_MenuManagerInitialize", function(menu_manager)
	MenuCallbackHandler.Block_Characters_check_clbk = function(this, item)
		BlockCharacters.settings[item:name()] = item:value() == 'on'
	end

	MenuCallbackHandler.Block_Characters_callback_options_closed = function(self)
		BlockCharacters:save()
	end

	BlockCharacters:load()
	MenuHelper:LoadFromJsonFile(BlockCharacters.options_path, BlockCharacters, BlockCharacters.settings)
end)