Class {
	#name : #WillowSandBoxWelcome,
	#superclass : #WAComponent,
	#category : #Sandbox
}

{ #category : #rendering }
WillowSandBoxWelcome >> renderActions: aRenderer [
	^ aRenderer paragraph
		with: [ aRenderer div
				class: 'btn-group';
				with: [ aRenderer anchor
						class: 'btn btn-default';
						url: '/' , self class sessionClass handlerName;
						with: 'new ' , self class sessionClass handlerName ] ]
]

{ #category : #rendering }
WillowSandBoxWelcome >> renderContentOn: aRenderer [
	aRenderer div
		class: 'panel panel-default';
		with: [
			aRenderer div
				class: 'panel-heading';
				with: [ self renderTitle: aRenderer ].
			aRenderer div
				class: 'panel-body';
				with: [ self
						renderDescription: aRenderer;
						renderActions: aRenderer ] ]
]

{ #category : #rendering }
WillowSandBoxWelcome >> renderDescription: aRenderer [
]

{ #category : #rendering }
WillowSandBoxWelcome >> renderTitle: aRenderer [
	aRenderer heading
		class: 'panel-title';
		with: self class sessionClass applicationClass applicationTitle
]
