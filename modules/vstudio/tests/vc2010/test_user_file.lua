--
-- tests/actions/vstudio/vc2010/test_user_file.lua
-- Verify handling of empty and non-empty .user files for VC'201x.
-- Copyright (c) 2015 Jess Perkins and the Premake project
--

	local p = premake
	local suite = test.declare("vstudio_vs2010_user_file")
	local vc2010 = p.vstudio.vc2010
	local vs2010 = p.vstudio.vs2010


--
-- Setup
--

	local wks

	function suite.setup()
		p.action.set("vs2010")
		wks = test.createWorkspace()
	end

	local function prepare()
		local prj = test.getproject(wks, 1)
		vc2010.generateUser(prj)
	end


--
-- If no debugger settings have been specified, then the .user
-- file should not be written at all.
--

	function suite.noOutput_onNoSettings()
		prepare()
		test.isemptycapture()
	end


--
-- If a debugger setting has been specified, output.
--

	function suite.doesOutput_onDebugSettings()
		debugcommand "bin/emulator.exe"
		prepare()
		test.hasoutput()
	end


--
-- Check the vcxuserfiles API controls whether .vcxproj.user is generated.
-- Uses a spy on p.generate to track which file extensions are requested.
--

	local function prepareProject()
		local calls = {}
		local origGenerate = p.generate
		p.generate = function(obj, ext, cb)
			table.insert(calls, ext)
			return false
		end
		vs2010.generateProject(test.getproject(wks, 1))
		p.generate = origGenerate
		return calls
	end

	function suite.vcxuserfiles_notGenerated_onDefault_withNoContent()
		-- Default behaviour: no debug settings → .vcxproj.user is NOT generated.
		local calls = prepareProject()
		test.excludes({ ".vcxproj.user" }, calls)
	end

	function suite.vcxuserfiles_generated_onDefault_withContent()
		-- Default behaviour: debug settings present → .vcxproj.user IS generated.
		debugcommand "bin/emulator.exe"
		local calls = prepareProject()
		test.contains({ ".vcxproj.user" }, calls)
	end

	function suite.vcxuserfiles_generated_onForce_withNoContent()
		-- Force: no debug settings, but file is always generated.
		vcxuserfiles "Force"
		local calls = prepareProject()
		test.contains({ ".vcxproj.user" }, calls)
	end

	function suite.vcxuserfiles_notGenerated_onOmit_withContent()
		-- Omit: debug settings present, but file generation is suppressed.
		debugcommand "bin/emulator.exe"
		vcxuserfiles "Omit"
		local calls = prepareProject()
		test.excludes({ ".vcxproj.user" }, calls)
	end
