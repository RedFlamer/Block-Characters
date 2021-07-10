local check_peer_preferred_character_orig = BaseNetworkSession.check_peer_preferred_character
function BaseNetworkSession:check_peer_preferred_character(preferred_character)
	local free_characters = clone(CriminalsManager.character_names())

	for _, peer in pairs(self._peers_all) do
		local character = peer:character()

		table.delete(free_characters, character) -- A player is using this character, remove them from available characters
	end

	for _, character in pairs(free_characters) do
		if not _G.BlockCharacters.settings[character] then
			table.delete(free_characters, character) -- Character is not allowed, remove them from available characters
		end
	end

	if #free_characters == 0 then
		return check_peer_preferred_character_orig(self, preferred_character) -- All available characters are used, revert to vanilla handling so all characters except for currently used ones will be available
	end

	local preferreds = string.split(preferred_character, " ")
	for _, preferred in ipairs(preferreds) do
		if table.contains(free_characters, preferred) then
			return preferred -- One of the peer's preferred characters is allowed, allow them to use their preferred character
		end
	end

	return free_characters[math.random(#free_characters)] -- If peer has no preference/preferred characters are not available to use, assign them a random allowed character
end
