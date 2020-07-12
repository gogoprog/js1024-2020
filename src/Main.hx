import js.Browser.window;

@:native("")
extern class Shim {
    @:native("a") static var canvas:js.html.CanvasElement;
    @:native("c") static var context:js.html.CanvasRenderingContext2D;
}

typedef Entity = {
    var x:Float;
    var y:Float;
    var r:Int;
}

class Main {
    static inline var screenSize = 512;
    static inline var mx = 64;
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
        var life = 100;
        var speed = 1;
        var distance = 0;
        function scale(s) {
            Shim.context.scale(s, s);
        }
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
            Shim.context.arc(x, y, r, 0, 7);
            Shim.context.fill();
        }
        function random():Float {
            var x = (sin(rseed++) + 1) * 99;
            return x - Std.int(x);
        }
        untyped onmousemove = function(e) {
            my = m.min(screenSize/2, e.clientY);
        }
        function spawn(x, y, r) {
            entities[entities.length] = {x:x, y:y, r:r};
        }
        function addColorStop(gradient, f, col) {
            gradient.addColorStop(f, col);
        }
        inline function drawShip() {
            col("#111");
            drawRect(mx, my, 32, 16);
            drawRect(mx - 24, my + 9, 16, 9);
            drawRect(mx - 24, my - 9, 16, 9);
        }
        var gradient = Shim.context.createLinearGradient(0, 0, 0, screenSize);
        addColorStop(gradient, 0, "#116");
        addColorStop(gradient, 0.75, "#A9D");
        addColorStop(gradient, 1, "#003");
        function drawBuildings(f, vmirror:Bool, hmax) {
            var a = (distance/f) % 32;

            for(i in 0...20) {
                rseed = Std.int((distance/ f)/32) + i;
                var h = 24 + random() * hmax;
                var w = 16+ random() * 16;
                drawRect(i * 32 - a, horizon - (vmirror ? 0 : h/2), w, h);
                var h = h + random() * 32;
                drawRect(i * 32 - a - w/2 + random() * w, horizon - (vmirror ? 0 : h/2), 4 + random() * 4, h);
            }
        }
        inline function isEnemy(e) {
            return e.r != 4;
        }
        inline function isCoin(e) {
            return e.r == 4;
        }
        function loop(t:Float) {
            {
                // World
                col(gradient);
                drawRect(screenSize/2, screenSize/2, screenSize, screenSize);
                col("#6bf");
                drawCircle(screenSize/2, horizon, 128);
                col("#57c");
                drawBuildings(4, false, 40);
                col("#128");
                drawRect(screenSize/2, horizon, screenSize, 16);
                drawBuildings(2, true, 75);
            }
            {
                // Ship and coins
                drawShip();

                if(distance % 32 == 0) {
                    spawn(screenSize*1.2, random() * 256, random() < 0.5 ? 4 : 16);
                }

                for(e in entities) {
                    col("#c" + (isCoin(e)? "f0" : "11"));
                    drawCircle(e.x, e.y, e.r);
                    e.x -= speed;

                    if(abs(e.x - mx) + abs(e.y - my) < 32) {
                        e.x = -screenSize;
                        life += isCoin(e) ? 1 : -10;
                    }
                }
            }
            {
                // Water reflection
                col("#fff");
                alpha(0.5);
                drawRect(screenSize/2, horizon + screenSize/8, screenSize, screenSize/4);
            }
            {
                time++;
                distance += speed;

                if(life > 0) {
                    untyped requestAnimationFrame(loop);
                } else {
                    untyped life = "LOST";
                }

                if(time % 64 == 0) {
                    speed++;
                }
            }
            {
                // Hud
                alpha(1);
                col("#000");
                scale(4);
                Shim.context.fillText(untyped life, 32/4, 122);
                scale(1/4);
            }
        }
        loop(0);
    }
}
