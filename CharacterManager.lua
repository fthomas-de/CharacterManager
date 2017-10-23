local version = GetAddOnMetadata("CharacterManager", "version");
local pname = UnitName("player");
local _, pclass = UnitClass("player");
local prealm = GetRealmName()
local plevel = UnitLevel("player");
local LA = LibStub:GetLibrary("LegionArtifacts-1.1")
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
local week = 604800;
local na_reset  = 1486479600;
local eu_reset  = 1485327600;

local dungeons = {"Darkheart Thicket-DHT", "Das Finsterherzdickicht-DHT", "Eye of Azshara-EoA", "Das Auge Azsharas-EoA", "Halls of Valor-HoV", "Die Hallen der Tapferkeit-HoV", "Neltharion's Lair-NL", "Neltharion's Hort-NL", "Neltharion's Lair-NL", "Black Rook Hold-BRH", "Die Rabenwehr-BRH", "Maw of Souls-MoS", "Der Seelenschlund-MoS", "Vault of the Wardens-VotW", "Das Verließ der Wächterinnen-VotW", "Return to Karazhan: Lower-LK", "Untere Rückkehr nach Karazhan-LK", "Return to Karazhan: Upper-UK", "Obere Rückkehr nach Karazhan-UK", "Cathedral of Eternal Night-CoeN", "Kathedrale der Ewigen Nacht-CoeN", "Court of Stars-CoS", "Der Hof der Sterne-CoS", "The Arcway-TA", "Der Arkus-TA", "Seat of the Triumvirate-SotT", "Sitz des Triumvirats-SotT"};
local world_quest_one_shot = {"DEATHKNIGHT", "DEMONHUNTER", "MAGE", "PALADIN", "WARLOCK", "WARRIOR"};
local world_quest_one_shot_ids = {["DEATHKNIGHT"]=221557, ["DEMONHUNTER"]=221561, ["MAGE"]=221602, ["PALADIN"]=221587, ["WARLOCK"]=219540, ["WARRIOR"]=221597};

local option_choices = {"Mythic+ Info", "Artifact level (AK)", "AK research", "Current seals", "Seals obtained", "Itemlevel", "OResources", "EN ID", "ToV ID", "NH ID", "ToS ID", "WQ 1shot", "Emissary Chests", "Minimap Icon"};

local window_shown = false;
local options_shown = false;
local mplus_shown = false;

local colors = {
    ["DEATHKNIGHT"] = "|cffC41F3B",
    ["Death Knight"] = "|cffC41F3B",
    ["DEMONHUNTER"] = "|cffA330C9",
    ["Demon Hunter"] = "|cffA330C9",
    ["DRUID"]   = "|cffFF7D0A",
    ["Druid"]   = "|cffFF7D0A",
    ["HUNTER"]  = "|cffABD473",
    ["Hunter"]  = "|cffABD473",
    ["MAGE"]    = "|cff69CCF0",
    ["Mage"]    = "|cff69CCF0",
    ["MONK"]    = "|cff00FF96",
    ["Monk"]    = "|cff00FF96",
    ["PALADIN"] = "|cffF58CBA",
    ["Paladin"] = "|cffF58CBA",
    ["PRIEST"]  = "|cffffffff",
    ["Priest"]  = "|cffffffff",
    ["ROGUE"]   = "|cffFFF569",
    ["Rogue"]   = "|cffFFF569",
    ["SHAMAN"]  = "|cff0070DE",
    ["Shaman"]  = "|cff0070DE",
    ["WARLOCK"] = "|cff9482C9",
    ["Warlock"] = "|cff9482C9",
    ["WARRIOR"] = "|cffC79C6E",
    ["Warrior"] = "|cffC79C6E",
    ["GOLD"] = "|cffffcc00",
    ["RED"] = "|cffff0000",
    ["UNKNOWN"]  = "|cffffffff",
    ["GREEN"] = "|cff00ff00",
    ["WHITE"] = "|cffffffff",
    ["DEPLETED"] = "|cff9d9d9d",
    ["GREY"] = "|cff888888",
};

local classes = {
    ["DEATHKNIGHT"] = "Death Knight",
    ["DEMONHUNTER"] = "Demon Hunter",
    ["DRUID"]   = "Druid",
    ["HUNTER"]  = "Hunter",
    ["MAGE"]    = "Mage",
    ["MONK"]    = "Monk",
    ["PALADIN"] = "Paladin",
    ["PRIEST"]  = "Priest",
    ["ROGUE"]   = "Rogue",
    ["SHAMAN"]  = "Shaman",
    ["WARLOCK"] = "Warlock",
    ["WARRIOR"] = "Warrior",
};


-- LIGHTRED             |cffff6060
-- LIGHTBLUE           |cff00ccff
-- TORQUISEBLUE	 |cff00C78C
-- SPRINGGREEN	  |cff00FF7F
-- GREENYELLOW    |cffADFF2F
-- BLUE                 |cff0000ff
-- PURPLE		    |cffDA70D6
-- GOLD            |cffffcc00
-- GOLD2			|cffFFC125
-- SUBWHITE        |cffbbbbbb
-- MAGENTA         |cffff00ff
-- YELLOW          |cffffff00
-- ORANGEY		    |cffFF4500
-- CHOCOLATE		|cffCD661D
-- CYAN            |cff00ffff
-- IVORY			|cff8B8B83
-- LIGHTYELLOW	    |cffFFFFE0
-- SEXGREEN		|cff71C671
-- SEXTEAL		    |cff388E8E
-- SEXPINK		    |cffC67171
-- SEXBLUE		    |cff00E5EE
-- SEXHOTPINK	    |cffFF6EB4

local months = {
	[1] = 31,
	[2] = 28,
	[3] = 31,
	[4] = 30,
	[5] = 31,
	[6] = 30,
	[7] = 31,
	[8] = 31,
	[9] = 30,
	[10] = 31,
	[11] = 30,
	[12] = 31,
};

-------------------------------------------------------------------------------------
local addon = LibStub("AceAddon-3.0"):NewAddon("CharacterManager", "AceConsole-3.0")
local eoscmLDB = LibStub("LibDataBroker-1.1"):NewDataObject("eoscm_minimap", {
	type = "data source",
	text = "you_selected_the_wrong_data_broker_look_for_Eoh's CharacterManager",
	icon = "Interface\\AddOns\\CharacterManager\\Icon\\CharacterManager",
	OnClick = function() show_window() end,
	OnTooltipShow = function(tt)
		tt:AddLine("Eoh's CharacterManager");
		tt:AddLine(colors["WHITE"] .. "Click|r to open Eoh's CharacterManager");
		tt:AddLine(colors["WHITE"] .. "Click and hold|r to drag the icon");
	end,
})
local icon = LibStub("LibDBIcon-1.0")


function addon:OnInitialize()
	-- Obviously you'll need a ## SavedVariables: BunniesDB line in your TOC, duh!
	self.db = LibStub("AceDB-3.0"):New("_EOSCM_DB_", {
		profile = {
			minimap = {
				hide = false,
			},
		},
	})
	icon:Register("eoscm_minimap", eoscmLDB, self.db.profile.minimap)
	self:RegisterChatCommand("hidemm", "HideMiniMap")
end


function addon:HideMiniMap()
	self.db.profile.minimap.hide = not self.db.profile.minimap.hide
	if self.db.profile.minimap.hide then
		icon:Hide("eoscm_minimap")
	else
		icon:Show("eoscm_minimap")
	end
end


local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
local dataobj = ldb:NewDataObject("Eoh's CharacterManager", {
	type = "data source",
	icon = "Interface\\AddOns\\CharacterManager\\Icon\\CharacterManager",
	text = "-",
	OnClick = function() show_window() end,
	OnTooltipShow = function(tt) 
		tt:AddLine(colors["WHITE"] .. "Eoh's CharacterManager " .. version .. "|r");
		tt:AddLine(" ");
		tt:AddLine(build_content()); 
	end,
})
dataobj.text = "CharacterManager";


-------------------------------------------------------------------------------------


-- main
cm_frame = CreateFrame("FRAME", "CharacterManager", UIParent, "BasicFrameTemplateWithInset"); -- Need a frame to respond to events
cm_frame:RegisterEvent("ADDON_LOADED");
cm_frame:RegisterEvent("ARTIFACT_UPDATE");
cm_frame:RegisterEvent("PLAYER_ENTERING_WORLD");
cm_frame:RegisterEvent("PLAYER_LOGOUT");
cm_frame:RegisterEvent("QUEST_FINISHED");
cm_frame:RegisterEvent("CHAT_MSG_ADDON");
cm_frame:RegisterEvent("UNIT_INVENTORY_CHANGED");
cm_frame:RegisterEvent("CHALLENGE_MODE_COMPLETED")
reg_ping = RegisterAddonMessagePrefix("eoscm-ping")
reg_update = RegisterAddonMessagePrefix("eoscm-update")
if not reg_ping or not reg_update then
	print("[eoscm] The M+ key synchronization might not work, try reloading :(")
end

function cm_frame:OnEvent(event, name, message, channel, sender)
	if event == "ADDON_LOADED" then
		if name == "CharacterManager" then
	 		DEFAULT_CHAT_FRAME:AddMessage(colors["GOLD"] .. "CharacterManager " .. version .. " loaded!");
	 		
	 		cm_frame:UnregisterEvent("ADDON_LOADED");

		 	-- init globals
		 	if _DB_ == nil then
		 		_DB_ = {};
		 	end

		 	if _NAMES_ == nil then
		 		_NAMES_ = {};
		 	end

		  	if _NEXT_RESET_ == nil then
		 		_NEXT_RESET_ = 0;
		 	end

		 	if _OPTIONS_ == nil then
		 		_OPTIONS_ = {
					["Mythic+ Info"] = true, 
					["Artifact level (AK)"] = true, 
					["AK research"] = true, 
					["Current seals"] = true, 
					["Seals obtained"] = true, 
					["Itemlevel"] = true, 
					["OResources"] = true, 
					["EN ID"] = true,
					["ToV ID"] = true,
					["Nighthold ID"] = true,
					["WQ 1shot"] = true,
					["Emissary Chests"] = true,
				};
			end

			if _TRACKED_CHARS_ == nil then
		 		_TRACKED_CHARS_ = {};

		 		for _, item in ipairs(_NAMES_) do 
		 			if _TRACKED_CHARS_[item] == nil then
		 				_TRACKED_CHARS_[item] = true;
		 			end
		 		end
		 	end

		 	-- init name
		 	if not contains(_NAMES_, pname) then 
		 		table.insert(_NAMES_, pname);
		 	end

		 	if _TRACKED_CHARS_[pname] == nil then 
		 		_TRACKED_CHARS_[pname] = true;
		 	end

		 	-- init class
		 	if not _DB_[pname.."cls"] then 
		 		_DB_[pname.."cls"] = pclass;
		 	end

		 	if _DB_[pname.."cls"] == "" or _DB_[pname.."cls"] == "UNKNOWN" then 
		 		_DB_[pname.."cls"] = pclass;
		 	end

		 	local options_checked = 0;
		 	for idx, item in ipairs(option_choices) do
		 		if _OPTIONS_[option_choices[idx]] then 
		 			options_checked = options_checked + 1;
		 		end
		 	end

		 	local tracked_chars = 0;
			for idx, item in ipairs(_NAMES_) do
				if _TRACKED_CHARS_[item] ~= nil and _TRACKED_CHARS_[item] == true then
					tracked_chars = tracked_chars + 1;
				end
			end

			-- main window
			multi = 15
			text = 155
			--print("tracked chars: " .. tracked_chars .. " opt checked: " .. options_checked)
		 	cm_frame:SetSize(300, text + (tracked_chars * (multi * options_checked)));
			cm_frame:SetPoint("CENTER", UIParent, "CENTER");
			cm_frame:EnableMouse(true);
			cm_frame:SetMovable(true);
			cm_frame:RegisterForDrag("LeftButton");
			cm_frame:SetScript("OnDragStart", cm_frame.StartMoving);
			cm_frame:SetScript("OnDragStop", cm_frame.StopMovingOrSizing);

			cm_frame.title = cm_frame:CreateFontString();
			cm_frame.title:SetFontObject("GameFontHighlight");
			cm_frame.title:SetPoint("LEFT", cm_frame.TitleBg, "LEFT", 5, 0);
			cm_frame.title:SetText("Eoh's CharacterManager - v" .. version);

			cm_frame.options_button = CreateFrame("Button", "options_button", cm_frame, "GameMenuButtonTemplate");
			cm_frame.options_button:SetPoint("BOTTOMRIGHT", cm_frame, "BOTTOMRIGHT", -12, 10);
			cm_frame.options_button:SetSize(70, 25);
			cm_frame.options_button:SetText("config");
			cm_frame.options_button:SetNormalFontObject("GameFontNormalLarge");
			cm_frame.options_button:SetHighlightFontObject("GameFontHighlightLarge");
			cm_frame.options_button:Hide();
			cm_frame.options_button:SetScript("OnClick", toggle_options_window);

			cm_frame.mplus_button = CreateFrame("Button", "mplus_button", cm_frame, "GameMenuButtonTemplate");
			cm_frame.mplus_button:SetPoint("TOPLEFT", cm_frame, "TOPLEFT", 10, -30);
			cm_frame.mplus_button:SetSize(40, 25);
			cm_frame.mplus_button:SetText("m+");
			cm_frame.mplus_button:SetNormalFontObject("GameFontNormalLarge");
			cm_frame.mplus_button:SetHighlightFontObject("GameFontHighlightLarge");
			cm_frame.mplus_button:Hide();
			cm_frame.mplus_button:SetScript("OnClick", toggle_mplus_window);

			cm_frame.reload_button = CreateFrame("Button", "reload_button", cm_frame, "GameMenuButtonTemplate");
			cm_frame.reload_button:SetPoint("BOTTOMLEFT", cm_frame, "BOTTOMLEFT", 10, 10);
			cm_frame.reload_button:SetSize(70, 25);
			cm_frame.reload_button:SetText("/reload");
			cm_frame.reload_button:SetNormalFontObject("GameFontNormalLarge");
			cm_frame.reload_button:SetHighlightFontObject("GameFontHighlightLarge");
			cm_frame.reload_button:Hide();
			cm_frame.reload_button:SetScript("OnClick", ReloadUI);

			cm_frame.content = cm_frame:CreateFontString("CM_CONTENT");
			cm_frame.content:SetPoint("CENTER");
			cm_frame.content:SetFontObject("GameFontHighlight");

			--cm_frame:SetScript("OnEvent", function(self)
		    --	self.content:SetText(build_content())
			--end)

			cm_frame:Hide();
		 	
		 	init();
		 	updates();
	 	end
	elseif event == "CHAT_MSG_ADDON" then
		if name == "eoscm-ping" and message == "ping" and (channel == "GUILD" or channel == "PARTY" or channel == "WHISPER") then
			--print("ping received from " .. sender .. " via " .. channel);
			answer_ping(channel, sender);

		elseif name == "eoscm-update" then
			--print("received key update from " .. sender .. ": " .. message);

			-- other server
			if contains(_MPLUS_BUDDIES_, sender) then
				--print("allrdy known (not my server): " .. sender);
				_MPLUS_KEYS_[sender] = message;
			else
			-- my server 
				for _, buddy in ipairs(_MPLUS_BUDDIES_) do
					if string.find(sender, buddy) then
						--print("allrdy known (my server): " .. buddy);
						_MPLUS_KEYS_[buddy] = message;
					end
				end
			end			
		end
		if self.mplus_frame then 
			self.mplus_frame.mplus_content:SetText(mplus_listing());
		end
	else 
	 	updates();
	 	self.content:SetText(build_content());
	 	if cm_frame.mplus_frame then
	 		self.mplus_frame.mplus_content:SetText(mplus_listing());
	 	end
	end
end
cm_frame:SetScript("OnEvent", cm_frame.OnEvent);


--slash commands
SLASH_CM1 = "/eoscm";
function SlashCmdList.CM(msg)
	--print(msg);
	if msg == "reset" then
		complete_reset();

	elseif string.match(msg, "rm") then 
		if remove_character(msg) then 
			ReloadUI();
		end 

	elseif string.match(msg, "rbud") then 
		remove_buddy(msg);
		-- ReloadUI();

	elseif msg == "weekly" then 
		weekly_reset(msg);
		ReloadUI();

	elseif msg == "debug" then
		debug();

	else
		show_window();
	end
end


-- init values
function init()
	-- init name
	if not contains(_NAMES_, pname)  then 
		table.insert(_NAMES_, pname);
	end

	if _NAMES_ == nil then
		_NAMES_ = {};
	end

	if _MPLUS_BUDDIES_ == nil then
		_MPLUS_BUDDIES_ = {};
	end

	if _MPLUS_KEYS_ == nil then
		_MPLUS_KEYS_ = {};
	end

	if _MPLUS_CLASS_ == nil then
		_MPLUS_CLASS_ = {};
	end

	for _, char_name in ipairs(_NAMES_) do 
		-- init vars
	 	if not _DB_[char_name .. "cls"] then
	 		_DB_[char_name .. "cls"] = "UNKNOWN";
	 	end

	 	if not _DB_[char_name .. "level"] then
	 		_DB_[char_name .. "level"] = 0;
	 	end

	 	if not _DB_[char_name .. "artifactlevel"] then
	 		_DB_[char_name .. "artifactlevel"] = 0;
	 	end

	 	if not _DB_[char_name .. "hkey"] then
	 		_DB_[char_name .. "hkey"] = 0;
	 	end

	 	if not _DB_[char_name .. "bagkey"] then
	 		_DB_[char_name .. "bagkey"] = "no key";
	 	end     

	 	if not _DB_[char_name .. "seals"] then
	 		_DB_[char_name .. "seals"] = 0;
	 	end

	 	if not _DB_[char_name .. "itemlevel"] then
	 		_DB_[char_name .. "itemlevel"] = 0;
	 	end

	 	if not _DB_[char_name .. "itemlevelbag"] then
	 		_DB_[char_name .. "itemlevelbag"] = 0;
	 	end

	 	if not _DB_[char_name .. "orderres"] then
	 		_DB_[char_name .. "orderres"] = 0;
	 	end

	 	if not _DB_[char_name .. "akremain"] then
	 		_DB_[char_name .. "akremain"] = "0 0 0 0";
	 	end

	 	if not _DB_[char_name .. "nhraidid"] then
	 		_DB_[char_name .. "nhraidid"] = "?";
	 	end

	 	if not _DB_[char_name .. "enraidid"] then
	 		_DB_[char_name .. "enraidid"] = "?";
	 	end

	 	if not _DB_[char_name .. "tovraidid"] then
	 		_DB_[char_name .. "tovraidid"] = "?";
	 	end

	 	if not _DB_[char_name .. "tosraidid"] then
	 		_DB_[char_name .. "tosraidid"] = "?";
	 	end

	 	if not _DB_[char_name .. "wqoneshot"] then
	 		_DB_[char_name .. "wqoneshot"] = -1;
	 	end

	 	if not _DB_[pname.."emissary"] then
	 		_DB_[pname.."emissary"] = 0;
	 	end

	  	if not _DB_[pname.."emissary_date"] then
	 		_DB_[pname.."emissary_date"] = 0;
	 	end
	 end
end


-- windows
function init_options_window()
	local chars = 0;
	for idx, item in ipairs(_NAMES_) do
		if _NAMES_[item] ~= nil and _NAMES_[item] == true then
			chars = chars + 1;
		end
	end

	cm_frame.options_frame = CreateFrame("FRAME", "CharacterManagerOptions", cm_frame, "BasicFrameTemplateWithInset");
 	cm_frame.options_frame:SetSize(250, (50 * table.getn(option_choices) + 55 + 45 * chars));
	cm_frame.options_frame:SetPoint("TOPLEFT", cm_frame, "TOPRIGHT");
	cm_frame.options_frame:SetScript("OnHide", hide_options);

	local retarded_space_solutions_ltd = "                                    ";

	cm_frame.options_frame.button1 = CreateFrame("CheckButton", option_choices[1], cm_frame.options_frame, "UICheckButtonTemplate")
	cm_frame.options_frame.button1:SetPoint("CENTER", cm_frame.options_frame, "TOP", -55, -65);
	cm_frame.options_frame.button1:SetText(retarded_space_solutions_ltd .. option_choices[1]);
	cm_frame.options_frame.button1:SetNormalFontObject("GameFontNormalLarge");
	if _OPTIONS_[option_choices[1]] then
		cm_frame.options_frame.button1:Click();
	end
	cm_frame.options_frame.button1:SetScript("OnClick", function(self)
		_OPTIONS_[self:GetName()] = self:GetChecked();
	end)


	cm_frame.options_frame.button2 = CreateFrame("CheckButton", option_choices[2], cm_frame.options_frame, "UICheckButtonTemplate")
	cm_frame.options_frame.button2:SetPoint("TOP", cm_frame.options_frame.button1, "BOTTOM");
	cm_frame.options_frame.button2:SetText(retarded_space_solutions_ltd .. option_choices[2]);
	cm_frame.options_frame.button2:SetNormalFontObject("GameFontNormalLarge");
	if _OPTIONS_[option_choices[2]] then
		cm_frame.options_frame.button2:Click();
	end
	cm_frame.options_frame.button2:SetScript("OnClick", function(self)
		_OPTIONS_[self:GetName()] = self:GetChecked();
	end)	


	cm_frame.options_frame.button3 = CreateFrame("CheckButton", option_choices[3], cm_frame.options_frame, "UICheckButtonTemplate")
	cm_frame.options_frame.button3:SetPoint("TOP", cm_frame.options_frame.button2, "BOTTOM");
	cm_frame.options_frame.button3:SetText(retarded_space_solutions_ltd .. option_choices[3]);
	cm_frame.options_frame.button3:SetNormalFontObject("GameFontNormalLarge");
	if _OPTIONS_[option_choices[3]] then
		cm_frame.options_frame.button3:Click();
	end
	cm_frame.options_frame.button3:SetScript("OnClick", function(self)
		_OPTIONS_[self:GetName()] = self:GetChecked();
	end)
	

	cm_frame.options_frame.button4 = CreateFrame("CheckButton", option_choices[4], cm_frame.options_frame, "UICheckButtonTemplate")
	cm_frame.options_frame.button4:SetPoint("TOP", cm_frame.options_frame.button3, "BOTTOM");
	cm_frame.options_frame.button4:SetText(retarded_space_solutions_ltd .. option_choices[4]);
	cm_frame.options_frame.button4:SetNormalFontObject("GameFontNormalLarge");
	if _OPTIONS_[option_choices[4]] then
		cm_frame.options_frame.button4:Click();
	end
	cm_frame.options_frame.button4:SetScript("OnClick", function(self)
		_OPTIONS_[self:GetName()] = self:GetChecked();
	end)
	

	cm_frame.options_frame.button5 = CreateFrame("CheckButton", option_choices[5], cm_frame.options_frame, "UICheckButtonTemplate")
	cm_frame.options_frame.button5:SetPoint("TOP", cm_frame.options_frame.button4, "BOTTOM");
	cm_frame.options_frame.button5:SetText(retarded_space_solutions_ltd .. option_choices[5]);
	cm_frame.options_frame.button5:SetNormalFontObject("GameFontNormalLarge");
	if _OPTIONS_[option_choices[5]] then
		cm_frame.options_frame.button5:Click();
	end
	cm_frame.options_frame.button5:SetScript("OnClick", function(self)
		_OPTIONS_[self:GetName()] = self:GetChecked();
	end)
	

	cm_frame.options_frame.button6 = CreateFrame("CheckButton", option_choices[6], cm_frame.options_frame, "UICheckButtonTemplate")
	cm_frame.options_frame.button6:SetPoint("TOP", cm_frame.options_frame.button5, "BOTTOM");
	cm_frame.options_frame.button6:SetText(retarded_space_solutions_ltd .. option_choices[6]);
	cm_frame.options_frame.button6:SetNormalFontObject("GameFontNormalLarge");
	if _OPTIONS_[option_choices[6]] then
		cm_frame.options_frame.button6:Click();
	end
	cm_frame.options_frame.button6:SetScript("OnClick", function(self)
		_OPTIONS_[self:GetName()] = self:GetChecked();
	end)
	

	cm_frame.options_frame.button7 = CreateFrame("CheckButton", option_choices[7], cm_frame.options_frame, "UICheckButtonTemplate")
	cm_frame.options_frame.button7:SetPoint("TOP", cm_frame.options_frame.button6, "BOTTOM");
	cm_frame.options_frame.button7:SetText(retarded_space_solutions_ltd .. option_choices[7]);
	cm_frame.options_frame.button7:SetNormalFontObject("GameFontNormalLarge");
	if _OPTIONS_[option_choices[7]] then
		cm_frame.options_frame.button7:Click();
	end
	cm_frame.options_frame.button7:SetScript("OnClick", function(self)
		_OPTIONS_[self:GetName()] = self:GetChecked();
	end)
	

	cm_frame.options_frame.button8 = CreateFrame("CheckButton", option_choices[8], cm_frame.options_frame, "UICheckButtonTemplate")
	cm_frame.options_frame.button8:SetPoint("TOP", cm_frame.options_frame.button7, "BOTTOM");
	cm_frame.options_frame.button8:SetText(retarded_space_solutions_ltd .. option_choices[8]);
	cm_frame.options_frame.button8:SetNormalFontObject("GameFontNormalLarge");
	if _OPTIONS_[option_choices[8]] then
		cm_frame.options_frame.button8:Click();
	end
	cm_frame.options_frame.button8:SetScript("OnClick", function(self)
		_OPTIONS_[self:GetName()] = self:GetChecked();
	end)


	cm_frame.options_frame.button9 = CreateFrame("CheckButton", option_choices[9], cm_frame.options_frame, "UICheckButtonTemplate")
	cm_frame.options_frame.button9:SetPoint("TOP", cm_frame.options_frame.button8, "BOTTOM");
	cm_frame.options_frame.button9:SetText(retarded_space_solutions_ltd .. option_choices[9]);
	cm_frame.options_frame.button9:SetNormalFontObject("GameFontNormalLarge");
	if _OPTIONS_[option_choices[9]] then
		cm_frame.options_frame.button9:Click();
	end
	cm_frame.options_frame.button9:SetScript("OnClick", function(self)
		_OPTIONS_[self:GetName()] = self:GetChecked();
	end)


	cm_frame.options_frame.button10 = CreateFrame("CheckButton", option_choices[10], cm_frame.options_frame, "UICheckButtonTemplate")
	cm_frame.options_frame.button10:SetPoint("TOP", cm_frame.options_frame.button9, "BOTTOM");
	cm_frame.options_frame.button10:SetText(retarded_space_solutions_ltd .. option_choices[10]);
	cm_frame.options_frame.button10:SetNormalFontObject("GameFontNormalLarge");
	if _OPTIONS_[option_choices[10]] then
		cm_frame.options_frame.button10:Click();
	end
	cm_frame.options_frame.button10:SetScript("OnClick", function(self)
		_OPTIONS_[self:GetName()] = self:GetChecked();
	end)

	cm_frame.options_frame.button11 = CreateFrame("CheckButton", option_choices[11], cm_frame.options_frame, "UICheckButtonTemplate")
	cm_frame.options_frame.button11:SetPoint("TOP", cm_frame.options_frame.button10, "BOTTOM");
	cm_frame.options_frame.button11:SetText(retarded_space_solutions_ltd .. option_choices[11]);
	cm_frame.options_frame.button11:SetNormalFontObject("GameFontNormalLarge");
	if _OPTIONS_[option_choices[11]] then
		cm_frame.options_frame.button11:Click();
	end
	cm_frame.options_frame.button11:SetScript("OnClick", function(self)
		_OPTIONS_[self:GetName()] = self:GetChecked();
	end)

	cm_frame.options_frame.button12 = CreateFrame("CheckButton", option_choices[12], cm_frame.options_frame, "UICheckButtonTemplate")
	cm_frame.options_frame.button12:SetPoint("TOP", cm_frame.options_frame.button11, "BOTTOM");
	cm_frame.options_frame.button12:SetText(retarded_space_solutions_ltd .. option_choices[12]);
	cm_frame.options_frame.button12:SetNormalFontObject("GameFontNormalLarge");
	if _OPTIONS_[option_choices[12]] then
		cm_frame.options_frame.button12:Click();
	end
	cm_frame.options_frame.button12:SetScript("OnClick", function(self)
		_OPTIONS_[self:GetName()] = self:GetChecked();
	end)

	cm_frame.options_frame.button13 = CreateFrame("CheckButton", option_choices[13], cm_frame.options_frame, "UICheckButtonTemplate")
	cm_frame.options_frame.button13:SetPoint("TOP", cm_frame.options_frame.button12, "BOTTOM");
	cm_frame.options_frame.button13:SetText(retarded_space_solutions_ltd .. option_choices[13]);
	cm_frame.options_frame.button13:SetNormalFontObject("GameFontNormalLarge");
	if _OPTIONS_[option_choices[13]] then
		cm_frame.options_frame.button13:Click();
	end
	cm_frame.options_frame.button13:SetScript("OnClick", function(self)
		_OPTIONS_[self:GetName()] = self:GetChecked();
	end)


	local last_button = cm_frame.options_frame.button13;
	for idx, item in ipairs(_NAMES_) do

		if _TRACKED_CHARS_[item] ~= nil then
			cm_frame.options_frame.track_button = CreateFrame("CheckButton", item, cm_frame.options_frame, "UICheckButtonTemplate")
			
			if idx == 1 then
				cm_frame.options_frame.track_button:SetPoint("TOP", last_button, "BOTTOM", 0, -35);
			else
				cm_frame.options_frame.track_button:SetPoint("TOP", last_button, "BOTTOM");
			end
			last_button = cm_frame.options_frame.track_button;

			cm_frame.options_frame.track_button:SetText(retarded_space_solutions_ltd .. item);
			cm_frame.options_frame.track_button:SetNormalFontObject("GameFontNormalLarge");
			if _TRACKED_CHARS_[item] then
				cm_frame.options_frame.track_button:Click();
			end

			cm_frame.options_frame.track_button:SetScript("OnClick", function(self)
				_TRACKED_CHARS_[self:GetName()] = self:GetChecked();

			end)
		end
	end


	cm_frame.options_frame.weekly_button = CreateFrame("Button", "weekly_button", cm_frame.options_frame, "GameMenuButtonTemplate");
	cm_frame.options_frame.weekly_button:SetPoint("BOTTOMLEFT", cm_frame.options_frame, "BOTTOMLEFT", 10, 10);
	cm_frame.options_frame.weekly_button:SetSize(70, 25);
	cm_frame.options_frame.weekly_button:SetText("/weekly");
	cm_frame.options_frame.weekly_button:SetNormalFontObject("GameFontNormalLarge");
	cm_frame.options_frame.weekly_button:SetHighlightFontObject("GameFontHighlightLarge")
	cm_frame.options_frame.weekly_button:SetScript("OnClick", weekly);
	cm_frame.options_frame.weekly_button:Hide();

	cm_frame.options_frame.reset_button = CreateFrame("Button", "reset_button", cm_frame.options_frame, "GameMenuButtonTemplate");
	cm_frame.options_frame.reset_button:SetPoint("BOTTOMRIGHT", cm_frame.options_frame, "BOTTOMRIGHT", -10, 10);
	cm_frame.options_frame.reset_button:SetSize(70, 25);
	cm_frame.options_frame.reset_button:SetText("/reset");
	cm_frame.options_frame.reset_button:SetNormalFontObject("GameFontNormalLarge");
	cm_frame.options_frame.reset_button:SetHighlightFontObject("GameFontHighlightLarge");
	cm_frame.options_frame.reset_button:SetScript("OnClick", complete_reset);
	cm_frame.options_frame.reset_button:Hide();
end


function init_mplus_window()
	buddies = 0;

	for _, buddy in ipairs(_MPLUS_BUDDIES_) do
		buddies = buddies + 1;
	end

	cm_frame.mplus_frame = CreateFrame("FRAME", "CharacterManagerMPlus", cm_frame, "BasicFrameTemplateWithInset");
	multi = 45
	text = 125
	if buddies > 4 then 
 		cm_frame.mplus_frame:SetSize(250, multi*buddies+text);
 	else 
 		cm_frame.mplus_frame:SetSize(250, 425);
 	end
	cm_frame.mplus_frame:SetPoint("TOPRIGHT", cm_frame, "TOPLEFT");
	cm_frame.mplus_frame:SetScript("OnHide", hide_options);

	cm_frame.mplus_frame.sync_button = CreateFrame("Button", "sync_button", cm_frame.mplus_frame, "GameMenuButtonTemplate");
	cm_frame.mplus_frame.sync_button:SetPoint("BOTTOMLEFT", cm_frame.mplus_frame, "BOTTOMLEFT", 10, 10);
	cm_frame.mplus_frame.sync_button:SetSize(95, 25);
	cm_frame.mplus_frame.sync_button:SetText("grp to list");
	cm_frame.mplus_frame.sync_button:SetNormalFontObject("GameFontNormalLarge");
	cm_frame.mplus_frame.sync_button:SetHighlightFontObject("GameFontHighlightLarge");
	cm_frame.mplus_frame.sync_button:SetScript("OnClick", sync_group);
	cm_frame.mplus_frame.sync_button:Hide();

	cm_frame.mplus_frame.refresh_button = CreateFrame("Button", "refresh_button", cm_frame.mplus_frame, "GameMenuButtonTemplate");
	cm_frame.mplus_frame.refresh_button:SetPoint("BOTTOMRIGHT", cm_frame.mplus_frame, "BOTTOMRIGHT", -13, 10);
	cm_frame.mplus_frame.refresh_button:SetSize(85, 25);
	cm_frame.mplus_frame.refresh_button:SetText("get keys");
	cm_frame.mplus_frame.refresh_button:SetNormalFontObject("GameFontNormalLarge");
	cm_frame.mplus_frame.refresh_button:SetHighlightFontObject("GameFontHighlightLarge");
	cm_frame.mplus_frame.refresh_button:SetScript("OnClick", ping_mplus);
	cm_frame.mplus_frame.refresh_button:Hide();

	cm_frame.mplus_frame.reset_button = CreateFrame("Button", "reset_button", cm_frame.mplus_frame, "GameMenuButtonTemplate");
	cm_frame.mplus_frame.reset_button:SetPoint("TOPLEFT", cm_frame.mplus_frame, "TOPLEFT", 10, -30);
	cm_frame.mplus_frame.reset_button:SetSize(85, 25);
	cm_frame.mplus_frame.reset_button:SetText("clear list");
	cm_frame.mplus_frame.reset_button:SetNormalFontObject("GameFontNormalLarge");
	cm_frame.mplus_frame.reset_button:SetHighlightFontObject("GameFontHighlightLarge");
	cm_frame.mplus_frame.reset_button:SetScript("OnClick", reset_mplus);
	cm_frame.mplus_frame.reset_button:Hide();

	cm_frame.mplus_frame.mplus_content = cm_frame.mplus_frame:CreateFontString("MPLUS_CONTENT", "OVERLAY");
	cm_frame.mplus_frame.mplus_content:SetPoint("TOP", cm_frame.mplus_frame, "TOP", 0, -75);
	cm_frame.mplus_frame.mplus_content:SetFontObject("GameFontHighlight");
	cm_frame.mplus_frame.mplus_content:SetText(mplus_listing());	
end


-- options window settings
function toggle_options_window()
	if options_shown == false then
		show_options();
	else
		hide_options();
	end
end


function show_options()
	if not cm_frame.options_frame then
		init_options_window();
	end
	options_shown = true;
	cm_frame.options_frame:Show();
	cm_frame.options_frame.weekly_button:Show();
	cm_frame.options_frame.reset_button:Show();
end


function hide_options()
	if not cm_frame.options_frame then
		init_options_window();
	end
	options_shown = false;
	cm_frame.options_frame:Hide();
	cm_frame.options_frame.weekly_button:Hide();
	cm_frame.options_frame.reset_button:Hide();
end


-- mplus window settings
function toggle_mplus_window()
	if mplus_shown == false then
		show_mplus();
	else
		hide_mplus();
	end
end


function show_mplus()
	if not cm_frame.mplus_frame then
		init_mplus_window();
	end
	mplus_shown = true;
	cm_frame.mplus_frame:Show();
	cm_frame.mplus_frame.sync_button:Show();
	cm_frame.mplus_frame.refresh_button:Show();
	cm_frame.mplus_frame.reset_button:Show();
end


function hide_mplus()
	if not cm_frame.mplus_frame then
		mplus_frame();
	end
	mplus_shown = false;
	cm_frame.mplus_frame:Hide();
	cm_frame.mplus_frame.sync_button:Hide();
	cm_frame.mplus_frame.refresh_button:Hide();
	cm_frame.mplus_frame.reset_button:Hide();
end


-- main window settings 
function toogle_window()
	if window_shown == false then
		window_shown = true;
		init();
		updates();
		cm_frame:Show();
		cm_frame.options_button:Show();
		cm_frame.mplus_button:Show();
		cm_frame.reload_button:Show();
	else
		window_shown = false;
		cm_frame:Hide();
		cm_frame.options_button:Hide();
		cm_frame.mplus_button:Hide();
		cm_frame.reload_button:Hide();
	end
end


function show_window()
	window_shown = true;
	init();
	updates();
	cm_frame:Show();
	cm_frame.options_button:Show();
	cm_frame.mplus_button:Show();
	cm_frame.reload_button:Show();
end


-- text window content
function build_content()
	updates();

	local s = "";
	for i=0, table.getn(_NAMES_) do 
		local n = _NAMES_[i];

		if n and _TRACKED_CHARS_[n] then 
			s = s .. colors[_DB_[n.."cls"]] .. n .. " - " .. classes[_DB_[n.."cls"]] .. "|r" .. "\n";

			if _OPTIONS_[option_choices[1]] then
				if tonumber(_DB_[n.."hkey"]) < 10 then
					s = s .. colors["WHITE"] .. "Highest M+: " .. colors["RED"] .. _DB_[n.."hkey"] .. "|r" .. colors["WHITE"] .. " (Bag: " .. _DB_[n.."bagkey"] .. ")|r\n";
				else
					s = s .. colors["WHITE"] .. "Highest M+: " .. _DB_[n.."hkey"] .. " (Bag: " .. _DB_[n.."bagkey"] .. ")|r\n";
				end
			end

			if _OPTIONS_[option_choices[2]] then
				s = s .. colors["WHITE"] .. "Artifact lvl: " .. _DB_[n.."artifactlevel"] .. " (AK: " .. _DB_[n.."level"] .. ")" .. "|r\n";
			end
			
			if _OPTIONS_[option_choices[3]] and _DB_[n.."level"] ~= 40 then
				s = s .. colors["WHITE"] .. "Next AK: " .. target_date_to_time(n) .. "|r\n";
			end

			if _OPTIONS_[option_choices[4]] then
				s = s .. colors["WHITE"] .. "Seals: " .. _DB_[n.."seals"] .. "/6" .. "|r\n";
			end

			if _OPTIONS_[option_choices[5]] then
				if _DB_[n.."sealsobt"] <= 2 then 
					s = s .. colors["WHITE"] .. "Seals obtained: " .. colors["RED"] .. _DB_[n.."sealsobt"].. "|r" .. colors["WHITE"] .. "/3" .. "|r\n";	
				else
					s = s .. colors["WHITE"] .. "Seals obtained: " .. _DB_[n.."sealsobt"] .. "/3" .. "|r\n";	
				end
			end

			if _OPTIONS_[option_choices[6]] then
				s = s .. colors["WHITE"] .. "Itemlevel: " .. _DB_[n.."itemlevel"] .. "/" .. _DB_[n.."itemlevelbag"] .. "|r\n";
			end

			if _OPTIONS_[option_choices[7]] then
				s = s .. colors["WHITE"] .. "OResources: " .. _DB_[n.."orderres"] .. "|r\n";
			end

			if _OPTIONS_[option_choices[8]] then
				--if _DB_[n.."enraidid"] ~= "-" and _DB_[n.."enraidid"] ~= "?" then
					s = s .. colors["WHITE"] .. "Emerald Nightmare: " .. _DB_[n.."enraidid"] .. "|r\n";
				--end
			end

			if _OPTIONS_[option_choices[9]] then
				--if _DB_[n.."tovraidid"] ~= "-" and _DB_[n.."tovraidid"] ~= "?" then
					s = s .. colors["WHITE"] .. "Trials of Valor: " .. _DB_[n.."tovraidid"] .. "|r\n";
				--end
			end

			if _OPTIONS_[option_choices[10]] then
				--if _DB_[n.."nhraidid"] ~= "-" and _DB_[n.."nhraidid"] ~= "?" then
					s = s .. colors["WHITE"] .. "Nighthold: " .. _DB_[n.."nhraidid"] .. "|r\n";
				--end
			end

			if _OPTIONS_[option_choices[11]] then
				--if _DB_[n.."tosraidid"] ~= "-" and _DB_[n.."tosraidid"] ~= "?" then
					s = s .. colors["WHITE"] .. "Tomb of Sargeras: " .. _DB_[n.."tosraidid"] .. "|r\n";
				--end
			end

			if _OPTIONS_[option_choices[12]] then
				local wq_oneshot_time = _DB_[n.."wqoneshot"];
				if wq_oneshot_time == "unknown" then
					s = s .. colors["WHITE"] .. "WQ 1shot CD unknown :(" .. "|r\n";
				elseif _DB_[n.."wqoneshot"] ~= -1 then
					if GetServerTime() >= _DB_[n.."wqoneshot"] then
						s = s .. colors["WHITE"] .. "WQ 1shot: |r" .. colors["GREEN"] .. "UP" .. "|r" .. "|r\n";
					else
						
						s = s .. colors["WHITE"] .. "WQ 1shot in: " .. wq_oneshot_remaining(n) .. "|r\n";
					end
				end
			end

			if _OPTIONS_[option_choices[13]] then
				if _DB_[n .. "emissary"] and _DB_[n .. "emissary_date"] then
					s = s .. colors["WHITE"] .. "Emissary chests (estimated): " .. emissary_string(n) .. "|r\n";
				else
					s = s .. colors["WHITE"] .. "Emissary chests: Unknown :(|r\n";
				end
			end

			if table.getn(_NAMES_) > 1 and i ~= table.getn(_NAMES_) then 
				s = s .. "\n";
			end
		end
	end
	s = s .. "\n\n\n" .. colors["RED"] .. "Open your artifact weapon to force a data refresh." .. "|r" .. "\n";
	s = s .. colors["RED"] .. "This window only resizes after reloads." .. "|r" .. "\n\n";
	s = s .. "Use /hidemm to hide the minimap icon." .. "\n"; 
	return s
end


function mplus_listing()
	s = "";

	for _, buddy in ipairs(_MPLUS_BUDDIES_) do
		if _MPLUS_KEYS_[buddy] then
			s = s .. buddy .. " - " .. colors[_MPLUS_CLASS_[buddy]] .. _MPLUS_CLASS_[buddy] .. "|r" .. "\n" .. _MPLUS_KEYS_[buddy] .. "\n\n"
		else
			s = s .. buddy .. " - " .. colors[_MPLUS_CLASS_[buddy]] .. _MPLUS_CLASS_[buddy] .. "|r" .. "\n" .. "?" .. "\n\n"
		end
	end

	s = s .. "\n\n" .. colors["RED"] .. "Synchronize keys with \nyour m+ grp!\nEveryone needs this addon.\n\nUse '/eoscm rbud NAME'\nto remove a single name.|r"

	return s
end


-- Helper 
function contains(tab, val)
	if tab == nil or val == nil then 
		return false; 
	end

    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end


function tolist(i)
	lst = {};
	for item in i do
		table.insert(lst, item);
	end
	return lst;
end


function find(lst, val)
	for idx, item in ipairs(lst) do
		if item == val then
			return idx;
		end
	end

	return -1;
end


function target_date_to_time(n)
	-- check if u can pick up akr on current char
	local t = C_Garrison.GetLooseShipments(3);
    local i = 1;
    for l = i,#t do 
        local c = C_Garrison.GetLandingPageShipmentInfoByContainerID(C_Garrison.GetLooseShipments(3)[l]);
        if c=="Artifact Research Notes" then 
            i=l;
            break
        end
    end

    if C_Garrison.GetLooseShipments(3)[i] then
	    local _, _, _, shipmentsReady, _, _, _, _ = C_Garrison.GetLandingPageShipmentInfoByContainerID(C_Garrison.GetLooseShipments(3)[i]);

	    if shipmentsReady and shipmentsReady == 1 and n == pname then
	    	return colors["GOLD"] .. "PICK IT UP!" .. "|r";
	    end
	end

	local target_day = 0;
	local target_month = 0;
	local target_hour = 0;
	local target_min = "??";

	if _DB_[n.."akremain"] then
		for idx, item in ipairs(tolist(string.gmatch(_DB_[n.."akremain"], "%S+"))) do -- "d-m-h"
			if idx == 1 then
				target_day = item;

			elseif idx == 2 then
				target_month = item;

			elseif idx == 3 then 
				target_hour = item;

			elseif idx == 4 then
				target_min = item;
			end
		end

		--print("target date: " .. target_day .. "." .. target_month .. "  " .. target_hour .. ":" .. target_min);

		local current_day;
		local current_month;
		local current_hour;
		local current_minute;
		for idx, item in ipairs(tolist(string.gmatch(date("%d %m %H %M"), "%S+"))) do
			if idx == 1 then 
				current_day = tonumber(item);

			elseif idx == 2 then
				current_month = tonumber(item);

			elseif idx == 3 then 
				current_hour = tonumber(item); 

			elseif idx == 4 then
				current_minute = tonumber(item);

			end
		end

		--print("current date: " .. current_day .. "." .. current_month .. "  " .. current_hour .. ":" .. current_minute);

		-- in the past
		-- today
		if tonumber(current_day) == tonumber(target_day) and tonumber(current_hour) > tonumber(target_hour) then
			return colors["GOLD"] .. "PICK IT UP!" .. "|r";

		-- today last update less than 60 mins before
		elseif target_min ~= "??" and tonumber(current_day) == tonumber(target_day) and tonumber(current_hour) == tonumber(target_hour) and tonumber(current_minute) > tonumber(target_min) then
			return colors["GOLD"] .. "PICK IT UP!" .. "|r";

		-- last month
		elseif tonumber(current_month) > tonumber(target_month) then
			return colors["GOLD"] .. "PICK IT UP!" .. "|r";

		-- not today, this month but in the past
		elseif tonumber(current_day) > tonumber(target_day) and tonumber(current_month) == tonumber(target_month) then
			return colors["GOLD"] .. "PICK IT UP!" .. "|r";

		-- not today, but in the future	
		elseif tonumber(current_day) ~= tonumber(target_day) then
			if tostring(target_min) ~= "??" and tonumber(target_min) < 10 then
				target_min = "0" .. target_min;
			end

			if tonumber(current_minute) < 10 then
				current_minute = "0" .. current_minute;
			end

			if tostring(target_min) == "??" then
				return time_diff(current_month, current_day, current_hour, current_minute, target_month, target_day, target_hour, target_min) .. 
				" (" .. target_day .. "." .. target_month .. " around " .. target_hour .. " h)";
			else
				return time_diff(current_month, current_day, current_hour, current_minute, target_month, target_day, target_hour, target_min) .. 
				" (" .. target_day .. "." .. target_month .. " " .. target_hour .. ":" .. target_min .. ")";
			end

		else
			-- same day
			if target_min == "??" then
				target_min = 0;
			end


			local h = tonumber(target_hour) - tonumber(current_hour); -- works cus same day
			local m = tonumber(target_min) - tonumber(current_minute); --  may be negative

			if m < 0 then
				h = h - 1;
				m = m + 60;
			end

			if tonumber(h) > 0 then
				return colors["GOLD"] .. "Today" .. "|r" .. " in " .. h .. " h and " .. m .. " min";
			else
				return colors["GOLD"] .. "Today" .. "|r" .. " in " .. m .. " min";
			end
		end
	else
		return "unknown";
	end
end


function wq_oneshot_remaining(char_name)
	local oneshot_time = _DB_[char_name.."wqoneshot"] - GetServerTime();
	local oneshot_hour = math.floor(oneshot_time / 3600);
	local oneshot_minute = math.floor(math.floor(oneshot_time % 3600) / 60) ;

	if oneshot_hour == 0 then
		return colors["GOLD"] .. oneshot_minute .. " min|r"
	else
		return oneshot_hour .. " h and " .. oneshot_minute .. " min"
	end
end


function count_open_emissary_quests()
	-- wardens, valajar, nightfallen, kirin tor, dreamweaver, highmountain, farondis, argussian, ligths
	local emissary_quest_ids = {42422, 42234, 42421, 43179, 42170, 42233, 42420, 48642, 48639}
	local count = 0;

	local num_entries, num_quests = GetNumQuestLogEntries();
	for i=1,num_entries do
		-- title, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questID, startEvent, displayQuestID, isOnMap, hasLocalPOI, isTask, isStory, isHidden 
		local _, _, _, _, _, _, _, quest_id, _, _, _, _, _, _, _ = GetQuestLogTitle(i);
		if contains(emissary_quest_ids, tonumber(quest_id)) then
			count = count + 1;
		end			
	end
	return count;
end


function emissary_string(name)
	local count = _DB_[name.."emissary"];
	local emissary_date = _DB_[name.."emissary_date"];

	-- was saved checked today
	if GetServerTime() <= emissary_date then
		return count;

	else
		-- wasnt check today
		local one_day = 60 * 60 * 24;
		local two_days = one_day * 2;
		local time_since_save = GetServerTime() - emissary_date;

		if time_since_save > two_days then
			return 3;

		elseif time_since_save > one_day then
			if count >= 1 then
				return 2 + 1;
			
			else 
				return 2;
			end

		else
			if count >= 2 then
				return 1 + 2;
			
			elseif count == 1 then
				return 1 + 1;
			
			else 
				return 1;
			end
		end
	end
	return -1;
end


function time_diff(m1, d1, h1, min1, m2, d2, h2, min2)
	-- 2 is later than 1
	local s = "";

	-- case min2 contains "??"
	-- just days and hr
	if tostring(min2) == "??" then
		-- case same month
		if tonumber(m1) == tonumber(m2) then
			d =  tonumber(d2) - tonumber(d1);
			
			h = tonumber(h2) - tonumber(h1);
			if h < 0 then 
				d = d - 1;
				h = 24 - h1 + h2
			end
			s = s .. d .. " days ";
			s = s .. h .. " h"; 

		-- not the same month
		else
			s = s .. tonumber(d2) + tonumber(months[m1]) - tonumber(d1) .. " days ";
			s = s .. math.abs(tonumber(h2)-tonumber(h1)) .. " h"; 

		end

	-- case d1 == d2 => m1 == m2
	-- just hr and min
	elseif tonumber(d1) == tonumber(d2) then
		local h = tonumber(h2) - tonumber(h1);
		local min = 60 - tonumber(min1) + tonumber(min2);

		if min >= 60 then
			h = h + 1;
			min = min - 60;
		end
		s = s .. tostring(h) .. " h";
		s = s .. tostring(min) .. min;


	else 
		-- different days -- next day i guess
		--print(h1 .. " " .. min1);
		--print(h2 .. " " .. min2);
		local h = 24 - tonumber(h1) + tonumber(h2);

		local min = -1;

		if tonumber(min1) > tonumber(min2) then
			min = 60 - tonumber(min1) + tonumber(min2);
			h = h - 1;

		else
			min = min2 - min1;
		end

		s = s .. tostring(h) .. " h ";
		s = s .. tostring(min) .. " min";  
	end
	
	return s
end


-- mplus
function ping_mplus()
	--print("pinging...")
	SendAddonMessage("eoscm-ping", "ping", "GUILD")
	SendAddonMessage("eoscm-ping", "ping", "PARTY")
end

--/run SendAddonMessage("eoscm-ping", "ping", "WHISPER", "iconqt")
--/run SendAddonMessage("eoscm-ping", "ping", "WHISPER", "Jpzxxraucher-Blackrock")
function answer_ping(channel, sender)
	--print("answering ping via " .. channel .. " with " .. _DB_[pname .. "bagkey"])
	if channel == "WHISPER" then
		SendAddonMessage("eoscm-update", tostring(_DB_[pname .. "bagkey"]), channel, sender)
	else
		SendAddonMessage("eoscm-update", tostring(_DB_[pname .. "bagkey"]), channel)
	end
end


function sync_group()
	for i=1, GetNumGroupMembers() do
		local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i)
		if name ~= pname then
			if not contains(_MPLUS_BUDDIES_, name) then 
				buddy_class = UnitClass(name);
				print("[eoscm] adding: " .. name .. " as " .. colors[buddy_class] .. buddy_class .. "|r")
				table.insert(_MPLUS_BUDDIES_, name)
				_MPLUS_CLASS_[name] = buddy_class
			end
		end	
	end

	if cm_frame.mplus_frame then 
		cm_frame.mplus_frame.mplus_content:SetText(mplus_listing());
	end
end


function reset_mplus()
	_MPLUS_BUDDIES_ = {};
	_MPLUS_KEYS_ = {};
	if cm_frame.mplus_frame then 
		cm_frame.mplus_frame.mplus_content:SetText(mplus_listing());
	end
end


-- updater
function updates()
	--print("updating...")
	check_for_id_reset();

	seals_update();
	seals_obtained_update();
	level_update();
	orderres_update();
	itemlevel_update();
	artifactlevel_update();
	bagkey_update();
	hkey_update();
	akremain_update();
	update_raidid();
	update_raidid_en();
	update_raidid_tov();
	update_raidid_tos();
	update_wqoneshot();
	update_emissary();

	new_shit();
end


function highest_key()
	local maps = C_ChallengeMode.GetMapTable();
	local highest_key = 0;
	for _, mapID in pairs(maps) do
		local _, _, level, affixes = C_ChallengeMode.GetMapPlayerStats(mapID);
        if level ~= nil and level > highest_key then
        	highest_key = level;
        end
    end

	return highest_key
end


function key_in_bags()
	for b=0, 5 do 
    	for s=0, GetContainerNumSlots(b) do 
	    	local link = GetContainerItemLink(b,s);
	    	if link then
		    	if string.match(link, "Keystone") or string.match(link, "Schlüsselstein") then
					printable = gsub(link, "\124", "\124\124");

					firstpos = string.find(printable, ":")+1;
					firstcutoff = string.sub(printable, firstpos);

					secondpos = string.find(firstcutoff, ":")+1;
					secondcutoff = string.sub(firstcutoff, secondpos);

					thirdpos = string.find(secondcutoff, ":");
					thirdcutoff = string.sub(secondcutoff, 0, thirdpos-1);
					
					level = thirdcutoff;

					for i=1, table.getn(dungeons) do
						dungeon = dungeons[i];
						pos = string.find(dungeon, "-");
						short = string.sub(dungeon, pos+1);
						long = string.sub(dungeon, 0, pos-1);

						return_string = "";
						if string.match(printable, long) then
							return_string = short .. "+" .. level;
							if string.match(printable, colors["DEPLETED"]) then
								return_string = colors["GREY"] .. return_string .. "d|r";
							end
							return return_string;
						end
					end
		    	end
		    end
    	end
    end
end


function artifactlevel_update()
	level = LA:GetPowerPurchased();
	if level then 
		_DB_[pname.."artifactlevel"] = level;
	end
end


function level_update()
	level = C_ArtifactUI.GetArtifactKnowledgeLevel();
	if level then 
		_DB_[pname.."level"] = level;
	end
end


function seals_obtained_update()
	local seals = 0;
	if IsQuestFlaggedCompleted(43510) then
		seals = seals + 1;
	end

	for i,q in ipairs({43892,43893,43894,43895,43896,43897}) do 
		if (IsQuestFlaggedCompleted(q)) then 
			seals = seals + 1;
		end 
	end 

	if _DB_[pname.."sealsobt"] then
		if tonumber(_DB_[pname.."sealsobt"]) < seals then
			_DB_[pname.."sealsobt"] = seals;			
		end
	elseif not _DB_[pname.."sealsobt"] then
		_DB_[pname.."sealsobt"] = seals;
	end
end


function seals_update()
	_, amount, _, _, _, _, _, _ = GetCurrencyInfo(1273);

	if amount then 
		_DB_[pname.."seals"] = amount;
	end
end


function orderres_update()
	_, amount, _, _, _, _, _, _ = GetCurrencyInfo(1220);

	if amount then 
		_DB_[pname.."orderres"] = amount;
	end
end


function itemlevel_update()
	avgItemLevel, avgItemLevelEquipped = GetAverageItemLevel();
	avgItemLevel = math.floor(avgItemLevel*100)/100;
	avgItemLevelEquipped = math.floor(avgItemLevelEquipped*100)/100;

	if avgItemLevel then 
		if math.floor(avgItemLevel) ~= 0 then
			_DB_[pname.."itemlevelbag"] = avgItemLevel;
		end
	end

	if avgItemLevelEquipped then 
		if math.floor(avgItemLevelEquipped) ~= 0 then
			_DB_[pname.."itemlevel"] = avgItemLevelEquipped;
		end
	end
end


function bagkey_update()
 	local bagkey = key_in_bags();
 	if bagkey then
 		_DB_[pname .. "bagkey"] = bagkey;
 	end
end


function hkey_update()
	local hkey = highest_key();
 	if hkey and hkey > _DB_[pname .. "hkey"] then
 		_DB_[pname .. "hkey"] = hkey;
 	end
end


function akremain_update()
    local remaining_days = 0;
    local remaining_hours = 0;
    local remaining_minutes = 0;
	local current_month = 0;
	local current_day = 0;
	local current_hour = 0;
	local current_minute = 0;

    local t = C_Garrison.GetLooseShipments(3);
    local i = 1;
    for l = i,#t do 
        local c = C_Garrison.GetLandingPageShipmentInfoByContainerID(C_Garrison.GetLooseShipments(3)[l]);
        if c=="Artifact Research Notes" then 
            i=l;
            break
        end
    end

    if not C_Garrison.GetLooseShipments(3)[i] then
		return 
	end

    local _, _, _, shipmentsReady, _, _, _, tlStr = C_Garrison.GetLandingPageShipmentInfoByContainerID(C_Garrison.GetLooseShipments(3)[i]);

    if tlStr then
		local lst = tolist(string.gmatch(tlStr, "%S+"));
		 -- days and hr
		if lst[4] and lst[2] and string.match(lst[2], "days") and string.match(lst[4], "hr") then
		    for idx, item in ipairs(lst) do
		    	if idx == 1 then
		    		remaining_days = item;
		    	elseif idx == 3 then
		    		remaining_hours = item;
		    	end
		    end
		    remaining_minutes = "??";

		-- days only because hours == 0
		elseif lst[2] and string.match(lst[2], "days") then
		    for idx, item in ipairs(lst) do
		    	if idx == 1 then
		    		remaining_days = item;
		    	end
		    end
		    remaining_hours = 0;
		    remaining_minutes = "??";

		-- hr and mins
		elseif lst[2] and lst[4] and string.match(lst[2], "hr") and string.match(lst[4], "min") then
		    for idx, item in ipairs(lst) do
		    	if idx == 1 then
		    		remaining_hours = item;
		    	elseif idx == 3 then
		    		remaining_minutes = item;
		    	end
		    end

		-- mins only because hrs == 0
		elseif lst[2] and string.match(lst[2], "min") then 
			for idx, item in ipairs(lst) do
		    	if idx == 1 then
		    		remaining_minutes = item;
		    	end
		    end

		else
			--print("No matching time found, AK research may be wrong for this Char");
			--print("DEBUGINFO: >" .. tostring(lst[2]) .. "<" .. " and " .. ">" .. tostring(lst[4]) .. "<");
			return 
		end
	    
	    local current_time = date("%d %m %H %M");
		if current_time then
			local lst = tolist(string.gmatch(current_time, "%S+"));

			for idx, item in ipairs(lst) do
		    	if idx == 1 then
		    		current_day = tonumber(item);
		    	elseif idx == 2 then
		    		current_month = tonumber(item);
		    	elseif idx == 3 then
		    		current_hour = tonumber(item);
		    	elseif idx == 4 then
		    		current_minute = tonumber(item);
		    	end
		    end
		end

		local target_day = current_day + remaining_days;
		local target_month = current_month;
		local target_hour = current_hour + tonumber(remaining_hours);

		if tostring(remaining_minutes) ~= "??" then
			target_min = current_minute + remaining_minutes;
		else 
			target_min = remaining_minutes;
		end
		
		if tostring(target_min) ~= "??" and target_min > 60 then
			target_min = target_min - 60;
			target_hour = target_hour + 1;
		end

		if target_hour > 24 then 
			target_hour = target_hour - 24;
			target_day = target_day + 1;

			if target_day > months[tonumber(target_month)] then
				target_day = target_day - months[target_month];
				target_month = target_month + 1;

				if target_month > 12 then
					target_month = 1;
				end
			end
		end

		target_month = tonumber(target_month);
		target_day = tonumber(target_day);
		target_hour = tonumber(target_hour);

		time_string = target_day .. " " .. target_month .. " " .. target_hour .. " " .. target_min;

		if time_string then 
			--print("updating timestring: " .. time_string);
			_DB_[pname .. "akremain"] = time_string; 
		end
	 	
	end
end

--Die Nachtfestung
--Die Prüfung der Tapferkeit
--Das Grabmal des Sargeras
--Der Smaragdgrüne Alptraum

-- NH
function update_raidid()
	instances = GetNumSavedInstances();
	local s = "";

	for i=1, instances do
		name, id, reset, difficulty, locked, extended, instanceIDMostSig, isRaid, maxPlayers, difficultyName, numEncounters, encounterProgress = GetSavedInstanceInfo(i);
		--print(difficultyName)
		if (name == "The Nighthold" or name == "Die Nachtfestung") and (difficultyName == "Mythic" or difficultyName == "Mythisch") and locked then
			if encounterProgress < numEncounters then
			 	s = s .. colors["RED"] .. tostring(encounterProgress) .. "|r" .. colors["WHITE"] .. "/" .. tostring(numEncounters) .. "M |r";
			else
				s = s .. colors["WHITE"] .. tostring(encounterProgress) .. "/" .. tostring(numEncounters) .. "M |r";
			end

		elseif (name == "The Nighthold" or name == "Die Nachtfestung") and (difficultyName == "Heroic" or difficultyName == "Heroisch") and locked then
			if encounterProgress < numEncounters then
				s = s .. colors["RED"] .. tostring(encounterProgress) .. "|r" .. colors["WHITE"] .. "/" .. tostring(numEncounters) .. "H |r";
			else
				s = s .. colors["WHITE"] .. tostring(encounterProgress) .. "/" .. tostring(numEncounters) .. "H |r";
			end

		elseif (name == "The Nighthold" or name == "Die Nachtfestung") and (difficultyName == "Normal" or difficultyName == "Normal") and locked then
			if encounterProgress < numEncounters then
				s = s .. colors["RED"] .. tostring(encounterProgress) .. "|r" .. colors["WHITE"] .. "/" .. tostring(numEncounters) .. "N ";
			else
				s = s .. colors["WHITE"] .. tostring(encounterProgress) .. "/" .. tostring(numEncounters) .. "N |r";
			end

		end
	end
	if s == "" then 
		s = "-";
	end
	_DB_[pname.."nhraidid"] = s;
end


--TOV
function update_raidid_tov()
	instances = GetNumSavedInstances();
	local s = "";

	for i=1, instances do
		name, id, reset, difficulty, locked, extended, instanceIDMostSig, isRaid, maxPlayers, difficultyName, numEncounters, encounterProgress = GetSavedInstanceInfo(i);
		if (name == "Trial of Valor" or name == "Die Prüfung der Tapferkeit") and (difficultyName == "Mythic" or difficultyName == "Mythisch") and locked then
			if encounterProgress < numEncounters then
			 	s = s .. colors["RED"] .. tostring(encounterProgress) .. "|r" .. colors["WHITE"] .. "/" .. tostring(numEncounters) .. "M |r";
			else
				s = s .. colors["WHITE"] .. tostring(encounterProgress) .. "/" .. tostring(numEncounters) .. "M |r";
			end

		elseif (name == "Trial of Valor" or name == "Die Prüfung der Tapferkeit") and (difficultyName == "Heroic" or difficultyName == "Heroisch") and locked then
			if encounterProgress < numEncounters then
				s = s .. colors["RED"] .. tostring(encounterProgress) .. "|r" .. colors["WHITE"] .. "/" .. tostring(numEncounters) .. "H |r";
			else
				s = s .. colors["WHITE"] .. tostring(encounterProgress) .. "/" .. tostring(numEncounters) .. "H |r";
			end

		elseif (name == "Trial of Valor" or name == "Die Prüfung der Tapferkeit") and (difficultyName == "Normal" or difficultyName == "Normal") and locked then
			if encounterProgress < numEncounters then
				s = s .. colors["RED"] .. tostring(encounterProgress) .. "|r" .. colors["WHITE"] .. "/" .. tostring(numEncounters) .. "N ";
			else
				s = s .. colors["WHITE"] .. tostring(encounterProgress) .. "/" .. tostring(numEncounters) .. "N |r";
			end

		end
	end
	if s == "" then 
		s = "-";
	end
	_DB_[pname.."tovraidid"] = s;
end


-- EN
function update_raidid_en()
	instances = GetNumSavedInstances();
	local s = "";

	for i=1, instances do
		name, id, reset, difficulty, locked, extended, instanceIDMostSig, isRaid, maxPlayers, difficultyName, numEncounters, encounterProgress = GetSavedInstanceInfo(i);

		if (name == "The Emerald Nightmare" or name == "Der Smaragdgrüne Albtraum") and (difficultyName == "Mythic" or difficultyName == "Mythisch") and locked then
			if encounterProgress < numEncounters then
			 	s = s .. colors["RED"] .. tostring(encounterProgress) .. "|r" .. colors["WHITE"] .. "/" .. tostring(numEncounters) .. "M |r";
			else
				s = s .. colors["WHITE"] .. tostring(encounterProgress) .. "/" .. tostring(numEncounters) .. "M |r";
			end

		elseif (name == "The Emerald Nightmare" or name == "Der Smaragdgrüne Albtraum") and (difficultyName == "Heroic" or difficultyName == "Heroisch") and locked then
			if encounterProgress < numEncounters then
				s = s .. colors["RED"] .. tostring(encounterProgress) .. "|r" .. colors["WHITE"] .. "/" .. tostring(numEncounters) .. "H |r";
			else
				s = s .. colors["WHITE"] .. tostring(encounterProgress) .. "/" .. tostring(numEncounters) .. "H |r";
			end

		elseif (name == "The Emerald Nightmare" or name == "Der Smaragdgrüne Albtraum") and (difficultyName == "Normal" or difficultyName == "Normal") and locked then
			if encounterProgress < numEncounters then
				s = s .. colors["RED"] .. tostring(encounterProgress) .. "|r" .. colors["WHITE"] .. "/" .. tostring(numEncounters) .. "N ";
			else
				s = s .. colors["WHITE"] .. tostring(encounterProgress) .. "/" .. tostring(numEncounters) .. "N |r";
			end

		end
	end
	if s == "" then 
		s = "-";
	end
	_DB_[pname.."enraidid"] = s;
end


--TOS
function update_raidid_tos()
	instances = GetNumSavedInstances();
	local s = "";

	for i=1, instances do
		name, id, reset, difficulty, locked, extended, instanceIDMostSig, isRaid, maxPlayers, difficultyName, numEncounters, encounterProgress = GetSavedInstanceInfo(i);
		if (name == "Tomb of Sargeras" or name == "Das Grabmal des Sargeras") and (difficultyName == "Mythic" or difficultyName == "Mythisch") and locked then
			if encounterProgress < numEncounters then
			 	s = s .. colors["RED"] .. tostring(encounterProgress) .. "|r" .. colors["WHITE"] .. "/" .. tostring(numEncounters) .. "M |r";
			else
				s = s .. colors["WHITE"] .. tostring(encounterProgress) .. "/" .. tostring(numEncounters) .. "M |r";
			end

		elseif (name == "Tomb of Sargeras" or name == "Das Grabmal des Sargeras") and (difficultyName == "Heroic" or difficultyName == "Heroisch") and locked then
			if encounterProgress < numEncounters then
				s = s .. colors["RED"] .. tostring(encounterProgress) .. "|r" .. colors["WHITE"] .. "/" .. tostring(numEncounters) .. "H |r";
			else
				s = s .. colors["WHITE"] .. tostring(encounterProgress) .. "/" .. tostring(numEncounters) .. "H |r";
			end

		elseif (name == "Tomb of Sargeras" or name == "Das Grabmal des Sargeras") and (difficultyName == "Normal" or difficultyName == "Normal") and locked then
			if encounterProgress < numEncounters then
				s = s .. colors["RED"] .. tostring(encounterProgress) .. "|r" .. colors["WHITE"] .. "/" .. tostring(numEncounters) .. "N ";
			else
				s = s .. colors["WHITE"] .. tostring(encounterProgress) .. "/" .. tostring(numEncounters) .. "N |r";
			end

		end
	end
	if s == "" then 
		s = "-";
	end
	_DB_[pname.."tosraidid"] = s;
end


function update_wqoneshot()
	if contains(world_quest_one_shot, pclass) then
		local current_saved_val = _DB_[pname .. "wqoneshot"];
		local spell_id = world_quest_one_shot_ids[pclass];

		-- remove later TODO
		if current_saved_val == "Unknown" then
			_DB_[pname .. "wqoneshot"] = "unknown";
		end

		if current_saved_val == 0 or current_saved_val == "unknown" then 
			--print("currently 0 or unknown")

			-- check if on cd
			start, duration, enabled = GetSpellCooldown(spell_id);
			--print("tocheck: " .. start .. ", " .. duration .. ", " .. enabled);
		
			if start ~= 0 and duration ~= 0 then
				-- calculate new cd
				local finish = start + duration - GetTime(); -- this has to run in the same session the spell was used
				local finish_hours = math.floor(finish / 3600);

				-- check if cd is valid
				if finish_hours > 0 and finish_hours < 18 then

					-- if yes save
					-- _DB_[pname .. "wqoneshot"] = GetServerTime() + finish;
					local tmp = GetServerTime() + finish;
					--print("SAAIIIIIIIIFF cus valid cd");
					--print("getservertime: " .. GetServerTime());
					--print("finish: " .. finish);
					--print("finish_hours: " .. finish_hours);
					--print("ready at (tmp): " .. tmp);
					_DB_[pname .. "wqoneshot"] = tmp;
				else
					-- else do nothing -> value is 0 and on cd -> didnt save last time -> value is unknown
					--print("new cd is not valid, setting to unknown");
					_DB_[pname .. "wqoneshot"] = "unknown";
					return 

				end
			-- else nothing changed -> return
			else
				--print("still not on cd");
				_DB_[pname .. "wqoneshot"] = 0;
				return

			end

		else 
			--print("currently not 0")

			-- check if valid (<=18h)
			current_saved_val = current_saved_val - GetServerTime();
			--print("tocheck: " .. current_saved_val);
			current_saved_val_hours = math.floor(current_saved_val / 3600);
			--print("tocheck: " .. current_saved_val_hours);

			-- if not valid reset
			if current_saved_val_hours < 0 or current_saved_val_hours > 18 then
				--print("should be reset");
				_DB_[pname .. "wqoneshot"] = "unknown";
			
			-- else stop -> all ok
			else
				--print("should not be reset");
				return

			end
		end
	end
end


function update_emissary()
	local count = count_open_emissary_quests();

	-- reduce count if too old
	_DB_[pname .. "emissary_date"] = GetServerTime() + GetQuestResetTime();
	_DB_[pname .. "emissary"] = count;
end


-- cmd functions
function remove_character(msg)
	local lst = tolist(string.gmatch(msg, "%S+"));
	local cmd = lst[1];
	local name_to_remove = lst[2];

	if #lst ~= 2 or lst[1] ~= "rm" then
		print("[eoscm] Command unknown! :(");
		return false;
	else 
		if contains(_NAMES_, name_to_remove) then
			print("[eoscm] Successfully removed: " .. table.remove(_NAMES_, find(_NAMES_, name_to_remove)));
			return true;
		else
			print("[eoscm] Name unknown!");
			return false;
		end
	end
end


function remove_buddy(msg)
	local lst = tolist(string.gmatch(msg, "%S+"));
	local cmd = lst[1];
	local name_to_remove = lst[2];

	if #lst ~= 2 or lst[1] ~= "rbud" then
		print("[eoscm] Command unknown! :(");
		return false;

	else 
		if contains(_MPLUS_BUDDIES_, name_to_remove) then
			print("[eoscm] Successfully removed: " .. table.remove(_MPLUS_BUDDIES_, find(_MPLUS_BUDDIES_, name_to_remove)));
			cm_frame.mplus_frame.mplus_content:SetText(mplus_listing());
			return true;

		else
			print("[eoscm] Name unknown!");
			return false;
		end
	end
end


function weekly_reset(msg)
	for idx, item in ipairs(_NAMES_) do
		-- reset finished key
		_DB_[item.."hkey"] = 0;

		-- reset bag key
		_DB_[item.."bagkey"] = "?";

		-- reset seals obtained
		_DB_[item.."sealsobt"] = 0;

		-- reset raid ids
		_DB_[item.."nhraidid"] = "-";
	end
end


function check_for_id_reset()
	-- init needed values
	local reset = 0;
	local region = GetCurrentRegion();

	if region == 1 then 
		reset = na_reset;
	elseif region == 3 then
		reset = eu_reset;
	end

	server_time = GetServerTime();

	-- case _NEXT_RESET_ is not initialized
	if tonumber(_NEXT_RESET_) == 0 then
		while reset < server_time do 
			reset = reset + week;
		end
		_NEXT_RESET_ = reset;
 	end

 	-- case no reset needed
 	if tonumber(_NEXT_RESET_) > server_time then 
 		return

 	else 
 		while reset < server_time do 
			reset = reset + week;
		end
		_NEXT_RESET_ = reset;
		weekly_reset();
 	end
end


function weekly()
	weekly_reset("weekly");
	ReloadUI();
end


function complete_reset()
	_NAMES_ = nil;
	_DB_ = nil;
	_NEXT_RESET_ = nil;
	_TRACKED_CHARS_ = nil;
	_OPTIONS_ = nil;
	_MPLUS_BUDDIES_ = nil;
	_MPLUS_KEYS_ = nil;
	ReloadUI();
end


-- misc
function debug()
	--print(colors["RED"] .. "oh oh, you shouldnt do this" .. "|r")

	--_NEXT_RESET_ = _NEXT_RESET_ - 172800;
end


function new_shit()
	--print("new shit");
	--print("return: " .. time_diff(5, 17, 12, 2, 5, 18, 11, 3));
	--print("return: " .. time_diff(5, 17, 12, 3, 5, 18, 11, 3));
	--print("return: " .. time_diff(5, 17, 12, 3, 5, 18, 11, 2));
	--count_open_emisarry_quests();
	return
end

-- TODO 
-- auf aktuellem char auslesen, ob AK rdy
-- splitter supplies

-- split files

-- maybe later:
-- tooltips, its not that easy with checkboxes
-- addon updates available, only solution is to compare own version with other version. if its older show msg. not rly useful with 500~ downloads 