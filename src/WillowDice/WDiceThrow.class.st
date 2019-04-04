Class {
	#name : #WDiceThrow,
	#superclass : #Announcement,
	#instVars : [
		'result'
	],
	#category : #WillowDice
}

{ #category : #accessing }
WDiceThrow >> result [
	^ result
]

{ #category : #accessing }
WDiceThrow >> result: anObject [
	result := anObject
]
