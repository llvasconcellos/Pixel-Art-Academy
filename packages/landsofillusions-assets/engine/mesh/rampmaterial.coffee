LOI = LandsOfIllusions

class LOI.Assets.Engine.Mesh.RampMaterial extends THREE.ShaderMaterial
  constructor: (@options) ->
    shades = (THREE.Color.fromObject shade for shade in @options.shades)

    super
      lights: true

      uniforms: _.extend
        shades:
          type: 'c'
          value: shades
      ,
        THREE.UniformsLib.lights

      vertexShader: """
#include <shadowmap_pars_vertex>

varying vec3 normalEye;

void main()	{
  normalEye = normalize((modelViewMatrix * vec4(normal, 0.0)).xyz);

  vec4 worldPosition = modelMatrix * vec4(position, 1.0);
  gl_Position = projectionMatrix * viewMatrix * worldPosition;

  // Shadow map.
  #{THREE.ShaderChunk.shadowmap_vertex}
}
"""

      fragmentShader: """
#include <common>
#include <packing>
#include <lights_pars_begin>
#include <shadowmap_pars_fragment>

uniform vec3 shades[#{@options.shades.length}];

varying vec3 normalEye;

void main()	{
  vec3 sourceColor = shades[#{@options.shadeIndex}];

  // Shade color based on the normal.
  float lightIntensity = 0.0;

  DirectionalLight directionalLight;

  for (int i = 0; i < NUM_DIR_LIGHTS; i++) {
    directionalLight = directionalLights[i];

    // Shade using Lambert cosine law.
    lightIntensity += dot(directionalLight.direction, normalEye);

    // Apply shadow map.
    lightIntensity *= getShadow(directionalShadowMap[i], directionalLight.shadowMapSize, directionalLight.shadowBias, directionalLight.shadowRadius, vDirectionalShadowCoord[0]);
  }

  float shadeFactor = ambientLightColor.r + 0.6 * clamp(lightIntensity, 0.0, 1.0);

  vec3 shadedColor = sourceColor * shadeFactor;

  // Find the nearest color from the palette to represent the shaded color.
  vec3 bestColor;
  vec3 secondBestColor;
  float bestColorDistance = 1000000.0;
  float secondBestColorDistance = 1000000.0;

  for (int shadeIndex = 0; shadeIndex < #{@options.shades.length}; shadeIndex++) {
    vec3 shade = shades[shadeIndex];
    // Note: We intentionally use squared distance.
    float distance = distance(shade, shadedColor);

    if (distance < bestColorDistance) {
      secondBestColor = bestColor;
      secondBestColorDistance = bestColorDistance;
      bestColor = shade;
      bestColorDistance = distance;
    } else if (distance < secondBestColorDistance) {
      secondBestColor = shade;
      secondBestColorDistance = distance;
    }
  }

  gl_FragColor = vec4(bestColor, 1);
}
"""
