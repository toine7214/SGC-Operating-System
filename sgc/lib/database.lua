--------------------------------------------------
-- SGC Operating System
-- Base de données
-- Version : 0.2.1
--------------------------------------------------

local database = {}

local config = SGC.load("lib.config")

--------------------------------------------------
-- Lecture de toutes les lignes
--------------------------------------------------

local function readLines()

    local lines = {}

    if not fs.exists(config.paths.addresses) then
        return lines
    end

    local file = fs.open(config.paths.addresses,"r")

		if not file then return lines
		end

    while true do

        local line = file.readLine()

        if not line then
            break
        end

        if line and line ~= "" then
			table.insert(lines,line)
		end

    end

    file.close()

    return lines

end


--------------------------------------------------
-- Liste des planètes
--------------------------------------------------

function database.list()

    local result = {}

    local lines = readLines()

    for _,line in ipairs(lines) do

        local name = line:match("([^=]+)=")

        if name then
            table.insert(result,name)
        end

    end

    table.sort(result)

    return result

end


--------------------------------------------------
-- Adresse d'une planète
--------------------------------------------------

function database.get(name)

    local lines = readLines()

    for _,line in ipairs(lines) do

        local planet,address =
            line:match("([^=]+)=(.+)")

        if planet == name then

            local symbols = {}

            for value in
                string.gmatch(address,"[^,]+") do

                table.insert(
                    symbols,
                    tonumber(value)
                )

            end

            return symbols

        end

    end

    return nil

end


--------------------------------------------------
-- Vérifie l'existence
--------------------------------------------------

function database.exists(name)

    return database.get(name) ~= nil

end


--------------------------------------------------
-- Nombre d'adresses
--------------------------------------------------

function database.count()

    return #database.list()

end


--------------------------------------------------
-- Ajout d'une adresse
--------------------------------------------------

function database.add(name,address)

    if type(address) ~= "table" then
        return false,"Adresse invalide"
    end

    if type(name) ~= "string" or name == "" then
        return false,"Nom invalide"
    end


    if database.exists(name) then
        return false,"Adresse déjà existante"
    end


    local lines =
        readLines()


    table.insert(
        lines,
        name.."="..table.concat(address,",")
    )


    local file =
        fs.open(
            config.paths.addresses,
            "w"
        )


    if not file then

        return false,
        "Impossible d'ouvrir la base"

    end


    for _,line in ipairs(lines) do

        file.writeLine(line)

    end


    file.close()


    return true

end


--------------------------------------------------
-- Suppression
--------------------------------------------------

function database.remove(name)

    local lines = readLines()

    local output = {}

    local removed = false

    for _,line in ipairs(lines) do

        local planet =
            line:match("([^=]+)=")

        if planet ~= name then
            table.insert(output,line)
        else
            removed = true
        end

    end

    local file = fs.open(config.paths.addresses,"w")

		if not file then
			return false
		end

    for _,line in ipairs(output) do
        file.writeLine(line)
    end

    file.close()

    return removed

end

--------------------------------------------------
-- Compatibilite V0.1
--------------------------------------------------

function database.getAllAddresses()
    return database.list()
end

function database.getAddress(name)
    return database.get(name)
end

return database