Class {
	#name : #WDiceApplication,
	#superclass : #WillowApplication,
	#traits : 'SandboxGoogleSetup',
	#classTraits : 'SandboxGoogleSetup classTrait',
	#instVars : [
		'content',
		'semaphore',
		'lastThrow',
		'result',
		'button',
		'editForm',
		'nameInput',
		'editSubmitButton',
		'edit',
		'editButton',
		'valuesInput'
	],
	#category : #WillowDice
}

{ #category : #accessing }
WDiceApplication class >> applicationTitle [

	^ 'Willow Dice'
]

{ #category : #accessing }
WDiceApplication class >> handlerName [

	^ 'willowDice'
]

{ #category : #'private-utility' }
WDiceApplication class >> registerAsApplicationUsing: deploymentModeClass [

	| application welcomeApp |

	welcomeApp := WAAdmin register: WillowChatWelcome asApplicationAt: self handlerName, '/access'.
	welcomeApp filter configuration at: #exceptionHandler put: self errorHandlerFactory.
	welcomeApp configuration addParent: WillowSystemConfiguration instance.
	welcomeApp preferenceAt: WillowSystemConfiguration deploymentModeClassKey put: deploymentModeClass.
	welcomeApp addLibrary: Bootstrap3DeploymentMetadataLibrary.
	application := WAAdmin register: self asApplicationAt: self handlerName, '/uid'.
	application preferenceAt: #sessionClass put: self sessionClass.
	application filter configuration at: #exceptionHandler put: self errorHandlerFactory.
	application configuration addParent: WillowSystemConfiguration instance.
	application preferenceAt: WillowSystemConfiguration deploymentModeClassKey put: deploymentModeClass.
	self installFileHandlerAccordingTo: deploymentModeClass new.
	^ application
]

{ #category : #'private-utility' }
WDiceApplication class >> restart [
	self
		stop;
		start
]

{ #category : #'private-utility' }
WDiceApplication class >> sessionClass [

	^ WillowDiceSession
]

{ #category : #'private-utility' }
WDiceApplication class >> start [

	self registerAsDeployedApplication.
	(ZnZincServerAdaptor port: 8080)
		codec: GRPharoUtf8Codec new;
		start
]

{ #category : #'private-utility' }
WDiceApplication class >> stop [

	ZnServer stopDefault.
	ZnZincServerAdaptor allInstancesDo: [ :each | each shutDown ].
	self unregisterFromApplications.
	Smalltalk garbageCollect
]

{ #category : #'private-utility' }
WDiceApplication class >> unregisterFromApplications [
	WAAdmin unregister: self handlerName , '/access'.
	WAAdmin unregister: self handlerName , '/uid'.
	super unregisterFromApplications
]

{ #category : #initialization }
WDiceApplication >> children [ 

	^ Array with: content.
]

{ #category : #accessing }
WDiceApplication >> componentSupplierForApplication [

	^ BootstrapComponentSupplier
		withBootstrapLibrary: (self deploymentMode libraryFor: Bootstrap3MetadataLibrary) withoutOptionalTheme
		selectLibrary: ((self deploymentMode libraryFor: BootstrapSelectLibrary) using: self language)
		datepickerLibrary: ((self deploymentMode libraryFor: BootstrapDatepickerLibrary) using: self language)
		typeaheadLibrary: (self deploymentMode libraryFor: BootstrapTypeaheadLibrary) new
]

{ #category : #accessing }
WDiceApplication >> contentView [

	^ content
]

{ #category : #initialization }
WDiceApplication >> facesFromString: aString [
	^ aString splitOn: ';'
]

{ #category : #initialization }
WDiceApplication >> facesToString [
	^';' join: self model faces.
	
]

{ #category : #initialization }
WDiceApplication >> initialRequest: request [
	super initialRequest: request.
	edit := false.
	semaphore := Semaphore new.
	semaphore signal.
	self model announcer
		when: WDiceThrow , WDiceRolling, WDiceChanged
		do: [ :ev | 
			edit
				ifFalse: [ semaphore signal ] ].
	self initializeEditButton.
	self initializeNameInput.
	self initializeValuesInput.
	self initializeSubmitButton.
	self initializeEditForm.
	self initializeResult.
	self initializeButton.
	self initializeContent.
	lastThrow := 'nothing'
]

{ #category : #initialization }
WDiceApplication >> initializeButton [
	button := AsynchronicButtonWebView
		labeled: 'throw'
		applying: [ :theButton | theButton addClass bootstrap button ].
	button onTrigger
		determineBehaviorByEvaluating: [ :response | 
			self model throw ]
]

{ #category : #initialization }
WDiceApplication >> initializeContent [
	^ content := IdentifiedWebView
		forDivNamed: 'root'
		containing: [ :canvas | canvas render: result]
		applying: [ :div | div addClass bootstrap containerFluid ]
]

{ #category : #initialization }
WDiceApplication >> initializeEditButton [
	editButton := AsynchronicButtonWebView
		labeled: '🖊️'
		applying: [ :theButton | 
			theButton addClass bootstrap buttonLink
				+ theButton addClass bootstrap button ].
	editButton onTrigger
		determineBehaviorByEvaluating: [ :response | 
			edit := true.
			semaphore signal ]
]

{ #category : #initialization }
WDiceApplication >> initializeEditForm [
	editForm := IdentifiedWebView
		forFormNamed: 'form'
		containing: [ :canvas | 
			nameInput identifyIn: canvas.
			canvas
				render: nameInput;
				render: valuesInput;
				render: editSubmitButton ]
		applying: [ :aForm | 
			aForm addClass bootstrap formGroup
				+ aForm addClass bootstrap containerFluid ]
]

{ #category : #initialization }
WDiceApplication >> initializeNameInput [
	nameInput := TextFieldWebView
		singleLineTriggeringOnKeyUpApplying: [ :theInput | theInput addClass bootstrap formControl ].
	nameInput changeContentsTo: self model diceName
]

{ #category : #initialization }
WDiceApplication >> initializeResult [
	^ result := PeriodicallyRenderedWebView
		evaluating: [  semaphore wait ]
		every: 10
		millisecondsThenRendering:
			[ :canvas | edit ifTrue: [ canvas render: editForm ] ifFalse: [self renderDice: canvas] ]
		until: [ false ]
]

{ #category : #initialization }
WDiceApplication >> initializeSubmitButton [
	editSubmitButton := AsynchronicButtonWebView
		labeled: 'send'
		applying: [ :theButton | theButton addClass bootstrap button ].
	editSubmitButton onTrigger
		serializeContainerForm;
		determineBehaviorByEvaluating: [ :response | |newFaces|
			newFaces := self facesFromString: valuesInput contents.
			edit := false.
			self model diceName: nameInput contents;
			faces: newFaces .
			semaphore signal ]
]

{ #category : #initialization }
WDiceApplication >> initializeValuesInput [
	valuesInput := TextFieldWebView
		singleLineTriggeringOnKeyUpApplying: [ :theInput | theInput addClass bootstrap formControl ].
	valuesInput changeContentsTo: self facesToString
]

{ #category : #accessing }
WDiceApplication >> jQueryLibrary [

	^(self deploymentMode libraryFor: JQuery3MetadataLibrary) default
]

{ #category : #initialization }
WDiceApplication >> lastThrow: anObject [
	lastThrow := anObject.
	semaphore signal
]

{ #category : #accessing }
WDiceApplication >> messageView: aMessage [
	^ IdentifiedWebView
		forDivNamed: 'message'
		containing: [ :canvas | canvas preformatted class:'well'; with: aMessage message]
		applying: [ :div | ]
]

{ #category : #updating }
WDiceApplication >> model [ 
	^ self session model
]

{ #category : #initialization }
WDiceApplication >> renderDice: canvas [
	canvas heading: self model diceName.
	^ self model isRolling
		ifTrue: [ canvas paragraph: '🎲' ]
		ifFalse: [ canvas
				paragraph: self model lastResult asString;
				render: button;
				render: editButton ]
]

{ #category : #updating }
WDiceApplication >> requiredLibraries [

	" Libraries added here are not considered until the server is restarted.
	  Including a library with a favicon.ico will automatically use it.	"

	^ {}
]

{ #category : #initialization }
WDiceApplication >> sendMessage: aString [
	self model sendMessage: aString.
]
