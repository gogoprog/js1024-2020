import js.Browser.window;

@:native("")
extern class Shim {
    @:native("a") static var canvas:js.html.CanvasElement;
    @:native("c") static var context:js.html.CanvasRenderingContext2D;
}

class Main {
    static function main() {
        var screenSize = 512;
        Shim.canvas.width = Shim.canvas.height = screenSize;
        var rseed;
        var mx = 0;
        var time:Int = 0;
        var m = Math;
        var abs = m.abs;
        var sin = m.sin;
        var cos = m.cos;
        var horizon:Float = 512 * 0.75;
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
            var x = (sin(rseed++) + 1) * 9999;
            return x - Std.int(x);
        }
        untyped onmousedown = untyped onmouseup = function(e) {
        }
        untyped onmousemove = function(e) {
            mx = e.clientX;
        }
        function getn(arr:Dynamic) {
            var n = arr.length;

            for(i in 0...n) {
                if(arr[i].t > 666 || abs(arr[i].y) > screenSize*2) {
                    return i;
                }
            }

            return n;
        }
        var gradient = Shim.context.createLinearGradient(0, 0, 0, screenSize);
        gradient.addColorStop(0, "#116");
        gradient.addColorStop(1, "#A9D");
        function loop(t:Float) {
            col(gradient);
            drawRect(256, 256, screenSize, screenSize);
            alpha(1);
            col("#6bf");
            drawCircle(screenSize/2, horizon, 128);
            col("#57c");
            var a = (time/2) % 32;

            for(i in 0...20) {
                var h = 24 + random() * 40;
                rseed = Std.int(time/2/32) + i;
                drawRect(i * 32 - a, horizon - h/2, 16 + random() * 16, h);
            }

            {
                col("#128");
                drawRect(screenSize/2, horizon, screenSize, 16);
                var a = time%32;

                for(i in 0...20) {
                    rseed = Std.int(time/32) + i;
                    drawRect(i * 32 - a, horizon, 16 + random() * 16, 48 + random() * 64);
                }
            }

            col("#aaa");
            alpha(0.4);
            drawRect(256, horizon + 64, screenSize, 128);
            time++;
            untyped requestAnimationFrame(loop);
        }
        loop(0);
    }
}
