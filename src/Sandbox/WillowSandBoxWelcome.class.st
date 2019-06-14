Class {
	#name : #WillowSandBoxWelcome,
	#superclass : #WAComponent,
	#category : #Sandbox
}

{ #category : #rendering }
WillowSandBoxWelcome >> renderActions: aRenderer [
	^ aRenderer anchor
		class: 'btn btn-primary';
		url: '/' , self class sessionClass handlerName;
		with: 'new ' , self class sessionClass handlerName
]

{ #category : #rendering }
WillowSandBoxWelcome >> renderContentOn: aRenderer [
	aRenderer div
		class: 'panel panel-default';
		with: [
			aRenderer div
				class: 'panel-body';
				with: [ self
						renderDescription: aRenderer;
						renderActions: aRenderer ] ]
]

{ #category : #rendering }
WillowSandBoxWelcome >> renderDescription: aRenderer [
	aRenderer heading: self class sessionClass applicationClass applicationTitle.
	 
]
