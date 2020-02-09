class Ball {
    Position currentPosition;
    Speed currentSpeed;
    Dimension dimension;
    color fillColor;
    float MOVEMENT = 5;
    
    public Ball(Dimension size, color fill) {
         currentPosition = new Position(width/2, height/2);
         int signX = -1 + (int)random(2) * 2;
         int signY = -1 + (int)random(2) * 2;
         float angle = random(-PI/4, PI/4);
         float xspeed = 2 * MOVEMENT * cos(angle);
         float yspeed = 2 * MOVEMENT * sin(angle);
         currentSpeed = new Speed(signX*xspeed, signY*yspeed);
         dimension = size;
         fillColor = fill;
    }
    
    public void move() {
        currentPosition.x += currentSpeed.x;
        currentPosition.y += currentSpeed.y;
    }
    
    public void display() {
         fill(fillColor);
         noStroke();
         circle(currentPosition.x, currentPosition.y, dimension.width);
    }
    
}

class Player {
    Position currentPosition;
    Speed currentSpeed;
    Dimension dimension;
    color fillColor;
    PlayerSide side;
    
    public Player(Dimension size, color fill, PlayerSide side) {
         switch(side) {
             case LEFT:
                 currentPosition = new Position(20, (height/2));
                 break;
             case RIGHT:
                 currentPosition = new Position(width-20, (height/2));
                 break;
         }
         currentSpeed = new Speed(0, 0);
         dimension = size;
         fillColor = fill;
         this.side = side;
    }
    
    public void move() {
        currentPosition.y = constrain(currentPosition.y + currentSpeed.y, dimension.height/2, height - dimension.height/2);
    }
    
    public void display() {
         fill(fillColor);
         stroke(0, 255, 0);
         rectMode(CENTER);
         rect(currentPosition.x, currentPosition.y, dimension.width, dimension.height);
    }
    
}

interface EffectTriggerer {
    public void triggerEffect();
    public void revertEffect();
}

abstract class EffectBox implements EffectTriggerer {
    Position currentPosition;
    Dimension dimension;
    color fillColor;
    PImage icon;
    int effectiveTime = 0;
    boolean triggered = false;
    
    public EffectBox(Position aparitionPosition, Dimension size, color fill, PImage iconImage) {
        currentPosition = aparitionPosition;
        dimension = size;
        fillColor = fill;
        icon = iconImage;
    }
    
    public void display() {
         if(triggered) {
             if(millis() > effectiveTime + EFFECT_DISPELL_SECONDS*1000) {
                 revertEffect();
                 manager.effects.remove(this);
             }
         } else {
             noFill();
             stroke(fillColor);
             rectMode(CENTER);
             rect(currentPosition.x, currentPosition.y, dimension.width, dimension.height);
             imageMode(CENTER);
             image(icon, currentPosition.x, currentPosition.y, dimension.width - 10, dimension.height - 10);
         }
    }
    
}

class SmallBallEffectBox extends EffectBox {
  
    public SmallBallEffectBox(Position aparitionPosition, Dimension size, color fill) {
        super(aparitionPosition, size, fill, smallBallImg);
    }
    
    public void triggerEffect(){
        triggered = true;
        effectiveTime = millis();
        manager.ball.dimension.width = BALL_SIZE/2;
        manager.ball.dimension.height = BALL_SIZE/2;
    }
    
    public void revertEffect() {
        manager.ball.dimension.width = BALL_SIZE;
        manager.ball.dimension.height = BALL_SIZE;
    }
    
}

class BigBallEffectBox extends EffectBox {
  
    public BigBallEffectBox(Position aparitionPosition, Dimension size, color fill) {
        super(aparitionPosition, size, fill, bigBallImg);
    }
    
    public void triggerEffect() {
        triggered = true;
        effectiveTime = millis();
        manager.ball.dimension.width = BALL_SIZE*1.5;
        manager.ball.dimension.height = BALL_SIZE*1.5;
    }

    public void revertEffect() {
        manager.ball.dimension.width = BALL_SIZE;
        manager.ball.dimension.height = BALL_SIZE;
    }
    
}

class SlowBallEffectBox extends EffectBox {
  
    public SlowBallEffectBox(Position aparitionPosition, Dimension size, color fill) {
        super(aparitionPosition, size, fill, slowBallImg);
    }
    
    public void triggerEffect() {
        triggered = true;
        effectiveTime = millis();
        manager.ball.MOVEMENT /= 1.45;
        manager.ball.currentSpeed.x = manager.ball.currentSpeed.x/1.45;
        manager.ball.currentSpeed.y = manager.ball.currentSpeed.y/1.45;
    }
    
    public void revertEffect() {
        manager.ball.MOVEMENT *= 1.45;
        manager.ball.currentSpeed.x = manager.ball.currentSpeed.x*1.45;
        manager.ball.currentSpeed.y = manager.ball.currentSpeed.y*1.45;;
    }
    
}

class FastBallEffectBox extends EffectBox {
  
    public FastBallEffectBox(Position aparitionPosition, Dimension size, color fill) {
        super(aparitionPosition, size, fill, fastBallImg);
    }
    
    public void triggerEffect() {
        triggered = true;
        effectiveTime = millis();
        manager.ball.MOVEMENT *= 1.45;
        manager.ball.currentSpeed.x = manager.ball.currentSpeed.x*1.45;
        manager.ball.currentSpeed.y = manager.ball.currentSpeed.y*1.45;
    }
    
    public void revertEffect() {
        manager.ball.MOVEMENT /= 1.45;
        manager.ball.currentSpeed.x = manager.ball.currentSpeed.x/1.45;
        manager.ball.currentSpeed.y = manager.ball.currentSpeed.y/1.45;
    }
    
}

enum PlayerSide {
    LEFT, RIGHT; 
}

class Position {
  float x;
  float y;
  
  public Position(float x, float y) {
      this.x = x;
      this.y = y;
  }
  
}

class Speed {
    float x;
    float y;
    
    public Speed(float x, float y) {
        this.x = x;
        this.y = y;
    }
    
}

class Dimension {
    float width;
    float height;
    
    public Dimension(float width, float height) {
        this.width = width;
        this.height = height;
    }
    
}
