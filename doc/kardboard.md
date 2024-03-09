The purpose of the app is to allow submitting results of a series of contests in
order to display them in a leaderboard. The app is designed to be used by
players of the game Super Mario Kart 8 Deluxe but can be used for other games
with similar scoring systems. 

Every Versus Race or a Grand Prix consists of 12 racers including up to 4 real 
players. The placement only takes real players into account. Consider
the following example:

* 1st place: NPC
* 2nd place: Alice
* Places 3rd to 11th: NPCs
* 12th place: Bob

In the scoring system of the Kartboard app their places must be submitted as 
follows:

* 1st place: Alice
* 2nd place: Bob

It is possible to have a tie in the end of the Grand Prix. In this case, the
same place can be submitted for two or more players. The next place after a tie
will be "shifted" by the number of players who tied. For example:

* 1st place: Alice (score: 30)
* 1st place: Bob (score: 30)
* 3rd place: Charlie (score: 20)

Even though Charlie's score is technically second, the second place is already 
"taken" by the tie. This follows the in-game leaderboard of Mario Kart 8 Deluxe.

The only supported user login is through Google.

A user is created upon first login. Each user is assigned 1000 points. Every
race updates contestants' total score and their position on the leaderboard.
