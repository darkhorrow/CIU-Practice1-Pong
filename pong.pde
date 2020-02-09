// Ball default properties
float BALL_SIZE = 40;
color BALL_COLOR = color(255);

// Players default properties
float PLAYER_WIDTH = 20;
float PLAYER_HEIGHT = 120;
float PLAYER_SPEED = 8;
color LEFT_PLAYER_COLOR = color(102, 0, 153);
color RIGHT_PLAYER_COLOR = color(0, 102, 153);

// Sound defaults
SoundFile COLLISION;
SoundFile BALL_POINT;
SoundFile SOUNDTRACK;
SoundFile GAME_OVER;
SoundFile EFFECT_PICKUP;

// Text defaults
PFont FONT;

// Effects aparition
int EFFECT_SECONDS = 5;
int EFFECT_DISPELL_SECONDS = 3;
PImage slowBallImg;
PImage fastBallImg;
PImage bigBallImg;
PImage smallBallImg;

GameManager manager;

void setup() {
    // Map declarations
    fullScreen();
    noSmooth();
    // Assets
    slowBallImg = loadImage("data/slow_ball.png");
    fastBallImg = loadImage("data/fast_ball.png");
    bigBallImg = loadImage("data/big_ball.png");
    smallBallImg = loadImage("data/small_ball.png");
    FONT = loadFont("data/RetroGaming-48.vlw");
    COLLISION = new SoundFile(this, "sounds/hit.wav");
    BALL_POINT = new SoundFile(this, "sounds/impact.wav");
    SOUNDTRACK = new SoundFile(this, "sounds/soundtrack.wav");
    GAME_OVER = new SoundFile(this, "sounds/gameover.wav");
    EFFECT_PICKUP = new SoundFile(this, "sounds/powerup.wav");
    // GameManager
    manager = new GameManager();
    thread("SoundTrackThread");
}

void draw() {
    manager.update();
}

void keyPressed() {
    if(manager.isInGame) { 
        if(keyCode == 'W') {
            manager.playerLeft.currentSpeed.y = -PLAYER_SPEED;
        }
        if(keyCode == 'S') {
            manager.playerLeft.currentSpeed.y = PLAYER_SPEED;
        }
        if(keyCode == UP) {
            manager.playerRight.currentSpeed.y = -PLAYER_SPEED;
        }
        if(keyCode == DOWN) {
            manager.playerRight.currentSpeed.y = PLAYER_SPEED;
        }
        if(keyCode == 'R') {
            manager.isPaused = false; 
        }
    } else {
        manager.gameStartScore();
    }
}

void keyReleased() {
    if(keyCode == 'W' || keyCode == 'S') {
        manager.playerLeft.currentSpeed.y = 0;
    }
    if(keyCode == UP || keyCode == DOWN) {
        manager.playerRight.currentSpeed.y = 0;
    }
}

void SoundTrackThread() {
     SOUNDTRACK.play();
     SOUNDTRACK.amp(0.2);
     SOUNDTRACK.loop();
}

public void CollisionSound() {
     COLLISION.play();
}

void PointSound() {
     BALL_POINT.play();
}

void EffectSound() {
     EFFECT_PICKUP.play(); 
}
