Class {
	#name : #WillowChatModel,
	#superclass : #Object,
	#instVars : [
		'announcer'
	],
	#category : #WillowChat
}

{ #category : #initialization }
WillowChatModel >> announcer [ 
	^ announcer
]

{ #category : #initialization }
WillowChatModel >> initialize [ 
	announcer := Announcer new.
]

{ #category : #initialization }
WillowChatModel >> sendMessage: aString [
	announcer
		announce:
			(WCNewMessage new
				message: aString;
				yourself)
]

{ #category : #initialization }
WillowChatModel >> sendMessage: aString username: aName [
	announcer
		announce:
			(WCNewMessage new
				message: aString;
				username: aName;
				yourself)
]
