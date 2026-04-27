Controls the generation of the Visual Studio `.vcxproj.filters` file for a project.

```lua
vcxfiltersfiles ("value")
```

By default, Premake generates a `.vcxproj.filters` file only when the project's source tree contains subfolders. This setting allows you to override that behavior by suppressing or forcing generation of the file.

### Parameters ###

`value` specifies the desired generation behavior; one of the following:

| Value   | Description                                                                        |
|---------|------------------------------------------------------------------------------------|
| Default | Generate a `.vcxproj.filters` file only when the source tree has subfolders.       |
| Omit    | Suppress `.vcxproj.filters` generation entirely.                                   |
| Force   | Always generate a `.vcxproj.filters` file, even when the source tree is flat.      |

### Applies To ###

Projects.

### Availability ###

Premake 5.0.0 or later. Visual Studio (vstudio) action only.

### Examples ###

```lua
-- Always generate the filters file, even for flat source trees
vcxfiltersfiles "Force"
```

```lua
-- Never generate a filters file
vcxfiltersfiles "Omit"
```

### See Also ###

* [vcxuserfiles](vcxuserfiles.md)
