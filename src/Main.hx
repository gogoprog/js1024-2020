import js.Browser.window;

@:native("")
extern class Shim {
    @:native("a") static var canvas:js.html.CanvasElement;
    @:native("c") static var context:js.html.CanvasRenderingContext2D;
}

typedef Entity = {
    var x:Float;
    var y:Float;
    var d:Int;
}

class Main {
    static inline var screenSize = 512;
    static function main() {
        Shim.canvas.width = Shim.canvas.height = screenSize;
        var rseed;
        var my = 0;
        var time:Int = 0;
        var m = Math;
        var abs = m.abs;
        var sin = m.sin;
        var cos = m.cos;
        var horizon:Float = screenSize * 0.75;
        var entities = new Array<Entity>();
        function col(n:Dynamic) {
            Shim.context.fillStyle = n;
        }
        function alpha(n) {
            Shim.context.globalAlpha = n;
        }
        function drawRect(x:Float, y:Float, w:Float, h:Float) {
            Shim.context.fillRect(x-w/2, y-h/2, w, h);
        }
        function drawCircle(x, y, r) {
            Shim.context.beginPath();
            Shim.context.arc(x, y, r, 0, 6.28);
            Shim.context.fill();
        }
        function random():Float {
            var x = (sin(rseed++) + 1) * 99;
            return x - Std.int(x);
        }
        untyped onmousedown = untyped onmouseup = function(e) {
        }
        untyped onmousemove = function(e) {
            my = m.min(screenSize * 0.7, e.clientY);
        }
        function spawn(x, y, d) {
            entities[entities.length] = {x:x, y:y, d:d};
        }
        function addColorStop(gradient, f, col) {
            gradient.addColorStop(f, col);
        }
        inline function drawShip() {
            col("#111");
            drawRect(64, my, 32, 16);
            drawRect(40, my + 9, 16, 9);
            drawRect(40, my - 9, 16, 9);
        }
        var gradient = Shim.context.createLinearGradient(0, 0, 0, screenSize);
        addColorStop(gradient, 0, "#116");
        addColorStop(gradient, 0.75, "#A9D");
        addColorStop(gradient, 1, "#003");
        function drawBuildings(f, vmirror:Bool, hmax) {
            var a = (time/f) % 32;

            for(i in 0...20) {
                rseed = Std.int((time / f)/32) + i;
                var h = 24 + random() * hmax;
                var w = 16+ random() * 16;
                drawRect(i * 32 - a, horizon - (vmirror ? 0 : h/2), w, h);
                var h = h + random() * 32;
                drawRect(i * 32 - a - w/2 + random() * w, horizon - (vmirror ? 0 : h/2), 4 + random() * 4, h);
            }
        }
        function loop(t:Float) {
            {
                // World
                col(gradient);
                drawRect(screenSize/2, screenSize/2, screenSize, screenSize);
                alpha(1);
                col("#6bf");
                drawCircle(screenSize/2, horizon, 128);
                col("#57c");
                drawBuildings(2, false, 40);
                col("#128");
                drawRect(screenSize/2, horizon, screenSize, 16);
                drawBuildings(1, true, 75);
            }
            {
                // Ship and coins
                drawShip();
                col("#fff");

                if(time % 32 == 0) {
                    spawn(screenSize*1.2, random() * 256, 0);
                }

                for(e in entities) {
                    drawCircle(e.x, e.y, 4);
                    e.x -= 2;
                }
            }
            {
                // Water reflection
                alpha(0.3);
                drawRect(screenSize/2, horizon + screenSize/8, screenSize, screenSize/4);
            }
            {
                time++;
                untyped requestAnimationFrame(loop);
            }
        }
        loop(0);
    }
}
