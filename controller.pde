import processing.sound.*;

class GameManager {
    Ball ball;
    Player playerLeft;
    Player playerRight;
    int leftScore = 0;
    int rightScore = 0;
    int maxScore = 5;
    boolean isInGame = false;
    boolean isPaused = true;
    boolean isGameOver = false;
    
    String scoreSelector = "5";
    EffectBoxFactory[] usableEffects = { new SmallBallFactory(), new BigBallFactory(), new SlowBallFactory(), new FastBallFactory(), };
    ArrayList<EffectBox> effects = new ArrayList<EffectBox>();
    int timer = millis();
    
    public GameManager() {
         ball = new Ball(new Dimension(BALL_SIZE, BALL_SIZE), BALL_COLOR);
         playerLeft = new Player(new Dimension(PLAYER_WIDTH, PLAYER_HEIGHT), LEFT_PLAYER_COLOR, PlayerSide.LEFT);
         playerRight = new Player(new Dimension(PLAYER_WIDTH, PLAYER_HEIGHT), RIGHT_PLAYER_COLOR, PlayerSide.RIGHT);
    }
    
    public void update() {
        background(0);
        if(isInGame) {
              
            drawScenario();
        
            playerLeft.display();
            playerRight.display();
            ball.display();
            
            displayEffects();
            
            displayScores();
            
            if(!isPaused && !isGameOver){
                if(millis() > timer + (EFFECT_SECONDS*1000)) {
                    int chooser = int(random(usableEffects.length)); 
                    effects.add(usableEffects[chooser].create());
                    println("Effect box added: " + usableEffects[chooser]);
                    timer = millis();
                }
              
                playerLeft.move();
                playerRight.move();
            
                ball.move();
            
                collisionBallToWall();
                collisionBallToPlayer();
                checkBallEffectsCollision();
            } else if(isGameOver) {
                displayGameOver();
            } else {
                timer = millis();
                displayRestart();
            }
        } else {
            if(GAME_OVER.isPlaying()) {
                displayGameOver();
            } else {
                leftScore = 0;
                rightScore = 0;
                timer = millis();
                effects = new ArrayList<EffectBox>();
                displayGameStart();
            }
        }
    }
    
    public void collisionBallToWall() {
        if(ball.currentPosition.x > width) {
            leftScore++;
            thread("PointSound");
            effects = new ArrayList<EffectBox>();
            respawnBall();  
        }
        if(ball.currentPosition.x < 0) {
            rightScore++;
            thread("PointSound");
            effects = new ArrayList<EffectBox>();
            respawnBall();
        }
        if(ball.currentPosition.y > height - (ball.dimension.width/2) || ball.currentPosition.y < 0 + (ball.dimension.width/2)) {
            ball.currentSpeed.y *= -1;
            thread("CollisionSound");
        }
    }
    
    public void collisionBallToPlayer() {
          float ballX = ball.currentPosition.x;
          float ballY = ball.currentPosition.y;
          float ballRadius = ball.dimension.width/2;
          
          float leftPlayerX = playerLeft.currentPosition.x;
          float leftPlayerY = playerLeft.currentPosition.y;
          float leftPlayerWidth = playerLeft.dimension.width;
          float leftPlayerHeight = playerLeft.dimension.height;
          
          float rightPlayerX = playerRight.currentPosition.x;
          float rightPlayerY = playerRight.currentPosition.y;
          float rightPlayerWidth = playerRight.dimension.width;
          float rightPlayerHeight= playerRight.dimension.height;
          
          if(ballY - ballRadius < leftPlayerY + leftPlayerHeight/2  && ballY + ballRadius > leftPlayerY - leftPlayerHeight/2 && ballX - ballRadius < leftPlayerX + leftPlayerWidth/2){
              if(ballX > leftPlayerX) {
                  float diff = ballY - (leftPlayerY - leftPlayerHeight/2);
                  float radians =  radians(45);
                  float angle = map(diff, 0, leftPlayerHeight, -radians, radians);
                  ball.currentSpeed.x = 2 * ball.MOVEMENT * cos(angle);
                  ball.currentSpeed.y = 2 * ball.MOVEMENT * sin(angle);
                  ball.currentPosition.x = leftPlayerX + (leftPlayerWidth/2) + ballRadius;
                  thread("CollisionSound");
              }
          }
          if(ballY - ballRadius < rightPlayerY + rightPlayerHeight/2  && ballY + ballRadius > rightPlayerY - rightPlayerHeight/2 && ballX + ballRadius > rightPlayerX - rightPlayerWidth/2){
              if(ballX < rightPlayerX) {
                  float diff = ballY - (rightPlayerY - rightPlayerHeight/2);
                  float angle = map(diff, 0, rightPlayerHeight, radians(225), radians(135));
                  ball.currentSpeed.x = 2 * ball.MOVEMENT * cos(angle);
                  ball.currentSpeed.y = 2 * ball.MOVEMENT * sin(angle);
                  ball.currentPosition.x = rightPlayerX - (rightPlayerWidth/2) - ballRadius;
                  thread("CollisionSound");
              }
          }
    }
    
    public void drawScenario() {
        strokeWeight(2);
        stroke(color(255, 0, 0));
        line(0, 0, 0, height);
        line(width-2, 0, width-2, height);
        stroke(color(0,255,0));
        line(0, 0, width, 0);
        line(0, height-2, width, height-2);
        line(width/2, 0, width/2, height);
        rectMode(CENTER);
        noFill();
        square(width/2, height/2, 100);
        rect(width/2, height/2, 600 , 300);
    }
    
    public void displayScores() {
        textFont(FONT);
        textAlign(CENTER, CENTER);
        textSize(32);
        fill(playerRight.fillColor);
        text(rightScore, width*0.75, height/4);
        
        textAlign(CENTER, CENTER);
        textSize(32);
        fill(playerLeft.fillColor);
        text(leftScore, width/4-16, height/4);
    }
    
    public void displayRestart() {
        textFont(FONT);
        textSize(40);
        textAlign(CENTER, CENTER);
        fill(color(0,random(255),random(255)));
        text("Press 'R' to launch the ball!", width/2, height/2 - 100);
    }
    
    public void displayGameStart() {
        textFont(FONT);
        textSize(40);
        textAlign(CENTER, CENTER);
        fill(color(0,random(255),random(255)));
        String auxChar = "_";
        if(maxScore < 1) {
            auxChar = "";
        }
        text("Type goals to win: " + maxScore + auxChar, width/2, height/2 - 100);
        text("> Press Enter to confirm", width/2, height/2);
    }
    
    public void displayGameOver() {
        textFont(FONT);
        textSize(40);
        textAlign(CENTER, CENTER);
        fill(color(0,random(255),random(255)));
        color c;
        if(max(leftScore, rightScore) == leftScore) {
            text("Player 1 wins", width/2, height/2 + 100);
            c = playerLeft.fillColor;
        } else {
            text("Player 2 wins", width/2, height/2 + 100);
            c = playerRight.fillColor;
        }
        float w = 30;
        float h = 70;
        fill(c);
        triangle((width/2)-w/2, height/2, width/2, (height/2)-h, (width/2)+w/2, height/2);
        triangle((width/2)-3*w/2, height/2, (width/2)-3*w/2, (height/2)-h, (width/2)-w/2, height/2);
        triangle((width/2)+3*w/2, height/2, (width/2)+3*w/2, (height/2)-h, (width/2)+w/2, height/2);
        rect(width/2, (height/2)+w/2, w*3, h/3);
        if(!GAME_OVER.isPlaying() && isGameOver) {
            GAME_OVER.play();
            GAME_OVER.amp(0.5);
            isGameOver = false;
            maxScore = 5;
            scoreSelector = "5";
            isInGame = false;
        }        
    }
    
    public void respawnBall() {
       ball = new Ball(new Dimension(BALL_SIZE, BALL_SIZE), BALL_COLOR);
       playerLeft.currentPosition.y = height/2;
       playerRight.currentPosition.y = height/2;
       checkScoreStatus();
    }
    
    public void checkScoreStatus() {
        if(max(leftScore, rightScore) == maxScore) {
            isGameOver = true;
        } else {
            isPaused = true;
        }
    }
    
    void displayEffects() {
        ArrayList<EffectBox> iterAux = new ArrayList<EffectBox>(effects);
        for(EffectBox effect : iterAux) {
            effect.display();
        }
    }
    
    public void checkBallEffectsCollision() {
        float ballX = ball.currentPosition.x;
        float ballY = ball.currentPosition.y;
        float ballRadius = ball.dimension.height;
        ArrayList<EffectBox> iterAux = new ArrayList<EffectBox>(effects);
        for(EffectBox effect : iterAux) {
            if(effect.triggered){
                println("Effect already triggered: " + effect);
                continue;
            }
            float left = effect.currentPosition.x - effect.dimension.width/2;
            float right = effect.currentPosition.x + effect.dimension.width/2;
            float top = effect.currentPosition.y - effect.dimension.height/2;
            float bottom = effect.currentPosition.y + effect.dimension.height/2;
            
            if(ballX + ballRadius > left && ballX - ballRadius < right && ballY + ballRadius > top && ballY - ballRadius < bottom) {
                effect.triggerEffect();
                println("Effect triggered: " + effect);
            }
        }
    }
    
    public void gameStartScore() {
        if(key >= 48 && key <= 57) {
            int number = key - 48;
            if(scoreSelector.length() <= 3) {
                scoreSelector += number;
                maxScore = int(scoreSelector);
            }         
        } else {
            if(keyCode == ENTER) {
                if(maxScore < 1) {
                    maxScore = 5;
                }
                manager.isInGame = true;
                manager.isPaused = true;
            }
            if(keyCode == BACKSPACE) {
                scoreSelector = scoreSelector.substring(0, max(scoreSelector.length()-1, 0));
                maxScore = int(scoreSelector);
            }
        }
    }
    
}
