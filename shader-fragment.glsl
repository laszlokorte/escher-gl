precision mediump float;
uniform sampler2D texture;
uniform float zoomFactor;
uniform vec2 zoomCenter;
uniform float zoomClamped;
uniform float zoom;
uniform float zoomCylic;
uniform float sheer;
uniform vec2 ctrl;
uniform vec2 offset;
varying vec2 uvOrig;
uniform float rotation;
uniform float escherAngle;
uniform float escherScale;
uniform float warp;
uniform float plotPolar;
void main() {
    vec2 rotoffset = vec2(
            cos(rotation) * offset.x - sin(rotation) * offset.y,
            sin(rotation) * offset.x + cos(rotation) * offset.y
        );

    vec2 d = (uvOrig - 0.5) * 2.0 + rotoffset;

    vec2 polar = vec2(
            atan(d.y, d.x) / (3.141),
            log(length(d)) / log(zoomFactor)
        );

    vec2 cpos = mix(polar, d, plotPolar);
    vec2 uvShifted = vec2(
            cpos.x * cos(escherAngle + ctrl.x) - cpos.y * sin(escherAngle + ctrl.x),
            cpos.x * sin(escherAngle + ctrl.x) + cpos.y * cos(escherAngle + ctrl.x)
        ) / 2.0 * (escherScale + ctrl.y) + vec2(escherAngle + ctrl.x, escherScale + ctrl.y) * zoom * 0.1 - 0.5;

    float rad = 1.0 / zoomFactor / 1.0 + (1.0 - 1.0 / zoomFactor) * mod(2.0 * uvShifted.y, 1.0);

    vec2 cc = vec2(
            // TODO figure out the rad factor
            0.5 + cos(2.0 * 3.141 * uvShifted.x) * exp(rad * (exp(1.0) + 0.24)) / log(zoomFactor),
            0.5 + sin(2.0 * 3.141 * uvShifted.x) * exp(rad * (exp(1.0) + 0.24)) / log(zoomFactor)
        );

    vec2 uvv = cc;
    if (abs(uvv.x - 0.5) * 2.0 < 1.0 / zoomFactor / zoomFactor && abs(uvv.y - 0.5) * 2.0 < 1.0 / zoomFactor / zoomFactor) {
        uvv = (uvv - 0.5) * zoomFactor * zoomFactor + 0.5;
    } else if (abs(uvv.x - 0.5) * 2.0 < 1.0 / zoomFactor && abs(uvv.y - 0.5) * 2.0 < 1.0 / zoomFactor) {
        uvv = (uvv - 0.5) * zoomFactor + 0.5;
    } else if (abs(uvv.x - 0.5) > 0.5 || abs(uvv.y - 0.5) > 0.5) {
        uvv = (uvv - 0.5) / zoomFactor + 0.5;
    }
    uvv = uvv + zoomCenter;

    vec4 sharp = texture2D(texture, uvv);

    vec2 dm = uvOrig - 0.5;
    float r = length(dm);
    float mask = smoothstep(0.1, 0.1, r);
    gl_FragColor = sharp;
}
