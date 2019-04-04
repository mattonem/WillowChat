Class {
	#name : #WDiceApplication,
	#superclass : #WillowApplication,
	#instVars : [
		'content',
		'semaphore',
		'firstRender'
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
WDiceApplication >> initialRequest: request [
	super initialRequest: request.
	"self model announcer
		when: WCNewMessage
		do: [ :el | ]."
	self initializeContent.
	semaphore := Semaphore new.
	firstRender := true
]

{ #category : #initialization }
WDiceApplication >> initializeContent [
	^ content
]

{ #category : #accessing }
WDiceApplication >> jQueryLibrary [

	^(self deploymentMode libraryFor: JQuery3MetadataLibrary) default
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
