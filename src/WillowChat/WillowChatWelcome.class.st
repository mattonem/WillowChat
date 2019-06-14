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

{ #category : #rendering }
WillowChatWelcome >> renderDescription: aRenderer [
	aRenderer paragraph: 'This is a very basic chat implementation. You could discuss with friends of yours just by sharing the generated link. But be aware that all sessions will expire after 1 hour.'
]
