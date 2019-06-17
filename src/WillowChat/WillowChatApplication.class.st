Class {
	#name : #WillowChatApplication,
	#superclass : #WillowApplication,
	#traits : 'SandboxGoogleSetup',
	#classTraits : 'SandboxGoogleSetup classTrait',
	#instVars : [
		'content',
		'chatFlow',
		'messageViews',
		'semaphore',
		'form',
		'textInput',
		'button'
	],
	#category : #WillowChat
}

{ #category : #accessing }
WillowChatApplication class >> applicationTitle [

	^ 'Willow Chat'
]

{ #category : #accessing }
WillowChatApplication class >> handlerName [

	^ 'willowChat'
]

{ #category : #'private-utility' }
WillowChatApplication class >> registerAsApplicationUsing: deploymentModeClass [

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
WillowChatApplication class >> restart [
	self
		stop;
		start
]

{ #category : #'private-utility' }
WillowChatApplication class >> sessionClass [

	^ WillowChatSession
]

{ #category : #'private-utility' }
WillowChatApplication class >> start [

	self registerAsDeployedApplication.
	(ZnZincServerAdaptor port: 8080)
		codec: GRPharoUtf8Codec new;
		start
]

{ #category : #'private-utility' }
WillowChatApplication class >> stop [

	ZnServer stopDefault.
	ZnZincServerAdaptor allInstancesDo: [ :each | each shutDown ].
	self unregisterFromApplications.
	Smalltalk garbageCollect
]

{ #category : #'private-utility' }
WillowChatApplication class >> unregisterFromApplications [
	WAAdmin unregister: self handlerName , '/access'.
	WAAdmin unregister: self handlerName , '/uid'.
	super unregisterFromApplications
]

{ #category : #initialization }
WillowChatApplication >> children [ 

	^ Array with: content.
]

{ #category : #accessing }
WillowChatApplication >> componentSupplierForApplication [

	^ BootstrapComponentSupplier
		withBootstrapLibrary: (self deploymentMode libraryFor: Bootstrap3MetadataLibrary) withoutOptionalTheme
		selectLibrary: ((self deploymentMode libraryFor: BootstrapSelectLibrary) using: self language)
		datepickerLibrary: ((self deploymentMode libraryFor: BootstrapDatepickerLibrary) using: self language)
		typeaheadLibrary: (self deploymentMode libraryFor: BootstrapTypeaheadLibrary) new
]

{ #category : #accessing }
WillowChatApplication >> contentView [

	^ content
]

{ #category : #initialization }
WillowChatApplication >> initialRequest: request [
	super initialRequest: request.
	messageViews := OrderedCollection new.
	self model announcer
		when: WCNewMessage
		do: [ :el | self newMessage: el ].
	self initializeField.
	self initializeButton.
	self initializeForm.
	self initializeChatFlow.
	self initializeContent.
	semaphore := Semaphore new.
	semaphore signal.
]

{ #category : #initialization }
WillowChatApplication >> initializeButton [
	button := AsynchronicButtonWebView
		labeled: 'send'
		applying: [ :theButton | theButton addClass bootstrap button ].
	button onTrigger
		serializeContainerForm;
		determineBehaviorByEvaluating: [ :response | 
			self sendMessage: textInput contents.
			response onReturn setValueTo: '' thenTriggerChangeOf: textInput ]
]

{ #category : #initialization }
WillowChatApplication >> initializeChatFlow [
	chatFlow := PeriodicallyRenderedWebView
		evaluating: [ semaphore wait ]
		every: 0
		millisecondsThenRendering:
			[ :canvas | messageViews do: [ :messageView | canvas render: messageView ] ]
		until: [ false ]
]

{ #category : #initialization }
WillowChatApplication >> initializeContent [
	content := IdentifiedWebView
		forDivNamed: 'root'
		containing: [ :canvas | canvas render: chatFlow;
			 render: form]
		applying: [ :div | div addClass bootstrap containerFluid ]
]

{ #category : #initialization }
WillowChatApplication >> initializeField [
	textInput := TextFieldWebView
		multiLineTriggeringOnKeyUpApplying: [ :theInput | 
			theInput addClass bootstrap formControl ]
]

{ #category : #initialization }
WillowChatApplication >> initializeForm [
	form := IdentifiedWebView
		forFormNamed: 'form'
		containing: [ :canvas | 
			textInput identifyIn: canvas.
					canvas
						render: textInput;
						render: button ]
		applying: [ :aForm | aForm addClass bootstrap formInline + aForm addClass bootstrap containerFluid ]
]

{ #category : #accessing }
WillowChatApplication >> jQueryLibrary [

	^(self deploymentMode libraryFor: JQuery3MetadataLibrary) default
]

{ #category : #accessing }
WillowChatApplication >> messageView: aMessage [
	^ IdentifiedWebView
		forDivNamed: 'message'
		containing: [ :canvas | canvas preformatted class:'well'; with: aMessage message]
		applying: [ :div | ]
]

{ #category : #updating }
WillowChatApplication >> model [ 
	^ self session model
]

{ #category : #accessing }
WillowChatApplication >> newMessage: message [
	messageViews
		add:
			(self messageView: message).
	semaphore signal
]

{ #category : #updating }
WillowChatApplication >> requiredLibraries [

	" Libraries added here are not considered until the server is restarted.
	  Including a library with a favicon.ico will automatically use it.	"

	^ {}
]

{ #category : #initialization }
WillowChatApplication >> sendMessage: aString [
	self model sendMessage: aString.
]
