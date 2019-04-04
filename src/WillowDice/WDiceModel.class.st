Class {
	#name : #WDiceModel,
	#superclass : #Object,
	#instVars : [
		'announcer',
		'faces',
		'rolling',
		'lastResult'
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
	faces := OrderedCollection withAll: {1 . 2 . 3 . 4 . 5 . 6}.
	rolling := false.
	
]

{ #category : #initialization }
WDiceModel >> isRolling [
	^ rolling
]

{ #category : #initialization }
WDiceModel >> lastResult [
	^ lastResult
]

{ #category : #initialization }
WDiceModel >> stopRolling [
	lastResult := faces atRandom.
	rolling := false.
	announcer
		announce:
			(WDiceThrow new
				result: lastResult;
				yourself)
]

{ #category : #initialization }
WDiceModel >> throw [
	rolling ifTrue: [ ^ self ].
	rolling := true.
	[ 1 second wait. self stopRolling ] fork. 
	announcer
		announce:
			(WDiceRolling new
				yourself).
]
