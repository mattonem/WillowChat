Class {
	#name : #WillowSandBoxSession,
	#superclass : #Object,
	#category : #Sandbox
}

{ #category : #accessing }
WillowSandBoxSession class >> applicationClass [
^self subclassResponsibility
]

{ #category : #accessing }
WillowSandBoxSession class >> handlerName [
	^ self applicationClass handlerName
]
