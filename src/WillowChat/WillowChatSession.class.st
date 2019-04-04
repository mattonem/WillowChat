Class {
	#name : #WillowChatSession,
	#superclass : #WillowSharedModelSession,
	#category : #WillowChat
}

{ #category : #'instance creation' }
WillowChatSession class >> modelClass [
	^ WillowChatModel 
]
