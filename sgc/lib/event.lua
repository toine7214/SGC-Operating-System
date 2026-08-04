--------------------------------------------------
-- SGC Operating System
-- Event Bus
-- Version : 0.2.1
--------------------------------------------------

local event = {}

--------------------------------------------------
-- Liste des abonnés
--------------------------------------------------

local listeners = {}

--------------------------------------------------
-- Abonnement
--------------------------------------------------

function event.subscribe(name, callback)

    if type(callback) ~= "function" then
        error("callback attendu")
    end

    if not listeners[name] then
        listeners[name] = {}
    end

    table.insert(listeners[name], callback)

end

--------------------------------------------------
-- Désabonnement
--------------------------------------------------

function event.unsubscribe(name, callback)

    if not listeners[name] then
        return
    end

    for i, fn in ipairs(listeners[name]) do

        if fn == callback then
            table.remove(listeners[name], i)
            return
        end

    end

end

--------------------------------------------------
-- Emission
--------------------------------------------------

function event.emit(name, data)

    if not listeners[name] then
        return
    end

    for _, callback in ipairs(listeners[name]) do

        local ok, err = pcall(callback, data)

        if not ok then
            print("[EVENT] "..err)
        end

    end

end

--------------------------------------------------
-- Nettoyage
--------------------------------------------------

function event.clear()

    listeners = {}

end

--------------------------------------------------
-- Statistiques
--------------------------------------------------

function event.count(name)

    if not listeners[name] then
        return 0
    end

    return #listeners[name]

end

return event
