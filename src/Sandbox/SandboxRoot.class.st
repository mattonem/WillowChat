Class {
	#name : #SandboxRoot,
	#superclass : #WAComponent,
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
	children := WillowSharedModelWelcome allSubclasses collect: [ :aclazz | aclazz new]. 
	children addAll: (WillowSandBoxWelcome allSubclasses collect: [ :aclazz | aclazz new]).
]

{ #category : #rendering }
SandboxRoot >> renderContentOn: aRenderer [
	children do: [ :c | aRenderer div with: [ aRenderer render: c ] ]
]

{ #category : #rendering }
SandboxRoot >> updateRoot: aRoot [
	super updateRoot: aRoot.
	aRoot script
		attributeAt: 'async' put: true;
		url: '//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js'.
	aRoot script
		with:
			'  (adsbygoogle = window.adsbygoogle || []).push({
    google_ad_client: "ca-pub-6554111086429445",
    enable_page_level_ads: true
  });'
]
