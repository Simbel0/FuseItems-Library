return {
	test = function(cutscene)
		cutscene:text("* Hi! I'm a dummy that can fuses items!")
		cutscene:text("* Would you like to fuse items?")
		if cutscene:choicer({"yes", "no"}) == 1 then
			cutscene:after(function()
				Game.world:openMenu(FuseMenu())
			end)
		else
			cutscene:text("* That's fine. Come back when you need me.")
		end
	end
}