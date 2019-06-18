Class {
	#name : #WDiamondGoLWelcome,
	#superclass : #WillowSandBoxWelcome,
	#category : #WillowGoL
}

{ #category : #testing }
WDiamondGoLWelcome class >> sessionClass [
	^ WGoLSession 
]

{ #category : #rendering }
WDiamondGoLWelcome >> renderDescription: aRenderer [
	super renderDescription: aRenderer.
	aRenderer paragraph
		with: [ aRenderer
				text: 'Game of Life is an implementation of the '.
			aRenderer anchor
				url: 'https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life';
				with: 'game of life'.
			aRenderer
				text: '.' ]
]
