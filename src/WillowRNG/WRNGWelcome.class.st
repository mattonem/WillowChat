Class {
	#name : #WRNGWelcome,
	#superclass : #WillowSandBoxWelcome,
	#instVars : [
		'releaseName'
	],
	#category : #WillowRNG
}

{ #category : #'as yet unclassified' }
WRNGWelcome class >> applicationName [
	^ 'Release Name Generator'
]

{ #category : #'as yet unclassified' }
WRNGWelcome class >> applicationTitle [
	^ 'Release Name Generator'
]

{ #category : #'as yet unclassified' }
WRNGWelcome class >> registerAsDeployedApplication [

]

{ #category : #testing }
WRNGWelcome class >> sessionClass [
	^ WRNGSession
]

{ #category : #testing }
WRNGWelcome class >> unregisterFromApplications [

]

{ #category : #rendering }
WRNGWelcome >> renderActions: aRenderer [
	aRenderer paragraph
		with: [ aRenderer div
				class: 'btn-group';
				with: [ aRenderer anchor
						callback: [ releaseName := RNG randomGoodName ];
						class: 'btn btn-default';
						with: 'generate' ] ].
	releaseName ifNotNil: [ aRenderer blockquote: releaseName ]
]

{ #category : #rendering }
WRNGWelcome >> renderDescription: aRenderer [
	super renderDescription: aRenderer.
	aRenderer paragraph
		with: [ aRenderer
				text: 'This regenrator will generate an awesome release name for you.'. ]
]
