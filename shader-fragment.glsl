precision mediump float;

uniform sampler2D texture;

uniform float zoomFactor;
uniform vec2 zoomCenter;

uniform float zoom;
uniform vec2 ctrl;

uniform float escherAngle;
uniform float escherScale;
uniform float plotPolar;

varying vec2 uvCoord;

#define PI 3.141

vec2 rot(vec2 subject, float rad, vec2 pivot) {
    mat2 rot = mat2(cos(rad), -sin(rad), sin(rad), cos(rad));
    return rot * (subject - pivot) + pivot;
}

vec2 rescale(vec2 subject, float factor) {
    float max = 2.0 * max(abs(subject.x), abs(subject.y)) + 1e-8;
    float l = log(max) / log(factor);
    float k = floor(-l);
    float scale = pow(factor, k);

    return subject * scale;
}

void main() {
    vec2 uvCentered = (uvCoord - 0.5);

    vec2 uvPolar = vec2(
            log(length(uvCentered)) / log(zoomFactor),
            atan(uvCentered.y, uvCentered.x) / PI
        ) / 2.0;

    vec2 polarOrOriginal = mix(uvPolar, vec2(uvCentered.y * PI / 4.0 * 2.0 , uvCentered.x * PI / 4.0), plotPolar);
    vec2 zoomInLog = rot(vec2(1.0, 0.0), -(escherAngle + ctrl.x), vec2(0.0, 0.0)) * 0.1 * zoom;
    vec2 rotated = rot(polarOrOriginal + zoomInLog, escherAngle + ctrl.x, vec2(0.0));
    vec2 rotScaled = rotated * (escherScale + ctrl.y) - 0.5;

    float rad = mod(2.0 * rotScaled.x, 1.0);

    vec2 cartesian = vec2(
            cos(2.0 * PI * rotScaled.y),
            sin(2.0 * PI * rotScaled.y)
        ) * exp(rad * log(zoomFactor)) / log(zoomFactor);

    vec2 finalUV = rescale(cartesian, zoomFactor) + 0.5 + zoomCenter;

    vec4 imageColor = texture2D(texture, finalUV);

    gl_FragColor = imageColor;
}
