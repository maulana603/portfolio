// Description: This is the JavaScript file for the Space Shooter game. Game made by Maulana Ariefai

// Display background
var imgBackground = document.createElement('img');
imgBackground.src = 'img/background.jpg';
imgBackground.style.position = 'fixed';
imgBackground.style.top = '0';
imgBackground.style.left = '0';
imgBackground.style.width = '100%';
imgBackground.style.height = '100%';
imgBackground.style.zIndex = '-1';
document.body.appendChild(imgBackground);

/* display spaceship*/
var spaceship = document.createElement('img');
spaceship.src = 'img/spaceship.png';
spaceship.style.position = 'fixed';
spaceship.style.top = '50%';
spaceship.style.left = '50%';
spaceship.style.transform = 'translate(-50%, -50%)';
spaceship.style.zIndex = '1';
document.body.appendChild(spaceship);
spaceship.style.width = '5%';
spaceship.style.top = '95%';

/* moving function */
document.addEventListener('mousemove', function (event) {
  spaceship.style.left = event.clientX + 'px';
});

/* adding shooting function*/
document.addEventListener('keydown', function (event) {
  // If space is pressed, create a bullet
  if (event.keyCode === 32) {
    var bullet = document.createElement('img');
    bullet.src = 'img/bullet.png';
    bullet.style.position = 'absolute';
    bullet.style.top = spaceship.offsetTop + 'px';
    bullet.style.left = spaceship.offsetLeft + spaceship.offsetWidth / 2 - bullet.offsetWidth / 2 + 'px';
    document.body.appendChild(bullet);
    var bulletInterval = setInterval(function () {
      bullet.style.top = bullet.offsetTop - 10 + 'px';
      // If the bullet is off the screen, remove it
      if (bullet.offsetTop < 0) {
        clearInterval(bulletInterval);
        document.body.removeChild(bullet);
      }
    }, 10);
  }
});

/* adding enemy */
//create enemy
var enemyInterval = setInterval(function () {
  var enemy = document.createElement('img');
  enemy.src = 'img/enemy.png';
  enemy.style.position = 'absolute';
  enemy.style.top = '0';
  enemy.style.left = Math.random() * window.innerWidth + 'px';
  document.body.appendChild(enemy);
  //move enemy
  var enemyInterval = setInterval(function () {
    enemy.style.top = enemy.offsetTop + 1 + 'px';
    if (enemy.offsetTop > window.innerHeight) {
      clearInterval(enemyInterval);
      document.body.removeChild(enemy);
    }
  }, 10);
}, 2000);


/* collision and score function */
//This code will keep track of the score and remove bullets and enemies when they collide
var score = 0;
var scoreElement = document.createElement('div');
scoreElement.style.position = 'fixed';
scoreElement.style.top = '0';
scoreElement.style.right = '0';
scoreElement.style.color = 'white';
scoreElement.style.fontSize = '20px';
scoreElement.style.fontWeight = 'bold';
scoreElement.style.padding = '10px';
document.body.appendChild(scoreElement);
var collisionInterval = setInterval(function () {
  var bullets = document.querySelectorAll('img[src="img/bullet.png"]');
  var enemies = document.querySelectorAll('img[src="img/enemy.png"]');
  for (var i = 0; i < bullets.length; i++) {
    for (var j = 0; j < enemies.length; j++) {
      if (bullets[i].offsetLeft < enemies[j].offsetLeft + enemies[j].offsetWidth &&
        bullets[i].offsetLeft + bullets[i].offsetWidth > enemies[j].offsetLeft &&
        bullets[i].offsetTop < enemies[j].offsetTop + enemies[j].offsetHeight &&
        bullets[i].offsetHeight + bullets[i].offsetTop > enemies[j].offsetTop) {
        document.body.removeChild(enemies[j]);
        document.body.removeChild(bullets[i]);
        score++;
        scoreElement.innerHTML = 'Score: ' + score;
      }
    }
  }
}, 10);


/* Enemy reach bottom, restart button appear*/
var gameOver = false;
var gameOverInterval = setInterval(function () {
  var enemies = document.querySelectorAll('img[src="https://bit.ly/enemy-images"]');
  for (var i = 0; i < enemies.length; i++) {
    if (enemies[i].offsetTop > window.innerHeight - enemies[i].offsetHeight) {
      gameOver = true;
      clearInterval(enemyInterval);
      clearInterval(collisionInterval);
      clearInterval(gameOverInterval);
      var restartButton = document.createElement('button');
      restartButton.innerHTML = 'Restart';
      restartButton.style.position = 'fixed';
      restartButton.style.top = '50%';
      restartButton.style.left = '50%';
      restartButton.style.transform = 'translate(-50%, -50%)';
      restartButton.style.fontSize = '20px';
      restartButton.style.padding = '10px';
      restartButton.addEventListener('click', function () {
        location.reload();
      });
      document.body.appendChild(restartButton);
    }
  }
}, 10);

/* if the score reach 100, There will be a pop up appears written "You won the game" */
var scoreInterval = setInterval(function () {
  if (score === 100) {
    clearInterval(scoreInterval);
    alert('You won the game!');
  }
}, 10);