return {
	
	LrSdkVersion = 3.0,
	LrSdkMinimumVersion = 6.0, -- minimum SDK version required by this plug-in

	LrToolkitIdentifier = 'com.bootlegsoft.randombullshit',

	LrPluginName = LOC "$$$/RandomBullshit/PluginName=Random Bullshit",
    LrForceInitPlugin = true,
    LrInitPlugin = 'Init.lua', -- Main client logic

	-- Add the menu item to the File menu.
	LrExportMenuItems = {
		title = "Go!!!!",
		file = "RandomBullshit.lua",
	},

	VERSION = { major=10, minor=0, revision=0, build="202110051851-ef6045e0", },

}


	
