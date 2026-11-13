# Featherweight_iris2
Featherweighted for Iris 2nd attempt

Written on Latest Iris VK. No specific support fot Optifine or Iris 1.8-

For developers, I highly recommend reading docs.md as it overviews how this shader is written. There is A LOT of proprietary styles/code, because Featherweight has a shader-defined patcher(just #defines), which adds "custom" behavior. This is used to abstract away from the Optifine/Iris pipeline. Notably `version.glsl` and `custom_pipeline.glsl`. I aim to make this pack as independant from the Optifine pipeline as possible.