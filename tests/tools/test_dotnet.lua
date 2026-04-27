--
-- tests/tools/test_dotnet.lua
-- Automated test suite for the .NET toolset interface.
-- Copyright (c) 2012-2013 Jess Perkins and the Premake project
--

	local p = premake
	local suite = test.declare("tools_dotnet")
	local dotnet = p.tools.dotnet


--
-- Setup/teardown
--

	local wks, prj, cfg

	function suite.setup()
		wks, prj = test.createWorkspace()
	end

	local function prepare()
		cfg = test.getconfig(prj, "Debug")
	end


--
-- On Windows, use Microsoft's CSC compiler by default.
--

	function suite.defaultCompiler_onWindows()
		_TARGET_OS = "windows"
		prepare()
		test.isequal("csc", dotnet.gettoolname(cfg, "csc"))
	end


--
-- Everywhere other than Windows, use Mono by default.
--

	function suite.defaultCompiler_onMacOSX()
		_TARGET_OS = "macosx"
		prepare()
		test.isequal("csc", dotnet.gettoolname(cfg, "csc"))
	end


--
-- Check support for the `csversion` API
--

function suite.flags_csversion()
	prepare()
	csversion "7.2"
	test.contains({ "/langversion:7.2" }, dotnet.getflags(cfg))
end


	-- Explicit buildaction "Page" must produce "Page" even when the filename is "App.xaml"
	function suite.fileinfo_xaml_explicitPage_withAppFilename()
		local fcfg = {
			abspath = "App.xaml",
			buildaction = "Page",
			project = { kind = p.CONSOLEAPP, _ = { files = {} } },
		}
		local info = dotnet.fileinfo(fcfg)
		test.isequal("Page", info.action)
	end

	-- Explicit buildaction "Application" produces "ApplicationDefinition".
	function suite.fileinfo_xaml_explicitApplication()
		local fcfg = {
			abspath = "MyWindow.xaml",
			buildaction = "Application",
			project = { kind = p.CONSOLEAPP, _ = { files = {} } },
		}
		local info = dotnet.fileinfo(fcfg)
		test.isequal("ApplicationDefinition", info.action)
	end

	-- Any other valid buildaction (here "None") with filename "App.xaml" triggers
	-- the filename heuristic and produces "ApplicationDefinition".
	function suite.fileinfo_xaml_otherBuildaction_appFilenameHeuristic()
		local fcfg = {
			abspath = "App.xaml",
			buildaction = "None",
			project = { kind = p.CONSOLEAPP, _ = { files = {} } },
		}
		local info = dotnet.fileinfo(fcfg)
		test.isequal("ApplicationDefinition", info.action)
	end
