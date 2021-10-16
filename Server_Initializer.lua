# Server_Initializer-Archived
10/05/21 | 5 October 2021, Archived.

----------------------------------------------
--// SERVERSCRIPT - Server_Initializer
--// MADE IN CHINA
----------------------------------------------

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

function CreateNewInstance(class, parent, name)
	local int = Instance.new(class, parent)
	int.Name = name
end

--// SERVER DATA
local Data = {}
Data.Storage = nil
Data.Events = nil
	Data.RemoteEvents = nil
	Data.RE_Events = nil

	Data.RemoteFunctions = nil
	Data.RF_Events = nil

Data.Modules = nil
Data.Resources = nil
Data.PlayerData = nil

--// Initializing Server
Data.Storage = CreateNewInstance("Folder", ReplicatedStorage, "Storage") --// create storage in rep

-- VVV --
Data.Events = CreateNewInstance("Folder", Data.Storage, "CommunicationEvents") --// create events storage

Data.RemoteEvents = CreateNewInstance("Folder", Data.Events, "RemoteEvents")
Data.RE_Events = CreateNewInstance("Folder", Data.RemoteEvents, "Events")

Data.RemoteFunctions = CreateNewInstance("Folder", Data.Events, "RemoteFunctions")
Data.RF_Events = CreateNewInstance("Folder", Data.RemoteFunctions, "Events")
--------

Data.Modules = CreateNewInstance("Folder", Data.Storage, "Modules") --// create module folder
Data.Resources = CreateNewInstance("Folder",	Data.Storage, "Resources") --// create resource folder

--// container

Players.PlayerAdded:Connect(function(Player)
	
	--// save data	
	Data.PlayerData = CreateNewInstance("Folder", Player, "PlayerData") --// create storage in rep
	local playerfps = CreateNewInstance("NumberValue", Data.PlayerData, "FramePerSeconds")
	
	--// data in player
	--// example:
	local playtime = CreateNewInstance("NumberValue", Data.PlayerData, "Playtime")
	task.spawn(function()
		repeat wait(1)
			playtime.Value += 1
		until Player == nil
	end)
	
	Player.CharacterAdded:Connect(function(Character)
		
		--// ehhh idk
		
	end)
end)
--// Create Events
task.spawn(function(CREATE_EVENTS)
	CreateNewInstance("RemoteEvent", Data.RemoteEvents, "CheckFrame")	
end)

--// Events Receiver
task.spawn(function(EVENTS_RECEIVER)
	for _,event in pairs(Data.Events:GetDescendants()) do
		if event:IsA("RemoteEvent") then
			event.OnServerEvent:Connect(function(player, value)
				if event.Name == "RemoteEvent" then
					--// do something
				elseif event.Name == "CheckFrame" then --// example
					local fps = player:WaitForChild("FramePerSeconds")
					if fps.Value <= 200 then
						print("you're lookin real sussy over there")
					else
						fps.Value = value
					end					
				else
					warn("unregistered remoteevent fired.")
				end			
			end)
		elseif event:IsA("RemoteFunction") then
			event.OnServerInvoke:Connect(function()
				if event.Name == "RemoteFunction" then
					--// do something
				else
					warn("unregistered remotefunction invoke")
				end
			end)
		end
		wait(0.1)
	end
end)
