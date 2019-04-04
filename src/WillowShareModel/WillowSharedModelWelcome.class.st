Class {
	#name : #WillowSharedModelWelcome,
	#superclass : #WAComponent,
	#instVars : [
		'uid'
	],
	#category : #WillowShareModel
}

{ #category : #testing }
WillowSharedModelWelcome class >> canBeRoot [ 
^ true
]

{ #category : #testing }
WillowSharedModelWelcome class >> sessionClass [
	^ self subclassResponsibility 
]

{ #category : #rendering }
WillowSharedModelWelcome >> renderContentOn: aRenderer [
	aRenderer anchor
		callback: [ uid := self class sessionClass newModel ];
		class: 'btn btn-primary';
		with: 'new chat'.
	uid
		ifNotNil: [ aRenderer anchor
				class: 'btn btn-primary';
				url: '/', self class sessionClass handlerName,'/uid/' , uid;
				with: 'access' ]
]
