LOI = LandsOfIllusions

class LOI.Engine.Materials.SpriteMaterial extends THREE.ShaderMaterial
  constructor: (options = {}) ->
    super
      lights: true
      side: THREE.DoubleSide
      shadowSide: THREE.DoubleSide

      uniforms: _.extend
        # Globals
        renderSize:
          value: new THREE.Vector2

        # Color information
        palette:
          value: LOI.paletteTexture

        # Shading
        smoothShading:
          value: options.smoothShading or false
        directionalShadowColorMap:
          value: []
        directionalOpaqueShadowMap:
          value: []
        preprocessingMap:
          value: null

        # Texture
        map:
          value: null
        normalMap:
          value: null
        uvTransform:
          value: new THREE.Matrix3
      ,
        THREE.UniformsLib.lights

      vertexShader: """
#include <common>
#include <uv_pars_vertex>
#include <shadowmap_pars_vertex>

void main()	{
	#include <uv_vertex>
  #include <begin_vertex>
	#include <project_vertex>
  #include <worldpos_vertex>
	#include <shadowmap_vertex>
}
"""

      fragmentShader: """
#include <common>
#include <uv_pars_fragment>
#include <map_pars_fragment>
#include <normalmap_pars_fragment>
#include <packing>
#include <lights_pars_begin>
#include <shadowmap_pars_fragment>

#{LOI.Engine.Materials.ShaderChunks.ditherParametersFragment}

// Globals
uniform vec2 renderSize;

// Color information
uniform sampler2D palette;
#{LOI.Engine.Materials.ShaderChunks.paletteParametersFragment}

// Shading
uniform bool smoothShading;
#{LOI.Engine.Materials.ShaderChunks.totalLightIntensityParametersFragment}
uniform sampler2D preprocessingMap;

uniform mat4 modelViewMatrix;

void main()	{
  // Read palette color from main map.
  vec4 sample = texture2D(map, vUv);

  // Discard transparent pixels.
  if (sample.a < 1.0) discard;

  // Palette color (ramp and shade) is stored in the red and green channels.
  vec2 paletteColor = sample.rg;
  paletteColor = (paletteColor * 255.0 + 0.5) / 256.0;

  // Read normal from normal map.
  vec3 spriteNormal = texture2D(normalMap, vUv).xyz * 2.0 - 1.0;
  vec3 normal = normalize((modelViewMatrix * vec4(spriteNormal, 0.0)).xyz);

  // Calculate total light intensity. This step also tints the palette color based
  // on shadow color, so we have to do it before applying tinting in preprocessing.
  #{LOI.Engine.Materials.ShaderChunks.totalLightIntensityFragment}

  // Apply preprocessing info.
  #{LOI.Engine.Materials.ShaderChunks.applyPreprocessingFragment}

  // Get actual RGB values for this palette color.
  #{LOI.Engine.Materials.ShaderChunks.readSourceColorFromPaletteFragment}

  // Calculate the shaded color.
  #{LOI.Engine.Materials.ShaderChunks.shadeSourceColorFragment}

  // Bound shaded color to palette ramp.
  float ramp = paletteColor.r;
  float dither = sample.b;
  vec3 destinationColor = boundColorToPaletteRamp(shadedColor, ramp, dither, smoothShading);

  // Color the pixel with the best match from the palette.
  gl_FragColor = vec4(destinationColor, 1);
}
"""

    @options = options
