-- BORDER
require("full-border"):setup {
	-- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
	type = ui.Border.ROUNDED,
}

-- BUNNY
require("bunny"):setup({
  hops = {
    { key = "~", path = "~", desc = "Home" },
    { key = "h", path = "~", desc = "Home" },

    { key = "s", path = "~/Pictures/Screenshots", desc = "Screenshots" },
    { key = "w", path = "~/Pictures/wallpapers", desc = "Wallpapers" },

    { key = "d", path = "~/.dotfiles", desc = "Dotfiles" },
    { key = "r", path = "~/programming", desc = "Programming" },
  },
})
