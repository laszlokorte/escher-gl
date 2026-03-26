
precision mediump float;
attribute vec2 position;
uniform vec2 ctrl;
uniform float zoom;
uniform float rotation;
varying vec2 uvOrig;
void main() {
    vec2 cp = vec2(position.x, 1.0 - position.y) - 0.5;
    uvOrig = vec2(
            cp.x * cos(rotation) - cp.y * sin(rotation),
            cp.x * sin(rotation) + cp.y * cos(rotation)
        ) + 0.5;
    gl_Position = vec4(1.0 - 2.0 * position, 0, 1);
}
