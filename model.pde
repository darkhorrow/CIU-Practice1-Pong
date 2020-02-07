class Ball {
    Position currentPosition;
    Speed currentSpeed;
    Dimension dimension;
    color fillColor;
    final float MOVEMENT = 5;
    
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
}

abstract class EffectBox implements EffectTriggerer {
    Position currentPosition;
    Dimension dimension;
    color fillColor;
    
    public EffectBox(Position aparitionPosition, Dimension size, color fill) {
        currentPosition = aparitionPosition;
        dimension = size;
        fillColor = fill;
    }
    
    public void display() {
         fill(fillColor);
         rectMode(CENTER);
         rect(currentPosition.x, currentPosition.y, dimension.width, dimension.height);
    }
    
}

class SmallBallEffectBox extends EffectBox {
  
    public SmallBallEffectBox(Position aparitionPosition, Dimension size, color fill) {
        super(aparitionPosition, size, fill);
    }
    
    public void triggerEffect(){
        manager.ball.dimension.width = BALL_SIZE/2;
        manager.ball.dimension.height = BALL_SIZE/2;
    }   
    
}

class BigBallEffectBox extends EffectBox {
  
    public BigBallEffectBox(Position aparitionPosition, Dimension size, color fill) {
        super(aparitionPosition, size, fill);
    }
    
    public void triggerEffect(){
        manager.ball.dimension.width = BALL_SIZE*1.5;
        manager.ball.dimension.height = BALL_SIZE*1.5;
    }   
    
}

class SlowBallEffectBox extends EffectBox {
  
    public SlowBallEffectBox(Position aparitionPosition, Dimension size, color fill) {
        super(aparitionPosition, size, fill);
    }
    
    public void triggerEffect(){
        manager.ball.currentSpeed.x = manager.ball.currentSpeed.x/2;
        manager.ball.currentSpeed.y = manager.ball.currentSpeed.y/2;
    }   
    
}

class FastBallEffectBox extends EffectBox {
  
    public FastBallEffectBox(Position aparitionPosition, Dimension size, color fill) {
        super(aparitionPosition, size, fill);
    }
    
    public void triggerEffect(){
        manager.ball.currentSpeed.x = manager.ball.currentSpeed.x*2;
        manager.ball.currentSpeed.y = manager.ball.currentSpeed.y*2;
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
