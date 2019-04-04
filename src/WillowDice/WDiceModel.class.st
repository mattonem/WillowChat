Class {
	#name : #WDiceModel,
	#superclass : #Object,
	#instVars : [
		'announcer',
		'faces'
	],
	#classInstVars : [
		'announcer'
	],
	#category : #WillowDice
}

{ #category : #initialization }
WDiceModel >> announcer [
	^ announcer
]

{ #category : #initialization }
WDiceModel >> initialize [
	announcer := Announcer new.
	faces := OrderedCollection withAll: {1 . 2 . 3 . 4 . 5 . 6}
]

{ #category : #initialization }
WDiceModel >> throw [
	announcer
		announce:
			(WDiceThrow new
				result: faces atRandom;
				yourself)
]
