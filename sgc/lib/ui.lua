--------------------------------------------------
-- SGC Operating System
-- Interface graphique
-- Version : 0.2.1
--------------------------------------------------

local ui = {}

local config = SGC.load("lib.config")


--------------------------------------------------
-- Informations écran
--------------------------------------------------

local function screen()

    local w, h = term.getSize()

    return w, h

end



--------------------------------------------------
-- Effacement écran
--------------------------------------------------

function ui.clear()

    term.setBackgroundColor(config.colors.background)
    term.setTextColor(config.colors.foreground)

    term.clear()
    term.setCursorPos(1,1)

end



--------------------------------------------------
-- Écriture simple
--------------------------------------------------

function ui.print(x, y, text)

    term.setCursorPos(x,y)
    term.write(text)

end



--------------------------------------------------
-- Texte centré
--------------------------------------------------

function ui.center(y, text)

    local w, h = screen()

    local x = math.floor((w - #text) / 2) + 1

    term.setCursorPos(x,y)
    term.write(text)

end



--------------------------------------------------
-- Ligne horizontale écran principal
--------------------------------------------------

function ui.line(y)

    local w,h = term.getSize()

    term.setCursorPos(
        1,
        y
    )

    term.write(
        string.rep("-", w)
    )

end



--------------------------------------------------
-- Cadre principal
--------------------------------------------------

function ui.frame()

    local w, h = screen()

    term.setTextColor(config.colors.foreground)

    -- haut

    term.setCursorPos(1,2)
    term.write("+" .. string.rep("-", w-2) .. "+")


    -- côtés

    for y = 3, h-1 do

        term.setCursorPos(1,y)
        term.write("|")

        term.setCursorPos(w,y)
        term.write("|")

    end


    -- bas

    term.setCursorPos(1,h-1)
    term.write("+" .. string.rep("-", w-2) .. "+")


    term.setTextColor(config.colors.foreground)

end



--------------------------------------------------
-- En-tête
--------------------------------------------------

function ui.header(title)

    local w, h = screen()


    term.setBackgroundColor(
        config.colors.titleBackground
    )

    term.setTextColor(
        config.colors.titleForeground
    )


    term.setCursorPos(1,1)

    term.clearLine()


    ui.center(1,title)


    term.setBackgroundColor(
        config.colors.background
    )

    term.setTextColor(
        config.colors.foreground
    )

end



--------------------------------------------------
-- Pied de page
--------------------------------------------------

function ui.footer(text)

    local w, h = screen()


    term.setCursorPos(1,h)

    term.setBackgroundColor(
        config.colors.titleBackground
    )

    term.setTextColor(
        config.colors.titleForeground
    )

    term.clearLine()


    ui.center(h,text)


    term.setBackgroundColor(
        config.colors.background
    )

    term.setTextColor(
        config.colors.foreground
    )

end



--------------------------------------------------
-- Initialisation écran complet
--------------------------------------------------

function ui.begin(title)

    ui.clear()

    ui.header(title)

    ui.frame()

end



--------------------------------------------------
-- Message
--------------------------------------------------

function ui.message(title,text)

    ui.begin(title)

    ui.print(3,5,text)

    ui.print(3,7,"Appuie sur une touche...")

    os.pullEvent("key")

end







--------------------------------------------------
-- Sélection menu
--------------------------------------------------

function ui.select(text, selected)

    if selected then

        term.setBackgroundColor(
            config.colors.menuSelectedBackground
        )

        term.setTextColor(
            config.colors.menuSelectedForeground
        )


    else

        term.setBackgroundColor(
            config.colors.background
        )

        term.setTextColor(
            config.colors.foreground
        )

    end


    term.clearLine()

    term.write(text)


    term.setBackgroundColor(
        config.colors.background
    )

    term.setTextColor(
        config.colors.foreground
    )

end

--------------------------------------------------
-- Barre de progression
--------------------------------------------------

function ui.progress(x, y, width, percent)

    percent = math.max(0, math.min(100, percent))

    local filled = math.floor(width * percent / 100)

    term.setCursorPos(x, y)

    term.write("[")

    for i = 1, width do

        if i <= filled then
            term.write("#")
        else
            term.write("#")
        end

    end

    term.write("] "..percent.."%")

end

--------------------------------------------------
-- Création d'une fenêtre
--------------------------------------------------

function ui.window(x, y, width, height)

    local win = window.create(
        term.current(),
        x,
        y,
        width,
        height,
        false
    )

    win.setBackgroundColor(config.colors.background)
    win.setTextColor(config.colors.foreground)

    return win

end
 --------------------------------------------------
-- Efface une fenêtre
--------------------------------------------------

function ui.clearWindow(win)

    win.setVisible(false)

    win.setBackgroundColor(config.colors.background)
    win.setTextColor(config.colors.foreground)

    win.clear()

    win.setCursorPos(1,1)

    win.setVisible(true)

end
--------------------------------------------------
-- Ecriture fenêtre
--------------------------------------------------

function ui.windowWrite(win,x,y,text)

    win.setCursorPos(
        x,
        y
    )

    win.write(
        tostring(text)
    )

end
--------------------------------------------------
-- Ligne dans une fenêtre
--------------------------------------------------

function ui.windowLine(win,y)

    local w,h =
        win.getSize()

    win.setCursorPos(
        1,
        y
    )

    win.write(
        string.rep("-",w)
    )

end

--------------------------------------------------
-- Label
--------------------------------------------------

function ui.label(win, x, y, text)

    win.setCursorPos(x, y)
    win.write(tostring(text))

end

--------------------------------------------------
-- Valeur
--------------------------------------------------

function ui.value(win, x, y, text)

    local w,h = win.getSize()

    win.setCursorPos(x,y)

    local width = w - x + 1

    win.write(string.rep(" ",width))

    win.setCursorPos(x,y)

    win.write(tostring(text))

end

--------------------------------------------------
-- Séparateur
--------------------------------------------------

function ui.separator(win,y)

    local w,h = win.getSize()

    win.setCursorPos(1,y)

    win.write(string.rep("-",w))

end

--------------------------------------------------
-- Confirmation
--------------------------------------------------

function ui.confirm(question)

    ui.begin("CONFIRMATION")

    print()

    print(question)

    print()

    print("[Y] Oui    [N] Non")

    while true do

        local _,key=os.pullEvent("key")

        if key==keys.y then
            return true
        end

        if key==keys.n then
            return false
        end

    end

end

--------------------------------------------------
-- Etat
--------------------------------------------------

function ui.status(win,x,y,state)

    win.setCursorPos(x,y)

    if state then

        win.setTextColor(config.colors.success)

        win.write("[+] ONLINE")

    else

        win.setTextColor(config.colors.error)

        win.write("[-] OFFLINE")

    end

    win.setTextColor(
    config.colors.foreground
)

end
---------------------------------------------
--Compatibilité ancienne API
---------------------------------------------

function ui.title(text)
	
	ui.begin(text)
	
end

--------------------------------------------------
-- ListView
--------------------------------------------------

function ui.ListView(win)

    local list = {}

    list.window = win
    list.items = {}
    list.selected = 1
    list.top = 1
    list.focus = true


    --------------------------------------------------
    -- Définit les éléments
    --------------------------------------------------

    function list:setItems(items)

        self.items = items or {}

        if #self.items == 0 then

            self.selected = 0

        elseif self.selected < 1 then

            self.selected = 1

        elseif self.selected > #self.items then

            self.selected = #self.items

        end

    end


    --------------------------------------------------
    -- Sélection
    --------------------------------------------------

    function list:setSelected(index)

        if #self.items == 0 then

            self.selected = 0
            return

        end


        self.selected = math.max(
            1,
            math.min(index,#self.items)
        )

    end



    --------------------------------------------------
    -- Retour sélection
    --------------------------------------------------

    function list:getSelected()

        return self.selected

    end



    --------------------------------------------------
    -- Retour élément
    --------------------------------------------------

    function list:getItem()

        if self.selected == 0 then
            return nil
        end

        return self.items[self.selected]

    end



    --------------------------------------------------
    -- Navigation haut
    --------------------------------------------------

    function list:moveUp()

        if self.selected > 1 then

            self.selected = self.selected - 1

            return true

        end

        return false

    end



    --------------------------------------------------
    -- Navigation bas
    --------------------------------------------------

    function list:moveDown()

        if self.selected < #self.items then

            self.selected = self.selected + 1

            return true

        end

        return false

    end



    --------------------------------------------------
    -- Dessin
    --------------------------------------------------

    function list:draw()

        ui.clearWindow(self.window)


        local w,h =
            self.window.getSize()


        if self.selected < self.top then

            self.top = self.selected

        end


        if self.selected >= self.top + h then

            self.top =
                self.selected - h + 1

        end



        for line = 1,h do


            local index =
                self.top + line - 1


            local item =
                self.items[index]


            if item then


                self.window.setCursorPos(1,line)


                if index == self.selected then

                    self.window.setBackgroundColor(config.colors.menuSelectedBackground)
					self.window.setTextColor(config.colors.menuSelectedForeground)

                else

                    self.window.setBackgroundColor(config.colors.background)
					self.window.setTextColor(config.colors.foreground)

                end


                self.window.write(
                    string.format(
                        "%-"..w.."s",
                        item
                    )
                )

            end

        end


        self.window.setBackgroundColor(colors.black)
        self.window.setTextColor(colors.white)

    end



    --------------------------------------------------
    -- Focus
    --------------------------------------------------

    function list:setFocus(state)

        self.focus = state

    end


    function list:hasFocus()

        return self.focus

    end



    return list

end

--------------------------------------------------
-- Position des chevrons Stargate
--------------------------------------------------

local chevrons = {

    {x=15,y=5}, -- 1 haut

    {x=21,y=7}, -- 2 haut droite

    {x=23,y=10}, -- 3 droite haut

    {x=21,y=13}, -- 4 droite bas

    {x=15,y=15}, -- 5 bas

    {x=9,y=13}, -- 6 gauche bas

    {x=7,y=10}, -- 7 gauche haut

    {x=9,y=7}, -- 8 haut gauche

    {x=15,y=10} -- 9 centre

}
--------------------------------------------------
-- Dessin anneau Stargate
--------------------------------------------------

function ui.drawGateRing(active)


    active =
        active or 0



    for i,pos in ipairs(chevrons) do


        term.setCursorPos(
            pos.x,
            pos.y
        )


        if i <= active then

            term.setTextColor(
                colors.lime
            )

            term.write("0")


        else

            term.setTextColor(
                colors.gray
            )

            term.write(".")

        end


    end


    term.setTextColor(
        config.colors.foreground
    )


end
--------------------------------------------------
-- Ecran de composition Stargate
--------------------------------------------------
function ui.writeValue(x,y,width,text)

    term.setCursorPos(x,y)
    term.write(string.rep(" ",width))

    term.setCursorPos(x,y)
    term.write(text)

end
function ui.dialerScreen(destination)

    ui.begin("COMPOSITION")

    term.setCursorPos(3,3)
    print("Destination : "..destination)

    ui.drawGateRing(0)

    term.setCursorPos(36,7)
    term.write("Energie :")

    term.setCursorPos(36,9)
    term.write("Chevron :")

    term.setCursorPos(36,11)
    term.write("Etat :")

    ui.updateFooter("Q : Annuler")

end
--------------------------------------------------
-- Mise à jour chevron
--------------------------------------------------

function ui.updateChevron(number,total)

    ui.writeValue(
        46,
        9,
        8,
        number.." / "..total
    )

end
--------------------------------------------------
-- Fin composition
--------------------------------------------------

function ui.dialerConnected(destination)


    ui.begin("COMPOSITION TERMINEE")


    term.setCursorPos(4,5)

    print(
        "Destination : "
        ..destination
    )


    term.setCursorPos(4,8)

    term.setTextColor(
        colors.lime
    )

    print(
        "- CONNEXION ETABLIE"
    )


    term.setTextColor(
        config.colors.foreground
    )

end
function ui.updateDialState(state)

    ui.writeValue(
        36,
        12,
        15,
        state
    )

end
function ui.updateEnergy(percent)

    ui.writeValue(
        46,
        7,
        6,
        percent.." %"
    )

end
function ui.updateFooter(text)

    term.setCursorPos(3,19)
    term.clearLine()
    term.write(text)

end
return ui