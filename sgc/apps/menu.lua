local ui = SGC.load("lib.ui")

local menu = {}

local items = {
    "Composer",
    "Carnet adresses",
    "Diagnostic",
    "Iris",
    "Parametres"
}

function menu.run()

    local selected = 1

    while true do

        ui.title("SGC OPERATING SYSTEM")

        for i, item in ipairs(items) do
            term.setCursorPos(4, i + 2)

            if i == selected then
                term.write("> " .. item)
            else
                term.write("  " .. item)
            end
        end
		
		-- Pied de page
		local w, h = term.getSize()
			term.setCursorPos(2, h)
			term.setTextColor(colors.lightGray)
			term.write("Q : Quitter")
			term.setTextColor(colors.white)
		
        local event, key = os.pullEvent("key")

        if key == keys.q then
		return 0
		end
		
		if key == keys.up then
            selected = math.max(1, selected - 1)

        elseif key == keys.down then
            selected = math.min(#items, selected + 1)

        elseif key == keys.enter then
            return selected
        end

    end

end

return menu
