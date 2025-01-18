var distance, randIntRange, randRange;
randRange = function(min, max) {
  return Math.random() * (max - min) + min;
};
randIntRange = function(min, max) {
  return randRange(min, max) | 0;
};
distance = function(x1, y1, x2, y2) {
  return Math.sqrt(Math.pow(x1 - x2, 2) + Math.pow(y1 - y2, 2));
};
var store;
store = {
  fireworkSpeed: 2,
  fireworkAcceleration: 1.05,
  particleFriction: 0.95,
  particleGravity: 1.5
};
const store$1 = store;
var Firework;
Firework = class Firework2 {
  constructor(x1, y1, x2, y2, ctx, hue) {
    var i, ref;
    this.x = x1;
    this.y = y1;
    this.sx = x1;
    this.sy = y1;
    this.dx = x2;
    this.dy = y2;
    this.ctx = ctx;
    this.hue = hue;
    this.totalDistance = distance(this.sx, this.sy, this.dx, this.dy);
    this.currentDistance = 0;
    this.coordinates = [];
    this.coordinateCount = 3;
    this.angle = Math.atan2(this.dy - this.sy, this.dx - this.sx);
    this.speed = store$1.fireworkSpeed;
    this.acceleration = store$1.fireworkAcceleration;
    this.brightness = randIntRange(50, 70);
    for (i = 0, ref = this.coordinateCount; 0 <= ref ? i < ref : i > ref; 0 <= ref ? ++i : --i) {
      this.coordinates.push([this.x, this.y]);
    }
  }
  update(callback) {
    var vx, vy;
    this.coordinates.pop();
    this.coordinates.unshift([this.x, this.y]);
    this.speed *= this.acceleration;
    vx = Math.cos(this.angle) * this.speed;
    vy = Math.sin(this.angle) * this.speed;
    this.currentDistance = distance(this.sx, this.sy, this.x + vx, this.y + vy);
    if (this.currentDistance >= this.totalDistance) {
      return callback(this.dx, this.dy, this.hue);
    } else {
      this.x += vx;
      return this.y += vy;
    }
  }
  draw() {
    var last;
    last = this.coordinates.length - 1;
    this.ctx.beginPath();
    this.ctx.moveTo(this.coordinates[last][0], this.coordinates[last][1]);
    this.ctx.lineTo(this.x, this.y);
    this.ctx.strokeStyle = `hsl(${this.hue}, 100%, ${this.brightness}%)`;
    return this.ctx.stroke();
  }
};
const Firework$1 = Firework;
var PI2, Particle;
PI2 = Math.PI * 2;
Particle = class Particle2 {
  constructor(x, y, ctx, hue) {
    var i, ref;
    this.x = x;
    this.y = y;
    this.ctx = ctx;
    this.hue = hue;
    this.coordinates = [];
    this.coordinateCount = 5;
    this.angle = randRange(0, PI2);
    this.speed = randRange(1, 10);
    this.hue = randIntRange(this.hue - 20, this.hue + 20);
    this.friction = store$1.particleFriction;
    this.gravity = store$1.particleGravity;
    this.brightness = randIntRange(50, 90);
    this.alpha = 1;
    this.decay = randRange(0.015, 0.03);
    for (i = 0, ref = this.coordinateCount; 0 <= ref ? i < ref : i > ref; 0 <= ref ? ++i : --i) {
      this.coordinates.push([this.x, this.y]);
    }
  }
  update(callback) {
    this.coordinates.pop();
    this.coordinates.unshift([this.x, this.y]);
    this.speed *= this.friction;
    this.x += Math.cos(this.angle) * this.speed;
    this.y += Math.sin(this.angle) * this.speed + this.gravity;
    this.alpha -= this.decay;
    if (this.alpha <= this.decay) {
      return callback();
    }
  }
  draw() {
    var last;
    last = this.coordinates.length - 1;
    this.ctx.beginPath();
    this.ctx.moveTo(this.coordinates[last][0], this.coordinates[last][1]);
    this.ctx.lineTo(this.x, this.y);
    this.ctx.strokeStyle = `hsla(${this.hue}, 100%, ${this.brightness}%, ${this.alpha})`;
    return this.ctx.stroke();
  }
};
const Particle$1 = Particle;
var Fireworks;
Fireworks = class Fireworks2 {
  constructor(options) {
    this.canvas = document.getElementById(options.id || "fireworks-canvas");
    this.ctx = this.canvas.getContext ? this.canvas.getContext("2d") : null;
    this.width = this.canvas.width;
    this.height = this.canvas.height;
    this.hue = options.hue || 120;
    this.isRunning = false;
    this.fireworks = [];
    this.particles = [];
    this.particleCount = options.particleCount || 50;
    this.tick = 0;
    this.delay = options.delay || 30;
    this.minDelay = options.minDelay || 30;
    this.maxDelay = options.maxDelay || 90;
    this.boundaries = options.boundaries || {
      top: 50,
      bottom: this.height * 0.5,
      left: 50,
      right: this.width - 50
    };
    this.render.bind(this);
  }
  start() {
    this.isRunning = true;
    this.fireworks = [];
    this.particles = [];
    return this.render();
  }
  stop() {
    this.isRunning = false;
    return this.clear();
  }
  clear() {
    if (!this.ctx) {
      return;
    }
    this.ctx.globalCompositeOperation = "source-over";
    this.ctx.fillStyle = "rgba(0, 0, 0, 0.5)";
    return this.ctx.fillRect(0, 0, this.width, this.height);
  }
  render() {
    var self, tmp;
    if (!this.ctx || !this.isRunning) {
      return;
    }
    window.requestAnimationFrame(this.render.bind(this));
    self = this;
    this.hue += 0.5;
    this.ctx.globalCompositeOperation = "destination-out";
    this.ctx.fillStyle = "rgba(0, 0, 0, 0.5)";
    this.ctx.fillRect(0, 0, this.width, this.height);
    this.ctx.globalCompositeOperation = "lighter";
    tmp = this.fireworks.length;
    while (tmp--) {
      this.fireworks[tmp].draw();
      this.fireworks[tmp].update(function(x, y, hue) {
        var count;
        count = self.particleCount;
        while (count--) {
          self.particles.push(new Particle$1(x, y, self.ctx, hue));
        }
        return self.fireworks.splice(tmp, 1);
      });
    }
    tmp = this.particles.length;
    while (tmp--) {
      this.particles[tmp].draw();
      this.particles[tmp].update(function() {
        return self.particles.splice(tmp, 1);
      });
    }
    if (this.tick === this.delay) {
      this.fireworks.push(new Firework$1(this.width * 0.5, this.height, randIntRange(this.boundaries.left, this.boundaries.right), randIntRange(this.boundaries.top, this.boundaries.bottom), this.ctx, this.hue));
      this.delay = randIntRange(this.minDelay, this.maxDelay);
      this.tick = 0;
    }
    return this.tick++;
  }
};
const Fireworks$1 = Fireworks;
export {
  Fireworks$1 as default
};
