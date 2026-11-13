Todo:
- make sky(dir) + a more realistic one too
	- hosek-wilkie, brunetone? or hillaire?
- add sky lighting instead of just from lightmap, maybe use spherical harmonics pre compute

- add back sunrays
- Add tonemap
- add water/liquid rendering
- Implement fullscreen final pass **TAA**, mainly to learn filtering. so i can use it in the future on noise prone features.
	- Investigate and study TAA shaders to see how they work. 
- add back ssr 
	- compute low res reflected uv, dist/blur
	- resolve low res reflected uv and composite
	- possibly generate a low res depth map so more cache hits, possibly using compute shared mem to downsample

todo improve:
- soft shadows
	- soft shadow algo other than pcf, as pcf isnt cheap especially for large radius
	- pcss/variable penumbra shadows
	- add PCF colored lighting which does a single/fewer color tap, where full does tap per pcf sample


todo after all port:
- add mip bloom
    - spiral mip
- clouds
	- Normal, and simple volumetric
- Reflective shadow maps, provides single bounce indirect lighting
	- Store (position), normals, color as extra info on shadowmap
- (Cascaded) Light propagation volumes