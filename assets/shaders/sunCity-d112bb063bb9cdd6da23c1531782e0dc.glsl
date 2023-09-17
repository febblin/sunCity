#ifdef GL_ES
#define LOWP lowp
precision mediump float;
#else
#define LOWP
#endif
varying LOWP vec4 v_color;
varying vec2 v_texCoords;
uniform sampler2D u_texture;
uniform vec2 resolution;
uniform float time;

vec3 palette( float t, vec3 a, vec3 b, vec3 c, vec3 d) {
    return a + b * cos( 6.28318 * (c * t + d));
}

vec3 palette_a( float t) {
    return palette(t, vec3(.5,.5,.5), vec3(.5,.5,.5), vec3(1.,1.,1.), vec3(.263,.416,.557));
}

void main(){
    vec2 uv = gl_FragCoord.xy  / resolution;
    uv -= .5;
    uv *= 2.0;
    uv.x *= resolution.x / resolution.y;
    vec2 uv0 = uv;
    vec2 sUV = uv-vec2(.25, .5);

    float d = length(sUV);
    float val = smoothstep(0.3, 0.29, d);
    float bloom = smoothstep(0.7, 0.0, d/2.);
    float cut = 3.0 * sin((sUV.y - time * 0.08 * 1) * 100.0) + clamp(sUV.y * 15.0 + 1.0, -6.0, 6.0);
    cut = clamp(cut, 0.0, 1.0);
    vec3 outColor = vec3(clamp(val * cut, 0.0, 1.0) + bloom * 0.6);

//    float step = uv.x+time/15;
//    float c1 = step(.25, step)-step(.75, step);
//    float c2 = c1 * (1 - step(.5, uv.y));
//    outColor *= vec3(c2);

    if (uv0.y<0){
        uv0.y = 1.0 / (abs(uv0.y));
        uv0.x *= uv0.y;

        vec2 size = vec2(uv0.y, uv0.y * uv0.y * .2) * 0.01;
        uv0 += vec2(time * 4.0 * (.5), .0);
        uv0 = abs(fract(uv0) - 0.5);
        vec2 lines = smoothstep(size, vec2(0.0), uv0);
        lines += smoothstep(size * 5.0, vec2(0.0), uv0) * 0.4;
        outColor *= clamp(lines.x + lines.y, 0.0, 3.0);

    } else if (uv0.y >= .0){
//        outColor = max(outColor, sin((uv0.x+time))+1);
//        outColor += vec3(smoothstep(0., 0.7, sin(floor(uv0.x+time))/5));
    }

    gl_FragColor = vec4(outColor, 1.);
}