precision mediump float;

attribute vec2 position;
uniform vec2 ctrl;
uniform float zoom;
uniform float sheer;
uniform vec2 offset;
uniform float rotation;

uniform float plotPolar;

varying vec2 uvCoord;

vec2 rot(vec2 subject, float rad, vec2 pivot) {
    mat2 rot = mat2(cos(rad), -sin(rad), sin(rad), cos(rad));
    return rot * (subject - pivot) + pivot;
}

void main() {
    uvCoord = rot(position + vec2(offset.x, -offset.y) * 0.5, rotation, vec2(0.5));
    uvCoord += vec2(0.0, (uvCoord.x - 0.5) * mix(sheer, 0.0, plotPolar));

    gl_Position = vec4(1.0 - 2.0 * position, 0, 1);
}
