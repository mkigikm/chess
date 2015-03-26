# Chess

## Description
A terminal implementation of chess with a basic AI. Humans can play each other,
play an AI, or watch AIs play.

## Design choices
* uses inheritance to DRY up movement logic
* to check for legal moves, check, checkmate, etc. the board is duped, then
  movements are made on the duped board.
* three levels of computer AI
  * "random" moves randomly
  * "smart" looks for material advantage
  * "grandmaster" looks at responses to its move
* board evaluations are made using the function given by
  (http://www.pi.infn.it/~carosi/chess/shannon.txt)[(Shannon, 1950)].
* allows for board positions to be entered with a string to resume a game

## Libraries
The only dependencies are ruby and the `colorize` gem.

## How to Run
To run, download the repository, `bundle install` if you don't already have the
`colorize` gem, and run `./game.rb`.
