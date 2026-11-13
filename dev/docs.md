Featherweight is written in the (fake) core profile, final code is actually compatiblity. The shader has a patcher that patches core to compat.
This shader is meant to be lightweight, as in the name. So every texture sample, memory acess, frame buffer format/size is carefully considered.

### Resources
#### FBOs
- `scene` R11 G11 B10
- `light` RG8, local light, sky light(indirect)
- `gbuffers` R32UI / RG32UI, semi/ full PBR
- `shadowColor` RGB565, stores transmitted rgb(premultiplied)

### Shader programs
Names listed here are final program names
- `deferred`, shade program
- `composite80`, debug program

### Defines
`filename_ext` marks that the file has been included and exists in the file. The casing is exact one to one match with file name.

settings

### Personal Naming Conventions
 - **Casing**
    - (Future Runtime) Settings values = PascalCase
    - Out buffers = PascalCase
    - Defines(Actual defines, even after patches) = UPPER_SNAKE_CASE
 - Light level = [0, 1]
 - Light Brightness = [0, ∞) adjusted for brightness
 - "Light" with no context refers to directional light ie sun/moon light
 - To avoid ambiguity we should avoid naming things with vague relation **especially** for objects. Examples:
  (Object) `playerPosition` could be intepreted likely as "position of the player" or unlikely "player space position". (Non-Object)`worldPosition` could be intepreted likely as "the position in the world" or unlikely "position of the world"(this is the unlikely case as we cant *usually* move worlds but objects such as players are moveable)
  Instead we should name things like `posPlayer`, `posWorld` meaning "position in player (space)" and "position in world (space)".

### Comment Tags
- Crediting(usu. for specific person, not public domain info)
  - `CREDIT: someName (someLink)`
  - `ACKNOWLEDGEMENT: someName (someLink)` More important/significant than CREDIT
  - `ACKNOWLEDGED: someName (someLink)` same as `ACKNOWLEDGEMENT` but is acknowledge in front page
  - `SOURCE:` or `SOURCES:` refers to original source code
- `POINT` a weak "NOTICE"
- `TODO` to do
- `TODOMAYBE` maybe do
- `TODONOW` ongoing code
- `TODOLATER` to do in the foreseeable future
- `TODONOWBUTLATER` should do at the end of the session/feature.
- `TODOEVENTUALLY` should do eventually
- `NOTE` a note for readers, including oneself
- `NOTE_PERF` note relating to performance
- `PIN` likely will come back to, usually to edit/add features
- `CODE: xxx` a random code(literally button mash) 
- `REMOVE` to remove for some reason
- `CONFIGTODO` to add this config to user accessible settings.
- `AP_ISSUE` an issue/bug with aperture
- `TEMP` temporary

### File Structure
    - `func` folder should contain **pipeline agnostic** code, meaning its pure glsl and not tied to any platform or pipeline. Name should follow function in file 1:1, if multiple functions exist then we can depart and use snake_case like normal.
    - `lib` folder usually contains functions relating to one category/field. Not required to be platform agnostic

### Shader Settings
As this shader is built to (hopefully, easily) support Aperture in the future. It leans more into Aperture than actual Iris. Settings that can be made into realtime will be `PascalCase` but non-realtime will still be `UPPER_SNAKE_CASE`. Note that a setting may have both casing as one is real time and other is not. For example: `ShadowsEnabled` and `SHADOWS_ENABLED` as it is still realtime, but if you reload it will recompile to optimize.