Class {
	#name : #WGolApplication,
	#superclass : #WillowApplication,
	#traits : 'SandboxGoogleSetup',
	#classTraits : 'SandboxGoogleSetup classTrait',
	#instVars : [
		'content',
		'gameView',
		'game',
		'cellViews',
		'semaphore',
		'stepButton'
	],
	#category : #WillowGoL
}

{ #category : #accessing }
WGolApplication class >> applicationTitle [
	
	^'Game Of Life'
]

{ #category : #accessing }
WGolApplication class >> handlerName [

	^'gameOfLife'
]

{ #category : #'accessing method dictionary' }
WGolApplication class >> sessionClass [
	^ WGoLSession
]

{ #category : #updating }
WGolApplication >> cellViewModel: aCell canvas: canvas [
	| button |
	button := AsynchronicButtonWebView
		labeled: ''
		applying: [ :theButton | 
			aCell isAlive
				ifTrue: [ theButton addClass bootstrap button
						+ theButton addClass bootstrap buttonWarning ]
				ifFalse: [ theButton addClass bootstrap button ] ].
	button onTrigger
		determineBehaviorByEvaluating: [ :response | 
			aCell isAlive
				ifTrue: [ aCell die ]
				ifFalse: [ aCell getBorn ].
			semaphore signal ].
	canvas render: button
]

{ #category : #accessing }
WGolApplication >> componentSupplierForApplication [

	^ BootstrapComponentSupplier
		withBootstrapLibrary: (self deploymentMode libraryFor: Bootstrap3MetadataLibrary) withoutOptionalTheme
		selectLibrary: ((self deploymentMode libraryFor: BootstrapSelectLibrary) using: self language)
		datepickerLibrary: ((self deploymentMode libraryFor: BootstrapDatepickerLibrary) using: self language)
		typeaheadLibrary: (self deploymentMode libraryFor: BootstrapTypeaheadLibrary) new
]

{ #category : #accessing }
WGolApplication >> contentView [

	^ content
]

{ #category : #updating }
WGolApplication >> initialize [ 
	super initialize.
	cellViews := OrderedCollection new.
	self initializeContent.
	
	self initializeGameView.
	self initializeStepButton 
]

{ #category : #updating }
WGolApplication >> initializeContent [
	^ content := IdentifiedWebView
		forDivNamed: 'root'
		containing: [ :canvas | 
			canvas heading: 'Game of life'.
			canvas render: gameView
			]
		applying: [ :div | div addClass bootstrap container ]
]

{ #category : #updating }
WGolApplication >> initializeGameView [
	game := GameOfLife col: 20 row: 20.
	semaphore := Semaphore new signal.
	game announcer when: GameOfLifeStepFinishAnnouncement do: [ semaphore signal ].
	^ gameView := PeriodicallyRenderedWebView
		evaluating: [ semaphore wait ]
		every: 10
		millisecondsThenRendering: [ :canvas | 
			canvas table
				with: [ 1 to: game nbRows do: [ :i | 
						canvas tableRow
							with: [ 1 to: game nbColumns do: [ :j | 
									canvas tableData
										with: [ self cellViewModel: (game cellAt: i @ j) canvas: canvas ] ] ] ] ] . canvas render: stepButton ]
		until: [ false ]
]

{ #category : #updating }
WGolApplication >> initializeStepButton [
	stepButton := AsynchronicButtonWebView
		labeled: 'step'
		applying: [ :theButton | theButton addClass bootstrap button ].
	stepButton onTrigger
		determineBehaviorByEvaluating: [ :response | game step ]
]

{ #category : #accessing }
WGolApplication >> jQueryLibrary [

	^(self deploymentMode libraryFor: JQuery3MetadataLibrary) default
]
