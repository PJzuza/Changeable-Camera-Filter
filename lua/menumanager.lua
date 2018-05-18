if not _G.CCF then
	_G.CCF = _G.CCF or {}
	CCF._path = ModPath
	CCF.settings_path = SavePath .. "CCF.txt"
end

function CCF:Reset()
	self.settings = {
		color_camera_filters = 1
	}
end

function CCF:Save()
	local file = io.open(self.settings_path, "w+")
	if file then
		file:write(json.encode(self.settings))
		file:close()
	end
end

function CCF:Load()
	CCF:Reset()
	local file = io.open(self.settings_path, "r")
	if file then
		for k, v in pairs(json.decode(file:read('*all')) or {}) do
			self.settings[k] = v
		end
		file:close()
	end
end

Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_CCF", function( loc )
	if file.DirectoryExists(CCF._path .. "loc/") then
			for _, filename in pairs(file.GetFiles(CCF._path .. "loc/")) do
				local str = filename:match('^(.*).txt$')
				if str and Idstring(str) and Idstring(str):key() == SystemInfo:language():key() then
					loc:load_localization_file(CCF._path .. "loc/" .. filename)
					break
				end
			end
	end
	loc:load_localization_file(CCF._path .. "loc/english.txt", false)
end)

Hooks:Add( "MenuManagerInitialize", "MenuManagerInitialize_CCF", function( menu_manager )
	MenuCallbackHandler.callback_color_camera_filters = function (self, item)
		CCF.settings.color_camera_filters_value = item:value()
	end

	MenuCallbackHandler.ccf_save = function(this, item)
		CCF:Save()
	end
	
	MenuCallbackHandler.callback_ccf_reset = function(self, item)
		MenuHelper:ResetItemsToDefaultValue(item, {["color_camera_filters"] = true}, 1)
	end
	
	CCF:Load()	
	MenuHelper:LoadFromJsonFile(CCF._path .. "menu/options.txt", CCF, CCF.settings)
end )