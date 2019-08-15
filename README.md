# Set iOS Game
A matching game on iOS based on "Set!".

## What I learned:
- Model View Controller methodology
- Protocols
- Customizing UIView
- UIBezierPath
- Unit testing for the model

## Details about the Model
Since the game model is supposed to be compleatly independent and blind to user interfaces, I spent a lot of time thinking about the essential information needed for the application.

After a lot of thought I decided on the following for a public api for the game model

### SetGame Public API
- Read-only cards on playing field (dealtCards).
- Read-only selected cards.
- Read-only previously matched cards.
- Read-only card deck (I am considering making this private).
- init(withNumberOfCards numCards: Int)
- func resetGame()
- func chooseCard(atIndex: int)
- func createDealFunction(whichDeals numCards: Int) -> () -> Bool
  - The deal function creates and returns a function that deals x number of cards as defined by numCards.
  - I created this function mostly to learn about closures and returning a function.
- func dealThreeCards()

Currently, I am still working on figuring out what aspects of the API to remove (make private).

### SetCard struct
This struct is defines the properties and methods a set game card has. 
It has basic properties such as:
- numberOfShapes
- shape
- shade
- color

Where all four of these properties are enums.
Most importantly, SetCard has a method called match that checks if a card matches with two other cards.

### SetDeck struct
This struct on init creates an instance of every possible card propriety combintation (81 of them).
It also has a function called draw that draws one random card from the deck.

## Details about the Set Card View
I subclassed UIView to create a SetCardView.
Here's why:
- To draw custom shapes with UIBezierPath.
- To learn about gesture recognizers.
- To eventually add some animation when the card is selected.

What the shapes look like:
