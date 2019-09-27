Config                            = {}

Config.DrawDistance               = 25.0
Config.MarkerType                 = 1
Config.MarkerSize                 = { x = 0.5, y = 0.5, z = 0.5 }
Config.MarkerColor                = { r = 122, g = 210, b = 255 }

Config.EnablePlayerManagement     = true
Config.EnableArmoryManagement     = true
Config.EnableESXIdentity          = true -- enable if you're using esx_identity
Config.EnableNonFreemodePeds      = true -- turn this on if you want custom peds
Config.EnableLicenses             = true -- enable if you're using esx_license

Config.EnableHandcuffTimer        = true -- enable handcuff timer? will unrestrain player after the time ends
Config.HandcuffTimer              = 10 * 60000 -- 10 mins

Config.EnableJobBlip              = true -- enable blips for colleagues, requires esx_society

Config.MaxInService               = -1
Config.Locale = 'en'

Config.PoliceStations = {

	LSPD = {

		Blip = {
			Coords  = vector3(425.1, -979.5, 30.7),
			Sprite  = 526,
			Display = 4,
			Scale   = 1.2,
			Colour  = 30
		},

		Cloakrooms = {
			vector3(452.6, -992.8, 30.6)
		},

		Armories = {
			vector3(452.445,-980.189,30.689),
			vector3(459.76, -989.66, 24.91),
			vector3(1711.71, 2571.69, -69.43),
			vector3(477.418,-989.42,24.915)
		},

		Vehicles = {
			{
				Spawner = vector3(426.94, -1011.8, 28.95),
				InsideShop = vector3(228.5, -993.5, -99.5),
				SpawnPoints = {
					{ coords = vector3(408.15, -1021.25, 29.36), heading = 90.0, radius = 6.0 },
					{ coords = vector3(407.97, -1026.04, 29.37), heading = 90.0, radius = 6.0 },
					{ coords = vector3(408.13, -1006.29, 29.27), heading = 118.78, radius = 6.0 }
				}
			},
			{
				Spawner = vector3(473.3, -1018.8, 28.0),
				InsideShop = vector3(228.5, -993.5, -99.0),
				SpawnPoints = {
					{ coords = vector3(475.9, -1021.6, 28.0), heading = 276.1, radius = 6.0 },
					{ coords = vector3(484.1, -1023.1, 27.5), heading = 302.5, radius = 6.0 }
				}
			}
		},

		Helicopters = {
			{
				Spawner = vector3(461.1, -981.5, 43.6),
				InsideShop = vector3(477.0, -1106.4, 43.0),
				SpawnPoints = {
					{ coords = vector3(449.5, -981.2, 43.6), heading = 92.6, radius = 10.0 }
				}
			}
		},

		BossActions = {
			vector3(448.4, -973.2, 30.6)
		}

	},

	SandyShoresSheriff = {

		Blip = {
			Coords  = vector3(1851.42, 3690.7, 43.99),
			Sprite  = 526,
			Display = 4,
			Scale   = 1.2,
			Colour  = 30
		},

		Cloakrooms = {
			vector3(1840.138,3689.614,34.287)
		},

		Armories = {
			vector3(1840.443,3691.358,34.287)
		},

		Vehicles = {
			{
				Spawner = vector3(1870.45, 3690.87, 33.65),
				InsideShop = vector3(228.5, -993.5, -99.5),
				SpawnPoints = {
					{ coords = vector3(1877.05, 3687.67, 33.47), heading = 217.65, radius = 6.0 },
					{ coords = vector3(1868.86, 3681.76, 33.63), heading = 217.65, radius = 6.0 },
					{ coords = vector3(1859.94, 3676.76, 33.64), heading = 217.65, radius = 6.0 }
				}
			}
		},

		Helicopters = {
			{
				Spawner = vector3(1840.25, 3684.07, 39.63),
				InsideShop = vector3(1834.39, 3675.36, 39.17),
				SpawnPoints = {
					{ coords = vector3(1834.39, 3675.36, 39.17), heading = 217.65, radius = 6.0 },
					{ coords = vector3(1829.93, 3688.19, 38.58), heading = 217.65, radius = 6.0 }
				}
			}
		},

		BossActions = {
			vector3(1855.235,3696.968,34.287)
		}

	}

}

Config.AuthorizedWeapons = {
    recruit = {
        { weapon = 'WEAPON_SMG', price = 0 },
        { weapon = 'WEAPON_COMBATPISTOL', price = 0 },
        { weapon = 'WEAPON_PUMPSHOTGUN', price = 0 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
        { weapon = 'WEAPON_STUNGUN', price = 0 },
        { weapon = 'WEAPON_FLASHLIGHT', price = 0 }
    },
 
    officer = {
        { weapon = 'WEAPON_COMBATPISTOL', price = 0 },
        { weapon = 'WEAPON_SMG', price = 0 },
        { weapon = 'WEAPON_PUMPSHOTGUN', price = 0 },
        { weapon = 'WEAPON_NIGHTSTICK', price = 0 },
        { weapon = 'WEAPON_STUNGUN', price = 0 },
        { weapon = 'WEAPON_FLASHLIGHT', price = 0 }
    },
 
    sergeant = {
        { weapon = 'WEAPON_COMBATPISTOL', price = 0 },
        { weapon = 'WEAPON_SMG', price = 0 },
        { weapon = 'WEAPON_PUMPSHOTGUN', price = 0 },
        { weapon = 'WEAPON_NIGHTSTICK', price = 0 },
        { weapon = 'WEAPON_STUNGUN', price = 0 },
        { weapon = 'WEAPON_FLASHLIGHT', price = 0 }
    },
 
    lieutenant = {
        { weapon = 'WEAPON_COMBATPISTOL', price = 0 },
        { weapon = 'WEAPON_SMG', price = 0 },
        { weapon = 'WEAPON_CARBINERIFLE', price = 0 },
        { weapon = 'WEAPON_PUMPSHOTGUN', price = 0 },
        { weapon = 'WEAPON_NIGHTSTICK', price = 0 },
        { weapon = 'WEAPON_STUNGUN', price = 0 },
        { weapon = 'WEAPON_FLASHLIGHT', price = 0 }
    },
 
    boss = {
        { weapon = 'WEAPON_COMBATPISTOL', price = 0 },
        { weapon = 'WEAPON_SMG', price = 0 },
        { weapon = 'WEAPON_CARBINERIFLE', price = 0 },
        { weapon = 'WEAPON_PUMPSHOTGUN', price = 0 },
        { weapon = 'WEAPON_NIGHTSTICK', price = 0 },
        { weapon = 'WEAPON_STUNGUN', price = 0 },
        { weapon = 'WEAPON_FLASHLIGHT', price = 0 }
	},
	
    deputy = {
        { weapon = 'WEAPON_SMG', price = 0 },
        { weapon = 'WEAPON_PUMPSHOTGUN', price = 0 },
        { weapon = 'WEAPON_COMBATPISTOL', price = 0 },
        { weapon = 'WEAPON_NIGHTSTICK', price = 0 },
        { weapon = 'WEAPON_STUNGUN', price = 0 },
        { weapon = 'WEAPON_FLASHLIGHT', price = 0 }
    },
 
    ssergent = {
        { weapon = 'WEAPON_SMG', price = 0 },
        { weapon = 'WEAPON_COMBATPISTOL', price = 0 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', price = 0 },
        { weapon = 'WEAPON_NIGHTSTICK', price = 0 },
        { weapon = 'WEAPON_STUNGUN', price = 0 },
        { weapon = 'WEAPON_FLASHLIGHT', price = 0 }
    },
 
    chiefdeputy = {
        { weapon = 'WEAPON_SMG', price = 0 },
        { weapon = 'WEAPON_CARBINERIFLE', price = 0 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', price = 0 },
		{ weapon = 'WEAPON_COMBATPISTOL', price = 0 },
        { weapon = 'WEAPON_NIGHTSTICK', price = 0 },
        { weapon = 'WEAPON_STUNGUN', price = 0 },
        { weapon = 'WEAPON_FLASHLIGHT', price = 0 }
    },
 
    sheriff = {
        { weapon = 'WEAPON_SMG', price = 0 },
        { weapon = 'WEAPON_CARBINERIFLE', price = 0 },
        { weapon = 'WEAPON_COMBATPISTOL', price = 0 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', price = 0 },
        { weapon = 'WEAPON_NIGHTSTICK', price = 0 },
        { weapon = 'WEAPON_STUNGUN', price = 0 },
        { weapon = 'WEAPON_FLASHLIGHT', price = 0 }
    },
 
    agent = {
        { weapon = 'WEAPON_SMG', price = 0 },
        { weapon = 'WEAPON_CARBINERIFLE', price = 0 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', price = 0 },
		{ weapon = 'WEAPON_COMBATPISTOL', price = 0 },
        { weapon = 'WEAPON_NIGHTSTICK', price = 0 },
        { weapon = 'WEAPON_STUNGUN', price = 0 },
        { weapon = 'WEAPON_FLASHLIGHT', price = 0 }
    },
 
    director = {
        { weapon = 'WEAPON_SMG', price = 0 },
        { weapon = 'WEAPON_CARBINERIFLE', price = 0 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', price = 0 },
		{ weapon = 'WEAPON_COMBATPISTOL', price = 0 },
        { weapon = 'WEAPON_NIGHTSTICK', price = 0 },
        { weapon = 'WEAPON_STUNGUN', price = 0 },
        { weapon = 'WEAPON_FLASHLIGHT', price = 0 }
    }
}

Config.AuthorizedVehicles = {
    shared = {
        { model = 'PBus', price = 0}
 
	},
	
    recruit = {
        { model = '18chgr', price = 0 },
        { model = 'sweethoe', price = 0 },
        { model = 'policeb', price = 0 }
    },
 
    officer = {
        { model = '18chgr', price = 0 },
        { model = 'sweethoe', price = 0 },
        { model = 'policeb', price = 0 }
    },
 
    sergeant = {
        { model = '18chgr', price = 0 },
        { model = 'sweethoe', price = 0 },
        { model = 'policeb', price = 0 }
    },
 
    lieutenant = {
        { model = '18chgr', price = 0 },
        { model = 'sweethoe', price = 0 },
        { model = 'policeb', price = 0 }
    },
 
    boss = {
        { model = '18chgr', price = 0 },
        { model = 'sweethoe', price = 0 },
        { model = 'riot', price = 0 },
        { model = 'policeb', price = 0 },
		{ model = 'policefelon', price = 0 },
		{ model = 'VettePD', price = 0 }
    },
 
    deputy = {
        { model = 'cvpi2', price = 0 },
        { model = 'bp1', price = 0 },
        { model = 'policeb', price = 0 },
    },
 
    ssergent = {
        { model = 'cvpi2', price = 0 },
        { model = 'bp1', price = 0 },
        { model = 'policeb', price = 0 },
    },
 
    chiefdeputy = {
        { model = 'cvpi2', price = 0 },
        { model = 'bp1', price = 0 },
        { model = 'policeb', price = 0 },
    },
 
    sheriff = {
        { model = 'cvpi2', price = 0 },
        { model = 'bp1', price = 0 },
        { model = 'policeb', price = 0 },
        { model = 'riot', price = 0 },
        { model = '2015polstang', price = 0 }
    },
 
    agent = {
        { model = 'policefelon', price = 0 },
        { model = 'polchgr', price = 0 },
        { model = 'fbi2', price = 0 }
	},
	
    director = {
        { model = 'policefelon', price = 0 },
        { model = 'polchgr', price = 0 },
        { model = 'fbi2', price = 0 }
    }
}

Config.AuthorizedHelicopters = {
	recruit = {},
	officer = {
		{ model = 'polmav', livery = 0, price = 0 }
	},
	sergeant = {
		{ model = 'polmav', livery = 0, price = 0 },
		{ model = 'haitun', livery = 0, price = 0 },
	},
	intendent = {
		{ model = 'polmav', livery = 0, price = 0 },
		{ model = 'haitun', livery = 0, price = 0 },
	},
	lieutenant = {
		{ model = 'polmav', livery = 0, price = 0 },
		{ model = 'haitun', livery = 0, price = 0 },
	},
	chef = {
		{ model = 'polmav', livery = 0, price = 0 },
		{ model = 'haitun', livery = 0, price = 0 },
	},
	boss = {
		{ model = 'polmav', livery = 0, price = 0 },
		{ model = 'haitun', livery = 0, price = 0 },
	},

    deputy = {
		{ model = 'polmav', livery = 0, price = 0 },
    },
 
    ssergent = {
		{ model = 'polmav', livery = 0, price = 0 },
		{ model = 'haitun', livery = 0, price = 0 },
    },
 
    chiefdeputy = {
		{ model = 'polmav', livery = 0, price = 0 },
		{ model = 'haitun', livery = 0, price = 0 },
    },
 
    sheriff = {
		{ model = 'polmav', livery = 0, price = 0 },
		{ model = 'haitun', livery = 0, price = 0 },
    },
 
    agent = {
		{ model = 'polmav', livery = 0, price = 0 },
		{ model = 'haitun', livery = 0, price = 0 },
	},
	
    director = {
		{ model = 'polmav', livery = 0, price = 0 },
		{ model = 'haitun', livery = 0, price = 0 },
    }
}

-- CHECK SKINCHANGER CLIENT MAIN.LUA for matching elements

Config.Uniforms = {
	recruit_wear = {
		male = {
			['tshirt_1'] = 59,  ['tshirt_2'] = 1,
			['torso_1'] = 55,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 41,
			['pants_1'] = 25,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 46,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 36,  ['tshirt_2'] = 1,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = 45,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	officer_wear = {
		male = {
			['tshirt_1'] = 58,  ['tshirt_2'] = 0,
			['torso_1'] = 55,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 41,
			['pants_1'] = 25,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	sergeant_wear = {
		male = {
			['tshirt_1'] = 58,  ['tshirt_2'] = 0,
			['torso_1'] = 55,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 1,
			['arms'] = 41,
			['pants_1'] = 25,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 7,   ['decals_2'] = 1,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	intendent_wear = {
		male = {
			['tshirt_1'] = 58,  ['tshirt_2'] = 0,
			['torso_1'] = 55,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 2,
			['arms'] = 41,
			['pants_1'] = 25,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 7,   ['decals_2'] = 2,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	lieutenant_wear = { -- currently the same as intendent_wear
		male = {
			['tshirt_1'] = 58,  ['tshirt_2'] = 0,
			['torso_1'] = 55,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 2,
			['arms'] = 41,
			['pants_1'] = 25,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 7,   ['decals_2'] = 2,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	chef_wear = {
		male = {
			['tshirt_1'] = 58,  ['tshirt_2'] = 0,
			['torso_1'] = 55,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 3,
			['arms'] = 41,
			['pants_1'] = 25,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 7,   ['decals_2'] = 3,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	boss_wear = { -- currently the same as chef_wear
		male = {
			['tshirt_1'] = 58,  ['tshirt_2'] = 0,
			['torso_1'] = 55,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 3,
			['arms'] = 41,
			['pants_1'] = 25,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 7,   ['decals_2'] = 3,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	bullet_wear = {
		male = {
			['bproof_1'] = 11,  ['bproof_2'] = 1
		},
		female = {
			['bproof_1'] = 13,  ['bproof_2'] = 1
		}
	},
	gilet_wear = {
		male = {
			['tshirt_1'] = 59,  ['tshirt_2'] = 1
		},
		female = {
			['tshirt_1'] = 36,  ['tshirt_2'] = 1
		}
	}
}
