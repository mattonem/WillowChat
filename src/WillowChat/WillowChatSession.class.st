Class {
	#name : #WillowChatSession,
	#superclass : #WillowSession,
	#instVars : [
		'uid',
		'model'
	],
	#classVars : [
		'models'
	],
	#category : #WillowChat
}

{ #category : #'instance creation' }
WillowChatSession class >> initialize [ 
	models := Dictionary new.
]

{ #category : #'instance creation' }
WillowChatSession class >> newChat [
	| uid |
	uid := UUID new asString.
	self newChat: uid.
	^ uid
]

{ #category : #'instance creation' }
WillowChatSession class >> newChat: uid [
	models at: uid put: WillowChatModel new.
	[ 1 hours wait.
	models removeKey: uid ifAbsent: [  ] ] fork
]

{ #category : #accessing }
WillowChatSession >> handleFiltered: aRequestContext [
	uid := aRequestContext request uri path last.
	model := self models
		at: uid
		ifAbsent: [ ^ aRequestContext responseGenerator
				notFound;
				respond ].
	super handleFiltered: aRequestContext
]

{ #category : #accessing }
WillowChatSession >> initializeFilters [
	
]

{ #category : #accessing }
WillowChatSession >> model [
	^ model
]

{ #category : #accessing }
WillowChatSession >> models [
	^ models ifNil: [ models := Dictionary new ]
]

{ #category : #accessing }
WillowChatSession >> updateUrl: aUrl [
	super updateUrl: aUrl.
	uid ifNotNil: [ aUrl addToPath: uid ]
]
