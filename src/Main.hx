import js.Browser.document;
import js.Browser.window;

class Main {
    static function main() {
        var w = window;
        var c:js.html.CanvasElement = cast w.document.querySelector("canvas");
        var screenSize = 512;
        c.width = c.height = screenSize;
        var ctx:js.html.CanvasRenderingContext2D = c.getContext("2d");
        var lastFireTime:Int;
        var rseed;
        var mx= 0;
        var time:Int = 0;
        var m = Math;
        var abs = m.abs;
        var sin = m.sin;
        var cos = m.cos;
        var horizon:Float = 512 * 0.75;
        function col(n:Dynamic) {
            ctx.fillStyle = n;
        }
        function alpha(n) {
            ctx.globalAlpha = n;
        }
        function scale(s) {
            ctx.scale(s, s);
        }
        function drawRect(x:Float, y:Float, w:Float, h:Float) {
            ctx.fillRect(x-w/2, y-h/2, w, h);
        }
        function mto(x, y) {
            ctx.moveTo(x, y);
        }
        function lto(x, y) {
            ctx.lineTo(x, y);
        }
        function beginPath() {
            ctx.beginPath();
        }
        function fill() {
            ctx.fill();
        }
        function drawCircle(x, y, r) {
            beginPath();
            ctx.arc(x, y, r, 0, 6.28);
            fill();
        }
        function random():Float {
            var x = (sin(rseed++) + 1) * 9999;
            return x - Std.int(x);
        }
        w.onmousedown = w.onmouseup = function(e) {
        }
        w.onmousemove = function(e) {
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
        var gradient = ctx.createLinearGradient(0, 0, 0, screenSize);
        gradient.addColorStop(0, "#116");
        gradient.addColorStop(1, "#A9D");
        function loop(t:Float) {
            // col("#33B");
            col(gradient);
            drawRect(256, 256, screenSize, screenSize);
            alpha(1);
            rseed = 1;
            col("#fff");
            // for(i in 0...99) {
            //     drawRect(random() * screenSize, (random() * screenSize + t * (random() * 0.2)) % screenSize, 2, 2);
            // }
            col("#6bf");
            drawCircle(screenSize/2, horizon, 128);
            col("#57c");

            for(i in 0...20) {
                var h = 24 + random() * 40;
                drawRect(i * 32 - mx * 0.05, horizon - h/2, 16 + random() * 16, h);
            }

            col("#128");
            drawRect(screenSize/2, horizon, screenSize, 16);

            for(i in 0...20) {
                drawRect(i * 32 - mx * 0.1, horizon, 16 + random() * 16, 48 + random() * 64);
            }

            col("#aaa");
            alpha(0.4);
            drawRect(256, horizon + 64, screenSize, 128);
            time++;
            w.requestAnimationFrame(loop);
        }
        loop(0);
    }
}
