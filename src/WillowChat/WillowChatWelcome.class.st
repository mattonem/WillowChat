Class {
	#name : #WillowChatWelcome,
	#superclass : #WAComponent,
	#instVars : [
		'uid'
	],
	#category : #WillowChat
}

{ #category : #testing }
WillowChatWelcome class >> canBeRoot [ 
^ true
]

{ #category : #rendering }
WillowChatWelcome >> renderContentOn: aRenderer [
	aRenderer anchor
		callback: [ uid := WillowSharedModelSession newChat ];
		class: 'btn btn-primary';
		with: 'new chat'.
	uid
		ifNotNil: [ aRenderer anchor
				class: 'btn btn-primary';
				url: '/', WillowChatApplication handlerName,'/uid/' , uid;
				with: 'access' ]
]
