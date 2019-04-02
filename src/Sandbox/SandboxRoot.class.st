Class {
	#name : #SandboxRoot,
	#superclass : #WAComponent,
	#instVars : [
		'chatindex'
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
	WillowChatApplication registerAsDeployedApplication.
	
	(ZnZincServerAdaptor port: 8080)
		codec: GRPharoUtf8Codec new;
		start
]

{ #category : #accessing }
SandboxRoot class >> stop [
	ZnServer stopDefault.
	ZnZincServerAdaptor allInstancesDo: [ :each | each shutDown ].
	self unregisterFromApplications.
	WillowChatApplication unregisterFromApplications.
	Smalltalk garbageCollect
	
]

{ #category : #accessing }
SandboxRoot class >> unregisterFromApplications [
	WAAdmin unregister: '/welcome'
]

{ #category : #rendering }
SandboxRoot >> children [ 
	^ { chatindex }
]

{ #category : #rendering }
SandboxRoot >> initialize [
	super initialize.
	chatindex := WillowChatWelcome new
]

{ #category : #rendering }
SandboxRoot >> renderContentOn: aRenderer [
	aRenderer render: chatindex.
]
