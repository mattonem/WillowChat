Class {
	#name : #WillowSharedModelWelcome,
	#superclass : #WillowSandBoxWelcome,
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
WillowSharedModelWelcome class >> isAbstract [
	^ true
]

{ #category : #testing }
WillowSharedModelWelcome class >> sessionClass [
	^ self subclassResponsibility 
]

{ #category : #rendering }
WillowSharedModelWelcome >> renderActions: aRenderer [
	aRenderer paragraph
		with: [ aRenderer div
				class: 'btn-group';
				with: [ aRenderer anchor
						callback: [ uid := self class sessionClass newModel ];
						class: 'btn btn-default';
						with: 'new ' , self class sessionClass handlerName.
					uid
						ifNotNil: [ aRenderer anchor
								class: 'btn btn-default';
								url: '/' , self class sessionClass handlerName , '/uid/' , uid;
								with: 'access' ] ] ]
]
