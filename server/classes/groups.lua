groups = {}

Group = {}
Group.__index = Group

local _user = 'user'
local _admin = 'admin'

setmetatable(Group, {
    __eq = function(self)
        return self.group
    end,
    __tostring = function(self)
        return self.group
    end,
    __call = function(self, group, inh, ace)
        local gr = {}

        gr.group = group
        gr.inherits = inh
        gr.aceGroup = ace
        groups[group] = gr
        
        for k, v in pairs(Group) do
            if type(v) == 'function' then
                gr[k] = v
            end
        end
        return gr
    end
})

function Group:canTarget(gr)
    if (gr == "") then
        return true
    elseif(self.group == "_dev") then
        return true
    elseif(gr == "_dev") then
        return false
    elseif(self.group == 'superadmin') then
        return true
    elseif(self.group == 'user') then
        if (gr == 'user') then
            return true
        else
            return false
        end
    else
        if(self.group == gr) then
            return true
        elseif(self.inherits == gr) then
            return true
        elseif(self.inherits == 'superadmin') then
            return true
        else
            if(self.inherits == 'user') then
                return true
            else
                return groups[self.inherits]:canTarget(gr)
            end
        end
    end
end

user = Group("user", "")
admin = Group("admin", "user")
superadmin = Group("superadmin", "admin")

ExecuteCommand('add_principal group.admin group.user')
ExecuteCommand('add_principal group.superadmin group.admin')

dev = Group("_dev", "superadmin")

AddEventHandler("trp:addGroup", function(group, inherit, aceGroup)
    if(type(aceGroup) ~= "string") then
        aceGroup = "user"
    end
    if(type(Group) ~= "string") then
        log('TRP_ERROR: There seems to be an issue while creating a new group, make sure that you entered a correct "group" as "string"')
        print('TRP_ERROR: There seems to be an issue while creating a new group, make sure that you entered a correct "group" as "string"')
    end
    if(type(inherit) ~= "string") then
        log('TRP_ERROR: There seems to be an issue while creating a new group, make sure that you entered a correct "inherit" as "string"')
        print('TRP_ERRO: There seems to be an issue while creating a new group, make sure that you entered a correct "inherit" as "string"')
    end
    ExecuteCommand('add_principal group.' .. group .. ' group.' .. inherit)

    if(inherit == _user) then
        _user = group
        groups['admin'].inherits = group
        ExecuteCommand('add_principal group.admin group.' .. group)
    elseif(inherit == _admin) then
        _admin = group
        groups['superadmin'].inherits = group
        ExecuteCommand('add_principal group.superadmin group.' .. group)
    end
    Group(group, inherit, aceGroup)
end)

function canGroupTarget(group, targetGroup, cb)
    if groups[group] and groups[targetGroup] then
        if cb then
            cb(groups[group]:canTarget(targetGroup))
        else
            return groups[group]:canTarget(targetGroup)
        end
    else
        if cb then
            cb(false)
        else
            return false
        end
    end
end

AddEventHandler("trp:canGroupTarget", function(group, targetGroup, cb)
    canGroupTarget(group, targetGroup, cb)
end)

AddEventHandler("trp:getAllGroups", function(cb)
    cb(groups)
end)