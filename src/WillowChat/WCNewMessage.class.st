Class {
	#name : #WCNewMessage,
	#superclass : #Announcement,
	#instVars : [
		'message',
		'username'
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

{ #category : #accessing }
WCNewMessage >> username [
	^ username
]

{ #category : #accessing }
WCNewMessage >> username: aName [
username := aName
]
