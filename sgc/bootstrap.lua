--------------------------------------------------
-- SGC Operating System
-- Bootstrap V2
-- Version : 0.2.1
--------------------------------------------------

local SGC = {}

--------------------------------------------------
-- Configuration
--------------------------------------------------

SGC.root = "/sgc"

--------------------------------------------------
-- Cache des modules
--------------------------------------------------

local cache = {}

--------------------------------------------------
-- Convertit un nom logique vers un chemin
--------------------------------------------------

local function resolve(name)

    if type(name) ~= "string" then
        error("SGC.load() : nom de module invalide (" .. tostring(name) .. ")")
    end

    name = name:gsub("%.", "/")

    return fs.combine(SGC.root, name .. ".lua")

end

--------------------------------------------------
-- Vérifie si un module existe
--------------------------------------------------

function SGC.exists(name)

    return fs.exists(resolve(name))

end

--------------------------------------------------
-- Charge un module
--------------------------------------------------

function SGC.load(name)

    if type(name) ~= "string" then
        print("===== SGC LOAD ERROR =====")
        print("Argument reçu : "..tostring(name))
        print(debug.traceback())
        error("SGC.load() : nom de module invalide")
    end

    if cache[name] then
        return cache[name]
    end

    local path = resolve(name)

    if not fs.exists(path) then
        error("Module introuvable : "..name)
    end

    local module = dofile(path)

    cache[name] = module

    return module

end

--------------------------------------------------
-- Alias
--------------------------------------------------

SGC.get = SGC.load

--------------------------------------------------
-- Décharge un module
--------------------------------------------------

function SGC.unload(name)

    cache[name] = nil

end

--------------------------------------------------
-- Recharge un module
--------------------------------------------------

function SGC.reload(name)

    cache[name] = nil

    return SGC.load(name)

end

--------------------------------------------------
-- Liste des modules chargés
--------------------------------------------------

function SGC.listLoaded()

    local list = {}

    for name in pairs(cache) do
        table.insert(list,name)
    end

    table.sort(list)

    return list

end

--------------------------------------------------
-- Lance une application
--------------------------------------------------

function SGC.run(name,...)

    local module = SGC.load(name)

    if type(module) ~= "table" then
        error(name.." ne retourne pas une table.")
    end

    if type(module.run) ~= "function" then
        error(name.." ne possède pas run().")
    end

    return module.run(...)

end

--------------------------------------------------
-- Démarrage
--------------------------------------------------

function SGC.start()

    return SGC.run("sgc")

end

--------------------------------------------------
-- API globale
--------------------------------------------------

_G.SGC = SGC

return SGC