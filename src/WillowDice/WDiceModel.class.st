Class {
	#name : #WDiceModel,
	#superclass : #Object,
	#instVars : [
		'announcer',
		'faces',
		'rolling',
		'lastResult',
		'diceName'
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

{ #category : #accessing }
WDiceModel >> diceName [
	^ diceName
]

{ #category : #accessing }
WDiceModel >> diceName: anObject [
	diceName := anObject.
	announcer announce: WDiceChanged new.
]

{ #category : #initialization }
WDiceModel >> faces [
	^ faces
]

{ #category : #initialization }
WDiceModel >> faces: newFaces [
	faces := newFaces
]

{ #category : #initialization }
WDiceModel >> initialize [
	announcer := Announcer new.
	faces := OrderedCollection withAll: {'⚀' . '⚁' . '⚂' . '⚃' . '⚄' . '⚅'}.
	diceName := 'a dice'.
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
