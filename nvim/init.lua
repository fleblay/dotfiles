require("fle-blay.autocmd")

vim.cmd("source ~/.vimrc")

local launch_tsserver = function()
	local autocmd
	local filetypes = {
		'typescript',
		'javascript',
		'typescriptreact',
		'javascriptreact',
		'typescript.tsx',
		'javascript.jsx',
	}

	--config only required field is command
	local config = {
		cmd = {'typescript-language-server', '--stdio'},
		name = 'tsserver', -- name is log messages
		root_dir = vim.fn.getcwd(), --where the lsp server will base its workspace
		-- Get a new ClientCapabilities object describing the LSP client capabilities
		capabilities = vim.lsp.protocol.make_client_capabilities(),
	}

	--on_attach is callback(client, bufnr) invoked when client attaches to a buffer
	config.on_attach = function(client, bufnr)
		--nvim_exec_autocmds({event}, {*opts})
		--execute all autocommands for {event} that matches {opts}
		--pattern defaults to *
		vim.api.nvim_exec_autocmds('User', {pattern = 'LspAttached'})
	end

	--on_init is callback with (client, initialize_result) invoked after lsp initialize
	--initialize_result is a table of capabilities the server may send
	config.on_init = function(client, results)
		-- If the server has sent offsetEncodings we modify the client_offsetEncoding acordingly
		-- before sending any request or notification
		if results.offsetEncoding then
			client.offset_encoding = results.offsetEncoding
		end

		-- client.config is a copy o the config argument we gave to lsp_start_client()
		-- if it contains an option called settings, we send that to the server
		if client.config.settings then
			-- notify({method}, {params}) sends notification to LSP server
			-- method is string
			-- params is table for the LSP method
			client.notify('workspace/didChangeConfiguration', {
				settings = client.config.settings
			})
		end


		local buf_attach = function()
			vim.lsp.buf_attach_client(0, client.id)
			print("LSP: Attaching current buffer to lsp")
		end

		-- creates a new autocommand event handler with ({event}, {*opts})
		-- defined by callback (Lua fx or vimscript function name string) OR command (Ex cmd string)
		-- desc is description for troubleshooting
		-- pattern (string, array) is pattern to match
		-- string.format retruns a string similar to printf
		autocmd = vim.api.nvim_create_autocmd('FileType', {
			desc = string.format('Attach LSP: %s', client.name),
			pattern = filetypes,
			callback = buf_attach
		})

		-- v:vim_did_enter is 0 during startup and 1 just before VimEnter
		-- vim.tbl_contains({t}, {value}) checks if table t contains value
		-- vim.bo[{bufnr}] permits getting and setting buffer-scoped options
		-- equivalent as :set and :setlocal. current buffer used bufnr omitted
		if vim.v.vim_did_enter == 1 and vim.tbl_contains(filetypes, vim.bo.filetype)
		then
			buf_attach()
			print("LSP: init OK : Attaching current buffer")
		else
			print("LSP: init OK : Current buffer not compatible")
		end
	end

	-- schedule_wrap({cb}) deffers callback cb function until nvim api is safe to call
	-- returns a function
	--on_exit is callback with (code, signal, client_id) invoked on client exit
	--code -> exit code of process
	--signal -> number describing signal used to terminate
	--client_id -> client handle
	config.on_exit = vim.schedule_wrap(function(code, signal, client_id)
		vim.api.nvim_del_autocmd(autocmd)
	end)

	vim.lsp.start_client(config)

end

local launch_cppserver = function()
	local config = {
		cmd = {'clangd'},
		name = 'cppserver', -- name is log messages
		root_dir = vim.fn.getcwd(), --where the lsp server will base its workspace
	}

	local client_id = vim.lsp.start_client(config)

	if client_id then
		vim.lsp.buf_attach_client(0, client_id) -- 1st param is buffer handle, 0 is current
	end
end


-- creates a new user command with ({name}, {command}, {*opts})
-- name must begin with a uppercase
-- desc = 'string' is for listing the command when a lua function is used for {command}
vim.api.nvim_create_user_command(
	'LaunchTsserver',
	launch_tsserver,
	{desc = 'Starting tsserver'}
	)

vim.api.nvim_create_user_command(
	'LaunchCppserver',
	launch_cppserver,
	{desc = 'Starting cppserver'}
	)
