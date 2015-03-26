# chess

A terminal implementation of chess with a basic AI.
* humans can play each other, an AI, or watch AIs play
* uses inheritence to DRY up movement logic
* three levels of computer AI
  * "random" moves randomlly
  * "smart" looks for material advantage
  * "grandmaster" looks at responses to its move
* allows for board positions to be entered with a string to resume a game

The only dependencies are ruby and the `colorize` gem.

To run, download the repository, `bundle install` if you don't already have the `colorize` gem, and run `./game.rb`.
