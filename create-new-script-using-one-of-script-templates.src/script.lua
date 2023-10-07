local fs = {}

local function main()
	local template_dir = vim.fn.expand("$GIT_PROJECTS_DIR/small_scripts/script-templates/")
	local pickers = require "telescope.pickers"
	local finders = require "telescope.finders"
	local conf = require("telescope.config").values
	local actions = require "telescope.actions"
	local action_state = require "telescope.actions.state"
	local make_entry = require "telescope.make_entry"
	local find_command = { "find", template_dir, "-type", "f" }
	local opts = { entry_maker = make_entry.gen_from_file {} }
	pickers.new(opts, {
		prompt_title = "Choose template",
		finder = finders.new_oneshot_job(find_command, opts),
		previewer = conf.file_previewer(opts),
		sorter = conf.file_sorter(opts),
		attach_mappings = function(prompt_bufnr, map)
			actions.select_default:replace(function()
				actions.close(prompt_bufnr)
				local selection = action_state.get_selected_entry()
				if not selection then return end
				fs.load_template(selection[1])
			end)
			return true
		end,
	}):find()
end

fs.load_template = function(path)
	local lines = {}
	local description = os.getenv("SCRIPT_DESCRIPTION") or "Yet another script of mine."
	for line in io.lines(path) do
		lines[#lines + 1] = line:gsub("SCRIPT_DESCRIPTION", description)
	end
	vim.api.nvim_buf_set_lines(0, 0, -1, true, lines)
	vim.cmd "w | e"
end

main()
