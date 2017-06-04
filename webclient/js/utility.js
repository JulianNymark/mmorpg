function renderEntities(list) {
  for(var i=0; i<list.length; i++) {
    renderEntity(list[i]);
  }
}

function renderEntity(entity) {
  ctx.save();
  ctx.translate(entity.pos[0], entity.pos[1]);
  entity.sprite.render(ctx);
  ctx.restore();
}

function getMousePos(withinThing, evt) {
  var rect = withinThing.getBoundingClientRect();

  var x;
  var y;

  if (evt.type == 'touchmove') {
    x = evt.touches[0].pageX;
    y = evt.touches[0].pageY;
  }
  else if (evt.type == 'mousemove') {
    x = evt.clientX;
    y = evt.clientY;
  }

  return {
    x: x - rect.left,
    y: y - rect.top
  };
}

var debugVerbosity = 1;

var debug = {
  log : function(stringy) {
    if (debugVerbosity == 1){
      console.log(stringy);
    }
  }
}

function addInputEventListeners(thing) {
  // mouse
  thing.addEventListener('mousemove', function(evt) {
    debug.log('inputCatcher.mousemove');
    var mousePos = getMousePos(thing, evt);
    brush.pos = [mousePos.x, mousePos.y];
    evt.preventDefault();
    strokeMove();
  });
  thing.addEventListener('mousedown', function(evt) {
    debug.log('inputCatcher.mousedown');
    var mousePos = getMousePos(thing, evt);
    brush.pos = [mousePos.x, mousePos.y];
    evt.preventDefault();
    strokeStart();
  });
  thing.addEventListener('mouseup', function(evt) {
    debug.log('inputCatcher.mouseup');
    var mousePos = getMousePos(thing, evt);
    brush.pos = [mousePos.x, mousePos.y];
    evt.preventDefault();
    strokeStop();
  });

  // mobile
  thing.addEventListener('touchmove', function(evt) {
    debug.log('inputCatcher.touchmove');
    var mousePos = getMousePos(thing, evt);
    brush.pos = [mousePos.x, mousePos.y];
    evt.preventDefault();
    strokeMove();
  });
  thing.addEventListener('touchstart', function(evt) {
    debug.log('inputCatcher.touchstart');
    var mousePos = getMousePos(thing, evt);
    brush.pos = [mousePos.x, mousePos.y];
    evt.preventDefault();
    strokeStart();
  });
  thing.addEventListener('touchend', function(evt) {
    debug.log('inputCatcher.touchend');
    var mousePos = getMousePos(thing, evt);
    brush.pos = [mousePos.x, mousePos.y];
    evt.preventDefault();
    strokeStop();
  });
}

function oddEventListeners() {
  // ensure that brush is always 'deactivated'! :joy:
  document.addEventListener('mouseup', function(evt) {
    debug.log('document.mouseup');
    strokeStop();
  });
  document.addEventListener('touchend', function(evt) {
    debug.log('document.touchend');
    strokeStop();
  });
}

var button1 = document.getElementById('b1');
var button2 = document.getElementById('b2');

button1.addEventListener('click', function(evt){
  lineWidth = 1;
});
button2.addEventListener('click', function(evt){
  lineWidth = 5;
});

var lineStart; var lineStop;
var lineWidth;

function strokeStart() {
  ctx.lineWidth = lineWidth;
  ctx.strokeStyle = '#000000';
  ctx.lineJoin = 'round';

  brush.active = true;
  lineStart = brush.pos;
  lineStop = lineStart;
}

function strokeMove() {
  if (brush.active) {
    lineStop = brush.pos;

    ctx.beginPath();
    ctx.moveTo(...lineStart);
    ctx.lineTo(...lineStop);
    ctx.closePath();
    ctx.stroke();

    lineStart = lineStop;
  }
}

function strokeStop() {
  brush.active = false;
}
