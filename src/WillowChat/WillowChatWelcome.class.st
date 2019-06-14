Class {
	#name : #WillowChatWelcome,
	#superclass : #WillowSharedModelWelcome,
	#category : #WillowChat
}

{ #category : #testing }
WillowChatWelcome class >> isAbstract [ 	

	^ false
]

{ #category : #testing }
WillowChatWelcome class >> sessionClass [
	^ WillowChatSession
]
