Class {
	#name : #WillowSandBoxSession,
	#superclass : #Object,
	#category : #Sandbox
}

{ #category : #accessing }
WillowSandBoxSession class >> applicationClass [
^WDiamondSquareApplication
]

{ #category : #accessing }
WillowSandBoxSession class >> handlerName [
	^ self applicationClass handlerName
]
