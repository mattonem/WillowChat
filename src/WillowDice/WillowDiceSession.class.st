Class {
	#name : #WillowDiceSession,
	#superclass : #WillowSharedModelSession,
	#category : #WillowDice
}

{ #category : #'instance creation' }
WillowDiceSession class >> applicationClass [
	^ WDiceApplication
]

{ #category : #'instance creation' }
WillowDiceSession class >> modelClass [
	^ WDiceModel
]
