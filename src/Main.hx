import js.Browser.document;
import js.Browser.window;

typedef Bullet = {
    var x:Float;
    var y:Float;
    var d:Int;
}

typedef Enemy = {
    var x:Float;
    var t:Float;
    var life:Int;
}

typedef Particle = {
    var x:Float;
    var y:Float;
    var t:Float;
}

typedef Bonus = {
    var x:Float;
    var y:Float;
    var b:Int;
}

class Main {
    static function main() {
        var w = window;
        var c:js.html.CanvasElement = cast w.document.querySelector("canvas");
        var screenSize = 512;
        c.width = c.height = screenSize;
        var ctx:js.html.CanvasRenderingContext2D = c.getContext("2d");
        var lastFireTime:Int;
        var rseed;
        var mx;
        var life:Int;
        var power:Int;
        var mustFire:Bool;
        var bullets:Array<Bullet>;
        var enemies:Array<Enemy>;
        var particles:Array<Particle>;
        var bonuses:Array<Bonus>;
        var time:Int = 0;
        var extremes = [-1, 1];
        var m = Math;
        var abs = m.abs;
        var sin = m.sin;
        var cos = m.cos;
        var state = 0;
        var score;
        var bestScore = 0;
        ctx.font = "20px monospace";
        function col(n) {
            ctx.fillStyle = n;
        }
        function alpha(n) {
            ctx.globalAlpha = n;
        }
        function scale(s) {
            ctx.scale(s, s);
        }
        function drawRect(x:Float, y:Float, w, h) {
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
        function circle(x, y, r) {
            beginPath();
            ctx.arc(x, y, r, 0, 6.28);
            fill();
        }
        function random():Float {
            var x = (sin(rseed++) + 1) * 9999;
            return x - Std.int(x);
        }
        w.onmousedown = w.onmouseup = function(e) {
            mustFire = untyped e.buttons;
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
        function fire(x, y, d) {
            bullets[getn(bullets)] = {x:x, y:y, d:d};
        }
        function ftext(a, b, c) {
            ctx.fillText(a, b, c);
        }
        function explode(x, y) {
            for(j in 0...36) {
                particles[getn(particles)] = {x:x, y:y, t:0};
            }

            untyped z(1, .05, 652, 1, .01, .6, 4, 71, .9);
        }
        function loop(t:Float) {
            col("#33B");
            drawRect(256, 256, screenSize, screenSize);
            rseed = 1;
            col("#fff");

            for(i in 0...99) {
                drawRect(random() * screenSize, (random() * screenSize + t * (random() * 0.2)) % screenSize, 2, 2);
            }

            time++;
            w.requestAnimationFrame(loop);
        }
        loop(0);
    }
}
