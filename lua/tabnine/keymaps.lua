local M = {}
local api = vim.api
local fn = vim.fn
local state = require("tabnine.state")
local config = require("tabnine.config")
local completion = require("tabnine.completion")

function M.setup()
	local accept_keymap = config.get_config().accept_keymap
	local dismiss_keymap = config.get_config().dismiss_keymap
	local complete_keymap = config.get_config().complete_keymap
	vim.keymap.set("i", accept_keymap, function()
		if not state.completions_cache then
			return accept_keymap
		end
		vim.schedule(completion.accept)
	end, { expr = true })

	vim.keymap.set("i", dismiss_keymap, function()
		if not state.completions_cache then
			return dismiss_keymap
		end
		vim.schedule(function()
			completion.clear()
			state.completions_cache = nil
		end)
	end, { expr = true })

	vim.keymap.set("i", complete_keymap, completion.complete, { expr = true })
end

return M
