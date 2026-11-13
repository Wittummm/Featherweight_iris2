<!---
The shader developer should make use of Issues(bugs), Discussions(ideas), and Pull Requests(changes) especially when it is significant to do so and when not in a dev version.
-->

Version: v0.x.x.x.Dev (Refer to changelog as pre v1 is volatile)

### Version Phases
Major.Minor.Revision.Patch.Tag, pre v1 versions are highly volatile.
 - Dev - Unstable
 - Alpha - Core mechanics
 - Beta

### Branches
 - `main` stable releases
 - `dev` unstable releases
 - `v0.0.0.0_feature-some-feature` for working on features
 - `v0.0.0.0_patch-some-patch` for working on patches (Uncommon unless issue is hard to patch)

### Notes, Caution

### Change Logs Summary
- 0.1.0.0, 2026/10/8, Initial port from old Featherweight, most code is reviewed and core functions are rewritten.
	- Deferred opaques
	- LabPBR PBR Support
	- Hammon diffuse, GGX Specular, Simple skylight contribution
	- No sky currently
	- Nearest, Linear, PCF shadows
		- Shadow bias based on distort factor, some slope bias
	- Debug Mode
- 0.2.0.0, 2026/10/13, Building up features
	- Reworked shadow code so it is more scalable. Uses more broken down functions
	- Colored Shadows(RGB565), No proper blending, first render first color. Works properly with PCF