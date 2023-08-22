local Lib = {}

Lib.fuseItemsList = {
	{
		result = "dd_burger",
		item1 = "darkburger",
		item2 = "darkburger"
	},
	{
		result = "silver_card",
		item1 = "amber_card",
		item2 = "amber_card"
	},
	{
		result = "twinribbon",
		item1 = "pink_ribbon",
		item2 = "white_ribbon"
	},
	{
		result = "spikeband",
		item1 = "glowwrist",
		item2 = "ironshackle"
	},
	{
		result = "tensionbow",
		item1 = "bshotbowtie",
		item2 = "tensionbit"
	},
	{
		result = "twistedswd",
		item1 = "thornring",
		item2 = "purecrystal"
	}
}

function Lib:init()
	print("Loaded FuseItems libray!")
end

function Lib:setItemsList(item_list)
	Lib.fuseItemsList = item_list
end

function Lib:getItemsList()
	return Lib.fuseItemsList
end

return Lib