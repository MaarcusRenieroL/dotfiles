-- Java / Spring Boot via nvim-jdtls.
-- jdtls is a special LSP that needs per-project workspaces + DAP/test bundles,
-- so it is started here (per buffer) instead of through vim.lsp.enable().
return {
	"mfussenegger/nvim-jdtls",
	ft = { "java" },
	dependencies = {
		"mfussenegger/nvim-dap",
	},
	config = function()
		local jdtls_ok, jdtls = pcall(require, "jdtls")
		if not jdtls_ok then
			return
		end

		local mason = vim.fn.stdpath("data") .. "/mason"

		-- Debug + test bundles so DAP and the test runner work.
		local bundles = {}
		vim.list_extend(
			bundles,
			vim.split(
				vim.fn.glob(mason .. "/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", true),
				"\n"
			)
		)
		vim.list_extend(
			bundles,
			vim.split(vim.fn.glob(mason .. "/packages/java-test/extension/server/*.jar", true), "\n")
		)
		-- Drop any empty entries (globs that matched nothing).
		bundles = vim.tbl_filter(function(j)
			return j ~= ""
		end, bundles)

		local function start()
			local root = vim.fs.root(0, {
				"mvnw",
				"gradlew",
				"pom.xml",
				"build.gradle",
				"build.gradle.kts",
				"settings.gradle",
				".git",
			})
			if not root then
				return
			end

			local workspace = vim.fn.stdpath("data")
				.. "/jdtls-workspace/"
				.. vim.fn.fnamemodify(root, ":p:h:t")

			-- Lombok is common in Spring Boot. If present, attach the agent.
			local lombok = mason .. "/packages/jdtls/lombok.jar"
			local cmd = { mason .. "/bin/jdtls", "-data", workspace }
			if vim.fn.filereadable(lombok) == 1 then
				table.insert(cmd, "--jvm-arg=-javaagent:" .. lombok)
			end

			local capabilities
			local cmp_ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
			if cmp_ok then
				capabilities = cmp_lsp.default_capabilities()
			end

			jdtls.start_or_attach({
				cmd = cmd,
				root_dir = root,
				capabilities = capabilities,
				init_options = { bundles = bundles },
				settings = {
					java = {
						configuration = { updateBuildConfiguration = "interactive" },
						eclipse = { downloadSources = true },
						maven = { downloadSources = true },
						implementationsCodeLens = { enabled = true },
						referencesCodeLens = { enabled = true },
						inlayHints = { parameterNames = { enabled = "all" } },
						signatureHelp = { enabled = true },
						completion = {
							favoriteStaticMembers = {
								"org.junit.jupiter.api.Assertions.*",
								"org.junit.jupiter.api.Assumptions.*",
								"org.mockito.Mockito.*",
								"org.assertj.core.api.Assertions.*",
							},
						},
					},
				},
				on_attach = function(_, bufnr)
					jdtls.setup_dap({ hotcodereplace = "auto" })
					pcall(require("jdtls.dap").setup_dap_main_class_configs)

					local map = function(lhs, rhs, desc)
						vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
					end
					map("<leader>ji", jdtls.organize_imports, "Java: organize imports")
					map("<leader>jv", jdtls.extract_variable, "Java: extract variable")
					map("<leader>jc", jdtls.extract_constant, "Java: extract constant")
					map("<leader>jm", function()
						jdtls.extract_method(true)
					end, "Java: extract method")
					map("<leader>jt", jdtls.test_class, "Java: test class")
					map("<leader>jn", jdtls.test_nearest_method, "Java: test nearest method")
				end,
			})
		end

		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("zoro-jdtls", { clear = true }),
			pattern = "java",
			callback = start,
		})

		-- The autocmd above fires on the *next* java buffer; start now for the
		-- buffer that triggered loading this plugin.
		if vim.bo.filetype == "java" then
			start()
		end
	end,
}
