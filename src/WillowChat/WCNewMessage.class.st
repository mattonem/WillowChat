Class {
	#name : #WCNewMessage,
	#superclass : #Announcement,
	#instVars : [
		'message'
	],
	#category : #WillowChat
}

{ #category : #accessing }
WCNewMessage >> message [
	^ message
]

{ #category : #accessing }
WCNewMessage >> message: aMessage [
	message := aMessage
]
