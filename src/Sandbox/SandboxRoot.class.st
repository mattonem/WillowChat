Class {
	#name : #SandboxRoot,
	#superclass : #WAComponent,
	#traits : 'SandboxGoogleSetup',
	#classTraits : 'SandboxGoogleSetup classTrait',
	#instVars : [
		'chatindex',
		'children'
	],
	#category : #Sandbox
}

{ #category : #testing }
SandboxRoot class >> canBeRoot [ 
^ true
]

{ #category : #accessing }
SandboxRoot class >> registerAsDeployedApplication [
	| root |
	root := WAAdmin register: self asApplicationAt: '/welcome'.
	WAAdmin defaultDispatcher defaultName: '/welcome'.
	root addLibrary: Bootstrap3DeploymentMetadataLibrary.
]

{ #category : #accessing }
SandboxRoot class >> start [
	self registerAsDeployedApplication.
	WillowSharedModelSession
		allSubclassesDo: [ :clazz | clazz applicationClass registerAsDeployedApplication ].
	WillowSandBoxSession
		allSubclassesDo: [ :clazz | clazz applicationClass registerAsDeployedApplication ].
	(ZnZincServerAdaptor port: 8080)
		codec: GRPharoUtf8Codec new;
		start
]

{ #category : #accessing }
SandboxRoot class >> stop [
	ZnServer stopDefault.
	ZnZincServerAdaptor allInstancesDo: [ :each | each shutDown ].
	self unregisterFromApplications.
	WillowSharedModelSession
		allSubclassesDo: [ :clazz | clazz applicationClass unregisterFromApplications ].
	WillowSandBoxSession
		allSubclassesDo: [ :clazz | clazz applicationClass unregisterFromApplications ].
	Smalltalk garbageCollect
	
]

{ #category : #accessing }
SandboxRoot class >> unregisterFromApplications [
	WAAdmin unregister: '/welcome'
]

{ #category : #rendering }
SandboxRoot >> children [ 
	^ children
]

{ #category : #rendering }
SandboxRoot >> initialize [
	super initialize.
	children := (WillowSandBoxWelcome allSubclasses
		reject: [ :c | c isAbstract ]) collect: [ :aclazz | aclazz new ]
]

{ #category : #rendering }
SandboxRoot >> renderContentOn: aRenderer [

	aRenderer div
		class: 'container';
		with: [ aRenderer
				heading: 'Kata SandBox';
				paragraph:
					'This is a place where I dropped a couple of web applications made just for fun as Katas or exercise. Fell free to play around. ';
				paragraph:
					'All this website is running thanks to Seaside framework and the awesome Pharo platforme.'.
			children do: [ :c | aRenderer div with: [ aRenderer render: c ] ] ]
]
