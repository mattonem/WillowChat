Class {
	#name : #WillowSandBoxWelcome,
	#superclass : #WAComponent,
	#category : #Sandbox
}

{ #category : #rendering }
WillowSandBoxWelcome >> renderContentOn: aRenderer [
	aRenderer anchor
		class: 'btn btn-primary';
		url: '/', self class sessionClass handlerName;
		with: 'new ', self class sessionClass handlerName.
]
