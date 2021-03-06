-- Access the Lightroom SDK namespaces.
local LrDialogs = import 'LrDialogs'
local LrLogger = import 'LrLogger'
local LrDevelopController = import 'LrDevelopController'
local LrApplicationView = import 'LrApplicationView'

local LrTasks = import 'LrTasks'
local LrFunctionContext = import 'LrFunctionContext'

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
STOP_RANDOM = false

local limit = 0.4
local processing = false

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
        processing = true
		LrDevelopController.setValue( "Exposure", -1 + math.random() * 2 )

		-- Random WB is not really yield a good result
		-- LrDevelopController.setValue( "Temperature", math.random(4000, 7000) )

		for _, adjust in ipairs(adjustsLess) do
			local minAdjust, maxAdjust = LrDevelopController.getRange(adjust)
		    LrDevelopController.setValue( adjust, math.random(minAdjust*limit, maxAdjust*limit) )
		end

		for _, adjust in ipairs(adjustsFull) do
			local minAdjust, maxAdjust = LrDevelopController.getRange(adjust)
		    LrDevelopController.setValue( adjust, math.random(minAdjust, maxAdjust) )
		end
		LrDevelopController.stopTracking()
		processing = false
	end
end

local PARAM_OBSERVER = {}
local sendChangedParams

-- send changed parameters
function sendChangedParams( observer )
    local allZero = true
    for _, param in ipairs(adjustsFull) do
        if(observer[param] ~= LrDevelopController.getValue(param)) then
            observer[param] = LrDevelopController.getValue(param)
        end
        local value = observer[param]
        if (param == "Brightness") then
            value = value - 50
        end
        if (value ~= 0) then
            allZero = false
        end
    end

    if not processing and not STOP_RANDOM and allZero
    then
        go()
    end
end

LrTasks.startAsyncTask( function()

    LrFunctionContext.callWithContext( 'socket_remote', function( context )
        -- add an observer for develop param changes
        LrDevelopController.addAdjustmentChangeObserver( context, PARAM_OBSERVER, sendChangedParams )
        while true do
            LrTasks.sleep( 1/5 )
        end
    end )

end )


return { go = go }