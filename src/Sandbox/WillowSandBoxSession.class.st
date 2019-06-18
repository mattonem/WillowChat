Class {
	#name : #WillowSandBoxSession,
	#superclass : #WillowSession,
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
