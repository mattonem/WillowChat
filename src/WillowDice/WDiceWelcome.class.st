Class {
	#name : #WDiceWelcome,
	#superclass : #WillowSharedModelWelcome,
	#category : #WillowDice
}

{ #category : #testing }
WDiceWelcome class >> sessionClass [
	^ WillowDiceSession
]

{ #category : #rendering }
WDiceWelcome >> renderDescription: aRenderer [
	super renderDescription: aRenderer.
	aRenderer paragraph: 'Generate a Dice and share it with your friends, it sounds fun, doesnt it.
 This app will let you customize your own dice (values and name), and then roll it. But by sharing the link to your very own dice, friends of yours will be able to interact with the same dice. Anyone can roll it, and see the result instantaneously.'
	 
]
