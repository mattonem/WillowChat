Class {
	#name : #WDiamondSquareWelcome,
	#superclass : #WillowSandBoxWelcome,
	#category : #WillowDiamondSquare
}

{ #category : #testing }
WDiamondSquareWelcome class >> sessionClass [
	^ WDiamondSquareSession
]

{ #category : #rendering }
WDiamondSquareWelcome >> renderDescription: aRenderer [
	super renderDescription: aRenderer.
	aRenderer paragraph
		with: [ aRenderer
				text: 'Diamond Square generator is an implementation of the '.
			aRenderer anchor
				url: 'https://en.wikipedia.org/wiki/Diamond-square_algorithm';
				with: 'diamond square algorithm'.
			aRenderer
				text: '. Given a size, it will generate a random elevation map (grey scale).' ]
]
