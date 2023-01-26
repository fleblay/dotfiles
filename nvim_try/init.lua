require("fle-blay.lsp")
require("fle-blay.autocmd")
require("fle-blay.utils_lsp")

vim.cmd("source ~/.vimrc")

local launch_server = function(language)
	local filetypes = make_filetypes(language)
	local config = make_config(language)

	set_default_config(config, filetypes)
	vim.lsp.start_client(config)
end

-- creates a new user command with ({name}, {command}, {*opts})
vim.api.nvim_create_user_command(
	'LaunchServer',
	function(var)
		if (var.args == nil) then print("Need args to launch LSP server") return end
		print("Launching server " .. var.args)
		launch_server(var.args)
	end,
	{
		desc = 'Starting server',
		nargs = 1,
		complete = function()
			return {'cpp', 'ts'}
		end
	}
)
