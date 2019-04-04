Class {
	#name : #WillowSharedModelSession,
	#superclass : #WillowSession,
	#instVars : [
		'uid',
		'model'
	],
	#classVars : [
		'models'
	],
	#category : #WillowShareModel
}

{ #category : #'instance creation' }
WillowSharedModelSession class >> handlerName [
	^ self modelClass handlerName
]

{ #category : #'instance creation' }
WillowSharedModelSession class >> initialize [ 
	models := Dictionary new.
]

{ #category : #'instance creation' }
WillowSharedModelSession class >> modelClass [
	^ self subclassResponsibility 
]

{ #category : #'instance creation' }
WillowSharedModelSession class >> newModel [
	| uid |
	uid := UUID new asString.
	self newModel: uid.
	^ uid
]

{ #category : #'instance creation' }
WillowSharedModelSession class >> newModel: uid [
	models at: uid put: self modelClass new.
	[ 1 hours wait.
	models removeKey: uid ifAbsent: [  ] ] fork
]

{ #category : #accessing }
WillowSharedModelSession >> handleFiltered: aRequestContext [
	uid := aRequestContext request uri path last.
	model := self models
		at: uid
		ifAbsent: [ ^ aRequestContext responseGenerator
				notFound;
				respond ].
	super handleFiltered: aRequestContext
]

{ #category : #accessing }
WillowSharedModelSession >> initializeFilters [
	
]

{ #category : #accessing }
WillowSharedModelSession >> model [
	^ model
]

{ #category : #accessing }
WillowSharedModelSession >> models [
	^ models ifNil: [ models := Dictionary new ]
]

{ #category : #accessing }
WillowSharedModelSession >> updateUrl: aUrl [
	super updateUrl: aUrl.
	uid ifNotNil: [ aUrl addToPath: uid ]
]
