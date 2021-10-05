-- Access the Lightroom SDK namespaces.
local LrDialogs = import 'LrDialogs'
local LrLogger = import 'LrLogger'
local LrDevelopController = import 'LrDevelopController'
local LrApplicationView = import 'LrApplicationView'

-- Create the logger and enable the print function.
local myLogger = LrLogger( 'exportLogger' )
myLogger:enable( "print" ) -- Pass either a string or a table of actions.

--------------------------------------------------------------------------------
-- Write trace information to the logger.

local function outputToLog( message )
	myLogger:trace( message )
end


--------------------------------------------------------------------------------
-- Adjustment
local limit = 0.4

local adjustsLess = {
	"Vibrance",
	"Saturation",
}

local adjustsFull = {
 "Highlights", 
 "Shadows",
 "Brightness",
 "Contrast",
 "Whites",
 "Blacks",
}

--------------------------------------------------------------------------------
-- Randomly adjust the photo.
local function go()
	-- Only for develop mode
	if (LrApplicationView.getCurrentModuleName() == "develop")
	then
		LrDevelopController.setValue( "Exposure", -1 + math.random() )
	
		for _, adjust in ipairs(adjustsLess) do
			local minAdjust, maxAdjust = LrDevelopController.getRange(adjust)
		    LrDevelopController.setValue( adjust, math.random(minAdjust*limit, maxAdjust*limit) )
		end

		for _, adjust in ipairs(adjustsFull) do
			local minAdjust, maxAdjust = LrDevelopController.getRange(adjust)
		    LrDevelopController.setValue( adjust, math.random(minAdjust, maxAdjust) )
		end
	end
end

--------------------------------------------------------------------------------
-- go!!!!
go()


