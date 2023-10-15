local settings = {};

--[[

      ..-'''-.                     
     \.-'''\ \    __  __   ___    
     _.._    | |  |  |/  `.'   `.  
   .' .._|__/ /   |   .-.  .-.   ' 
   | '   |_  '.   |  |  |  |  |  | 
 __| |__    `.  \ |  |  |  |  |  | 
|__   __|     \ '.|  |  |  |  |  | 
   | |         , ||  |  |  |  |  | 
   | |         | ||__|  |__|  |__| 
   | |        / ,'                 
   | |-....--'  /                  
   |_|`.. __..-'     
   
   F3M - F3MANAGER
   
   Thank you for using F3M to manage your in-game moderation through Discord.
   You must input the F3M Key that was sent to the server owner's direct messages, if you dont have the key, please run the
   '/getf3mkey' in a channel where the bot can access it.
   
   ! DISCLAIMER:
   *** DO NOT LEAK ANY OF YOUR API KEYS, OR YOUR F3M KEY! F3M IS NOT RESPONSIBLE FOR UNAUTHORISED USAGE ***
   
   Please make sure to assign your F3M Key to the 'F3M Key' between the brackets below. (otherwise it will not function)
]]

settings["F3M Key"] = "PUT YOUR KEY HERE!"
settings["Moderation Message"] = 'F3M: You were disconnected from the server. ($HOUR:$MINUTE $DAY/$MONTH/$YEAR) "$REASON"'

--[[

Extra parameters:

$REASON - Display the action reason
$AUTHOR - Display the action author (wip)
$HOUR - Hour of the action
$MINUTE -  Minute of the action
$SECOND - Second of the action
$YEAR - Year of the action
$MONTH - Month of the action
$DAY - Day of the action

]]


--// EXPERIENCED PROGRAMMERS AHEAD! DO NOT CHANGE ANYTHING !

local MessagingService = game:GetService("MessagingService");
local HttpService = game:GetService("HttpService");
local Players = game:GetService("Players");
local Called = false;

local Commands = {
	kick = function(...)
		local Args = {...}
		local Data = Args[1]
		local Username = Data.username; -- Disregard the warnings
		local Reason = Data.reason;
		local Author = Data.author or 'N/A'
		
		print('Kicking user ' .. Username .. ' with the reason: ' .. Reason);
		
		for _,Player in pairs(Players:GetPlayers()) do
			if Player.Name:lower() == Username:lower() then
				local T = os.date("!*t")
				local Msg = settings["Moderation Message"]
					:gsub('$REASON', Reason)
					:gsub('$HOUR', T.hour)
					:gsub('$MINUTE', T.min)
					:gsub('$SECOND', T.sec)
					:gsub('$YEAR', T.year)
					:gsub('$MONTH', T.month)
					:gsub('$DAY', T.day)
				Player:Kick(Msg);
				print('Kicked ' .. Username);
				break;
			end
		end
	end,
}

function main(Settings): ()
	if Called then return end;
	Called = true;

	-- Init

	MessagingService:SubscribeAsync("f3mNetwork", function(d, Time)
		local Data = HttpService:JSONDecode(d.Data) or 'N/A'
		
		if Data ~= nil then
			local Command = Data.command
			
			if Commands[Command] then
				Commands[Command](Data.data)
			end
		end
	end)
end

main(settings);
