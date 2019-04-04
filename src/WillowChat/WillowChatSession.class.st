Class {
	#name : #WillowChatSession,
	#superclass : #WillowSharedModelSession,
	#category : #WillowChat
}

{ #category : #'as yet unclassified' }
WillowChatSession class >> applicationClass [
	^ WillowChatApplication 
]

{ #category : #'instance creation' }
WillowChatSession class >> modelClass [
	^ WillowChatModel 
]
