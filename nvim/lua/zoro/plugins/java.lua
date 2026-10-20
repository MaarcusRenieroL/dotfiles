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
		-- Only the java-test *plugin* jar is an OSGi bundle. Mason's folder also holds the JUnit
		-- runtime jars (two conflicting versions), which make jdtls fail with "Load bundle list".
		vim.list_extend(
			bundles,
			vim.split(vim.fn.glob(mason .. "/packages/java-test/extension/server/com.microsoft.java.test.plugin-*.jar", true), "\n")
		)
		-- Drop any empty entries (globs that matched nothing).
		bundles = vim.tbl_filter(function(j)
			return j ~= ""
		end, bundles)

		local function get_jdk_homes()
			local homes = {}
			-- Prefer OpenJDK 21
			local jdk21 = "/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home"
			if vim.fn.isdirectory(jdk21) == 0 then
				jdk21 = vim.env.HOME .. "/.jdks/temurin21/Contents/Home"
			end
			if vim.fn.isdirectory(jdk21) == 1 then
				homes["21"] = jdk21
			end

			-- Homebrew OpenJDK (unversioned, currently JDK 27)
			local jdk_default = "/opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home"
			if vim.fn.isdirectory(jdk_default) == 1 then
				homes["default"] = jdk_default
			end

			return homes
		end

		-- jdtls needs JDK 21+. Prioritize JDK 21 to avoid mismatched compiler versions.
		local function java_executable()
			local homes = get_jdk_homes()
			if homes["21"] and vim.fn.executable(homes["21"] .. "/bin/java") == 1 then
				return homes["21"] .. "/bin/java"
			end
			if vim.env.JAVA_HOME and vim.fn.executable(vim.env.JAVA_HOME .. "/bin/java") == 1 then
				return vim.env.JAVA_HOME .. "/bin/java"
			end
			if homes["default"] and vim.fn.executable(homes["default"] .. "/bin/java") == 1 then
				return homes["default"] .. "/bin/java"
			end
			local sys_java = vim.fn.exepath("java")
			if sys_java and sys_java ~= "" then
				return sys_java
			end
		end

		local function get_root()
			local bufname = vim.api.nvim_buf_get_name(0)
			if bufname == "" then
				return nil
			end
			local markers = {
				"mvnw",
				"gradlew",
				"pom.xml",
				"build.gradle",
				"build.gradle.kts",
				"settings.gradle",
				".idea",
				".project",
				".classpath",
				".git",
			}
			local root = vim.fs.root(0, markers)
			if not root then
				root = vim.fs.root(0, { "src" })
			end
			if not root then
				root = vim.fs.dirname(bufname)
			end
			return root
		end

		local function build_runtimes()
			local homes = get_jdk_homes()
			local runtimes = {}
			if homes["21"] then
				table.insert(runtimes, {
					name = "JavaSE-21",
					path = homes["21"],
					default = true,
				})
			end
			if homes["default"] then
				table.insert(runtimes, {
					name = "JavaSE-27",
					path = homes["default"],
				})
			end
			return runtimes
		end

		local function get_workspace_dir(root)
			local project_name = vim.fs.basename(root)
			local hash = vim.fn.sha256(root):sub(1, 8)
			return vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name .. "_" .. hash
		end

		local function start()
			local root = get_root()
			if not root then
				return
			end

			local workspace = get_workspace_dir(root)

			-- Lombok is common in Spring Boot. If present, attach the agent.
			local lombok = mason .. "/packages/jdtls/lombok.jar"
			local cmd = { mason .. "/bin/jdtls", "-data", workspace }
			local java = java_executable()
			if java then
				table.insert(cmd, "--java-executable=" .. java)
			else
				vim.notify("jdtls: no JDK found (brew install openjdk@21)", vim.log.levels.ERROR)
				return
			end
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
						configuration = {
							updateBuildConfiguration = "interactive",
							runtimes = build_runtimes(),
						},
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

		vim.api.nvim_create_user_command("JdtCleanWorkspace", function()
			local root = get_root()
			if not root then
				vim.notify("jdtls: could not determine project root", vim.log.levels.WARN)
				return
			end
			local ws = get_workspace_dir(root)
			vim.fn.delete(ws, "rf")
			vim.notify("jdtls: deleted workspace cache: " .. ws, vim.log.levels.INFO)
		end, { desc = "Clean JDTLS workspace cache for current project" })

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
