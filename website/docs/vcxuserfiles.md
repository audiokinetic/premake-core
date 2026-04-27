Controls the generation of the Visual Studio `.vcxproj.user` file for a project.

```lua
vcxuserfiles ("value")
```

By default, Premake generates a `.vcxproj.user` file only when it would contain content. This setting allows you to override that behavior by suppressing or forcing generation of the file.

### Parameters ###

`value` specifies the desired generation behavior; one of the following:

| Value   | Description                                                                        |
|---------|------------------------------------------------------------------------------------|
| Default | Generate a `.vcxproj.user` file only when it would contain content.                |
| Omit    | Suppress `.vcxproj.user` generation entirely.                                      |
| Force   | Always generate a `.vcxproj.user` file, even when it would be empty.               |

### Applies To ###

Projects.

### Availability ###

Premake 5.0.0 or later. Visual Studio (vstudio) action only.

### Examples ###

```lua
-- Always generate the user file, even when empty
vcxuserfiles "Force"
```

```lua
-- Never generate a user file
vcxuserfiles "Omit"
```

### See Also ###

* [vcxfiltersfiles](vcxfiltersfiles.md)
