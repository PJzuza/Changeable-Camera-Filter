local superblt = false
for _, mod in pairs(BLT and BLT.Mods:Mods() or {}) do
	if mod:GetName() == "SuperBLT" and mod:IsEnabled() then
		superblt = true
		break
	end			
end
if superblt == false then
	if UpdateThisMod then
		UpdateThisMod:Add({
			mod_id = 'Changeable Camera Filter',
			data = {
				dl_url = 'https://raw.githubusercontent.com/PJzuza/Changeable-Camera-Filter/blob/master/updates/CCF.zip',
				info_url = 'https://raw.githubusercontent.com/PJzuza/Changeable-Camera-Filter/master/mod.txt'
			}
		})
	end

end